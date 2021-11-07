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
    global seeds num_dims num_points lat_stds llengths_mus;

    seeds = [0, 123, 9999, 9876543];
    num_dims = [1, 2, 3, 4, 30];
    num_points = [1, 10, 500, 10000];
    num_clusters = [1, 2, 5, 10, 100];
    lat_stds = [0.0, 5.0, 500];
    llengths_mus = [0, 10];
    llengths_sigmas = [0, 15];
    angles_stds = [0, pi/256, pi/32, pi/4, pi/2, pi, 2*pi];

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

% Get random cluster separations
function clu_seps = get_clu_seps(nd)
    clu_seps = get_clu_offsets(nd);
end

% Get random cluster offsets
function clu_offs = get_clu_offsets(nd)

    global seeds;

    clu_offs = zeros(2 + numel(seeds), nd);
    clu_offs(2, :) = ones(1, nd);
    for i = 1:numel(seeds)
        set_seed(seeds(i));
        clu_offs(2 + i, :) = 1000 * rand(1, nd);
    end;

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

% Test the points_on_line() function
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

% Test the rand_unit_vector() function
function test_rand_unit_vector

    global seeds num_dims;

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

% Test the rand_ortho_vector() function
function test_rand_ortho_vector

    global seeds num_dims;

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

% Test the rand_vector_at_angle() function
function test_rand_vector_at_angle

    global seeds num_dims;

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
                        assertElementsAlmostEqual(angle_btw(uvec{:}, r), abs(a));
                    end

                end;
            end;
        end;
    end;

end

% Test the fix_empty() function
function test_fix_empty

    % No empty clusters
    clusts = [11; 21; 10];
    clusts_fixed = fix_empty(clusts, false);
    assertEqual(clusts, clusts_fixed);

    % Empty clusters, no fix
    clusts = [0; 11; 21; 10; 0; 0];
    clusts_fixed = fix_empty(clusts, true);
    assertEqual(clusts, clusts_fixed);

    % Empty clusters, fix
    clusts = [5; 0; 21; 10; 0; 0; 101];
    clusts_fixed = fix_empty(clusts, false);
    assertEqual(sum(clusts), sum(clusts_fixed));
    assertNotEqual(clusts, clusts_fixed);
    assertEqual(any(clusts_fixed == 0), false);

    % Empty clusters, fix, several equal maximums
    clusts = [101; 5; 0; 21; 101; 10; 0; 0; 101; 100; 99; 0; 0; 0; 100];
    clusts_fixed = fix_empty(clusts, false);
    assertEqual(sum(clusts), sum(clusts_fixed));
    assertNotEqual(clusts, clusts_fixed);
    assertEqual(any(clusts_fixed == 0), false);

    % Empty clusters, no fix (flag)
    clusts = [0; 10];
    clusts_fixed = fix_empty(clusts, true);
    assertEqual(clusts, clusts_fixed);

    % Empty clusters, no fix (not enough points)
    clusts = [0; 1; 1; 0; 0; 2; 0; 0];
    clusts_fixed = fix_empty(clusts, false);
    assertEqual(clusts, clusts_fixed);

    % Works with 1D
    clusts = 100;
    clusts_fixed = fix_empty(clusts, true);
    assertEqual(clusts, clusts_fixed);

end

% Test the fix_num_points() function
function test_fix_num_points

    % No change
    clusts = [10; 100; 42; 0; 12];
    clusts_fixed = fix_num_points(clusts, sum(clusts));
    assertEqual(clusts, clusts_fixed);

    % Fix due to too many points
    clusts = [55; 12];
    num_pts = sum(clusts) - 14;
    clusts_fixed = fix_num_points(clusts, num_pts);
    assertNotEqual(clusts, clusts_fixed);
    assertEqual(sum(clusts_fixed), num_pts);

    % Fix due to too few points
    clusts = [0; 1; 0; 0];
    num_pts = 15;
    clusts_fixed = fix_num_points(clusts, num_pts);
    assertNotEqual(clusts, clusts_fixed);
    assertEqual(sum(clusts_fixed), num_pts);

    % 1D - No change
    clusts = 10;
    clusts_fixed = fix_num_points(clusts, sum(clusts));
    assertEqual(clusts, clusts_fixed);

    % 1D - Fix due to too many points
    clusts = 241;
    num_pts = sum(clusts) - 20;
    clusts_fixed = fix_num_points(clusts, num_pts);
    assertNotEqual(clusts, clusts_fixed);
    assertEqual(sum(clusts_fixed), num_pts);

    % 1D - Fix due to too few points
    clusts = 0;
    num_pts = 8;
    clusts_fixed = fix_num_points(clusts, num_pts);
    assertNotEqual(clusts, clusts_fixed);
    assertEqual(sum(clusts_fixed), num_pts);

end

% Test the clupoints_n_1_template function
function test_clupoints_n_1_template

    global seeds num_dims num_points lat_stds llengths_mus;

    % Number of line directions to test
    ndirs = 3;

    % Number of line centers to test
    ncts = 3;

    % Distance from points to projections will be 10
    dist_pt = 10;

    % Cycle through all test parameters
    for nd = num_dims(2:end) % Skip nd==1
        for tpts = num_points(num_points < 1000)
            for seed = seeds
                for lat_std = lat_stds
                    for length = llengths_mus
                        for dir = get_unitvecs(ndirs, nd)
                            for ctr = get_vecs(ncts, nd)

                                % Set seed
                                set_seed(seed);

                                % Create some point projections
                                pd2ctr = length * rand(tpts, 1) - length / 2;
                                proj = points_on_line(ctr{:}, dir{:}, pd2ctr);

                                % Very simple dist_fn, always puts points at a
                                % distance of dist_pt
                                dist_fn = @(clu_num_points, ldisp) ...
                                    randi([0 1], clu_num_points, 1) * dist_pt * 2 ...
                                        - dist_pt;

                                % Function should run without warnings
                                lastwarn('');
                                pts = clupoints_n_1_template( ...
                                    proj, lat_std, dir{:}, dist_fn);
                                assertTrue(isempty(lastwarn));

                                % Check that number of points is the same as the
                                % number of projections
                                assertEqual(size(pts), size(proj));

                                % For each vector from projection to point...
                                proj_pt_vecs = pts - proj;
                                for i = 1:num_points
                                    % Get current vector
                                    u = proj_pt_vecs(i, :)';
                                    % Vector should be approximately orthogonal
                                    % to the cluster line
                                    assertElementsAlmostEqual(dot(dir{:}, u), 0);
                                    % Vector should of a magnitude of
                                    % approximately dist_pt
                                    assertElementsAlmostEqual(norm(u), dist_pt);
                                end

                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

end

% Test the angle_deltas function
function test_angle_deltas

    global seeds num_clusters angles_stds;

    % Cycle through all test parameters
    for seed = seeds
        for nclu = num_clusters
            for astd = angles_stds

                % Set seed
                set_seed(seed);

                % Function should run without warnings
                lastwarn('');
                angles = angle_deltas(nclu, astd);
                assertTrue(isempty(lastwarn));

                % Check that return value has the correct dimensions
                assertEqual(size(angles), [nclu 1]);

                % Check that all angles are between -π/2 and π/2
                assertTrue(all(angles <= pi/2));
                assertTrue(all(angles >= -pi/2));

            end;
        end;
    end;
end

% Test the clucenters function
function test_clucenters

    global num_dims seeds num_clusters;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds
            for nclu = num_clusters
                for clu_sep = get_clu_seps(nd)'
                    for clu_off = get_clu_offsets(nd)'

                        % Set seed
                        set_seed(seed);

                        % Function should run without warnings
                        lastwarn('');
                        clu_ctrs = clucenters(nclu, clu_sep, clu_off);
                        assertTrue(isempty(lastwarn));

                        % Check that return value has the correct dimensions
                        assertEqual(size(clu_ctrs), [nclu nd]);

                    end;
                end;
            end;
        end;
    end;
end

% Test the llengths function
function test_llengths

    global num_dims seeds num_clusters;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds
            for nclu = num_clusters
                for llength_mu = llengths_mus
                    for llengths_sigma = llengths_sigmas

                        % Set seed
                        set_seed(seed);

                        % Function should run without warnings
                        lastwarn('');
                        lens = llengths(nclu, llength_mu, llength_sigma);
                        assertTrue(isempty(lastwarn));

                        % Check that return value has the correct dimensions
                        assertEqual(size(lens), [nclu 1]);

                        % Check that all lengths are >= 0
                        assertTrue(all(lens >= 0));

                    end;
                end;
            end;
        end;
    end;
end

% Test the clusizes function
function test_clusizes

    global seeds num_clusters num_points;

    % Cycle through all test parameters
    for seed = seeds
        for nclu = num_clusters
            for tpts = num_points
                for ae = [true, false]

                    % Don't test if number of points is less than number of
                    % clusters and we don't allow empty clusters
                    if ~ae && tpts < nclu
                        continue;
                    end

                    % Set seed
                    set_seed(seed);

                    % Function should run without warnings
                    lastwarn('');
                    clu_sizes = clusizes(nclu, tpts, ae);
                    assertTrue(isempty(lastwarn));

                    % Check that the output has the correct number of clusters
                    assertEqual(size(clu_sizes), [nclu 1]);

                    % Check that the total number of points is correct
                    assertEqual(sum(clu_sizes), tpts);

                    % If empty clusters are not allowed, check that all of them
                    % have points
                    if ~ae
                        assertTrue(all(clu_sizes > 0));
                    end;

                end;
            end;
        end;
    end;
end

% Test the clupoints_n_1 function
function test_clupoints_n_1

    global seeds num_dims num_points lat_stds llengths_mus;

    % Number of line directions to test
    ndirs = 3;

    % Number of line centers to test
    ncts = 3;

    % Cycle through all test parameters
    for nd = num_dims(2:end) % Skip nd==1
        for tpts = num_points(num_points < 1000)
            for seed = seeds
                for lat_std = lat_stds
                    for length = llengths_mus
                        for dir = get_unitvecs(ndirs, nd)
                            for ctr = get_vecs(ncts, nd)

                                % Set seed
                                set_seed(seed);

                                % Create some point projections
                                pd2ctr = length * rand(tpts, 1) - length / 2;
                                proj = points_on_line(ctr{:}, dir{:}, pd2ctr);

                                % Function should run without warnings
                                lastwarn('');
                                pts = clupoints_n_1( ...
                                    proj, lat_std, length, dir{:}, ctr{:});
                                assertTrue(isempty(lastwarn));

                                % Check that number of points is the same as the
                                % number of projections
                                assertEqual(size(pts), size(proj));

                                % For each vector from projection to point...
                                proj_pt_vecs = pts - proj;
                                for i = 1:num_points
                                    % Get current vector
                                    u = proj_pt_vecs(i, :)';
                                    % Vector should be approximately orthogonal
                                    % to the cluster line
                                    assertElementsAlmostEqual(dot(dir{:}, u), 0);
                                end

                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

end

% Test the clupoints_n function
function test_clupoints_n

    global seeds num_dims num_points lat_stds llengths_mus;

    % Number of line directions to test
    ndirs = 3;

    % Number of line centers to test
    ncts = 3;

    % Cycle through all test parameters
    for nd = num_dims(2:end) % Skip nd==1
        for tpts = num_points
            for seed = seeds
                for lat_std = lat_stds
                    for length = llengths_mus
                        for dir = get_unitvecs(ndirs, nd)
                            for ctr = get_vecs(ncts, nd)

                                % Set seed
                                set_seed(seed);

                                % Create some point projections
                                pd2ctr = length * rand(tpts, 1) - length / 2;
                                proj = points_on_line(ctr{:}, dir{:}, pd2ctr);

                                % Function should run without warnings
                                lastwarn('');
                                pts = clupoints_n( ...
                                    proj, lat_std, length, dir{:}, ctr{:});
                                assertTrue(isempty(lastwarn));

                                % Check that number of points is the same as the
                                % number of projections
                                assertEqual(size(pts), size(proj));

                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

end
