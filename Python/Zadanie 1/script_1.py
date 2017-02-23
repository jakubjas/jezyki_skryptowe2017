#!/var/bin/python
# Jakub Jas, grupa 2

import sys

if len(sys.argv) == 2:
    if int(sys.argv[1]) < 0:
        step = -1
    else:
        step = 1

    print

    for x in range(1, int(sys.argv[1]), step):
        for y in range(1, int(sys.argv[1]), step):
            print str(x * y).rjust(4),
        print

    print
else:
    print "Prosze podac argument!"

