# MOCluGen

**MOCluGen** is a MATLAB/Octave package for generating multidimensional clusters
using the CluGen algorithm. It provides the [`clugen()`](api/clugen) function
for this purpose, as well as a number of auxiliary functions, used internally
and modularly by [`clugen()`](api/clugen). Users can swap these auxiliary
functions by their own customized versions, fine-tuning their cluster generation
strategies, or even use them as the basis for their own generation algorithms.

## How to install

[Download](https://github.com/clugen/MOCluGen/archive/refs/heads/master.zip) the
package from its [GitHub](https://github.com/clugen/MOCluGen/) page or clone it
with following command in the terminal:

```text
$ git clone https://github.com/clugen/MOCluGen.git
```

Open MATLAB or GNU Octave and `cd` into the project's folder, and run the
`startup.m` script:

```matlab
startup
```

**MOCluGen** is now ready to use.

## Quick start

```matlab
o = clugen(2, 4, 400, [1 0], pi / 8, [50, 10], 20, 1, 2, 'seed', 123);
scatter(o.points(:, 1), o.points(:, 2), 36, o.clusters, 'filled', 'MarkerEdgeColor', 'k');
```

![2D example.](https://github.com/clugen/.github/blob/main/images/example2d_moc.png?raw=true)

```matlab
o = clugen(3, 4, 1000, [1 0 0], pi / 8, [20 15 25], 16, 4, 3.5, 'seed', 123);
scatter3(o.points(:, 1), o.points(:, 2), o.points(:,3), 36, o.clusters, 'filled', 'MarkerEdgeColor', 'k');
```

![3D example.](https://github.com/clugen/.github/blob/main/images/example3d_moc.png?raw=true)

## Further reading

* [Theory: the _clugen_ algorithm in detail](theory)
* [Examples](examples)
* [API](api)
* [Developing this package](dev)
