# MOCluGen

## Summary

MOCluGen is a MATLAB/Octave package for generating multidimensional clusters
using the CluGen algorithm. It provides the `clugen` function for
this purpose, as well as a number of auxiliary functions, used internally and
modularly by `clugen`. Users can swap these auxiliary functions by
their own customized versions, fine-tuning their cluster generation strategies,
or even use them as the basis for their own generation algorithms.

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
>> [points, point_clusters] = clugen(3, 4, 1000, [1; 0; 0], 0.1, [20; 15; 35], 12, 4, 0.5);
>> scatter3(points(:, 1), points(:, 2), points(:,3), 8, point_clusters);
```

![Example.](https://raw.githubusercontent.com/clugen/.github/main/images/MOCluGen/readme_example.svg)

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

TODO

## License

This script is made available under the [MIT License](LICENSE).
