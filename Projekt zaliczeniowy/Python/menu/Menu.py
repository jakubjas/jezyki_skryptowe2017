import sys
import math
import os
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir)))
from itertools import *
from state import State
from manager import Manager
from printer import Printer


class BaseMenu:
    """ Represents basic functionality of each menu view """

    def __init__(self):
        self.header = ""
        self.actions = []

    def get_action(self, action_id):
        """ Returns an action for a specified option """

        try:
            action_id = int(action_id)
        except ValueError:
            return None

        action = list(ifilter(lambda a: a["id"] == action_id, self.actions))
        return action[0] if len(action) else None

    def print_menu(self):
        """ Self-explanatory - prints the menu """

        separator = "+" + "-" * 50 + "+"
        print separator

        category = "|"
        cat_spacer = 25 - int(math.ceil(float(len(self.header)) / 2))
        category += " " * cat_spacer
        category += self.header
        category += " " * cat_spacer

        if len(self.header) % 2:
            category += " |"
        else:
            category += "|"

        print category

        print "|" + 50 * " " + "|"

        for action in self.actions:
            line = "| "
            action = "[" + str(action["id"]) + "] " + action["text"]
            line += action
            line += " " * (49 - len(action))
            line += "|"
            print line

        print separator

    @classmethod
    def print_action_header(cls, action_name):
        """ Prints header for a specified option """

        spacer = 25 - int(math.ceil(float(len(action_name)) / 2))

        header = "=" * spacer
        header += " " + action_name + " "
        header += "=" * spacer
        header += "\n"

        print header


class DatabaseMenu(BaseMenu):
    """ This menu includes the most common operations
        for working with databases """

    def __init__(self):
        self.header = "DATABASE MENU"
        self.actions = [
            {
                "id": 1,
                "text": "Create database",
                "func": self.create_database
            },
            {
                "id": 2,
                "text": "Delete database",
                "func": self.delete_database
            },
            {
                "id": 3,
                "text": "Load database",
                "func": self.load_database
            },
            {
                "id": 4,
                "text": "Exit",
                "func": lambda: sys.exit(0)
            }
        ]

    @classmethod
    def create_database(cls):
        """ Allows user to create database with a specified name """

        name = raw_input("Specify database name (default: music.db) - type 'exit' to abort): ") or "music.db"

        if name == 'exit':
            return DatabaseMenu

        State.ApplicationState.album_manager = Manager.AlbumManager(os.path.dirname(sys.argv[0]) + "/" + name)
        return MainMenu

    @classmethod
    def delete_database(cls):
        """ Allows user to delete database with a specified name """

        files = []

        for f in os.listdir(os.path.dirname(sys.argv[0])):
            if f.endswith(".db"):
                files.append(f)

        if not files:
            print "No database files found."
            raw_input("\nPress ENTER to go back to the previous menu... ")
            return DatabaseMenu

        else:
            print "Databases found: "

            for f in files:
                print(f)

            print

            name = raw_input("Specify database name (default: music.db - type 'exit' to abort): ") or "music.db"

            if name == 'exit':
                return DatabaseMenu

            elif not os.path.exists(os.path.dirname(sys.argv[0]) + "/" + name):
                print "The specified file does not exist.\n"
                return None

            os.remove(os.path.dirname(sys.argv[0]) + "/" + name)
            return DatabaseMenu

    @classmethod
    def load_database(cls):
        """ Allows user to load database with a specified name """

        files = []

        for f in os.listdir(os.path.dirname(sys.argv[0])):
            if f.endswith(".db"):
                files.append(f)

        if not files:
            print "No database files found."
            raw_input("\nPress ENTER to go back to the previous menu... ")
            return DatabaseMenu

        else:
            print "Databases found: "

            for f in files:
                print(f)

            print

            name = raw_input("Specify database name (default: music.db - type 'exit' to abort): ") or "music.db"

            if name == 'exit':
                return DatabaseMenu

            elif not os.path.exists(os.path.dirname(sys.argv[0]) + "/" + name):
                print "The specified file does not exist.\n"
                return None

            State.ApplicationState.album_manager = Manager.AlbumManager(os.path.dirname(sys.argv[0]) + "/" + name)
            return MainMenu


class MainMenu(BaseMenu):
    """ Main menu view """

    def __init__(self):
        self.header = "MAIN MENU"
        self.actions = [
            {
                "id": 1,
                "text": "Add album",
                "func": self.add_album_menu
            },
            {
                "id": 2,
                "text": "Delete album",
                "func": self.delete_album_menu
            },
            {
                "id": 3,
                "text": "Search",
                "func": self.search_menu
            },
            {
                "id": 4,
                "text": "Print collection",
                "func": self.print_collection_menu
            },
            {
                "id": 5,
                "text": "Database manager",
                "func": self.database_manager
            },
            {
                "id": 6,
                "text": "Exit",
                "func": lambda: sys.exit(0)
            }
        ]

    @classmethod
    def add_album_menu(cls):
        """ Method used for adding new albums to the existing database """

        while True:
            artist = raw_input("Artist: ")

            if artist:
                break

        while True:
            album_name = raw_input("Album name: ")

            if album_name:
                break

        while True:
            release_year = raw_input("Release year: ")

            if release_year.isdigit():
                break

        track_number = 1

        print "\nTracklist: (type '---' to finish)"

        while True:

            track_name = raw_input(str(track_number) + ". ")

            if track_name == "---":
                break
            else:
                Manager.AlbumManager.add_track(State.ApplicationState.album_manager, track_number, artist, track_name, album_name, release_year)
                track_number += 1

        return MainMenu

    @classmethod
    def delete_album_menu(cls):
        """ Switches the view to Delete Album """
        return DeleteMenu

    @classmethod
    def print_collection_menu(cls):
        """ Switches the view to Print Collection """
        return PrintCollection

    @classmethod
    def database_manager(cls):
        """ Switches the view to Database Manager """
        return DatabaseMenu

    @classmethod
    def search_menu(cls):
        """ Switches the view to Search Menu """
        return SearchMenu


class DeleteMenu(BaseMenu):
    """ This menu includes options for deleting single or multiple albums """

    def __init__(self):
        self.header = "DELETE ALBUM"
        self.actions = [
            {
                "id": 1,
                "text": "Delete a single release",
                "func": self.delete_a_single_release
            },
            {
                "id": 2,
                "text": "Delete all albums by an artist",
                "func": self.delete_all_by_artist
            },
            {
                "id": 3,
                "text": "Go back",
                "func": lambda: MainMenu
            }
        ]

    @classmethod
    def delete_a_single_release(cls):
        """ Allows user to delete a single album from the database """

        while True:
            artist = raw_input("Artist: ")

            if artist:
                break

        while True:
            album_name = raw_input("Album name: ")

            if album_name:
                break

        Manager.AlbumManager.delete_album(State.ApplicationState.album_manager, artist, album_name)
        return MainMenu

    @classmethod
    def delete_all_by_artist(cls):
        """ Allows user to delete all albums by a specified artist """

        while True:
            artist = raw_input("Artist: ")

            if artist:
                break

        Manager.AlbumManager.delete_all_by_artist(State.ApplicationState.album_manager, artist)
        return MainMenu


class SearchMenu(BaseMenu):
    """ Search Menu delivers various methods for filtering the database """

    def __init__(self):
        self.header = "SEARCH MENU"
        self.actions = [
            {
                "id": 1,
                "text": "Search by artist",
                "func": self.search_by_artist
            },
            {
                "id": 2,
                "text": "Search by album name",
                "func": self.search_by_album
            },
            {
                "id": 3,
                "text": "Search by release year",
                "func": self.search_by_year
            },
            {
                "id": 4,
                "text": "Search by track name",
                "func": self.search_by_track_name
            },
            {
                "id": 5,
                "text": "Go back",
                "func": lambda: MainMenu
            }
        ]

    @classmethod
    def search_by_artist(cls):
        """ Allows user to filter the database by artist """

        while True:
            artist = raw_input("Artist: ")

            if artist:
                break

        print

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_by_artist(State.ApplicationState.album_manager, artist))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return SearchMenu

    @classmethod
    def search_by_album(cls):
        """ Allows user to filter the database by album name """

        while True:
            album_name = raw_input("Album name: ")

            if album_name:
                break

        print

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_by_name(State.ApplicationState.album_manager, album_name))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return SearchMenu

    @classmethod
    def search_by_year(cls):
        """ Allows user to filter the database by release year """

        while True:
            release_year = raw_input("Release year: ")

            if release_year.isdigit():
                break

        print

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_by_year(State.ApplicationState.album_manager, release_year))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return SearchMenu

    @classmethod
    def search_by_track_name(cls):

        while True:
            track_name = raw_input("Track name: ")

            if track_name:
                break

        print

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_by_track_name(State.ApplicationState.album_manager, track_name))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return SearchMenu


class PrintCollection(BaseMenu):
    """ This menu delivers various methods for printing the database """

    def __init__(self):
        self.header = "PRINT MENU"
        self.actions = [
            {
                "id": 1,
                "text": "Print all albums sorted by artist",
                "func": self.sorted_by_artist
            },
            {
                "id": 2,
                "text": "Print all albums sorted by album name",
                "func": self.sorted_by_album
            },
            {
                "id": 3,
                "text": "Print all albums sorted by release year",
                "func": self.sorted_by_year
            },
            {
                "id": 4,
                "text": "Print album details",
                "func": self.print_album
            },
            {
                "id": 5,
                "text": "Go back",
                "func": lambda: MainMenu
            }
        ]

    @classmethod
    def sorted_by_artist(cls):
        """ Allows user to print the albums sorted by artist """

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_albums(State.ApplicationState.album_manager))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return PrintCollection

    @classmethod
    def sorted_by_album(cls):
        """ Allows user to print the albums sorted by album name """

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_albums(State.ApplicationState.album_manager, 'AlbumName'))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return PrintCollection

    @classmethod
    def sorted_by_year(cls):
        """ Allows user to print the albums sorted by release year """

        Printer.AlbumPrinter.print_albums(Manager.AlbumManager.get_albums(State.ApplicationState.album_manager, 'ReleaseYear'))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return PrintCollection

    @classmethod
    def print_album(cls):

        while True:
            artist = raw_input("Artist: ")

            if artist:
                break

        while True:
            album_name = raw_input("Album name: ")

            if album_name:
                break

        Printer.AlbumPrinter.print_album(Manager.AlbumManager.get_album(State.ApplicationState.album_manager, artist, album_name))
        raw_input("\nPress ENTER to go back to the previous menu... ")
        return PrintCollection
