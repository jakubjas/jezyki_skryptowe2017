#!/var/bin/python
# Jakub Jas, grupa 2

import re
import sys
import math

a = None
b = None
c = None
x1 = None
x2 = None

found_a = False
found_b = False
found_c = False
all_found = False

pattern_a = r"^a=[-+]?[0-9]*\.?[0-9]+\b$"
pattern_b = r"^b=[-+]?[0-9]*\.?[0-9]+\b$"
pattern_c = r"^c=[-+]?[0-9]*\.?[0-9]+\b$"
pattern_number = r"^[-+]?[0-9]*\.?[0-9]+\b$"

arguments = iter(sys.argv)
next(arguments)

for arg in arguments:
    if re.match(pattern_a, arg):
        a = float(arg.replace("a=", ""))
        found_a = True
    if re.match(pattern_b, arg):
        b = float(arg.replace("b=", ""))
        found_b = True
    if re.match(pattern_c, arg):
        c = float(arg.replace("c=", ""))
        found_c = True

while not all_found:
    while not found_a:
        my_input = raw_input("Prosze podac parametr a: ")
        if re.match(pattern_number, my_input):
            a = float(my_input)
            found_a = True
    while not found_b:
        my_input = raw_input("Prosze podac parametr b: ")
        if re.match(pattern_number, my_input):
            b = float(my_input)
            found_b = True
    while not found_c:
        my_input = raw_input("Prosze podac parametr c: ")
        if re.match(pattern_number, my_input):
            c = float(my_input)
            found_c = True
    if found_a and found_b and found_c:
        all_found = True

if a == 0 and b == 0 and c == 0:
    print "Nieskonczenie wiele rozwiazan rownania"
elif a == 0 and b == 0 and c != 0:
    print "Rownanie sprzeczne"
elif a == 0 and b != 0:
    x = float(-c)/float(b)
    print "x = " + str(x)
elif a != 0:
    delta = b*b - 4*a*c

    if delta > 0:
        x1 = float(-b + math.sqrt(delta)) / float(2*a)
        x2 = float(-b - math.sqrt(delta)) / float(2*a)
    elif delta == 0:
        x1 = x2 = float(-b)/float(2*a)
    elif delta < 0:
        x1 = "(" + str(-b) + " + i*sqrt(" + str(delta) + ") / " + str(2*a)
        x2 = "(" + str(-b) + " - i*sqrt(" + str(delta) + ") / " + str(2*a)

    if x1 is not None and x2 is not None:
        print "x1 = " + str(x1)
        print "x2 = " + str(x2)
