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

% Tests for the points_on_line function
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
