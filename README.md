# MOCluGen

## Summary

**MOCluGen** is a MATLAB/Octave implementation of the *clugen* algorithm for
generating multidimensional clusters. Each cluster is supported by a line
segment, the position, orientation and length of which guide where the
respective points are placed.

## Install and use

Clone the project with following command in the terminal:

```text
$ git clone https://github.com/clugen/MOCluGen.git
```

Alternatively, download the project from its GitHub page.

Open MATLAB or GNU Octave and `cd` into the project's folder, and run the
`startup.m` script:

```matlab
>> startup
```

`MOCluGen` can now be used, e.g:

```matlab
>> % Seed set to 123 in Octave for this example, see below
>> [points, point_clusters] = clugen(3, 4, 1000, [1; 0; 0], pi / 8, [20; 15; 25], 16, 4, 3.5);
>> scatter3(points(:, 1), points(:, 2), points(:,3), 36, point_clusters, 'filled', 'MarkerEdgeColor', 'k');
```

![Example.](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/example_clugen.svg)

Note that running the code above will yield a different result each time, unless
a seed is previously set, e.g. for MATLAB:

```matlab
>> % Sets seed to 123 in MATLAB
>> rng(123);
```

For GNU Octave, use the following instructions instead:

```matlab
>> % Sets seed to 123 in GNU Octave
>> rand("state", 123);
>> randn("state", 123);
```

## Reference

If you use this software, please cite the following reference:

* Fachada, N. & de Andrade, D. (2023). Generating Multidimensional Clusters With
  Support Lines. *Under review*.

## License

This script is made available under the [MIT License](LICENSE).
