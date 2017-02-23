#!/var/bin/python
# Jakub Jas, grupa 2

import numbers
import getopt
import sys
import os

c_flag = False
l_flag = False
m_flag = False
w_flag = False
d_flag = False
i_flag = False
e_flag = False

no_options = False


def usage():
    script_filename = os.path.basename(__file__)
    print "\nUsage: python " + str(script_filename) + " -c -l -m -w -d -i -e <files>\n" \
                                                      "-c:\tThe number of bytes in each input file is written to the"\
                                                      "standard output. This will cancel out any prior usage of the -m"\
                                                      " option.\n" \
                                                      "-l:\tThe number of lines in each input file is written to" \
                                                      "the standard output.\n" \
                                                      "-m:\tThe number of characters in each input file is written to" \
                                                      "the standard output. This will cancel out any prior usage of" \
                                                      "the -c option.\n" \
                                                      "-w:\tThe number of words in each input file is written to" \
                                                      "the standard output.\n" \
                                                      "-d:\tThe number of numeric values in each input file is written"\
                                                      "to the standard output.\n" \
                                                      "-i:\tThe number of integers in each input file is written to "\
                                                      "the standard output.\n" \
                                                      "-e:\tIgnore lines starting with #\n"

try:
    options, remainder = getopt.getopt(sys.argv[1:], 'clmwdie')

except getopt.GetoptError as err:
    print "\nError: " + str(err)
    usage()
    sys.exit(2)

for opt, arg in options:
    if opt in '-c':
        c_flag = True
        m_flag = False
    elif opt in '-l':
        l_flag = True
    elif opt in '-m':
        c_flag = False
        m_flag = True
    elif opt in '-w':
        w_flag = True
    elif opt in '-d':
        d_flag = True
    elif opt in '-i':
        i_flag = True
    elif opt in '-e':
        e_flag = True

if not (c_flag or l_flag or m_flag or w_flag or d_flag or i_flag or e_flag):
    no_options = True

if not remainder:
    if no_options:
        m_flag = True
        l_flag = True
        w_flag = True

    lines = 0
    words = 0
    chars = 0
    nums = 0
    integers = 0

    input_str = sys.stdin.readlines()

    for line in input_str:

        if e_flag:
            if line.startswith("#"):
                continue

        elements = line.split()

        if l_flag:
            lines += 1

        if m_flag:
            chars += len(line)

        if w_flag:
            words += len(elements)

        for word in elements:
            if numbers.check_if_valid_number(word):
                if numbers.check_if_integer(word) and i_flag:
                    integers += 1

                if d_flag:
                    nums += 1

    print "\n"

    if l_flag:
        print "%10s " % "Lines",

    if w_flag:
        print "%10s " % "Words",

    if m_flag:
        print "%10s " % "Chars",

    if d_flag:
        print "%10s " % "Numbers",

    if i_flag:
        print "%10s " % "Integers",

    print

    if l_flag:
        print "%10s " % lines,

    if w_flag:
        print "%10s " % words,

    if m_flag:
        print "%10s " % chars,

    if d_flag:
        print "%10s " % nums,

    if i_flag:
        print "%10s " % integers,

    print

else:
    header_printed = False
    global_lines = 0
    global_words = 0
    global_chars = 0
    global_nums = 0
    global_integers = 0
    global_size = 0

    if no_options:
        c_flag = True
        l_flag = True
        w_flag = True

    for filename in remainder:
        try:
            f = open(filename)
        except IOError as e:
            print "\n\nI/O error({0}): {1} ({2})\n".format(e.errno, e.strerror, f.name)

        if not header_printed:
            if l_flag:
                print "%10s " % "Lines",
            if w_flag:
                print "%10s " % "Words",
            if m_flag:
                print "%10s " % "Chars",
            if d_flag:
                print "%10s " % "Numbers",
            if i_flag:
                print "%10s " % "Integers",
            if c_flag:
                print "%10s " % "Bytes",

            print

            header_printed = True

        lines = 0
        words = 0
        chars = 0
        nums = 0
        integers = 0
        size = 0

        if c_flag:
            size = os.path.getsize(os.path.realpath(f.name))
            global_size += size

        for line in f:
            if e_flag:
                if line.startswith("#"):
                    continue

            elements = line.split()

            if l_flag:
                lines += 1
                global_lines += 1

            if m_flag:
                chars += len(line)
                global_chars += len(line)

            if w_flag:
                words += len(elements)
                global_words += len(elements)

            for word in elements:
                if numbers.check_if_valid_number(word):
                    if numbers.check_if_integer(word) and i_flag:
                        integers += 1
                        global_integers += 1

                    if d_flag:
                        nums += 1
                        global_nums += 1

        if l_flag:
            print "%10s " % lines,

        if w_flag:
            print "%10s " % words,

        if m_flag:
            print "%10s " % chars,

        if d_flag:
            print "%10s " % nums,

        if i_flag:
            print "%10s " % integers,

        if c_flag:
            print "%10s " % size,

        print "%s " % str(f.name)

    if len(remainder) > 1:
        if l_flag:
            print "%10s " % global_lines,

        if w_flag:
            print "%10s " % global_words,

        if m_flag:
            print "%10s " % global_chars,

        if d_flag:
            print "%10s " % global_nums,

        if i_flag:
            print "%10s " % global_integers,

        if c_flag:
            print "%10s " % global_size,

        print "total"
