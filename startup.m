% Run this script to initialize MOCluGen.
%
% Copyright (c) 2013-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
%

% Add path containing source code
addpath([pwd() filesep 'src']);

% Global variable, which defines the testing mode
global moclugen_test_mode

% Global variable can be set to 'minimal', 'ci', 'normal', 'full'
% If running on a CI environment, it's set to 'ci'
% Otherwise it's set to 'normal'
if numel(getenv('CI')) > 0
    moclugen_test_mode = 'ci';
else
    moclugen_test_mode = 'normal';
end;
