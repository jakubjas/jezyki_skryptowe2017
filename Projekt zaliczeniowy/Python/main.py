#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
from interface import Interface
from menu import Menu


def display_help():

    text = "AlbumDB - your personal music collection in one place"

    frame = ""

    for i in range(len(text)+4):
        frame += "*"

    print
    print frame

    print "* " + text + " *"

    print frame
    print

    script_filename = os.path.basename(__file__)
    print "Usage: ./" + str(script_filename) + "\n"

arguments = iter(sys.argv)
next(arguments)

for arg in arguments:
    if arg == '-h' or arg == '--help':
        display_help()
        sys.exit(1)

Interface.UserInterface.change_menu(Menu.DatabaseMenu())
