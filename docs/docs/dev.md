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