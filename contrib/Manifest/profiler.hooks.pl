% (included file)

:- doc(section, "Profiler (part)").

:- use_module(ciaobld(ciaoc_aux), [clean_tree/1]).

'$builder_hook'(profiler:item_def([
  lib('library/profiler')
])).
'$builder_hook'(profiler:build_docs) :- !.
'$builder_hook'(profiler:clean_norec) :- !,
	clean_tree(~bundle_path(contrib, 'library/profiler')).

