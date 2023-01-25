% Checks if the code is running in Octave or Matlab.
%
%     ioc = is_octave()
%
% This function is used internally by `cluseed()`.
%
% ## Return values
%
% - `ioc` - 5 if code is running in Octave, 0 otherwise.
%
function ioc = is_octave()

    persistent x;
    if isempty(x)
        x = exist('OCTAVE_VERSION', 'builtin');
    end;
    ioc = x;

end % function

% Copyright (c) 2012-2023 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
