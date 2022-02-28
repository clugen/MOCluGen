% Angle between two $n$-dimensional vectors.
%
%     a = angle_btw(v1, v2)
%
% Typically, the angle between two vectors `v1` and `v2` can be obtained with:
%
%     acos(dot(v1, v2) / (norm(v1) * norm(v2)))
%
% However, this approach is numerically unstable. The version provided here is
% numerically stable and based on the
% [AngleBetweenVectors](https://github.com/JeffreySarnoff/AngleBetweenVectors.jl)
% Julia package by Jeffrey Sarnoff (MIT license), implementing an algorithm
% provided by Prof. W. Kahan in
% [these notes](https://people.eecs.berkeley.edu/~wkahan/MathH110/Cross.pdf)
% (see page 15).
%
% ## Arguments
%
% - `v1` - First vector.
% - `v2` - Second vector.
%
% ## Return values
%
% - `a`- Angle between `v1` and `v2` in radians.
%
% ## Examples
%
%     v1 = [1.0, 1.0, 1.0, 1.0];
%     v2 = [1.0, 0.0, 0.0, 0.0];
%     rad2deg(angle_btw(v1, v2)) % Should be 60 degrees
%     % ans = 60.000
function a = angle_btw(v1, v2)

    % Returns true if the value of the sign of x is negative, otherwise false.
    signbit = @(x) x < 0;

    u1 = v1 / norm(v1);
    u2 = v2 / norm(v2);

    y = u1 - u2;
    x = u1 + u2;

    a0 = 2 * atan(norm(y) / norm(x));

    if not(signbit(a0) || signbit(pi - a0))
        a = a0;
    elseif signbit(a0)
        a = 0.0;
    else
        a = pi;
    end;

end

% Copyright (c) 2012-2022 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)