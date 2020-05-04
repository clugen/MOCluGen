[![Latest release](https://img.shields.io/github/release/fakenmc/generateData.svg)](https://github.com/fakenmc/generateData/releases)
[![MIT Licence](https://img.shields.io/badge/license-MIT-yellowgreen.svg)](https://opensource.org/licenses/MIT/)

# User Manual

### Summary

A Matlab/Octave script which generates 2D data for clustering; data is
created along straight lines, which can be more or less parallel
depending on the selected input parameters.

### Synopsis

    [data, clustPoints, idx, centers, slopes, lengths] =
        generateData(slope, slopeStd, numClusts, xClustAvgSep,
                     yClustAvgSep, lengthAvg, lengthStd, lateralStd,
                     totalPoints)

### Input parameters

  Parameter      | Description
  -------------- | ------------------------------------------------------------------------------------------------------
  *slope*        | Base direction of the lines on which clusters are based
  *slopeStd*     | Standard deviation of the slope; used to obtain a random slope variation from the normal distribution, which is added to the base slope in order to obtain the final slope of each cluster
  *numClusts*    | Number of clusters (and therefore of lines) to generate
  *xClustAvgSep* | Average separation of line centers along the X axis
  *yClustAvgSep* | Average separation of line centers along the Y axis
  *lengthAvg*    | The base length of lines on which clusters are based
  *lengthStd*    | Standard deviation of line length; used to obtain a random length variation from the normal distribution, which is added to the base length in order to obtain the final length of each line
  *lateralStd*   | "Cluster fatness", i.e., the standard deviation of the distance from each point to the respective line, in both *x* and *y* directions; this distance is obtained from the normal distribution
  *totalPoints*  | Total points in generated data (will be randomly divided among clusters)

### Return values

  Value         | Description
  ------------- | --------------------------------------------------------------------------------------
  *data*        | Matrix (*totalPoints* x *2*) with the generated data
  *clustPoints* | Vector (*numClusts* x *1*) containing number of points in each cluster
  *idx*         | Vector (*totalPoints* x *1*) containing the cluster indices of each point
  *centers*     | Matrix (*numClusts* x *2*) containing centers from where clusters were generated
  *slopes*      | Vector (*numClusts* x *1*) containing the effective slopes used to generate clusters
  *lengths*     | Vector (*numClusts* x *1*) containing the effective lengths used to generate clusters

### Usage example

    [data cp idx] = generateData(1, 0.5, 5, 15, 15, 5, 1, 2, 200);

The previous command creates 5 clusters with a total of 200 points, with
a base slope of 1 (*std*=0.5), separated in average by 15 units in both
*x* and *y* directions, with average length of 5 units (*std*=1) and a
"fatness" or spread of 2 units.

To take a quick look at the clusters just do:

    scatter(data(:,1), data(:,2), 8, idx);

### Reference

If you use this script in your work, please use the following reference:

-   Fachada, N., Figueiredo, M.A.T., Lopes, V.V., Martins, R.C., Rosa,
A.C., [Spectrometric differentiation of yeast strains using minimum volume
increase and minimum direction change clustering criteria](http://www.sciencedirect.com/science/article/pii/S0167865514000889),
Pattern Recognition Letters, vol. 45, pp. 55-61 (2014), doi: http://dx.doi.org/10.1016/j.patrec.2014.03.008

### License

This script is made available under the [MIT License](LICENSE).
