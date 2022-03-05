# Examples

These examples can be exactly reproduced in GNU Octave 5.2.0 by setting the seed
specified at the beginning of each code block before each call to the
[`clugen()`](../api/clugen) function.

The functions used to automatically plot these examples are available
[here](https://github.com/clugen/MOCluGen/tree/master/docs/plot_funcs).

## Examples in 2D

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

![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e01e02e03.svg)

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

![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e04e05e06.svg)

### Manipulating the length of cluster-supporting lines

#### Using the `llength` parameter

```matlab
seed = 1234

e07 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 0, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e08 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 10, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');
e09 = clugen(2, 5, 800, [1; 0], pi / 10, [10; 10], 30, 0, 0.5, 'seed', seed, ...
    'point_dist_fn', 'n');

plot2d(e07, 'e07: llength = 0', e08, 'e08: llength = 10', e09, 'e09: llength = 30');
```

![](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/e07e08e09.svg)
