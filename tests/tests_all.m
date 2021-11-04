%
% Unit tests for MOCluGen
%
% These tests require the MOxUnit framework available at
% https://github.com/MOxUnit/MOxUnit
%
% To run the tests:
% 1 - Make sure MOxUnit is on the MATLAB/Octave path
% 2 - Make sure MOCluGen is on the MATLAB/Octave path by running startup.m
% 3 - cd into the tests folder
% 4 - Invoke the moxunit_runtests script
%
% Copyright (c) 2021 Nuno Fachada
% Distributed under the MIT License (See accompanying file LICENSE or copy
% at http://opensource.org/licenses/MIT)
%
function test_suite = tests_all
    try
        % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions();
    catch
        % no problem; early Matlab versions can use initTestSuite fine
    end;
    initTestSuite;

    init_data();
end

% %%%%%%%%% %
% Test data %
% %%%%%%%%% %

function init_data
    global seeds num_dims num_points llengths_mus;

    seeds = [0, 123, 9999, 9876543];
    num_dims = [1, 2, 3, 4, 30];
    num_points = [1, 10, 500, 10000];
    llengths_mus = [0, 10];
end

% %%%%%%%%%%%%%%%%%%%%%%%% %
% Auxiliary test functions %
% %%%%%%%%%%%%%%%%%%%%%%%% %

% Get n random vectors with nd-dimensions
function vecs = get_vecs(n, nd)
    vecs = cell(1, n);
    for i = 1:n
        vecs{i} = rand(nd, 1);
    end
end

% Get n random unit vectors with nd-dimensions
function uvecs = get_unitvecs(n, nd)
    uvecs = cell(1, n);
    for i = 1:n
        v = rand(nd, 1);
        uvecs{i} = v ./ norm(v);
    end
end

% Get n angles
function angs = get_angles(n)
    angs = 2 * pi * rand(1, n) - pi;
end

% Returns true if the value of the sign of x is negative, otherwise false.
function s = signbit(x)
    s = x < 0;
end

% Get angle between two vectors, useful for checking correctness of results
% Previous version was unstable: angle(u, v) = acos(dot(u, v) / (norm(u) * norm(v)))
% Version below is based on AngleBetweenVectors.jl by Jeffrey Sarnoff (MIT license),
% https://github.com/JeffreySarnoff/AngleBetweenVectors.jl/blob/master/src/AngleBetweenVectors.jl
% in turn based on these notes by Prof. W. Kahan, see page 15:
% https://people.eecs.berkeley.edu/~wkahan/MathH110/Cross.pdf
function a = angle_btw(v1, v2)

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

% Reset random number generator with a given seed
function set_seed(seed)
    if moxunit_util_platform_is_octave()
        rand('state', seed);
        randn('state', seed);
    else
        rng(seed);
    end;
end

% %%%%%%%%%%%%%%%% %
% The actual tests %
% %%%%%%%%%%%%%%%% %

% Tests for the points_on_line() function
function test_points_on_line

    global seeds num_dims num_points llengths_mus;

    % Number of line directions to test
    ndirs = 3;

    % Number of line centers to test
    ncts = 3;

    % Cycle through all test parameters
    for nd = num_dims
        for tpts = num_points(num_points < 1000)
            for seed = seeds
                for length = llengths_mus
                    for dir = get_unitvecs(ndirs, nd)
                        for ctr = get_vecs(ncts, nd)

                            % Set seed
                            set_seed(seed);

                            % Create some random distances from center
                            dist2ctr = length .* rand(tpts, 1) - length / 2;

                            % Function should run without warnings
                            lastwarn('');
                            pts = points_on_line(ctr{:}, dir{:}, dist2ctr);
                            assertTrue(isempty(lastwarn));

                            % Check that the dimensions agree
                            assertEqual(size(pts), [tpts, nd]);

                            % Check that distance of points to the line is
                            % approximately zero
                            for i = 1:size(pts, 1)
                                % Current point
                                pt = pts(i, :);
                                % Get distance from current point to line
                                d = norm((pt' - ctr{:}) - dot(pt' - ctr{:}, dir{:}) .* dir{:});
                                % Check that it's approximately zero
                                assertVectorsAlmostEqual(d, 0);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

end

% Tests for the rand_unit_vector() function
function test_rand_unit_vector

    global seeds num_dims

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds

            % Set seed
            set_seed(seed);

            % Function should run without warnings
            lastwarn('');
            r = rand_unit_vector(nd);
            assertTrue(isempty(lastwarn));

            % Check that returned vector has the correct dimensions
            assertEqual(size(r), [nd 1]);

            % Check that returned vector has norm == 1
            assertElementsAlmostEqual(norm(r), 1);

        end;
    end;

end

% Tests for the rand_ortho_vector() function
function test_rand_ortho_vector

    global seeds num_dims

    % How many vectors to test?
    nvec = 10;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds
            for uvec = get_unitvecs(nvec, nd)

                % Set seed
                set_seed(seed);

                % Function should run without warnings
                lastwarn('');
                r = rand_ortho_vector(uvec{:});
                assertTrue(isempty(lastwarn));

                % Check that returned vector has the correct dimensions
                assertEqual(size(r), [nd 1]);

                % Check that returned vector has norm == 1
                assertElementsAlmostEqual(norm(r), 1);

                % Check that vectors are orthogonal
                if nd > 1
                    % The dot product of orthogonal vectors must be
                    % (approximately) zero
                    assertElementsAlmostEqual(dot(uvec{:}, r), 0);
                end;

            end;
        end;
    end;

end

% Tests for the rand_vector_at_angle() function
function test_rand_vector_at_angle

    global seeds num_dims

    % How many vectors to test?
    nvec = 10;

    % How many angles to test?
    nang = 10;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds
            for uvec = get_unitvecs(nvec, nd)
                for a = get_angles(nang)

                    % Set seed
                    set_seed(seed);

                    % Function should run without warnings
                    lastwarn('');
                    r = rand_vector_at_angle(uvec{:}, a);
                    assertTrue(isempty(lastwarn));

                    % Check that returned vector has the correct dimensions
                    assertEqual(size(r), [nd 1]);

                    % Check that returned vector has norm == 1
                    assertElementsAlmostEqual(norm(r), 1);

                    % Check that vectors u and r have an angle of a between them
                    if nd > 1 && abs(a) < pi/2
                        % @test angle(u, r) ≈ abs(a) atol=1e-12
                        assertElementsAlmostEqual(angle_btw(uvec{:}, r), abs(a));
                    end

                end;
            end;
        end;
    end;

end
