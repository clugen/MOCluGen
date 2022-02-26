# MOCluGen

This is the landing page. Do something about it.

MOCluGen is a MATLAB/Octave package for generating multidimensional clusters
using the CluGen algorithm. It provides the [`clugen`](api/clugen) function for
this purpose, as well as a number of auxiliary functions, used internally and
modularly by [`clugen`](api/clugen). Users can swap these auxiliary functions by
their own customized versions, fine-tuning their cluster generation strategies,
or even use them as the basis for their own generation algorithms.

## Further reading

* [The CluGen algorithm in detail](https://clugen.github.io/CluGen.jl/theory/)
  (refers to the Julia documentation)
* [Examples](examples)
* [API](api)
