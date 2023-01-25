% Run from the MOCluGen folder with:
%
% $ octave --no-gui tests/run_headless.m
%
% or
%
% $ cat tests/run_headless.m | matlab -nodesktop -nodisplay
%
% The MOXUNIT_PATH environment variable must contain the path to MOxUnit's
% source code.
if is_octave()
    pkg load statistics;
end;
moxunit_path = getenv('MOXUNIT_PATH');
if numel(moxunit_path) == 0 || ~exist([moxunit_path filesep 'moxunit_set_path.m'], 'file')
    warning('MOxUnit not found!');
    exit(2)
else
    addpath(moxunit_path);
    moxunit_set_path;
    test_results = ~moxunit_runtests('tests');
    exit(test_results);
end
