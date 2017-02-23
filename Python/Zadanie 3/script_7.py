#!/var/bin/python
# -*- coding: utf-8 -*-
# Jakub Jas, grupa 2

import sys
import getopt
import collections
import numbers


def horizontal_line():
    for i in range(90):
        sys.stdout.write('-')
    print

try:
    options, remainder = getopt.getopt(sys.argv[1:], '')

except getopt.GetoptError as err:
    print "\nError: " + str(err)
    sys.exit(2)

count_global = 0
avrg_global = []

if not remainder:
    print "Proszę podać plik z listą"
    sys.exit(2)

for filename in remainder:

    people = {}

    try:
        f = open(filename)
    except IOError as e:
        print "\n\nI/O error({0}): {1} ({2})\n".format(e.errno, e.strerror, f.name)

    for line in f:
        words = line.split()

        if len(words) == 3:
            name = (words[0].decode('utf-8').lower()).capitalize()
            surname = (words[1].decode('utf-8').lower()).capitalize()
            person = surname + " " + name
            mark = words[2]

            if numbers.convert_mark_to_num(mark) and name and surname:
                people.setdefault(person, []).append(mark)
            else:
                sys.stderr.write(line)
        else:
            sys.stderr.write(line)

    header = ""
    filename = "Plik: " + str(f.name)
    header += " " * (90 - len(filename))
    header += filename

    print

    print header + "\n"

    surname_name_h = "Nazwisko i imię"
    marks_l_h = "Lista ocen"
    average_h = "Średnia"
    surname_name_h += " " * (40 - len(surname_name_h))
    marks_l_h += " " * (40 - len(marks_l_h))
    average_h += " " * (10 - len(average_h))

    horizontal_line()

    sys.stdout.write(surname_name_h)
    sys.stdout.write(marks_l_h)
    sys.stdout.write(average_h + "\n")

    horizontal_line()

    sorted_people = collections.OrderedDict(sorted(people.items(), key=lambda s: str(s).decode('utf-8').split()[1]))

    for person in sorted_people:
        marks = sorted_people.get(person)
        marks_count = len(marks)
        sum_p = 0

        for mark in marks:
            sum_p += float(numbers.convert_mark_to_num(mark))

        average = float(sum_p)/float(marks_count)
        marks_string = ""

        for mark in marks:
            marks_string += str(mark).decode('utf-8')
            marks_string += " "

        person += " " * (39 - len(person))
        marks_string += " " * (40 - len(marks_string))

        sys.stdout.write(person)
        sys.stdout.write(marks_string)
        print "%.2f" % average

        avrg_global.append(average)
        count_global += 1

    print

horizontal_line()

sum_g = 0

for average in avrg_global:
    sum_g += average

avrg = float(sum_g)/float(count_global)

avrg_string = "Średnia ogółem: %.2f" % avrg

global_avrg = " " * (93 - len(avrg_string))
global_avrg += avrg_string

print global_avrg + "\n"
