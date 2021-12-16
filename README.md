# MOCluGen

## Summary

MOCluGen is a MATLAB/Octave package for generating multidimensional clusters
using the CluGen algorithm. It provides the `clugen` function for
this purpose, as well as a number of auxiliary functions, used internally and
modularly by `clugen`. Users can swap these auxiliary functions by
their own customized versions, fine-tuning their cluster generation strategies,
or even use them as the basis for their own generation algorithms.

## Build docs

```
$ cd docs
$ python3 mocdoc.py
$ mkdocs build
```

Requires `mkdocs-material` in Python.

## Run tests

```matlab
cd ~/workspace/MOxUnit/MOxUnit/
moxunit_set_path()
cd ~/workspace/MOCluGen
startup
moxunit_runtests tests
```

## Reference

TODO

## License

This script is made available under the [MIT License](LICENSE).
