% (included file)

:- doc(section, "MySQL bundle").

:- use_module(ciaobld(builder_aux), [wr_template/4]).
:- use_module(library(system), [file_exists/1]).

with_mysql := ~get_bundle_flag(core:with_mysql).
mysql_client_directory := ~get_bundle_flag(core:mysql_client_directory).

% Prepare source for build
% (e.g., for automatically generated code, foreign interfaces, etc.)
'$builder_hook'(persdb_mysql:prebuild_nodocs) :-
	( with_mysql(yes) ->
	    % TODO: ask bundle instead
	    wr_template(origin,
	        ~bundle_path(core, 'library/persdb_mysql'),
	        'linker_opts_auto.pl',
	        ['where_mysql_client_lives' = ~mysql_client_directory]),
	    % TODO: why?
	    ( file_exists(~bundle_path(core, 'library/persdb_mysql_op')) ->
	        wr_template(origin,
		    ~bundle_path(core, 'library/persdb_mysql_op'),
		    'linker_opts_auto.pl',
		    ['where_mysql_client_lives' = ~mysql_client_directory])
	    ; true
	    )
	; true
	).
