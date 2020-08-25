<!--[![Latest release](https://img.shields.io/github/release/fakenmc/generateData.svg)](https://github.com/fakenmc/generateData/releases)
[![MIT Licence](https://img.shields.io/badge/license-MIT-yellowgreen.svg)](https://opensource.org/licenses/MIT/)
[![View Generate Data for Clustering on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/37435-generate-data-for-clustering)-->

# mCluGen

## Summary

A MATLAB/Octave function which generates multidimensional data clusters. Data
is created along straight lines, which can be more or less parallel depending
on the selected input parameters.

**This is a work in progress**

## Synopsis

```MATLAB
[data, clustPoints, idx, centers, angles, lengths] = ...
    generateData(angleMean, angleStd, numClusts, xClustAvgSep, yClustAvgSep, ...
                 lengthMean, lengthStd, lateralStd, totalPoints, ...)
```

## Input parameters

### Required parameters

Parameter      | Description
-------------- | -----------
`angleMean`    | Mean angle in radians of the lines on which clusters are based. Angles are drawn from the normal distribution.
`angleStd`     | Standard deviation of line angles.
`numClusts`    | Number of clusters (and therefore of lines) to generate.
`xClustAvgSep` | Average separation of line centers along the X axis.
`yClustAvgSep` | Average separation of line centers along the Y axis.
`lengthMean`   | Mean length of the lines on which clusters are based. Line lengths are drawn from the folded normal distribution.
`lengthStd`    | Standard deviation of line lengths.
`lateralStd`   | Cluster "fatness", i.e., the standard deviation of the distance from each point to its projection on the line. The way this distance is obtained is controlled by the optional `'pointOffset'` parameter.
`totalPoints`  | Total points in generated data. These will be randomly divided between clusters using the half-normal distribution with unit standard deviation.

### Optional named parameters

Parameter name | Parameter values   | Default value | Description
-------------- | ---------------------------------- | ------------- | -----------
`allowEmpty`   | `true`, `false`    | `false`       | Allow empty clusters?
`pointDist`    | `'unif'`, `'norm'` | `unif`        | Specifies the distribution of points along lines, with two possible values: 1) `'unif'` distributes points uniformly along lines; or, 2) `'norm'` distribute points along lines using a normal distribution (line center is the mean and the line length is equal to 3 standard deviations).
`pointOffset`  | `1D`, `2D`         | `2D`          | Controls how points are created from their projections on the lines, with two possible values: 1) `'1D'` places points on a second line perpendicular to the cluster line using a normal distribution centered at their intersection; or, 2) `'2D'` places point using a bivariate normal distribution centered at the point projection.

## Return values

  Value         | Description
  ------------- | --------------------------------------------------------------------------------------
  `data`        | Matrix (`totalPoints` x *2*) with the generated data.
  `clustPoints` | Vector (`numClusts` x *1*) containing number of points in each cluster.
  `idx`         | Vector (`totalPoints` x *1*) containing the cluster indices of each point.
  `centers`     | Matrix (`numClusts` x *2*) containing line centers from where clusters were generated.
  `angles`      | Vector (`numClusts` x *1*) containing the effective angles of the lines used to generate clusters.
  `lengths`     | Vector (`numClusts` x *1*) containing the effective lengths of the lines used to generate clusters.

## Usage examples

### Basic usage

```MATLAB
[data cp idx] = generateData(pi / 2, pi / 8, 5, 15, 15, 5, 1, 2, 200);
```

The previous command creates 5 clusters with a total of 200 points, with
a mean angle of π/2 (*std*=π/8), separated in average by 15 units in both
*x* and *y* directions, with mean length of 5 units (*std*=1) and a
"fatness" or spread of 2 units.

The following command plots the generated clusters:

```MATLAB
scatter(data(:, 1), data(:, 2), 8, idx);
```

### Using optional parameters

The following command generates 7 clusters with a total of 100 000 points.
Optional parameters are used to override the defaults.

```MATLAB
[data cp idx] = generateData(0, pi / 16, 7, 25, 25, 25, 5, 1, 100000, ...
  'pointDist', 'norm', 'pointOffset', '1D', 'allowEmpty', true);
```

The generated clusters can be visualized with the same `scatter` command used
in the previous example.

### Reproducible cluster generation

To make cluster generation reproducible, set the random number generator seed
to a specific value (e.g. 123) before generating the data:

```MATLAB
rng(123);
```

For GNU Octave, use the following instructions instead:

```MATLAB
rand("state", 123);
randn("state", 123);
```

## Previous behaviors and reproducibility of results

Before [v2.0.0](https://github.com/fakenmc/generateData/tree/v2.0.0), lines
supporting clusters were parameterized with slopes instead of angles. We found
this caused difficulties when choosing line orientation, thus the change to
angles, which are much easier to work with.
Version [v1.3.0](https://github.com/fakenmc/generateData/tree/v1.3.0) still
uses slopes, for those who prefer this behavior.

For reproducing results in studies published before May 2020, use version
[v1.2.0](https://github.com/fakenmc/generateData/tree/v1.2.0) instead.
Subsequent versions were optimized in a way that changed the order in which
the required random values are generated, thus producing slightly different
results.

## Reference

If you use this function in your work, please cite the following reference:

- Fachada, N., & Rosa, A. C. (2020).
[generateData—A 2D data generator](https://doi.org/10.1016/j.simpa.2020.100017).
Software Impacts, 4:100017. doi: [10.1016/j.simpa.2020.100017](https://doi.org/10.1016/j.simpa.2020.100017)

## License

This script is made available under the [MIT License](LICENSE).
