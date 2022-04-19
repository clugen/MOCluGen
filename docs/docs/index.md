# MOCluGen

**MOCluGen** is a MATLAB/Octave package for generating multidimensional clusters
using the CluGen algorithm. It provides the [`clugen()`](api/clugen) function
for this purpose, as well as a number of auxiliary functions, used internally
and modularly by [`clugen()`](api/clugen). Users can swap these auxiliary
functions by their own customized versions, fine-tuning their cluster generation
strategies, or even use them as the basis for their own generation algorithms.

## Installation

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

`MOCluGen` is now ready to use.

## Quick examples

TO DO: 2D example

TO DO: 3D example

## Further reading

* [Theory: the _clugen_ algorithm in detail](theory)
* [Examples](examples)
* [API](api)
* [Developing this package](dev)
