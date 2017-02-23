#!/var/bin/python
# Jakub Jas, grupa 2

import getopt
import sys
import os

n_flag = False
v_flag = False


def usage():
    script_filename = os.path.basename(__file__)
    print "\nUsage: python " + str(script_filename) + " -n -v <files>\n" \
                                                      "-n:\tnumber the lines\n" \
                                                      "-v:\tprint comments\n"

try:
    options, remainder = getopt.getopt(sys.argv[1:], 'nv')

except getopt.GetoptError as err:
    print "\nError: " + str(err)
    usage()
    sys.exit(2)

for opt, arg in options:
    if opt in '-n':
        n_flag = True
    elif opt in '-v':
        v_flag = True

if not remainder:
    usage()
    sys.exit(3)

for filename in remainder:
    counter = 0

    try:
        f = open(filename)
    except IOError as e:
        print "\n\nI/O error({0}): {1} ({2})\n".format(e.errno, e.strerror, f.name)
        continue

    print "\n[File: " + str(f.name) + "]"

    for line in f:
        counter += 1

        if n_flag:
            if v_flag:
                    print counter, line,
            else:
                if not line.startswith("#"):
                    print counter, line,
        else:
            if v_flag:
                    print line,
            else:
                if not line.startswith("#"):
                    print line,
