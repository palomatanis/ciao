:- module(bundle_source_tree, [], [assertions, hiord, regtypes, isomodes]).

:- doc(title, "Query bundle sources").
:- doc(author, "Jose F. Morales").

% TODO: Merge with source_tree.pl?

:- doc(module, "This implements predicates to inspect bundle source
   tree based on @lib{source_tree}.").

:- use_module(engine(internals), ['$bundle_id'/1]).
:- use_module(library(bundle/bundle_paths), [bundle_path/3]).
:- use_module(library(aggregates), [findall/3]).

% ===========================================================================

:- doc(section, "Specifiers for collections of modules").

:- use_module(library(source_tree)).
:- use_module(library(lists), [append/3]).

:- export(resolve_modset/2).
:- pred resolve_modset(ModSet, Xs) # "@var{Xs} is a list of resolved
   module names for the module set specification @var{ModSet}.".

% TODO: allow different filters

resolve_modset(Fs, Xs) :- is_list(Fs), !,
	resolve_modset_list(Fs, Xs).
resolve_modset(bundle(Bundle), Xs) :- !,
	findall(X, bundle_contents(Bundle, [compilable_module], X), Xs0),
	resolve_modset_list(Xs0, Xs).
resolve_modset(F, Xs) :- !,
	Xs = [B],
	absolute_file_name(F, '', '.pl', '.', _, B, _).

resolve_modset_list([], []).
resolve_modset_list([F|Fs], Bs) :-
	resolve_modset(F, Bs0),
	append(Bs0, Bs1, Bs),
	resolve_modset_list(Fs, Bs1).

:- use_module(engine(internals), ['$bundle_id'/1]).
:- use_module(library(system), [working_directory/2]).

% TODO: Declare in bundle which are the roots for compilable module search (e.g., paths in alias paths)
% TODO: This is ad-hoc, fix
:- export(bundle_contents/3).
:- pred bundle_contents(+BundleOrPart, +Filter, -F) ::
	term * source_filter * term
   # "Enumerate contents (files) of a bundle or part of a bundle
      (filtered by @var{Filter})".

bundle_contents(ciao, Filter, X) :- !,
	'$bundle_id'(Id), % (nondet)
	\+ Id = ciao,
	bundle_contents(Id, Filter, X).
bundle_contents(core, Filter, X) :- !,
	% TODO: Note that it does not include all parts!
	( bundle_contents(part(core, engine), Filter, X)
	; bundle_contents(part(core, compiler), Filter, X)
	; bundle_contents(part(core, toplevel), Filter, X)
	; bundle_contents(part(core, lib), Filter, X)
	; bundle_contents(part(core, library), Filter, X)
%	; bundle_contents(part(contrib, library), Filter, X)
	).
%
bundle_contents(part(core, engine), Filter, X) :- !,
	bundle_path(core, 'engine', F),
	current_file_find(Filter, F, X).
bundle_contents(part(core, compiler), Filter, X) :- !,
	bundle_path(core, 'lib/compiler', F),
	current_file_find(Filter, F, X).
bundle_contents(part(core, toplevel), Filter, X) :- !,
	bundle_path(core, 'library/toplevel', F),
	current_file_find(Filter, F, X).
%
bundle_contents(part(core, lib), Filter, X) :- !,
	bundle_path(core, 'lib/compiler', F1),
	%
	bundle_path(core, 'lib', F),
	current_file_find(Filter, F, X),
	% TODO: Hack, not in lib/compiler
	\+ atom_concat(F1, _, X).
bundle_contents(part(core, library), Filter, X) :- !,
	bundle_path(core, 'library/toplevel', F1),
	%
	bundle_path(core, 'library', F),
	current_file_find(Filter, F, X),
	% TODO: Hack, not in library/toplevel
	\+ atom_concat(F1, _, X).
bundle_contents(part(contrib, library), Filter, X) :- !,
	bundle_path(contrib, 'library', F),
	current_file_find(Filter, F, X).
%
bundle_contents(part(ide, web), Filter, X) :- !,
	bundle_path(ide, 'web', F),
	current_file_find(Filter, F, X).
bundle_contents(part(ide, emacs_mode), Filter, X) :- !, % TODO: remove ad-hoc case?
	bundle_path(ide, 'emacs-mode', F),
	current_file_find(Filter, F, X).
%
bundle_contents(lpdoc, Filter, X) :- !,
	bundle_path(lpdoc, 'src', F),
	current_file_find(Filter, F, X).
bundle_contents(Id, Filter, X) :- !,
	bundle_path(Id, '.', F),
	current_file_find(Filter, F, X).

is_list([]).
is_list([_|_]).
