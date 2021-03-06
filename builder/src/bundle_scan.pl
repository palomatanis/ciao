:- module(bundle_scan, [], [assertions, fsyntax]).

:- doc(title, "Scanning and Registering of Bundles").
:- doc(author, "Ciao Development Team").
:- doc(author, "Jose F. Morales").

:- doc(module, "Scanning source for bundles and processing of
   @tt{Manifest.pl} files.

   A registered bundle can be viewed as the result of the compilation
   or processing of a @tt{Manifest.pl} (it should contain plain facts
   and no syntactic sugar).
").

:- use_module(library(pathnames), [path_concat/3]).
:- use_module(library(system_extra), [mkpath/1, del_file_nofail/1]).
:- use_module(library(system), [directory_files/2, file_exists/1, delete_file/1]).
:- use_module(library(aggregates), [findall/3]).
:- use_module(library(port_reify)).

% NOTE: be careful with bundle_path/3 (bundles may not be loaded yet)
:- use_module(ciaobld(config_common), [instciao_bundledir/2]).
:- use_module(engine(internals), [bundle_reg_dir/2]).

% ---------------------------------------------------------------------------
:- doc(section, "Scan bundles at given workspace").

:- use_module(engine(internals), [reload_bundleregs/0]).

% Note: scanning bundles must be done before configuration
% Note: bundle_path/? cannot be used until bundles are scanned (may
%   fail or report outdated data)

:- export(scan_bundles_at_path/1).
:- pred scan_bundles_at_path(Path) # "Update the bundle registry for
   the given workspace at @var{Path} directory (and reload
   bundleregs).".

% TODO: Document extended InsType = local | inpath(_)
% TODO: Allow a single bundle (use BundleSet?)

scan_bundles_at_path(Path) :-
	% Find bundles under Path and scan
	find_bundles(Path),
	once_port_reify(scan_bundles_at_path_(Path), Port),
	cleanup_find_bundles,
	port_call(Port).

scan_bundles_at_path_(Path) :- % (requires find_bundles/2 data)
	% TODO: Assumes that Path is correct
	( root_bundle_source_dir(CiaoSrc),
	  Path = CiaoSrc ->
	    InsType = local
	; InsType = inpath(Path)
	),
	% Create bundleregs
	ensure_bundlereg_dir(InsType),
	( % (failure-driven loop)
	  found_bundle(_Name, BundleDir),
	    create_bundlereg(BundleDir, InsType),
	    fail
	; true
	),
	% Remove orphan bundleregs (including configuration)
	swipe_bundlereg_dir(InsType),
	% Finally reload bundleregs
	reload_bundleregs.

swipe_bundlereg_dir(InsType) :-
	bundle_reg_dir(InsType, BundleRegDir),
	directory_files(BundleRegDir, Files),
	( member(File, Files),
	    ( orphan_reg_file(File) ->
	        path_concat(BundleRegDir, File, AbsFile),
	        delete_file(AbsFile)
	    ; true
	    ),
	    fail
	; true
	).

% A .bundlereg, .bundlecfg, or .bundlecfg_sh file for a bundle that is
% no longer available.
orphan_reg_file(File) :-
	( atom_concat(Name, '.bundlereg', File) -> true
	; atom_concat(Name, '.bundlecfg', File) -> true
	; atom_concat(Name, '.bundlecfg_sh', File) -> true
	),
	\+ found_bundle(Name, _).

% Make sure that the directory for the bundle database exists
ensure_bundlereg_dir(InsType) :-
	bundle_reg_dir(InsType, BundleRegDir),
	mkpath(BundleRegDir).

% ---------------------------------------------------------------------------

:- use_module(engine(system_info), [ciao_lib_dir/1]).
:- use_module(engine(internals), [bundlereg_filename/3]).
:- use_module(engine(internals), [bundlereg_version/1]).
:- use_module(ciaobld(builder_aux), [rootprefixed/2]).

:- export(rootprefix_bundle_reg_dir/2).
% Like bundle_reg_dir/2, but supporting InsType=global and prefixed
% with rootprefix if needed.
rootprefix_bundle_reg_dir(InsType, BundleRegDir) :-
	( InsType = global ->
	    % (special case relative to ciao_lib_dir/1)
	    % TODO: use something different?
	    instciao_bundledir(core, Dir),
	    path_concat(Dir, 'bundlereg', BundleRegDir0),
	    BundleRegDir = ~rootprefixed(BundleRegDir0)
	; bundle_reg_dir(InsType, BundleRegDir)
	).

% File is the registry file for the BundleName bundle
rootprefix_bundle_reg_file(InsType, BundleName, RegFile) :-
	rootprefix_bundle_reg_dir(InsType, BundleRegDir),
	bundlereg_filename(BundleName, BundleRegDir, RegFile).

% ---------------------------------------------------------------------------

:- use_module(library(bundle/bundlereg_gen), [is_bundledir/1]).

% found_bundle(Name,Dir): found bundle Name at Dir
:- data found_bundle/2.

% Find bundles at @var{Path} workspace using @pred{bundledirs_at_dir/3}.
% Store them at @pred{found_bundle/2} data. Use @pred{cleanup_find_bundles/0}
% when done.

find_bundles(Path) :-
	cleanup_find_bundles,
	( % (failure-driven loop)
	  bundledirs_at_dir(Path, no, Dir),
	    bundledir_to_name(Dir, Name),
	    assertz_fact(found_bundle(Name, Dir)),
	    fail
	; true
	).

cleanup_find_bundles :- retractall_fact(found_bundle(_, _)).

% Enumerate of all bundle directories (absolute path) under @var{Src}.
% If @var{Optional} is @tt{yes}, bundles require a @tt{ACTIVATE}
% directory mark to be enabled.
%
% This search is non-recursive by default. If the directory contains a
% file called BUNDLE_CATALOG, search goes into that directory. Bundles
% in a BUNDLE_CATALOG are only recognized if they contain a file
% called ACTIVATE.
%
% (nondet)

bundledirs_at_dir(Src, Optional, BundleDir) :-
	is_bundledir(Src), % a bundle 
	% TODO: Add a cut here, do not allow sub-bundles! <- needed only for 'ciao' bundle
	( Optional = yes -> directory_has_mark(activate, Src) ; true ),
	BundleDir = Src.
bundledirs_at_dir(Src, Optional, BundleDir) :-
	bundledirs_at_dir_(Src, Optional, BundleDir).

bundledirs_at_dir_(Src, Optional, BundleDir) :-
	directory_files(Src, Files),
	member(File, Files),
	\+ not_bundle(File),
	path_concat(Src, File, Dir),
	\+ directory_has_mark(nocompile, Dir), % TODO: not needed now?
	%
	( directory_has_mark(bundle_catalog, Dir) ->
	    % search recursively on the catalog (only if ACTIVATE is set on the bundle)
	    bundledirs_at_dir_(Dir, yes, BundleDir)
	; is_bundledir(Dir) -> % a bundle
	    ( Optional = yes -> directory_has_mark(activate, Dir) ; true ),
	    BundleDir = Dir
	; fail % (none, backtrack)
	).

not_bundle('.').
not_bundle('..').
not_bundle('Manifest').

directory_has_mark(nocompile, Dir) :-
	path_concat(Dir, 'NOCOMPILE', F),
	file_exists(F).
directory_has_mark(bundle_catalog, Dir) :-
	path_concat(Dir, 'BUNDLE_CATALOG', F),
	file_exists(F).
directory_has_mark(activate, Dir) :-
	path_concat(Dir, 'ACTIVATE', F),
	file_exists(F).

% ---------------------------------------------------------------------------

% BundleDir used in bundle registry (depends on InsType)
reg_bundledir(InsType, BundleName, BundleDir, Dir) :-
	( InsType = local -> Dir = BundleDir
	; InsType = inpath(_Path) -> Dir = BundleDir
	; InsType = global -> instciao_bundledir(BundleName, Dir)
	; fail
	).

% ---------------------------------------------------------------------------

:- doc(section, "Create/destroy bundleregs").
% A bundlereg contains the processed manifest information and resolved
% paths.

% TODO: allow relative paths? (with some relocation rules)

:- use_module(library(pathnames), [path_split/3]).
:- use_module(library(bundle/bundle_info), [root_bundle/1]).
:- use_module(library(bundle/bundlereg_gen), [gen_bundlereg/4]).
:- use_module(ciaobld(builder_aux), [root_bundle_source_dir/1]).

% TODO: hack, try to extract BundleName from Manifest, not dir (also in bundle.pl)
bundledir_to_name(BundleDir, BundleName) :-
	root_bundle_source_dir(RootDir),
	( BundleDir = RootDir ->
	    root_bundle(BundleName)
	; path_split(BundleDir, _, BundleName)
	).

:- export(create_bundlereg/2).
% Create a bundlereg for bundle at @var{BundleDir} and installation
% type @var{InsType} (which determines the location of the bundle
% registry and the absolute directories for alias paths).
create_bundlereg(BundleDir, InsType) :-
	% Obtain bundle name from path
	bundledir_to_name(BundleDir, BundleName),
	reg_bundledir(InsType, BundleName, BundleDir, AliasBase),
	rootprefix_bundle_reg_file(InsType, BundleName, RegFile),
	gen_bundlereg(BundleDir, BundleName, AliasBase, RegFile).

:- export(remove_bundlereg/2).
% Remove the bundlereg for bundle @var{BundleName} and installation
% type @var{InsType} (which determines the location of the bundle
% registry).
remove_bundlereg(BundleName, InsType) :-
	rootprefix_bundle_reg_file(InsType, BundleName, RegFile),
	del_file_nofail(RegFile).

:- export(ensure_global_bundle_reg_dir/0).
% Make sure that the directory for the (global installation) bundle
% database exists
ensure_global_bundle_reg_dir :-
	rootprefix_bundle_reg_dir(global, BundleRegDir),
	mkpath(BundleRegDir).



