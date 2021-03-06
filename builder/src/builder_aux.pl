:- module(_, [], [assertions, fsyntax, hiord]).

:- doc(title,  "Auxiliary Predicates for Builder").
:- doc(author, "Ciao Development Team").

:- use_module(library(pathnames),
	[path_split/3, path_dirname/2, path_basename/2, path_concat/3]).

:- use_module(library(bundle/bundle_flags)).
:- use_module(library(bundle/bundle_paths), [bundle_path/3, bundle_path/4]).
:- use_module(ciaobld(messages_aux), [cmd_message/3]).
:- use_module(ciaobld(messages_aux), [verbose_message/2]).
:- use_module(ciaobld(config_common), [cmd_path/4]).
:- use_module(library(messages), [warning_message/2]).

% ===========================================================================

% TODO: move to internals.pl?

% Source directory for Ciao at boot time (based on ciao_lib_dir/1
% for the bootstrap system).
% TODO: Simplify; add an environment variable during bootstrap?
:- export(root_bundle_source_dir/1).
root_bundle_source_dir(Dir) :-
	ciao_lib_dir(CiaoLibDir),
	atom_concat(CiaoLibDir, '/..', Dir0),
	fixed_absolute_file_name(Dir0, '.', Dir).

% ===========================================================================

:- use_module(library(bundle/bundlereg_gen), [lookup_bundle_root/2]).
:- use_module(library(bundle/bundle_info), [root_bundle/1]).
:- use_module(engine(internals), ['$bundle_id'/1]).

:- export(bundle_at_dir/2).
% Lookup the root or registered bundle at Dir or any of the parent directories
bundle_at_dir(Dir, Bundle) :-
	( lookup_bundle_root(Dir, BundleDir) ->
	    true
	; throw(error_msg("Not a bundle (or any of the parent directories).", []))
	),
	( dir_to_bundle(BundleDir, Bundle0) ->
	    Bundle = Bundle0
	; throw(error_msg("Bundle at ~w is not registered.", [BundleDir]))
	).

dir_to_bundle(BundleDir, Bundle) :-
	root_bundle_source_dir(BundleDir),
	!,
	root_bundle(Bundle).
dir_to_bundle(BundleDir, Bundle) :-
	'$bundle_id'(Bundle0),
	Dir = ~bundle_path(Bundle0, '.'),
	Dir == BundleDir,
	!,
	Bundle = Bundle0.

% ---------------------------------------------------------------------------

:- use_module(engine(internals), [ciao_path/1]).
:- use_module(library(pathnames), [path_get_relative/3]).

:- export(ciao_path_at_dir/2).
ciao_path_at_dir(Dir, Path) :-
	( lookup_ciao_path(Dir, Path0) ->
	    Path = Path0
	; throw(error_msg("Directory (or any of the parent directories) not in CIAOPATH.", []))
	).

% Detect the workspace from ciao_path/1 (or ciao root) for the given
% File (a directory or normal file)
lookup_ciao_path(File, Path) :-
	fixed_absolute_file_name(File, '.', Path0),
	( lookup_ciao_path_(Path0, Path1) ->
	    Path1 = Path
	; fail
	).

lookup_ciao_path_(Path0, Path) :-
	( ciao_path(Path)
	; root_bundle_source_dir(Path)
	),
	( Path0 = Path -> true
	; path_get_relative(Path, Path0, _) % Path0 is relative to Path
	).

% ===========================================================================

:- doc(section, "Invokation of external tools").
% TODO: make verbose messages optional

:- use_module(library(logged_process), [quoted_process_call/3]).

%ciaocmd := ~cmd_path(core, plexe, 'ciao'). % (supercommand)
% TODO: unfortunately 'ciao' supercommand is still a shell script; fix it so that it runs in Win32 without MSYS2
ciaocmd := ~cmd_path(core, shscript, 'ciao'). % (supercommand)

gmake := ~get_bundle_flag(ciao:gmake_cmd).

:- export(invoke_gmake/2).
invoke_gmake(Dir, Args) :-
	verbose_message("Executing `make' on `~w' with arguments ~w", [Dir, Args]),
	Env = ['CIAOCMD' = ~ciaocmd],
	Options = [cwd(Dir), env(Env)],
	quoted_process_call(~gmake, Args, Options).

:- export(invoke_ant/2).
% Compilation of foreign Java code through Apache Ant (http://ant.apache.org/)
% TODO: Make Ant command configurable?
invoke_ant(Dir, Args) :-
	verbose_message("Executing `ant' on `~w' with arguments ~w", [Dir, Args]),
	Options = [cwd(Dir)],
	quoted_process_call(path(ant), Args, Options).

% ===========================================================================

:- doc(section, "Filesystem operations for builddir and storedir").

:- use_module(library(system), [copy_file/3, using_windows/0]).
:- use_module(library(system_extra), [del_file_nofail/1, mkpath/2]).
:- use_module(library(system_extra), [ignore_nosuccess/1]).
:- use_module(library(source_tree), [remove_dir/1]).
:- use_module(ciaobld(config_common), [perms/1]).

% ---------------------------------------------------------------------------

:- doc(subsection, "Build staging area (builddir)").

:- export(ensure_builddir/2).
% Prepare a build (sub)directory (Rel can be '.' or a relative path)
ensure_builddir(Bundle, Rel) :-
 	mkpath(~bundle_path(Bundle, builddir, Rel), ~perms). % owner?

:- export(builddir_bin_copy_as/4). % TODO: rename to bld_cmd_copy?
% Copy a custom binary From at binary directory of builddir as Name
builddir_bin_copy_as(Bundle, Kind, From, Name) :-
	File = ~bld_cmd_path(Bundle, Kind, Name),
	copy_file(From, File, [overwrite]).

:- export(builddir_bin_link_as/4).
% 'Dest' will point to 'Src-Ver'
builddir_bin_link_as(Bundle, Kind, Src, Dest) :-
	From = ~bld_cmd_path(Bundle, Kind, Src),
	To = ~bld_cmd_path(Bundle, Kind, Dest),
	create_rel_link(From, To).

% ---------------------------------------------------------------------------

:- doc(subsection, "Installation area (bindir, storedir, etc.)").

:- use_module(ciaobld(config_common),
	[instciao_bindir/1,
	 instciao_storedir/1,
	 instciao_bundledir/2]).
:- use_module(ciaobld(builder_flags), [get_builder_flag/2]).
:- use_module(library(system), [delete_directory/1]).
:- use_module(library(source_tree), [copy_file_tree/4]).
:- use_module(library(glob), [glob/3]).

:- use_module(ciaobld(config_common), [
	bld_cmd_path/4,
	inst_cmd_path/4,
	active_cmd_path/3]).

:- export(rootprefix/1).
:- pred rootprefix(DestDir) # "@var{DestDir} is the prefix that is
   prepended to each (un)install target (useful for packaged bundle
   creation)".

% TODO: rename to install_destdir
rootprefix(R) :-
	( get_builder_flag(destdir, Value) ->
	    R = Value
	; R = ''
	).

:- export(rootprefixed/2).
% Add rootprefix (bundle param ciao:destdir) to the given path (for installation)
rootprefixed(Path0) := Path :-
	% (note: Path0 is an absolute path, do not use path_concat/3)
	Path = ~atom_concat(~rootprefix, Path0).

:- export(storedir_install/1).
% Creates a directory in the installation area
storedir_install(dir(Dir0)) :-
	Dir = ~rootprefixed(Dir0),
	( mkpath(Dir, ~perms) -> % TODO: owner?
	    true
	; throw(error_msg("Could not create ~w", [Dir]))
	).
% (copy all)
storedir_install(dir_rec(FromDir, ToDir)) :-
	copy_file_tree(installable_precomp(full),
	               FromDir, ~rootprefixed(ToDir), ~perms).
% (copy all except .po and .itf)
storedir_install(src_dir_rec(FromDir, ToDir)) :-
	copy_file_tree(installable_precomp(src),
	               FromDir, ~rootprefixed(ToDir), ~perms).
%
storedir_install(copy_and_link(Kind, Bundle, File)) :-
	storedir_install(copy(Kind, Bundle, File)),
	storedir_install(link_as(Kind, Bundle, File, File)).
%
storedir_install(copy(Kind, Bundle, File)) :-
	From = ~bld_cmd_path(Bundle, Kind, File),
	To = ~rootprefixed(~inst_cmd_path(Bundle, Kind, File)),
	storedir_install(dir(~instciao_bindir)),
	install_file(From, To).
%
storedir_install(file_exec(From, To0)) :-
	To = ~rootprefixed(To0),
	install_file(From, To).
%
storedir_install(file_noexec(From, To0)) :- % TODO: add Kind?
	To = ~rootprefixed(To0),
	install_file(From, To).
%
storedir_install(link_as(Kind, Bundle, Src, Dest)) :-
	% TODO: move to 'activation' operation?
	From = ~rootprefixed(~inst_cmd_path(Bundle, Kind, Src)),
	To = ~rootprefixed(~active_cmd_path(Kind, Dest)),
	create_rel_link(From, To).
%
% install a copy of File in <install_bundledir>/File and
% install a link from <install_bundledir>/File to <install_storedir>
storedir_install(lib_file_copy_and_link(Bundle, Path, File)) :-
	% ( ~instype = global -> true ; throw(install_requires_global) ),
	From = ~path_concat(Path, File),
	To = ~rootprefixed(~path_concat(~instciao_bundledir(Bundle), File)),
	PlainTo = ~rootprefixed(~path_concat(~instciao_storedir, File)),
	install_file(From, To),
	create_rel_link(To, PlainTo).
% TODO: show the same kind of messages that are used when compiling libraries
storedir_install(cmd_def(Bundle, _In, Output, Props)) :-
	cmd_def_kind(Props, K),
	cmd_message(Bundle, "installing '~w' command", [Output]),
	storedir_install(copy_and_link(K, Bundle, Output)).
%
% TODO: separate 'ciao-config' exec to get options for CC/LD?
% TODO: control engine 'activation' operation?
%
storedir_install(eng_contents(Eng)) :- !,
	% Install engine (including C headers)
	storedir_install(dir(~inst_eng_path(engdir, Eng))), % TODO: set_file_perms or set_exec_perms?
	%
	LocalEng = ~bld_eng_path(exec, Eng),
	InstEng = ~inst_eng_path(exec, Eng),
	% Install exec
	storedir_install(dir(~inst_eng_path(objdir_anyarch, Eng))), % TODO: set_file_perms or set_exec_perms?
	storedir_install(dir(~inst_eng_path(objdir, Eng))), % TODO: set_file_perms or set_exec_perms?
	storedir_install(file_exec(LocalEng, InstEng)),
	% Install headers
        HDir = ~bld_eng_path(hdir, Eng),
	InstEngHDir = ~inst_eng_path(hdir, Eng),
	storedir_install(src_dir_rec(HDir, InstEngHDir)).
storedir_install(eng_active(Eng)) :- !, % Activate engine (for multi-platform)
	eng_active_inst(Eng).

:- export(storedir_uninstall/1).
storedir_uninstall(link(Kind, File)) :-
	storedir_uninstall(file(~active_cmd_path(Kind, File))).
%
storedir_uninstall(copy(Kind, Bundle, File)) :-
	storedir_uninstall(file(~inst_cmd_path(Bundle, Kind, File))).
%
storedir_uninstall(copy_and_link(Kind, Bundle, File)) :-
	storedir_uninstall(link(Kind, File)),
	storedir_uninstall(copy(Kind, Bundle, File)).
%
storedir_uninstall(file(File)) :-
	del_file_nofail(~rootprefixed(File)).
%
storedir_uninstall(dir_rec(Dir)) :-
	safe_remove_dir_nofail(Dir).
%
storedir_uninstall(src_dir_rec(Dir)) :-
	safe_remove_dir_nofail(Dir).
%
storedir_uninstall(dir(Dir)) :-
	warn_on_nosuccess(delete_directory(~rootprefixed(Dir))).
%
storedir_uninstall(dir_if_empty(Dir)) :-
	ignore_nosuccess(delete_directory(~rootprefixed(Dir))).
%
storedir_uninstall(lib_file_copy_and_link(Bundle, _Path, File)) :-
	% ( ~instype = global -> true ; throw(uninstall_requires_global) ),
	PlainTo = ~path_concat(~instciao_storedir, File),
	To = ~path_concat(~instciao_bundledir(Bundle), File),
	storedir_uninstall(file(PlainTo)),
	storedir_uninstall(file(To)).
% TODO: show the same kind of messages that are used when compiling libraries
storedir_uninstall(cmd_def(Bundle, _In, Output, Props)) :-
	cmd_def_kind(Props, K),
	cmd_message(Bundle, "uninstalling '~w' command", [Output]),
	storedir_uninstall(copy_and_link(K, Bundle, Output)).
storedir_uninstall(eng_contents(Eng)) :- !,
	% Uninstall engine
	storedir_uninstall(file(~inst_eng_path(exec, Eng))),
        % Uninstall C headers
	InstEngHDir = ~inst_eng_path(hdir, Eng),
	storedir_uninstall(src_dir_rec(InstEngHDir)),
	%
	storedir_uninstall(dir_if_empty(~inst_eng_path(objdir, Eng))),
	storedir_uninstall(dir_if_empty(~inst_eng_path(objdir_anyarch, Eng))),
	storedir_uninstall(dir_if_empty(~inst_eng_path(engdir, Eng))).
storedir_uninstall(eng_active(Eng)) :- !,
	% TODO: only if it coincides with the active version (better, do unactivation before)
	storedir_uninstall(file(~active_inst_eng_path(exec, Eng))),
	storedir_uninstall(file(~active_inst_eng_path(exec_anyarch, Eng))).

% Remove dir recursively (with some additional safety checks)
safe_remove_dir_nofail(Dir) :-
	( path_get_relative(~instciao_storedir, Dir, _) ->
	    % Inside storedir
	    remove_dir_nofail(~rootprefixed(Dir))
	; % TODO: use a install_manifest.txt file (common practice)
          warning_message("Refusing to remove directories recursively outside the Ciao installation base: ~w", [Dir])
	).

:- use_module(ciaobld(eng_defs), [active_bld_eng_path/3]).

:- export(eng_active_bld/1).
% Create links for multi-platform engine selection (for build)
eng_active_bld(Eng) :-
	% E.g., ciaoengine.<OSARCH> -> <OSARCH>/ciaoengine
	A = ~bld_eng_path(exec, Eng),
	B = ~active_bld_eng_path(exec, Eng),
	create_rel_link(A, B),
	% Link for active exec_anyarch (E.g., ciaoengine -> ciaoengine.<OSARCH>)
	C = ~active_bld_eng_path(exec_anyarch, Eng),
	create_rel_link(B, C).

% Like eng_active_bld/1, but for installed engines
eng_active_inst(Eng) :-
	% Link for active exec (E.g., ciaoengine.<OSARCH> -> ciaoengine-1.15/objs/<OSARCH>/ciaoengine) % TODO: 'activation' as a different operation?
	A = ~rootprefixed(~inst_eng_path(exec, Eng)),
	B = ~rootprefixed(~active_inst_eng_path(exec, Eng)),
	create_rel_link(A, B),
	% Link for active exec_anyarch (E.g., ciaoengine -> ciaoengine.<OSARCH>)
	C = ~rootprefixed(~active_inst_eng_path(exec_anyarch, Eng)),
	create_rel_link(B, C).

% Properties of commands
% TODO: move to ciaoc_aux?
cmd_def_kind(Props, Kind) :-
	( member(kind=Kind, Props) -> true ; Kind=plexe ).

% ---------------------------------------------------------------------------
% (special for engines)
% TODO: generalize a-la OptimComp to executables with native code
%   (which can also be bytecode loaders, etc.)

% TODO: Make sure that CIAOHDIR points to the right place when the engine 
%   is installed in instype=global

:- use_module(ciaobld(eng_defs), [
	bld_eng_path/3,
	inst_eng_path/3,
	active_inst_eng_path/3]).

% ===========================================================================

:- doc(section, "Instantiating Template Files with Parameters").

:- use_module(library(text_template), [eval_template_file/3]).
:- use_module(library(system_extra), [warn_on_nosuccess/1]).
:- use_module(library(system_extra), [set_file_perms/2, set_exec_perms/2]).

:- export(wr_template/4).
% Generate files based on text templates
% TODO: improve
wr_template(at(OutDir), Dir, File, Subst) :-
	In = ~path_concat(Dir, ~atom_concat(File, '.skel')),
	Out = ~path_concat(OutDir, File),
	eval_template_file(In, Subst, Out).
wr_template(origin, Dir, File, Subst) :-
	In = ~path_concat(Dir, ~atom_concat(File, '.skel')),
	Out = ~path_concat(Dir, File),
	eval_template_file(In, Subst, Out).
wr_template(as_cmd(Bundle, Kind), Dir, File, Subst) :-
	In = ~path_concat(Dir, ~atom_concat(File, '.skel')),
	Out = ~bld_cmd_path(Bundle, Kind, File),
	eval_template_file(In, Subst, Out),
	( kind_exec_perms(Kind) ->
	    warn_on_nosuccess(set_exec_perms(Out, ~perms))
	; true
	).

kind_exec_perms(shscript).

% ===========================================================================

:- use_module(engine(internals), ['$bundle_prop'/2]).	
:- use_module(library(bundle/bundle_info), [bundle_version_patch/2]).

:- use_module(library(terms), [atom_concat/2]).
:- use_module(library(format), [format/3]).
:- use_module(library(write), [portray_clause/2]).
:- use_module(library(system), [file_exists/1]).
:- use_module(library(system_extra), [datime_string/1]).

:- export(generate_version_auto/2).
% Create a file (File) with a version/1 fact indicating the current
% version of Bundle, build time, and compiler version.

% TODO: generalize for all bundles; change modiftime only if there are changes
%       move, include other options (for runtime)?

generate_version_auto(_Bundle, File) :-
	file_exists(File), % TODO: update file if contents change
	!.
generate_version_auto(Bundle, File) :-
	Version = ~bundle_version_patch(Bundle),
	atom_codes(Date, ~datime_string), % TODO: use commit info instead
	%
	CVersion = ~bundle_version_patch(core),
	%
	VersionAtm = ~atom_concat([
	  Version, ': ', Date, ' (compiled with Ciao ', CVersion, ')'
        ]),
	open(File, write, O),
	format(O, "%% Do not edit - automatically generated!\n", []),
        portray_clause(O, version(VersionAtm)),
	close(O).

% ===========================================================================
% TODO: move to eng_maker.pl?

:- use_module(ciaobld(third_party_install), [third_party_path/2]).
:- use_module(library(pathnames), [path_relocate/4]).
:- use_module(library(lists), [append/3]).

:- export(add_rpath/3).
% Add rpaths (runtime search path for shared libraries)
add_rpath(local_third_party, LinkerOpts0, LinkerOpts) :- !,
	% TODO: better way to compute RelativeLibDir?
	% (for 'make_car_exec')
	bundle_path(ciao, '.', CiaoSrc),
	third_party_path(libdir, LibDir),
	path_relocate(CiaoSrc, '.', LibDir, RelativeLibDir),
	add_rpath_(RelativeLibDir, LinkerOpts0, LinkerOpts).
add_rpath(executable_path, LinkerOpts0, LinkerOpts) :- !,
	% (for 'ciaoc_sdyn')
	% TODO: Use process_call/3 in build foreign interface; DO NOT QUOTE HERE!
	add_rpath_('\\\'$ORIGIN\\\'', LinkerOpts0, LinkerOpts).

add_rpath_(Path, LinkerOpts0, LinkerOpts) :-
	atom_codes(Path, PathCs),
	append("-Wl,-rpath,"||PathCs, " "||LinkerOpts0, LinkerOpts).

% ===========================================================================

% (shared)
%:- export(create_link/2).
create_link(From, To) :-
	del_file_nofail(To),
	% TODO: better solution? windows lacks proper symlinks
        ( using_windows ->
            ignore_nosuccess(copy_file(From, To, [overwrite]))
        ; ignore_nosuccess(copy_file(From, To, [overwrite, symlink]))
        ).
        % TODO: do not set perms on a symbolic link (the source may
        %       not exist, as it happens in RPM generation)
%	warn_on_nosuccess(set_file_perms(To, ~perms)).

install_file(From, To) :-
	del_file_nofail(To),
	copy_file(From, To, [overwrite]),
	warn_on_nosuccess(set_exec_perms(To, ~perms)).

:- export(remove_dir_nofail/1).
remove_dir_nofail(Dir2) :-
	( file_exists(Dir2) -> remove_dir(Dir2) ; true ).

% ===========================================================================
% TODO: Move both create_rel_link/2 and relpath/3 to the libraries

% Create a "relocatable" link (computing relative paths)
% (e.g., "/a/b/c (symlink) -> /a/d/e" becomes "/a/b/c (symlink) -> ../d/e"
create_rel_link(From, To) :-
	path_dirname(To, ToDir),
	relpath(ToDir, From, RelFrom),
	create_link(RelFrom, To).

:- use_module(library(pathnames), [path_split_list/2, path_concat_list/2]).

%:- export(relpath/3).
% C is a path to B relative to A (using '..' if needed)
% (e.g., "/a/b/c -> /a/d/e" becomes "/a/b/c -> ../../d/e".
% Assume both are absolute, otherwise just return B.
relpath(A, B, C) :-
	path_split_list(A, As),
	path_split_list(B, Bs),
	As = ['/'|As0],
	Bs = ['/'|Bs0],
	!,
	relpath_(As0, Bs0, Cs),
	path_concat_list(Cs, C).
relpath(_, B, B).

% Consume common part
relpath_([A|As], [A|Bs], Cs) :- !, relpath_(As, Bs, Cs).
relpath_(As, Bs, Cs) :- relpath__(As, Bs, Cs).

% Add '..' for each A component (go back)
relpath__([_|As], Bs, ['..'|Cs]) :- !, relpath__(As, Bs, Cs).
relpath__([], Bs, Bs). % Finish with rest
