# Examples

These examples can be exactly reproduced in GNU Octave 5.2.0 by using the seed
specified at the beginning of each code block.

## Examples in 2D

These examples were plotted with the `plot2d()` helper function available
[here](https://github.com/clugen/MOCluGen/tree/master/docs/plot_funcs/plot2d.m).

### Manipulating the direction of cluster-supporting lines

#### Using the `direction` parameter

```matlab
seed = 123;

e01 = clugen(2, 4, 200, [1; 0], 0, [10; 10], 10, 1.5, 0.5, 'seed', seed);
e02 = clugen(2, 4, 200, [1; 1], 0, [10; 10], 10, 1.5, 0.5, 'seed', seed);
e03 = clugen(2, 4, 200, [0; 1], 0, [10; 10], 10, 1.5, 0.5, 'seed', seed);

plot2d(e01, 'e01: direction = [1; 0]', ...
    e02, 'e02: direction = [1; 1]', ...
    e03, 'e03: direction = [0; 1]');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e01e02e03.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e01e02e03.svg)

#### Changing the `angle_disp` parameter and using a custom `angle_deltas_fn` function

```matlab
seed = 9876;

% Custom angle_deltas function: arbitrarily rotate some clusters by 90 degrees
% Requires the statistics toolbox in either Octave or MATLAB
angdel_90 = @(nclu, astd) randsample([0 pi/2], nclu, true);

e04 = clugen(2, 6, 500, [1; 0], 0, [10; 10], 10, 1.5, 0.5, 'seed', seed);
e05 = clugen(2, 6, 500, [1; 0], pi / 8, [10; 10], 10, 1.5, 0.5, 'seed', seed);
e06 = clugen(2, 6, 500, [1; 0], 0, [10; 10], 10, 1.5, 0.5, 'seed', seed, ...
    'angle_deltas_fn', angdel_90);

plot2d(e04, 'e04: angle\_disp = 0', ...
    e05, 'e05: angle\_disp = π/8', ...
    e06, 'e06: custom angle\_deltas function');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e04e05e06.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e04e05e06.svg)

### Manipulating the length of cluster-supporting lines

#### Using the `llength` parameter

```matlab
seed = 1234;

e07 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 0, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e08 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 10, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e09 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 30, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');

plot2d(e07, 'e07: llength = 0', e08, 'e08: llength = 10', e09, 'e09: llength = 30');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e07e08e09.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e07e08e09.svg)

#### Changing the `llength_disp` parameter and using a custom `llengths_fn` function

```matlab
seed = 1234;

% Custom llengths function: line lengths grow for each new cluster
llen_grow = @(nclu, llen, llenstd) llen * (0:(nclu - 1))' + llenstd * randn(nclu, 1);

e10 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 15,  0.0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e11 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 15, 10.0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e12 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 10,  0.1, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n', 'llengths_fn', llen_grow);

plot2d(e10, 'e10: llength\_disp = 0.0', ...
    e11, 'e11: llength\_disp = 5.0', ...
    e12, 'e12: custom llengths function');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e10e11e12.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e10e11e12.svg)

### Manipulating relative cluster positions

#### Using the `cluster_sep` parameter

```matlab
seed = 3210;

e13 = clugen(2, 8, 1000, [1; 1], pi / 4, [10; 10], 10, 2, 2.5, 'seed', seed);
e14 = clugen(2, 8, 1000, [1; 1], pi / 4, [30; 10], 10, 2, 2.5, 'seed', seed);
e15 = clugen(2, 8, 1000, [1; 1], pi / 4, [10; 30], 10, 2, 2.5, 'seed', seed);

plot2d(e13, 'e13: cluster\_sep = [10; 10]', ...
    e14, 'e14: cluster\_sep = [30; 10]', ...
    e15, 'e15: cluster\_sep = [10; 30]');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e13e14e15.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e13e14e15.svg)

#### Changing the `cluster_offset` parameter and using a custom `clucenters_fn` function

```matlab
seed = 3210;

% Custom clucenters function: places clusters in a diagonal
centers_diag = @(nclu, csep, coff) ones(nclu, numel(csep)) .* (1:nclu)' * max(csep) + coff';

e16 = clugen(2, 8, 1000, [1; 1], pi / 4, [10; 10], 10, 2, 2.5, 'seed', seed);
e17 = clugen(2, 8, 1000, [1; 1], pi / 4, [10; 10], 10, 2, 2.5, 'seed', seed, ...
    'cluster_offset', [20; -20]);
e18 = clugen(2, 8, 1000, [1; 1], pi / 4, [10; 10], 10, 2, 2.5, 'seed', seed, ...
    'cluster_offset', [-50; -50], 'clucenters_fn', centers_diag);

plot2d(e16, 'e16: default', ...
    e17, 'e17: cluster\_offset = [20; -20]', ...
    e18, 'e18: custom clucenters function');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e16e17e18.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e16e17e18.svg)

### Lateral dispersion and placement of point projections on the line

#### Normal projection placement (default): `proj_dist_fn = "norm"`

```matlab
seed = 5678;

e19 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 0.0, 'seed', seed);
e20 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 1.0, 'seed', seed);
e21 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 3.0, 'seed', seed);

plot2d(e19, 'e19: lateral\_disp = 0', ...
    e20, 'e20: lateral\_disp = 1', ...
    e21, 'e21: lateral\_disp = 3');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e19e20e21.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e19e20e21.svg)

#### Uniform projection placement: `proj_dist_fn = "unif"`

```matlab
seed = 5678;

e22 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 0.0, 'seed', seed, ...
    'proj_dist_fn', 'unif');
e23 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 1.0, 'seed', seed, ...
    'proj_dist_fn', 'unif');
e24 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 3.0, 'seed', seed, ...
    'proj_dist_fn', 'unif');

plot2d(e22, 'e22: lateral\_disp = 0', ...
    e23, 'e23: lateral\_disp = 1', ...
    e24, 'e24: lateral\_disp = 3');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e22e23e24.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e22e23e24.svg)

#### Custom projection placement using the Beta distribution

```matlab
seed = 5678;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.1, 0.1, [n 1]) - len / 2;

e25 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 0.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);
e26 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 1.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);
e27 = clugen(2, 4, 1000, [1; 0], pi / 2, [20; 20], 13, 2, 3.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);

plot2d(e25, 'e25: lateral\_disp = 0', ...
    e26, 'e26: lateral\_disp = 1', ...
    e27, 'e27: lateral\_disp = 3');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e25e26e27.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e25e26e27.svg)

### Controlling final point positions from their projections on the cluster-supporting line

#### Points on hyperplane orthogonal to cluster-supporting line (default): `point_dist_fn = "n-1"`

```matlab
seed = 5050;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.03, 0.03, [n 1]) - len / 2;

e28 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 2.0, 'seed', seed);
e29 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 2.0, 'seed', seed, ...
    'proj_dist_fn', 'unif');
e30 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 2.0, 'seed', seed, ...
    'proj_dist_fn', proj_beta);

plot2d(e28, 'e28: proj\_dist\_fn = "norm" (default)', ...
    e29, 'e29: proj\_dist\_fn = "unif"', ...
    e30, 'e30: custom proj\_dist\_fn (Beta)');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e28e29e30.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e28e29e30.svg)

#### Points around projection on cluster-supporting line: `point_dist_fn = "n"`

```matlab
seed = 5050;

% Custom proj_dist_fn: point projections placed using the Beta distribution
% (requires MATLAB or Octave statistics toolbox)
proj_beta = @(len, n) len * betarnd(0.03, 0.03, [n 1]) - len / 2;

e31 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 2.0, 'seed', seed, ...
    'point_dist_fn', 'n');
e32 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 2.0, 'seed', seed, ...
    'point_dist_fn', 'n', 'proj_dist_fn', 'unif');
e33 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 2.0, 'seed', seed, ...
    'point_dist_fn', 'n', 'proj_dist_fn', proj_beta);

plot2d(e31, 'e31: proj\_dist_fn = "norm" (default)', ...
    e32, 'e32: proj\_dist_fn = "unif"', ...
    e33, 'e33: custom proj\_dist\_fn (Beta)');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e31e32e33.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e31e32e33.svg)

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

e34 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 3.0, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp);
e35 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 3.0, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp, 'proj_dist_fn', 'unif');
e36 = clugen(2, 5, 1500, [1; 0], pi / 3, [20; 20], 12, 3, 3.0, 'seed', seed, ...
    'point_dist_fn', clupoints_n_1_exp, 'proj_dist_fn', proj_beta);

plot2d(e34, 'e34: proj\_dist\_fn = "norm" (default)', ...
    e35, 'e35: proj\_dist\_fn = "unif"', ...
    e36, 'e36: custom proj\_dist\_fn (Beta)');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e34e35e36.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e34e35e36.svg)

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

e37 = clugen(2, 4, 1500, [1; 1], pi, [20; 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'point_dist_fn', 'n');
e38 = clugen(2, 4, 1500, [1; 1], pi, [20; 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'clusizes_fn', clusizes_unif, 'point_dist_fn', 'n');
e39 = clugen(2, 4, 1500, [1; 1], pi, [20; 20], 0, 0, 5, 'seed', seed, ...
    'clucenters_fn', centers_fixed, 'clusizes_fn', clusizes_equal, 'point_dist_fn', 'n');

plot2d(e37, 'e37: normal dist. (default)', ...
    e38, 'e38: unif. dist. (custom)', ...
    e39, 'e39: equal size (custom)');
```

[![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e37e38e39.svg)](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e37e38e39.svg)
