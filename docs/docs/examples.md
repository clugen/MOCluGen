# Examples

These examples can be exactly reproduced in GNU Octave 5.2.0 by using the seed
specified at the beginning of each code block.

## Examples in 2D

These examples were plotted with the `plot_examples_2d()` helper function available
[here](https://github.com/clugen/MOCluGen/tree/master/docs/plot_funcs/plot_examples_2d.m).

### Manipulating the direction of cluster-supporting lines

#### Using the `direction` parameter

```matlab
seed = 123;

e01 = clugen(2, 4, 200, [1 0], 0, [10 10], 10, 1.5, 0.5, 'seed', seed);
e02 = clugen(2, 4, 200, [1 1], 0, [10 10], 10, 1.5, 0.5, 'seed', seed);
e03 = clugen(2, 4, 200, [0 1], 0, [10 10], 10, 1.5, 0.5, 'seed', seed);
```

```matlab
plot_examples_2d(...
    e01, 'e01: direction = [1; 0]', ...
    e02, 'e02: direction = [1; 1]', ...
    e03, 'e03: direction = [0; 1]');
```

[![](img/e01e02e03.png)](img/e01e02e03.png)

#### Changing the `angle_disp` parameter and using a custom `angle_deltas_fn` function

```matlab
seed = 9876;

% Custom angle_deltas function: arbitrarily rotate some clusters by 90 degrees
% Requires the statistics toolbox in either Octave or MATLAB
angdel_90 = @(nclu, astd) randsample([0 pi/2], nclu, true);

e04 = clugen(2, 6, 500, [1 0], 0, [10 10], 10, 1.5, 0.5, 'seed', seed);
e05 = clugen(2, 6, 500, [1 0], pi / 8, [10 10], 10, 1.5, 0.5, 'seed', seed);
e06 = clugen(2, 6, 500, [1 0], 0, [10 10], 10, 1.5, 0.5, 'seed', seed, ...
    'angle_deltas_fn', angdel_90);
```

```matlab
plot_examples_2d(...
    e04, 'e04: angle\_disp = 0', ...
    e05, 'e05: angle\_disp = π/8', ...
    e06, 'e06: custom angle\_deltas function');
```

[![](img/e04e05e06.png)](img/e04e05e06.png)

### Manipulating the length of cluster-supporting lines

#### Using the `llength` parameter

```matlab
seed = 1234;

e07 = clugen(2, 5, 800, [1 0], pi / 10, [10 10], 0, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e08 = clugen(2, 5, 800, [1 0], pi / 10, [10 10], 10, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e09 = clugen(2, 5, 800, [1 0], pi / 10, [10 10], 30, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
```

```matlab
plot_examples_2d(...
    e07, 'e07: llength = 0', e08, 'e08: llength = 10', e09, 'e09: llength = 30');
```

[![](img/e07e08e09.png)](img/e07e08e09.png)

#### Changing the `llength_disp` parameter and using a custom `llengths_fn` function

```matlab
seed = 1234;

% Custom llengths function: line lengths grow for each new cluster
llen_grow = @(nclu, llen, llenstd) llen * (0:(nclu - 1))' + llenstd * randn(nclu, 1);

e10 = clugen(2, 5, 800, [1 0], pi / 10, [10 10], 15,  0.0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e11 = clugen(2, 5, 800, [1 0], pi / 10, [10 10], 15, 10.0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e12 = clugen(2, 5, 800, [1 0], pi / 10, [10 10], 10,  0.1, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n', 'llengths_fn', llen_grow);
```

```matlab
plot_examples_2d(...
    e10, 'e10: llength\_disp = 0.0', ...
    e11, 'e11: llength\_disp = 5.0', ...
    e12, 'e12: custom llengths function');
```

[![](img/e10e11e12.png)](img/e10e11e12.png)

### Manipulating relative cluster positions

#### Using the `cluster_sep` parameter

```matlab
seed = 3210;

e13 = clugen(2, 8, 1000, [1 1], pi / 4, [10 10], 10, 2, 2.5, 'seed', seed);
e14 = clugen(2, 8, 1000, [1 1], pi / 4, [30 10], 10, 2, 2.5, 'seed', seed);
e15 = clugen(2, 8, 1000, [1 1], pi / 4, [10 30], 10, 2, 2.5, 'seed', seed);
```

```matlab
plot_examples_2d(...
    e13, 'e13: cluster\_sep = [10; 10]', ...
    e14, 'e14: cluster\_sep = [30; 10]', ...
    e15, 'e15: cluster\_sep = [10; 30]');
```

[![](img/e13e14e15.png)](img/e13e14e15.png)

#### Changing the `cluster_offset` parameter and using a custom `clucenters_fn` function

```matlab
seed = 3210;

% Custom clucenters function: places clusters in a diagonal
centers_diag = @(nclu, csep, coff) ones(nclu, numel(csep)) .* (1:nclu)' * max(csep) + coff';

e16 = clugen(2, 8, 1000, [1 1], pi / 4, [10 10], 10, 2, 2.5, 'seed', seed);
e17 = clugen(2, 8, 1000, [1 1], pi / 4, [10 10], 10, 2, 2.5, 'seed', seed, ...
    'cluster_offset', [20 -20]);
e18 = clugen(2, 8, 1000, [1; 1], pi / 4, [10 10], 10, 2, 2.5, 'seed', seed, ...
    'cluster_offset', [-50 -50], 'clucenters_fn', centers_diag);
```

```matlab
plot_examples_2d(...
    e16, 'e16: default', ...
    e17, 'e17: cluster\_offset = [20; -20]', ...
    e18, 'e18: custom clucenters function');
```

[![](img/e16e17e18.png)](img/e16e17e18.png)

### Lateral dispersion and placement of point projections on the line

#### Normal projection placement (default): `proj_dist_fn = 'norm'`

```matlab
seed = 5678;

e19 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 0.0, 'seed', seed);
e20 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 1.0, 'seed', seed);
e21 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 3.0, 'seed', seed);
```

```matlab
plot_examples_2d(...
    e19, 'e19: lateral\_disp = 0', ...
    e20, 'e20: lateral\_disp = 1', ...
    e21, 'e21: lateral\_disp = 3');
```

[![](img/e19e20e21.png)](img/e19e20e21.png)

#### Uniform projection placement: `proj_dist_fn = 'unif'`

```matlab
seed = 5678;

e22 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 0.0, 'seed', seed, 'proj_dist_fn', 'unif');
e23 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 1.0, 'seed', seed, 'proj_dist_fn', 'unif');
e24 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 3.0, 'seed', seed, 'proj_dist_fn', 'unif');
```

```matlab
plot_examples_2d(...
    e22, 'e22: lateral\_disp = 0', ...
    e23, 'e23: lateral\_disp = 1', ...
    e24, 'e24: lateral\_disp = 3');
```

[![](img/e22e23e24.png)](img/e22e23e24.png)

#### Custom projection placement using the Beta distribution

```matlab
seed = 5678;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.1, 0.1, [n 1]) - len / 2;

e25 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 0.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);
e26 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 1.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);
e27 = clugen(2, 4, 1000, [1 0], pi / 2, [20 20], 13, 2, 3.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_2d(...
    e25, 'e25: lateral\_disp = 0', ...
    e26, 'e26: lateral\_disp = 1', ...
    e27, 'e27: lateral\_disp = 3');
```

[![](img/e25e26e27.png)](img/e25e26e27.png)

### Controlling final point positions from their projections on the cluster-supporting line

#### Points on hyperplane orthogonal to cluster-supporting line (default): `point_dist_fn = 'n-1'`

```matlab
seed = 5050;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.03, 0.03, [n 1]) - len / 2;

e28 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 2.0, 'seed', seed);
e29 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 2.0, 'seed', seed, ...
    'proj_dist_fn', 'unif');
e30 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 2.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_2d(...
    e28, 'e28: proj\_dist\_fn = "norm" (default)', ...
    e29, 'e29: proj\_dist\_fn = "unif"', ...
    e30, 'e30: custom proj\_dist\_fn (Beta)');
```

[![](img/e28e29e30.png)](img/e28e29e30.png)

#### Points around projection on cluster-supporting line: `point_dist_fn = 'n'`

```matlab
seed = 5050;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.03, 0.03, [n 1]) - len / 2;

e31 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 2.0, 'seed', seed, ...
    'point_dist_fn', 'n');
e32 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 2.0, 'seed', seed, ...
    'point_dist_fn', 'n', 'proj_dist_fn', 'unif');
e33 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 2.0, 'seed', seed, ...
    'point_dist_fn', 'n', 'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_2d(...
    e31, 'e31: proj\_dist\_fn = "norm" (default)', ...
    e32, 'e32: proj\_dist\_fn = "unif"', ...
    e33, 'e33: custom proj\_dist\_fn (Beta)');
```

[![](img/e31e32e33.png)](img/e31e32e33.png)

#### Custom point placement using the exponential distribution

```matlab
seed = 5050;

% Custom point_dist_fn: final points placed using the Exponential distribution
% (requires MATLAB or Octave statistics toolbox)
clupoints_n_1_exp = @(projs, lat_std, len, clu_dir, clu_ctr) ...
    clupoints_n_1_template(projs, lat_std, clu_dir, ...
        @(npts, lstd) lstd * exprnd(2 / lstd, [npts 1]));

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.03, 0.03, [n 1]) - len / 2;

e34 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 3.0, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp);
e35 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 3.0, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp, 'proj_dist_fn', 'unif');
e36 = clugen(2, 5, 1500, [1 0], pi / 3, [20 20], 12, 3, 3.0, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp, 'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_2d(...
    e34, 'e34: proj\_dist\_fn = "norm" (default)', ...
    e35, 'e35: proj\_dist\_fn = "unif"', ...
    e36, 'e36: custom proj\_dist\_fn (Beta)');
```

[![](img/e34e35e36.png)](img/e34e35e36.png)

### Manipulating cluster sizes

```matlab
seed = 543210;

% Custom clusizes_fn (e38): cluster sizes determined via the uniform distribution,
% no correction for total points
clusizes_unif = @(nclu, npts, ae) randi(2 * npts / nclu, nclu, 1);

% Custom clusizes_fn (e39): clusters all have the same size, no correction for
% total points
clusizes_equal = @(nclu, npts, ae) floor(npts / nclu) * ones(nclu, 1);

% Custom clucenters_fn (all): yields fixed positions for the clusters
centers_fixed = @(nclu, csep, coff) ...
    [-csep(1) -csep(2); csep(1) -csep(2); -csep(1) csep(2); csep(1) csep(2)];

e37 = clugen(2, 4, 1500, [1 1], pi, [20 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'point_dist_fn', 'n');
e38 = clugen(2, 4, 1500, [1 1], pi, [20 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'clusizes_fn', clusizes_unif, 'point_dist_fn', 'n');
e39 = clugen(2, 4, 1500, [1 1], pi, [20 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'clusizes_fn', clusizes_equal, 'point_dist_fn', 'n');
```

```matlab
plot_examples_2d(...
    e37, 'e37: normal dist. (default)', ...
    e38, 'e38: unif. dist. (custom)', ...
    e39, 'e39: equal size (custom)');
```

[![](img/e37e38e39.png)](img/e37e38e39.png)

## Examples in 3D

These examples were plotted with the `plot_examples_3d()` helper function available
[here](https://github.com/clugen/MOCluGen/tree/master/docs/plot_funcs/plot_examples_3d.m).

### Manipulating the direction of cluster-supporting lines

#### Using the `direction` parameter

```matlab
seed = 1;

e40 = clugen(3, 4, 500, [1 0 0], 0, [10 10 10], 15, 1.5, 0.5, 'seed', seed);
e41 = clugen(3, 4, 500, [1 1 1], 0, [10 10 10], 15, 1.5, 0.5, 'seed', seed);
e42 = clugen(3, 4, 500, [0 0 1], 0, [10 10 10], 15, 1.5, 0.5, 'seed', seed);
```

```matlab
plot_examples_3d(...
    e40, 'e40: direction = [1, 0, 0]', ...
    e41, 'e41: direction = [1, 1, 1]', ...
    e42, 'e42: direction = [0, 0, 1]');
```

[![](img/e40e41e42.png)](img/e40e41e42.png)

#### Changing the `angle_disp` parameter and using a custom `angle_deltas_fn` function

```matlab
seed = 9876;

% Custom angle_deltas function: arbitrarily rotate some clusters by 90 degrees
% Requires the statistics toolbox in either Octave or MATLAB
angdel_90 = @(nclu, astd) randsample([0 pi/2], nclu, true);

e43 = clugen(3, 6, 1000, [1 0 0], 0, [10 10 10], 15, 1.5, 0.5, 'seed', seed);
e44 = clugen(3, 6, 1000, [1 0 0], pi / 8, [10 10 10], 15, 1.5, 0.5, 'seed', seed);
e45 = clugen(3, 6, 1000, [1 0 0], 0, [10 10 10], 15, 1.5, 0.5, 'seed', seed, 'angle_deltas_fn', angdel_90);
```

```matlab
plot_examples_3d(...
    e43, 'e43: angle\_disp = 0', ...
    e44, 'e44: angle\_disp = π / 8', ...
    e45, 'e45: custom angle\_deltas function');
```

[![](img/e43e44e45.png)](img/e43e44e45.png)

### Manipulating the length of cluster-supporting lines

#### Using the `llength` parameter

```matlab
seed = 2;

e46 = clugen(3, 5, 800, [1 0 0], pi / 10, [10 10 10], 0, 0, 0.5, 'seed', seed, 'point_dist_fn', 'n');
e47 = clugen(3, 5, 800, [1 0 0], pi / 10, [10 10 10], 10, 0, 0.5, 'seed', seed, 'point_dist_fn', 'n');
e48 = clugen(3, 5, 800, [1 0 0], pi / 10, [10 10 10], 30, 0, 0.5, 'seed', seed, 'point_dist_fn', 'n');
```

```matlab
plot_examples_3d(...
    e46, 'e46: llength = 0', ...
    e47, 'e47: llength = 10', ...
    e48, 'e48: llength = 30');
```

[![](img/e46e47e48.png)](img/e46e47e48.png)

#### Changing the `llength_disp` parameter and using a custom `llengths_fn` function

```matlab
seed = 2;

% Custom llengths function: line lengths tend to grow for each new cluster
llen_grow = @(nclu, llen, llenstd) llen * (0:(nclu - 1))' + llenstd * randn(nclu, 1);

e49 = clugen(3, 5, 800, [1 0 0], pi / 10, [10 10 10], 15,  0.0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e50 = clugen(3, 5, 800, [1 0 0], pi / 10, [10 10 10], 15, 10.0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e51 = clugen(3, 5, 800, [1 0 0], pi / 10, [10 10 10], 10,  0.1, 0.5, 'seed', seed, ...
    'llengths_fn', llen_grow, 'point_dist_fn', 'n');
```

```matlab
plot_examples_3d(...
    e49, 'e49: llength\_disp = 0.0', ...
    e50, 'e50: llength\_disp = 10.0', ...
    e51, 'e51: custom llengths function');
```

[![](img/e49e50e51.png)](img/e49e50e51.png)

### Manipulating relative cluster positions

#### Using the `cluster_sep` parameter

```matlab
seed = 321;

e52 = clugen(3, 8, 1000, [1 1 1], pi / 4, [30 10 10], 25, 4, 3, 'seed', seed);
e53 = clugen(3, 8, 1000, [1 1 1], pi / 4, [10 30 10], 25, 4, 3, 'seed', seed);
e54 = clugen(3, 8, 1000, [1 1 1], pi / 4, [10 10 30], 25, 4, 3, 'seed', seed);
```

```matlab
plot_examples_3d(...
    e52, 'e52: cluster\_sep = [30, 10, 10]', ...
    e53, 'e53: cluster\_sep = [10, 30, 10]', ...
    e54, 'e54: cluster\_sep = [10, 10, 30]');
```

[![](img/e52e53e54.png)](img/e52e53e54.png)

#### Changing the `cluster_offset` parameter and using a custom `clucenters_fn` function

```matlab
seed = 321;

% Custom clucenters function: places clusters in a diagonal
centers_diag = @(nclu, csep, coff) ones(nclu, numel(csep)) .* (1:nclu)' * max(csep) + coff';

e55 = clugen(3, 8, 1000, [1 1 1], pi / 4, [10 10 10], 12, 3, 2.5, 'seed', seed);
e56 = clugen(3, 8, 1000, [1 1 1], pi / 4, [10 10 10], 12, 3, 2.5, 'seed', seed, ...
    'cluster_offset', [20 -20 20]);
e57 = clugen(3, 8, 1000, [1, 1, 1], pi / 4, [10, 10, 10], 12, 3, 2.5, 'seed', seed, ...
    'cluster_offset',  [-50 -50 -50], 'clucenters_fn', centers_diag);
```

```matlab
plot_examples_3d(...
    e55, 'e55: default', ...
    e56, 'e56: cluster\_offset = [20, -20, 20]', ...
    e57, 'e57: custom clucenters function');
```

[![](img/e55e56e57.png)](img/e55e56e57.png)

### Lateral dispersion and placement of point projections on the line

#### Normal projection placement (default): `proj_dist_fn = 'norm'`

```matlab
seed = 456;

e58 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 0.0, 'seed', seed);
e59 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 1.0, 'seed', seed);
e60 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 3.0, 'seed', seed);
```

```matlab
plot_examples_3d(...
    e58, 'e58: lateral\_disp = 0', ...
    e59, 'e59: lateral\_disp = 1', ...
    e60, 'e60: lateral\_disp = 3');
```

[![](img/e58e59e60.png)](img/e58e59e60.png)

#### Uniform projection placement: `proj_dist_fn = 'unif'`

```matlab
seed = 456;

e61 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 0.0, 'seed', seed, 'proj_dist_fn', 'unif');
e62 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 1.0, 'seed', seed, 'proj_dist_fn', 'unif');
e63 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 3.0, 'seed', seed, 'proj_dist_fn', 'unif');
```

```matlab
plot_examples_3d(...
    e61, 'e61: lateral\_disp = 0', ...
    e62, 'e62: lateral\_disp = 1', ...
    e63, 'e63: lateral\_disp = 3');
```

[![](img/e61e62e63.png)](img/e61e62e63.png)

#### Custom projection placement using the Beta distribution

```matlab
seed = 456;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.1, 0.1, [n 1]) - len / 2;

e64 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 0.0, 'seed', seed, 'proj_dist_fn', proj_beta);
e65 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 1.0, 'seed', seed, 'proj_dist_fn', proj_beta);
e66 = clugen(3, 4, 1000, [1 0 0], pi / 2, [20 20 20], 13, 2, 3.0, 'seed', seed, 'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_3d(...
    e64, 'e64: lateral\_disp = 0', ...
    e65, 'e65: lateral\_disp = 1', ...
    e66, 'e66: lateral\_disp = 3');
```

[![](img/e64e65e66.png)](img/e64e65e66.png)

### Controlling final point positions from their projections on the cluster-supporting line

#### Points on hyperplane orthogonal to cluster-supporting line (default): `point_dist_fn = "n-1"`

```matlab
seed = 34;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.1, 0.1, [n 1]) - len / 2;

e67 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed);
e68 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, 'proj_dist_fn', 'unif');
e69 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, 'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_3d(...
    e67, 'e67: proj\_dist\_fn = "norm" (default)', ...
    e68, 'e68: proj\_dist\_fn = "unif"', ...
    e69, 'e69: custom proj\_dist\_fn (Beta)');
```

[![](img/e67e68e69.png)](img/e67e68e69.png)

#### Points around projection on cluster-supporting line: `point_dist_fn = "n"`

```matlab
seed = 34;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.1, 0.1, [n 1]) - len / 2;

e70 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, ...
    'point_dist_fn', 'n');
e71 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, ...
    'point_dist_fn', 'n', 'proj_dist_fn', 'unif');
e72 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, ...
    'point_dist_fn', 'n', 'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_3d(...
    e70, 'e70: proj\_dist\_fn = "norm" (default)', ...
    e71, 'e71: proj\_dist\_fn = "unif"', ...
    e72, 'e72: custom proj\_dist\_fn (Beta)');
```

[![](img/e70e71e72.png)](img/e70e71e72.png)

#### Custom point placement using the exponential distribution

```matlab
seed = 34;

% Custom point_dist_fn: final points placed using the Exponential distribution
% (requires MATLAB or Octave statistics toolbox)
clupoints_n_1_exp = @(projs, lat_std, len, clu_dir, clu_ctr) ...
    clupoints_n_1_template(projs, lat_std, clu_dir, ...
        @(npts, lstd) lstd * exprnd(2 / lstd, [npts 1]));

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.1, 0.1, [n 1]) - len / 2;

e73 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20, 20], 22, 3, 2, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp);
e74 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp, 'proj_dist_fn', 'unif');
e75 = clugen(3, 5, 1500, [1 0 0], pi / 3, [20 20 20], 22, 3, 2, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp, 'proj_dist_fn', proj_beta);
```

```matlab
plot_examples_3d(...
    e73, 'e73: proj\_dist\_fn = "norm" (default)', ...
    e74, 'e74: proj\_dist\_fn = "unif"', ...
    e75, 'e75: custom proj\_dist\_fn (Beta)');
```

[![](img/e73e74e75.png)](img/e73e74e75.png)

### Manipulating cluster sizes

```matlab
seed = 543210;

% Custom clusizes_fn (e77): cluster sizes determined via the uniform distribution,
% no correction for total points
clusizes_unif = @(nclu, npts, ae) randi(2 * npts / nclu, nclu, 1);

% Custom clusizes_fn (e78): clusters all have the same size, no correction for
% total points
clusizes_equal = @(nclu, npts, ae) floor(npts / nclu) * ones(nclu, 1);

% Custom clucenters_fn (all): yields fixed positions for the clusters
centers_fixed = @(nclu, csep, coff) ...
    [-csep(1) -csep(2) -csep(3); csep(1) -csep(2) -csep(3); ...
     -csep(1)  csep(2)  csep(3); csep(1)  csep(2)  csep(3)];

e76 = clugen(3, 4, 1500, [1 1 1], pi, [20 20 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'point_dist_fn', 'n');
e77 = clugen(3, 4, 1500, [1 1 1], pi, [20 20 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'clusizes_fn', clusizes_unif, 'point_dist_fn', 'n');
e78 = clugen(3, 4, 1500, [1 1 1], pi, [20 20 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'clusizes_fn', clusizes_equal, 'point_dist_fn', 'n');
```

```matlab
plot_examples_3d(...
    e76, 'e76: normal dist. (default)', ...
    e77, 'e77: unif. dist. (custom)', ...
    e78, 'e78: equal size (custom)');
```

[![](img/e76e77e78.png)](img/e76e77e78.png)

## Examples in other dimensions

### Basic 1D example with density plot

These examples was plotted with the `plot_examples_1d()` helper function available
[here](https://github.com/clugen/MOCluGen/tree/master/docs/plot_funcs/plot_examples_1d.m).

```matlab
% Custom proj_dist_fn: point projections placed using the Weibull distribution
% (requires MATLAB or Octave statistics toolbox)
proj_wbull = @(len, n) wblrnd(len / 2, 1.5, [n 1]) - len / 2;


e79 = clugen(1, 3, 2000, 1, 0, 10, 6, 1.5, 0, 'seed', 45);
e80 = clugen(1, 3, 2000, 1, 0, 10, 6, 1.5, 0, 'seed', 45, 'proj_dist_fn', 'unif');
e81 = clugen(1, 3, 2000, 1, 0, 10, 6, 1.5, 0, 'seed', 45, 'proj_dist_fn', proj_wbull);
```

```matlab
plot_examples_1d(...
    e79, 'e79: proj\_dist\_fn = "norm" (default)', ...
    e80, 'e80: proj\_dist\_fn = "unif"', ...
    e81, 'e81: custom proj\_dist\_fn (Weibull)');
```

[![](img/e79e80e81.png)](img/e79e80e81.png)

### 5D example with default optional arguments

These examples were plotted with the `plot_examples_nd()` helper function available
[here](https://github.com/clugen/MOCluGen/tree/master/docs/plot_funcs/plot_examples_nd.m).

```matlab
nd = 5;
seed = 123;

e82 = clugen(nd, 6, 1500, [1 1 0.5 0 0], pi / 16, 30 * ones(nd, 1), 30, 4, 3, 'seed', seed);
```

```matlab
plot_examples_nd(e82, 'e82: 5D with optional parameters set to defaults');
```

[![](img/e82.png)](img/e82.png)

### 5D example with `proj_dist_fn = "unif"` and `point_dist_fn = "n"`

```matlab
nd = 5;
seed = 321;

e83 = clugen(nd, 6, 1500, [0.1 0.3 0.5 0.3 0.1], pi / 12, 30 * ones(nd, 1), 35, 5, 3.5, 'seed', seed, ...
    'proj_dist_fn', 'unif', 'point_dist_fn', 'n');
```

```matlab
plt = plot_examples_nd(e83, 'e83: 5D with proj\_dist\_fn="unif" and point\_dist\_fn="n"');
```

[![](img/e83.png)](img/e83.png)
