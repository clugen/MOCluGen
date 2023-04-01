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
% Copyright (c) 2021-2023 Nuno Fachada
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
    global seeds num_dims num_points num_clusters lat_stds llengths_mus ...
        llengths_sigmas angles_stds aes proj_fns ptd_fns csz_fns cc_fns ...
        ll_fns angd_fns ndirs ncts nvec nang moclugen_test_mode;

    if strcmpi(moclugen_test_mode, 'minimal')
        disp('Testing MOCluGen in `minimal` mode');

        % Mandatory parameters to test
        seeds = 123;
        num_dims = 2;
        num_points = 100;
        num_clusters = 5;
        lat_stds = 5.0;
        llengths_mus = 10;
        llengths_sigmas = 2;
        angles_stds = pi/256;

        % Optional parameters to test
        aes = true;
        proj_fns = {'unif'};
        ptd_fns = {'n'};
        csz_fns = {@clusizes};
        cc_fns = {@clucenters};
        ll_fns = {@llengths};
        angd_fns = {@angle_deltas};

        % Number of line directions to test
        ndirs = 1;

        % Number of line centers to test
        ncts = 1;

        % How many vectors to test?
        nvec = 1;

        % How many angles to test?
        nang = 1;

    elseif strcmpi(moclugen_test_mode, 'ci')
        disp('Testing MOCluGen in `ci` mode');

        % Mandatory parameters to test
        seeds = 123;
        num_dims = [1, 3];
        num_points = [1, 200];
        num_clusters = [1, 10];
        lat_stds = [0.0, 5.0];
        llengths_mus = [0, 10];
        llengths_sigmas = [0, 15];
        angles_stds = [pi/256, pi/2];

        % Optional parameters to test
        aes = [true, false];
        proj_fns = {'unif', @proj_dist_alt_equidist};
        ptd_fns = {'n', @point_dist_alt_plus1};
        csz_fns = {@clusizes, @clusizes_alt_equi};
        cc_fns = {@clucenters, @clucenters_alt_diag};
        ll_fns = {@llengths, @llengths_alt_unif_btw_10_20};
        angd_fns = {@angle_deltas, @angle_deltas_alt_zeros};

        % Number of line directions to test
        ndirs = 1;

        % Number of line centers to test
        ncts = 2;

        % How many vectors to test?
        nvec = 2;

        % How many angles to test?
        nang = 2;

    elseif strcmpi(moclugen_test_mode, 'normal')
        disp('Testing MOCluGen in `normal` mode');

        % Mandatory parameters to test
        seeds = [0, 123];
        num_dims = [1, 2, 3, 30];
        num_points = [1, 10, 500];
        num_clusters = [1, 5, 30, 100];
        lat_stds = [0.0, 5.0];
        llengths_mus = [0, 10];
        llengths_sigmas = [0, 15];
        angles_stds = [0, pi/256, pi/2, pi, 2*pi];

        % Optional parameters to test
        aes = [true, false];
        proj_fns = {'unif', @proj_dist_alt_equidist};
        ptd_fns = {'n', @point_dist_alt_plus1};
        csz_fns = {@clusizes, @clusizes_alt_equi};
        cc_fns = {@clucenters, @clucenters_alt_diag};
        ll_fns = {@llengths, @llengths_alt_unif_btw_10_20};
        angd_fns = {@angle_deltas, @angle_deltas_alt_zeros};

        % Number of line directions to test
        ndirs = 2;

        % Number of line centers to test
        ncts = 3;

        % How many vectors to test?
        nvec = 8;

        % How many angles to test?
        nang = 8;

    elseif strcmpi(moclugen_test_mode, 'full')
        disp('Testing MOCluGen in `full` mode (slow!)');

        % Mandatory parameters to test
        seeds = [0, 123, 9999, 9876543];
        num_dims = [1, 2, 3, 4, 30];
        num_points = [1, 10, 500, 10000];
        num_clusters = [1, 2, 5, 10, 100];
        lat_stds = [0.0, 5.0, 500];
        llengths_mus = [0, 10];
        llengths_sigmas = [0, 15];
        angles_stds = [0, pi/256, pi/4, pi/2, pi, 2*pi];

        % Optional parameters to test
        aes = [true, false];
        proj_fns = {'unif', @proj_dist_alt_equidist};
        ptd_fns = {'n', @point_dist_alt_plus1};
        csz_fns = {@clusizes, @clusizes_alt_equi};
        cc_fns = {@clucenters, @clucenters_alt_diag};
        ll_fns = {@llengths, @llengths_alt_unif_btw_10_20};
        angd_fns = {@angle_deltas, @angle_deltas_alt_zeros};

        % Number of line directions to test
        ndirs = 3;

        % Number of line centers to test
        ncts = 5;

        % How many vectors to test?
        nvec = 15;

        % How many angles to test?
        nang = 15;

    else
        error(['Unknown test mode `' moclugen_test_mode '`. Valid options '...
            ' are `minimal`, `ci`, `normal` or `full`.']);
    end
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

% Get n direction sets, each direction set containing three direction formats:
% 1) column vector; 2) row vector; 3) matrix (one direction per cluster)
function dirs = get_dirs(n, nd, nc)
    dirs = cell(1, 3 * n);
    for i = 1:n
        dirs{(i - 1) * 3 + 1} = rand(nd, 1);
        dirs{(i - 1) * 3 + 2} = rand(1, nd);
        dirs{(i - 1) * 3 + 3} = rand(nc, nd);
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
        clu_offs(2 + i, :) = 1000 * randn(1, nd);
    end;

end

% Get n angles
function angs = get_angles(n)
    angs = 2 * pi * rand(1, n) - pi;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Alternative module functions for clugen() testing purposes only %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

% Alternative function for proj_dist_fn parameter
function projd = proj_dist_alt_equidist(len, n)
    % Equidistant projections along line
    projd = (-len/2:len/n:len/2)';
    projd = projd(1:n);
end

% Alternative function for point_dist_fn parameter
function ptd = point_dist_alt_plus1(projs, lstd, len, cdir, cctr)
    % Add one to each projection component to obtain respective point
    ptd = projs + 1;
end

% Alternative function for clusizes_fn parameter
function csz = clusizes_alt_equi(nclu, tpts, ae)
    % All clusters have the same size, approximatelly
    csz = zeros(nclu, 1);
    for i = 1:tpts
        idx = rem(i, nclu) + 1;
        csz(idx) = csz(idx) + 1;
    end;
end

% Alternative function for clucenters_fn parameter
function ctrs = clucenters_alt_diag(nclu, csep, coff)
    % Put cluster centers equidistant on a diagonal line
    ctrs = ones(nclu, length(csep)) .* (1:nclu)';
end

% Alternative function for llengths_fn
function lens = llengths_alt_unif_btw_10_20(nclu, llen, llenstd)
    % Uniform lengths between 10 and 20
    lens = 10 + 10 * rand(nclu, 1);
end

% Alternative function for angle_deltas_fn
function angd = angle_deltas_alt_zeros(nclu, astd)
    % All angles deltas are zero
    angd = zeros(nclu, 1);
end

% %%%%%%%%%%%%%%%% %
% The actual tests %
% %%%%%%%%%%%%%%%% %

% Test the points_on_line() function
function test_points_on_line

    global seeds num_dims num_points llengths_mus ndirs ncts;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for tpts = num_points
            for seed = seeds

                % Set seed
                cluseed(seed);

                for length = llengths_mus
                    for dir = get_unitvecs(ndirs, nd)
                        for ctr = get_vecs(ncts, nd)

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

                            % Some tests done
                            tests_any_done = true;
                        end;
                    end;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the rand_unit_vector() function
function test_rand_unit_vector

    global seeds num_dims;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds

            % Set seed
            cluseed(seed);

            % Function should run without warnings
            lastwarn('');
            r = rand_unit_vector(nd);
            assertTrue(isempty(lastwarn));

            % Check that returned vector has the correct dimensions
            assertEqual(size(r), [nd 1]);

            % Check that returned vector has norm == 1
            assertElementsAlmostEqual(norm(r), 1);

            % Some tests done
            tests_any_done = true;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the rand_ortho_vector() function
function test_rand_ortho_vector

    global seeds num_dims nvec;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds

            % Set seed
            cluseed(seed);

            for uvec = get_unitvecs(nvec, nd)

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

                % Some tests done
                tests_any_done = true;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the rand_vector_at_angle() function
function test_rand_vector_at_angle

    global seeds num_dims nvec nang;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds

            % Set seed
            cluseed(seed);

            for uvec = get_unitvecs(nvec, nd)
                for a = get_angles(nang)

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

                    % Some tests done
                    tests_any_done = true;
                end;

                % Check corner case where angle == pi / 2 and vector length > 1
                if nd > 1
                    v = 100 * rand(1) * uvec{:};
                    lastwarn('');
                    r = rand_vector_at_angle(v, pi / 2);
                    assertTrue(isempty(lastwarn));
                    assertElementsAlmostEqual(angle_btw(v, r), pi / 2);
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the angle_btw() function
function test_angle_btw

    % Commonly used function for determining the angle between two vectors
    common_angle_btw = @(v1, v2) acos(dot(v1, v2) / (norm(v1) * norm(v2)));

    % 2D
    u = [1.5, 0];
    v = [0.1, -0.4];
    assertElementsAlmostEqual(angle_btw(u, v), common_angle_btw(u, v))

    % 3D
    u = [-1.5, 10, 0];
    v = [0.99, 4.4, -1.1];
    assertElementsAlmostEqual(angle_btw(u, v), common_angle_btw(u, v))

    % 8D
    u = [1.5, 0, 0, 0, 0, 0, 0, -0.5];
    v = [7.5, -0.4, 0, 0, 0, -16.4, 0.1, -0.01];
    assertElementsAlmostEqual(angle_btw(u, v), common_angle_btw(u, v))

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

    global seeds num_dims num_points lat_stds llengths_mus ndirs ncts;

    % Any tests performed?
    tests_any_done = false;

    % Distance from points to projections will be 10
    dist_pt = 10;

    % Cycle through all test parameters
    for nd = num_dims
        for tpts = num_points
            for seed = seeds

                % Set seed
                cluseed(seed);

                for lat_std = lat_stds
                    for length = llengths_mus
                        for dir = get_unitvecs(ndirs, nd)
                            for ctr = get_vecs(ncts, nd)

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

                                % The following checks are only for
                               % dimensionality above 1
                               if nd > 1
                                    % For each vector from projection to point...
                                    proj_pt_vecs = pts - proj;
                                    for i = 1:tpts
                                        % Get current vector
                                        u = proj_pt_vecs(i, :)';
                                        % Vector should be approximately
                                        % orthogonalto the cluster line
                                        assertElementsAlmostEqual(dot(dir{:}, u), 0);
                                        % Vector should have a magnitude of
                                        % approximately dist_pt
                                        assertElementsAlmostEqual(norm(u), dist_pt);
                                    end
                                end

                                % Some tests done
                                tests_any_done = true;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the angle_deltas function
function test_angle_deltas

    global seeds num_clusters angles_stds;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for seed = seeds

        % Set seed
        cluseed(seed);

        for nclu = num_clusters
            for astd = angles_stds

                % Function should run without warnings
                lastwarn('');
                angles = angle_deltas(nclu, astd);
                assertTrue(isempty(lastwarn));

                % Check that return value has the correct dimensions
                assertEqual(size(angles), [nclu 1]);

                % Check that all angles are between -π/2 and π/2
                assertTrue(all(angles <= pi/2));
                assertTrue(all(angles >= -pi/2));

                % Some tests done
                tests_any_done = true;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clucenters function
function test_clucenters

    global num_dims seeds num_clusters;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for seed = seeds

            % Set seed
            cluseed(seed);

            for nclu = num_clusters
                for clu_sep = get_clu_seps(nd)'
                    for clu_off = get_clu_offsets(nd)'

                        % Function should run without warnings
                        lastwarn('');
                        clu_ctrs = clucenters(nclu, clu_sep, clu_off);
                        assertTrue(isempty(lastwarn));

                        % Check that return value has the correct dimensions
                        assertEqual(size(clu_ctrs), [nclu nd]);

                        % Some tests done
                        tests_any_done = true;
                    end;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the llengths function
function test_llengths

    global seeds num_clusters llengths_mus llengths_sigmas;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for seed = seeds

        % Set seed
        cluseed(seed);

        for nclu = num_clusters
            for len = llengths_mus
                for len_std = llengths_sigmas

                    % Function should run without warnings
                    lastwarn('');
                    lens = llengths(nclu, len, len_std);
                    assertTrue(isempty(lastwarn));

                    % Check that return value has the correct dimensions
                    assertEqual(size(lens), [nclu 1]);

                    % Check that all lengths are >= 0
                    assertTrue(all(lens >= 0));

                    % Some tests done
                    tests_any_done = true;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clusizes function
function test_clusizes

    global seeds num_clusters num_points;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for seed = seeds

        % Set seed
        cluseed(seed);

        for nclu = num_clusters
            for tpts = num_points
                for ae = [true, false]

                    % Don't test if number of points is less than number of
                    % clusters and we don't allow empty clusters
                    if ~ae && tpts < nclu
                        continue;
                    end

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

                    % Some tests done
                    tests_any_done = true;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clupoints_n_1 function
function test_clupoints_n_1

    global seeds num_dims num_points lat_stds llengths_mus ndirs ncts;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for tpts = num_points
            for seed = seeds

                % Set seed
                cluseed(seed);

                for lat_std = lat_stds
                    for length = llengths_mus
                        for dir = get_unitvecs(ndirs, nd)
                            for ctr = get_vecs(ncts, nd)

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

                                % The following checks are only for
                                % dimensionality above 1
                                if nd > 1
                                    % For each vector from projection to point...
                                    proj_pt_vecs = pts - proj;
                                    for i = 1:tpts
                                        % Get current vector
                                        u = proj_pt_vecs(i, :)';
                                        % Vector should be approximately
                                        % orthogonal to the cluster line
                                        assertElementsAlmostEqual(dot(dir{:}, u), 0);
                                    end
                                end

                                % Some tests done
                                tests_any_done = true;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clupoints_n function
function test_clupoints_n

    global seeds num_dims num_points lat_stds llengths_mus ndirs ncts;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for nd = num_dims
        for tpts = num_points
            for seed = seeds

                % Set seed
                cluseed(seed);

                for lat_std = lat_stds
                    for length = llengths_mus
                        for dir = get_unitvecs(ndirs, nd)
                            for ctr = get_vecs(ncts, nd)

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

                                % Some tests done
                                tests_any_done = true;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clugen function mandatory parameters
function test_clugen_mandatory

    global seeds num_dims num_clusters num_points angles_stds llengths_mus ...
        llengths_sigmas lat_stds ndirs;

    % Any tests performed?
    tests_any_done = false;

    % Cycle through all test parameters
    for seed = seeds

        % Set seed
        cluseed(seed);

        for nd = num_dims
            for nclu = num_clusters
                for tpts = num_points
                    for dir = get_dirs(ndirs, nd, nclu)
                        for astd = angles_stds
                            for clu_sep = get_clu_seps(nd)'
                                for len_mu = llengths_mus
                                    for len_std = llengths_sigmas
                                        for lat_std = lat_stds

                                            % By default, allow_empty is false, so clugen() must be
                                            % given more points than clusters...
                                            if tpts >= nclu
                                                % ...in which case it runs without problem
                                                lastwarn('');
                                                cdata = clugen( ...
                                                    nd, nclu, tpts, dir{:}, astd, clu_sep, len_mu, ...
                                                    len_std, lat_std);
                                                assertTrue(isempty(lastwarn));
                                            else
                                                % ...otherwise an error will be thrown
                                                fn = @() clugen(nd, nclu, tpts, dir, astd, ...
                                                    clu_sep, len_mu, len_std, lat_std);
                                                assertError(fn);
                                                continue; % No need for more tests with this parameter set
                                            end;

                                            % Check dimensions of result variables
                                            assertEqual(size(cdata.points), [tpts nd]);
                                            assertTrue(isnumeric(cdata.points));
                                            assertEqual(size(cdata.clusters), [tpts 1]);
                                            assertTrue(isnumeric(cdata.clusters));
                                            assertTrue(all(rem(cdata.clusters, 1) == 0));
                                            assertEqual(size(cdata.projections), [tpts nd]);
                                            assertTrue(isnumeric(cdata.projections));
                                            assertEqual(size(cdata.sizes), [nclu 1]);
                                            assertTrue(isnumeric(cdata.sizes));
                                            assertTrue(all(rem(cdata.sizes, 1) == 0));
                                            assertEqual(size(cdata.centers), [nclu nd]);
                                            assertTrue(isnumeric(cdata.centers));
                                            assertEqual(size(cdata.directions), [nclu nd]);
                                            assertTrue(isnumeric(cdata.directions));
                                            assertEqual(size(cdata.angles), [nclu 1]);
                                            assertTrue(isnumeric(cdata.angles));
                                            assertEqual(size(cdata.lengths), [nclu 1]);
                                            assertTrue(isnumeric(cdata.lengths));

                                            % Check point cluster indexes
                                            assertEqual(unique(cdata.clusters), (1:nclu)');

                                            % Check total points
                                            assertEqual(sum(cdata.sizes), tpts);

                                            % Check that cluster directions have the correct angles
                                            % with the main direction
                                            if nd > 1
                                                d = dir{:};
                                                if numel(d) == nd
                                                    d = reshape(d, [1 nd]);
                                                    d = repmat(d, nclu, 1);
                                                end;
                                                for i = 1:nclu
                                                    assertElementsAlmostEqual(...
                                                        angle_btw(d(i, :)', cdata.directions(i, :)'), ...
                                                        abs(cdata.angles(i)));
                                                end;
                                            end;

                                            % Some tests done
                                            tests_any_done = true;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clugen function optional parameters
function test_clugen_optional

    global seeds aes proj_fns ptd_fns csz_fns cc_fns ll_fns angd_fns;

    % Any tests performed?
    tests_any_done = false;

    % Valid arguments
    nclu = 7;
    tpts = 500;
    astd = pi/256;
    len_mu = 9;
    len_std = 1.2;
    lat_std = 2;

    % Cycle through all test parameters
    for seed = seeds

        % Set seed
        cluseed(seed);

        for nd = [2, 7]

            clu_sep = len_mu * 3 * rand(nd, 1);
            clu_off = rand(nd, 1);
            dir = rand(nd, 1);

            for ae = aes % true, false
                for projd_fn = proj_fns % 'unif', etc.
                    for ptd_fn = ptd_fns % 'n', etc.
                        for csz_fn = csz_fns % clusizes, etc.
                            for cc_fn = cc_fns % clucenters, etc.
                                for ll_fn = ll_fns % llengths, etc.
                                    for angd_fn = angd_fns % angle_deltas, etc.

                                        % Function must execute without warnings
                                        lastwarn('');
                                        cdata = clugen( ...
                                            nd, nclu, tpts, dir, astd, clu_sep, len_mu, ...
                                            len_std, lat_std, ...
                                            'allow_empty', ae, ...
                                            'cluster_offset', clu_off, ...
                                            'proj_dist_fn', projd_fn{:}, ...
                                            'point_dist_fn', ptd_fn{:}, ...
                                            'clusizes_fn', csz_fn{:}, ...
                                            'clucenters_fn', cc_fn{:}, ...
                                            'llengths_fn', ll_fn{:}, ...
                                            'angle_deltas_fn', angd_fn{:}, ...
                                            'seed', seed);
                                        assertTrue(isempty(lastwarn));

                                        % Check expected sizes and types of return values
                                        assertEqual(size(cdata.points), [tpts nd]);
                                        assertTrue(isnumeric(cdata.points));
                                        assertEqual(size(cdata.clusters), [tpts 1]);
                                        assertTrue(isnumeric(cdata.clusters));
                                        assertTrue(all(rem(cdata.clusters, 1) == 0));
                                        assertEqual(size(cdata.projections), [tpts nd]);
                                        assertTrue(isnumeric(cdata.projections));
                                        assertEqual(size(cdata.sizes), [nclu 1]);
                                        assertTrue(isnumeric(cdata.sizes));
                                        assertTrue(all(rem(cdata.sizes, 1) == 0));
                                        assertEqual(size(cdata.centers), [nclu nd]);
                                        assertTrue(isnumeric(cdata.centers));
                                        assertEqual(size(cdata.directions), [nclu nd]);
                                        assertTrue(isnumeric(cdata.directions));
                                        assertEqual(size(cdata.angles), [nclu 1]);
                                        assertTrue(isnumeric(cdata.angles));
                                        assertEqual(size(cdata.lengths), [nclu 1]);
                                        assertTrue(isnumeric(cdata.lengths));

                                        % Check point cluster indexes
                                        if ~ae
                                            assertEqual(unique(cdata.clusters), (1:nclu)');
                                        else
                                            assertTrue(all(cdata.clusters <= nclu));
                                        end;

                                        % Check total points
                                        assertEqual(sum(cdata.sizes), tpts);
                                        % This might not be the case if the
                                        % specified clusize_fn does not obey the
                                        % total number of points

                                        % Some tests done
                                        tests_any_done = true;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    % Make sure some tests were performed
    assertTrue(tests_any_done);
end

% Test the clugen function exceptions / errors
function test_clugen_exceptions

    % Valid arguments
    nd = 3;
    nclu = 5;
    seed = 123;
    tpts = 1000;
    dir = [1; 0; 0];
    astd = pi/64;
    clu_sep = [10; 10; 5];
    len_mu = 5;
    len_std = 0.5;
    lat_std = 0.3;
    ae = true;
    clu_off = [-1.5; 0; 2];
    pt_dist = 'unif';
    pt_off = 'n';
    csizes_fn = @clusizes;
    ccenters_fn = @clucenters;
    llengths_fn = @llengths;
    langles_fn = @angle_deltas;

    % No warnings with valid arguments
    lastwarn('');
    clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertTrue(isempty(lastwarn));

    % No warnings with zero points since allow_empty is set to true
    lastwarn('');
    clugen(nd, nclu, 0, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertTrue(isempty(lastwarn));

    % When allow_empty is false, num_points must be >= num_clusters
    fn = @() clugen(nd, nclu, 0, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', false, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Seed needs to be positive integer
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', -123);
    assertError(fn);

    % Invalid number of dimensions
    fn = @() clugen(0, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid number of clusters
    fn = @() clugen(nd, 0, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Direction needs to have magnitude > 0
    fn = @() clugen(nd, nclu, tpts, [0; 0; 0], astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Direction needs to have length nd (or nd columns)
    fn = @() clugen(nd, nclu, tpts, [0.5; 1], astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Direction needs to have nclu rows and nd columns
    dir_badrows = [0.5 1 3; 2 1 0];
    fn = @() clugen(nd, nclu, tpts, dir_badrows, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Direction needs to have nclu rows and nd columns
    dir_badcols = [0.5 1; 2 1; 2 1; -1 3; 10 2];
    fn = @() clugen(nd, nclu, tpts, dir_badcols, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Direction needs to be vector (1D) or matrix (2D)
    dir_baddims = ones(nclu, nd, 4);
    fn = @() clugen(nd, nclu, tpts, dir_baddims, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % cluster_sep needs to have nd dims
    fn = @() clugen(nd, nclu, tpts, dir, astd, [50; 50; 50; 50], len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % cluster_offset needs to have nd dims
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', -50, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Unknown proj_dist_fn given as string
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', 'bad_proj_dist', ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid proj_dist_fn given as function
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', @(x) [x;x;x], ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Unknown point_dist_fn given as string
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', 'n+1', 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid point_dist_fn given as function
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', @(x) [x;x;x], 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid function given as clusizes_fn
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', @(x) [x;x;x], ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid function given as clucenters_fn
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', @(x) [x;x;x], 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid function given as llengths_fn
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', @(x) [x;x;x], ...
        'angle_deltas_fn', langles_fn, 'seed', seed);
    assertError(fn);

    % Invalid function given as angle_deltas_fn
    fn = @() clugen(nd, nclu, tpts, dir, astd, clu_sep, len_mu, len_std, lat_std, ...
        'allow_empty', ae, 'cluster_offset', clu_off, 'proj_dist_fn', pt_dist, ...
        'point_dist_fn', pt_off, 'clusizes_fn', csizes_fn, ...
        'clucenters_fn', ccenters_fn, 'llengths_fn', llengths_fn, ...
        'angle_deltas_fn', @(x) [x;x;x], 'seed', seed);
    assertError(fn);

end
