## Clone and install

Clone the project with following command in the terminal:

```text
$ git clone https://github.com/clugen/MOCluGen.git
```

Alternatively,
[download](https://github.com/clugen/MOCluGen/archive/refs/heads/main.zip) the
package from its [GitHub](https://github.com/clugen/MOCluGen/) page.

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

By default, the tests will run in `normal` mode, which can take quite a few
minutes. The test mode can be changed by setting the `moclugen_test_mode`
variable to the following values:

- `minimal`: Run a few quick tests, just to check if basic functionality is OK.
  Incomplete coverage. Takes a few seconds.
- `ci`: The default mode in CI environments. Runs a comprehensive set of tests,
  with full coverage, but doesn't check for that many parameter combinations.
  Takes around one minute.
- `normal`: The default mode. Like `ci`, but tests more parameter combinations.
  Takes between 5 to 30 minutes.
- `full`: Like `normal`, but tests many parameter combinations, with some
  extreme values. Can take one or more hours.

For example, to test in `minimal` mode, one would do:

```matlab
moclugen_test_mode = 'minimal'
moxunit_runtests tests
```

## Build docs

Building the documentation requires [Octave], [Python] and [mkdocs-material] and
must be performed on a [Bash] shell. A physical or virtual display (e.g.,
[xvfb]) are required for generating good looking plots. After these requirements
are met, and considering we're in the `MOCluGen` folder, run the following
commands:

```text
$ cd docs
$ python mocdoc.py                    # Get doc-comments from MATLAB source files
$ ./run_moc_in_md.sh docs/examples.md # Run examples code and generate images
$ mkdocs build                        # Build docs
```

The documentation can be served locally with:

```text
$ mkdocs serve
```

## Code style

To contribute to MOCluGen, follow this code style:

* Encoding: UTF-8
* Indentation: 4 spaces (no tabs)
* Line size limit: 100 chars
* Newlines: Unix style, i.e. LF or `\n`

[MOxUnit]: https://github.com/MOxUnit/MOxUnit
[Python]: https://www.python.org/downloads/
[mkdocs-material]: https://pypi.org/project/mkdocs-material/
[Octave]: https://octave.org/
[Bash]: https://en.wikipedia.org/wiki/Bash_(Unix_shell)
[xvfb]: https://en.wikipedia.org/wiki/Xvfb