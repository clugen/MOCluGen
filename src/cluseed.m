
% Initialize the random number generator with a given seed.
%
%      cluseed(seed)
%
% ## Arguments
%
% - `seed`: Seed for initializing the random number generator.
%
% ## Note
%
% This function works in both MATLAB or Octave and simplifies reproducible
% executions of the different stochastic functions in this package. Note that
% reproducibility is only guaranteed within the same version of either MATLAB or
% Octave.
%
% ## Examples
%
%     % Set seed to 123
%     cluseed(123);
function cluseed(seed)
    if is_octave()
        rand('state', seed);
        randn('state', seed);
        rande('state', seed);
        randg('state', seed);
        randp('state', seed);
    else
        rng(seed);
    end;
end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)

% Reset random number generator with a given seed
