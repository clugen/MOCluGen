#!/usr/bin/env python3

# Script for extracting MATLAB/Octave code embedded in Markdown files.
#
# Copyright (c) 2022 Nuno Fachada
# Distributed under the MIT License (See accompanying file LICENSE or copy
# at http://opensource.org/licenses/MIT)

import sys
from pathlib import Path

# Check if Markdown file was given as parameter
if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <MARKDOWN_FILE>")
    exit(1)

# Create file path
mdfile = Path(sys.argv[1])

# Check if file exists, and if not, quit
if not mdfile.exists():
    print(f"File '{mdfile}' does not exist!")
    exit(2)

# Initially we are not in a code fence
incode = False

# Open it and parse it
with mdfile.open("r") as mdfl:

    # Go through each line
    for mdline in mdfl:

        if incode:
            if mdline.strip() == "```":
                incode = False
            else:
                print(mdline, end = "")
        else:
            if mdline.strip() == "```matlab":
                incode = True

