#!/usr/bin/env bash

# Runs the MATLAB/Octave code embedded in a Markdown file.
# Code is executed in Octave.
#
# Copyright (c) 2022-2023 Nuno Fachada
# Distributed under the MIT License (See accompanying file LICENSE or copy
# at http://opensource.org/licenses/MIT)

# Check number of parameters
if [[ $# -ne 1 ]]; then
    >&2 echo "Usage: $0 <MARKDOWN_FILE>"
    exit 1
fi

# Check if file exists
if ! test -f $1; then
    >&2 echo "File '$1' does not exist"
    exit 2
fi

# Check if Octave is found
if ! command -v octave &> /dev/null; then
    >&2 echo "GNU Octave could not be found"
    exit 3
fi

# Check if a physical display is not available
if [[ -z "${DISPLAY}" ]]; then
    # Check if a virtual display is available via xvfb
    if command -v xvfb-run &> /dev/null; then
        # We have a virtual display, so plots will turn out nice
        XVFB_RUN="xvfb-run"
    else
        # We also don't have a virtual display, plots will probably not be good
        >&2 echo "No physical or virtual display found, plots may not look good"
    fi
fi

# If we get here we can extract and run the embedded code
echo "# Code starts here
pkg load statistics
addpath([pwd() filesep '..' filesep 'src']);
addpath([pwd() filesep 'plot_funcs']);
$(./md2moc.py $1)
close all hidden" | $(echo ${XVFB_RUN}) octave

# Move the generated images to docs/img
mv *.png docs/img