:- bundle(core).
% Manifest file for Ciao core (engine, compiler, basic libraries,
% extra libraries)
packname('Core').
alias_paths([
%    core_docsrc = 'doc',
    core_tests = 'tests',
    %
    core_cmds = 'cmds',
    %
%    engine = 'engine',
    %
    rtchecks = 'lib/rtchecks',
    unittest = 'lib/unittest',
    plindent = 'contrib/plindent',
    predefres = 'lib/resdefs/predefres',
    res_nargs = 'lib/resdefs/predefres/res_nargs',
    res_steps = 'lib/resdefs/predefres/res_steps',
    predefprf = 'lib/resdefs/predefprf',
    prf_ticks = 'lib/resdefs/predefprf/prf_ticks',
    prf_costcenter = 'lib/resdefs/predefprf/prf_costcenter'
]).
