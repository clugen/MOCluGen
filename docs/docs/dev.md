## Clone and install

Clone the project with following command in the terminal:

```text
$ git clone https://github.com/clugen/MOCluGen.git
```

Alternatively, download the project from its GitHub page.

Open MATLAB or GNU Octave and `cd` into the project's folder, and run the
`startup.m` script:

```matlab
startup
```

`MOCluGen` can now be used and/or developed.

## Run tests

Tests require the [MOxUnit] testing framework. Download it, open MATLAB or GNU
Octave, `cd` into framework's folder, and run the following instruction:

```matlab
moxunit_set_path()
```

In MATLAB/Octave change to the `MOCluGen` folder, and execute the following
instructions to run the tests:

```matlab
startup
moxunit_runtests tests
```

## Build docs

Building the documentation requires [Python] and [mkdocs-material]. After these
packages are installed, and considering we're in the `MOCluGen` folder, run the
following commands:

```text
$ cd docs
$ python3 mocdoc.py                   # Get doc-comments from MATLAB source files
$ ./run_moc_in_md.sh docs/examples.md # Run examples code and generate images
$ mkdocs build                        # Build docs
```

The documentation can be served locally with:

```text
$ mkdocs serve
```

[MOxUnit]: https://github.com/MOxUnit/MOxUnit
[Python]: https://www.python.org/downloads/
[mkdocs-material]: https://pypi.org/project/mkdocs-material/