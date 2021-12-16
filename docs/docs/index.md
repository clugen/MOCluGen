# MOCluGen

MOCluGen is a MATLAB/Octave package for generating multidimensional clusters
using the CluGen algorithm. It provides the [`clugen`](api/clugen) function for
this purpose, as well as a number of auxiliary functions, used internally and
modularly by [`clugen`](api/clugen). Users can swap these auxiliary functions by
their own customized versions, fine-tuning their cluster generation strategies,
or even use them as the basis for their own generation algorithms.

## Algorithm overview

CluGen is an algorithm for generating multidimensional clusters. Each cluster is
supported by a line segment, the position, orientation and length of which guide
where the respective points are placed. For brevity, *line segments* will be
referred to as *lines*.

Given an $n$-dimensional direction vector $\mathbf{d}$ (and a number of
additional parameters, which will be discussed shortly), the _clugen_ algorithm
works as follows ($^*$ means the algorithm step is stochastic):

1. Normalize $\mathbf{d}$.
2. $^*$Determine cluster sizes.
3. $^*$Determine cluster centers.
4. $^*$Determine lengths of cluster-supporting lines.
5. $^*$Determine angles between $\mathbf{d}$ and cluster-supporting lines.
6. For each cluster:
    1. $^*$Determine direction of the cluster-supporting line.
    2. $^*$Determine distance of point projections from the center of the
       cluster-supporting line.
    3. Determine coordinates of point projections on the cluster-supporting line.
    4. $^*$Determine points from their projections on the cluster-supporting
      line.

Details of the algorithm are given (TODO: add link to Julia's implementation
Theory section).

## See also

* [Examples](examples)
* [API](api)
