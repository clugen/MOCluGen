#!/usr/bin/env bash

# Runs the MATLAB/Octave code embedded in a Markdown file.
# Code is executed in Octave.
#
# Copyright (c) 2022 Nuno Fachada
# Distributed under the MIT License (See accompanying file LICENSE or copy
# at http://opensource.org/licenses/MIT)

# Check number of parameters
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <MARKDOWN_FILE>"
    exit 1
fi

# Check if file exists
if ! test -f $1; then
    echo "File '$1' does not exist"
    exit 2
fi

# Check if Octave is found
if ! command -v octave &> /dev/null; then
    echo "GNU Octave could not be found"
    exit 3
fi

# If we get here we can extract and run the embedded code
echo "# Code starts here
pkg load statistics
addpath([pwd() filesep '..' filesep 'src']);
addpath([pwd() filesep 'plot_funcs']);
$(./md2moc.py $1)
close all hidden" | octave