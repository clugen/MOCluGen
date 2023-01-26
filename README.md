[![Checks](https://github.com/clugen/MOCluGen/actions/workflows/tests.yml/badge.svg)](https://github.com/clugen/MOCluGen/actions/workflows/tests.yml)
[![codecov](https://codecov.io/gh/clugen/MOCluGen/branch/main/graph/badge.svg?token=5EWC7L6J3T)](https://codecov.io/gh/clugen/MOCluGen)
[![docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://clugen.github.io/MOCluGen/)
[![MIT](https://img.shields.io/badge/license-MIT-yellowgreen.svg)](https://tldrlegal.com/license/mit-license)

# MOCluGen

## Summary

**MOCluGen** is a MATLAB/Octave implementation of the *clugen* algorithm for
generating multidimensional clusters. Each cluster is supported by a line
segment, the position, orientation and length of which guide where the
respective points are placed.

## Install and use

[Download](https://github.com/clugen/MOCluGen/archive/refs/heads/main.zip) the
package from its [GitHub](https://github.com/clugen/MOCluGen/) page or clone it
with following command in the terminal:

```text
$ git clone https://github.com/clugen/MOCluGen.git
```

Open MATLAB or GNU Octave and `cd` into the project's folder, and run the
`startup.m` script:

```matlab
>> startup
```

`MOCluGen` can now be used, e.g:

```matlab
>> o = clugen(2, 4, 400, [1 0], pi / 8, [50, 10], 20, 1, 2, 'seed', 123);
>> scatter(o.points(:, 1), o.points(:, 2), 36, o.clusters, 'filled', 'MarkerEdgeColor', 'k');
```

![Example 2D](https://github.com/clugen/.github/blob/main/images/example2d_moc.png?raw=true)

```matlab
>> o = clugen(3, 4, 1000, [1 0 0], pi / 8, [20 15 25], 16, 4, 3.5, 'seed', 123);
>> scatter3(o.points(:, 1), o.points(:, 2), o.points(:,3), 36, o.clusters, 'filled', 'MarkerEdgeColor', 'k');
```

![Example 3D](https://github.com/clugen/.github/blob/main/images/example3d_moc.png?raw=true)

## See also

* [pyclugen](https://github.com/clugen/pyclugen/), a Python implementation of
  the *clugen* algorithm.
* [CluGen.jl](https://github.com/clugen/CluGen.jl/), a Julia implementation of
  the *clugen* algorithm.
* [clugenr](https://github.com/clugen/clugenr/), an R implementation
  of the *clugen* algorithm.

## Reference

If you use this software, please cite the following reference:

* Fachada, N. & de Andrade, D. (2023). Generating Multidimensional Clusters With
  Support Lines. <https://doi.org/10.48550/arXiv.2301.10327>.

## License

[MIT License](LICENSE)
