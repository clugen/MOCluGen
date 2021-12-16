#!/usr/bin/env python3

# Script for stripping doccomments from MATLAB functions and convert them into
# separate Markdown source files. The script converts indented code blocks to
# Markdown code fences (MATLAB) and replaces mentions to functions with links
# to their documentation.
#
# Copyright (c) 2021 Nuno Fachada
# Distributed under the MIT License (See accompanying file LICENSE or copy
# at http://opensource.org/licenses/MIT)

from pathlib import Path

# Get input files, assuming each file contains a MATLAB function
input_filepaths = sorted(Path('..', 'src').glob('*.m'))

# Docs and API folders
docs_dir = 'docs'
api_dir = 'api'

# Output folder
output_dir = Path(docs_dir, api_dir)

# Total files
n = len(input_filepaths)

# Dictionary of function names (keys) - function docs in Markdown (values)
docs = {}

# Go through each file
for mfilepath in input_filepaths:

    # Blank line indexes
    blanks = []

    # Lines for current function docs
    curr_doc = []

    # First line is a Markdown title with the function's name
    curr_doc.append(f"# {mfilepath.stem}\n\n")

    # Process current MATLAB file/function
    with mfilepath.open("r") as mfile:

        # Go through each line of the file
        for mline in mfile:

            # Strip blanks from line edges
            mline = mline.strip()

            # Check the type of line
            if len(mline) == 0:
                # We ignore blank lines
                continue
            elif mline.startswith("% "):
                # Doccomment with space, remove them
                mline = mline[2:]
            elif mline.startswith("%"):
                # Doccomment without space: bad format, but accept and remove it
                mline = mline[1:]
            elif mline.startswith("function"):
                # Functions starts here, stop search for doccoments
                break

            # If current doccomment line is blank, take not of its index on the
            # blanks list
            if len(mline) == 0:
                blanks.append(len(curr_doc))

            # Append line to current function's doccomments list
            curr_doc.append(mline + "\n")

    # If last document does not end in a blank line, add it
    if curr_doc[-1] != "\n":
        blanks.append(len(curr_doc))
        curr_doc.append("\n")

    # List of blank line pairs which wrap around indented example code
    code_pairs = []

    # Populate list of blank line pairs which wrap around indented example code
    for i in range(len(blanks) - 1):

        # Get current pair
        pair = blanks[i:i+2]

        # If blank lines are adjacent they don't contain code, so we can ignore
        # this pair
        if pair[0] + 1 == pair[1]:
            continue

        # Check if current pair really wraps example code
        is_code = True
        for j in range(pair[0] + 1, pair[1]):
            if not curr_doc[j].startswith("    "):
                # Blank lines pair does not wrap example code since it contains
                # at least one line not indented
                is_code = False
                break

        # If current pair wraps example code, append it to the code_pairs list
        if is_code:
            code_pairs.append(pair)

    # If we have any indented example code wrapped by blank lines...
    if len(code_pairs) > 0:

        # Some of the code sections may be adjacent, only separated by a blank
        # line. In this case, let's merge these sections.

        # The merged pairs list will contain the final blank line pairs which
        # contain code, with possibly some of them being merged into one block
        merged_pairs = [code_pairs[0]]

        # Go through all blank line pairs
        for i in range(len(code_pairs) - 1):

            # Is current blank line pair adjacent to the next blank line pair?
            if code_pairs[i][1] == code_pairs[i + 1][0]:
                # If so, the respective code block are adjacent also, let's
                # merge them, replacing the last block placed in the list
                # (which was the first of the two blocks under discussion)
                merged_pairs[-1] = [code_pairs[i][0], code_pairs[i + 1][1]]
            else:
                # Otherwise, the blocks are not adjacent, thus just add the
                # second pair as a new block in the merged_pairs list
                merged_pairs.append(code_pairs[i + 1])

        # For each merged pair of blank lines defining an indented code block...
        for pair in merged_pairs:

            # Replace first blank line with a blank line + the start of the
            # code fence
            curr_doc[pair[0]] = "\n```matlab\n"

            # Replace the second blank line with the end of the code fence and
            # a new blank line
            curr_doc[pair[1]] = "```\n\n"

            # Remove one level of indentation from the wrapped code inside the
            # code fence
            for i in range(pair[0] + 1, pair[1]):
                curr_doc[i] = curr_doc[i][4:]

    # Add current function's Markdown documentation to the dictionary
    docs[mfilepath.stem] = ''.join(curr_doc)

# For each key (function name) in the dictionary...
for kfun in docs.keys():

    # Get the names of all functions except the current one
    other_kfuns = docs.keys() - {(kfun,)}

    # Replace function names with links to their documentation
    for okfun in other_kfuns:
        docs[kfun] = docs[kfun].replace(f"`{okfun}`", f"[`{okfun}`](../{okfun})")
        docs[kfun] = docs[kfun].replace(f"`{okfun}()`", f"[`{okfun}()`](../{okfun})")

    # Save respective Markdown file
    mdfilepath = Path(output_dir, kfun + ".md")
    print(docs[kfun], file=mdfilepath.open("w"))





