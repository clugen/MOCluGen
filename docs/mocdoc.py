from pathlib import Path

input_files = sorted(Path('..', 'src').glob('*.m'))
output_dir = Path('docs', 'api')

# total files
n = len(input_files)

docs = {}

for mfilepath in input_files:

    blanks = []
    curr_doc = []
    curr_doc.append(f"# {mfilepath.stem}\n\n")

    with mfilepath.open("r") as mfile:
        for mline in mfile:

            mline = mline.strip()

            if len(mline) == 0:
                continue
            elif mline.startswith("% "):
                mline = mline[2:]
            elif mline.startswith("%"):
                mline = mline[1:]
            elif mline.startswith("function"):
                break

            if len(mline) == 0:
                blanks.append(len(curr_doc))

            curr_doc.append(mline + "\n")

    if curr_doc[-1] != "\n":
        blanks.append(len(curr_doc))
        curr_doc.append("\n")

    code_pairs = []

    for i in range(len(blanks) - 1):
        pair = blanks[i:i+2]
        if pair[0] + 1 == pair[1]:
            continue
        is_code = True
        for j in range(pair[0] + 1, pair[1]):
            if not curr_doc[j].startswith("    "):
                is_code = False
                break

        if is_code:
            code_pairs.append(pair)

    if len(code_pairs) > 0:
        merged_pairs = [code_pairs[0]]

        for i in range(len(code_pairs) - 1):
            if code_pairs[i][1] != code_pairs[i + 1][0]:
                merged_pairs.append(code_pairs[i + 1])
            else:
                merged_pairs[-1] = [code_pairs[i][0], code_pairs[i + 1][1]]

        for pair in merged_pairs:
            curr_doc[pair[0]] = "\n```matlab\n"
            curr_doc[pair[1]] = "```\n\n"
            for i in range(pair[0] + 1, pair[1]):
                curr_doc[i] = curr_doc[i][4:]

    docs[mfilepath.stem] = ''.join(curr_doc)

for kfun in docs.keys():
    # Add links to functions

    # Save file
    mdfilepath = Path(output_dir, kfun + ".md")
    print(docs[kfun], file=mdfilepath.open("w"))





