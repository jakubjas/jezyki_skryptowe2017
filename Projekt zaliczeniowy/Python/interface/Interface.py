import os


class UserInterface:
    """ Main class for maintaining the user interface """

    current_menu = None

    def __init__(self):
        pass

    @classmethod
    def change_menu(cls, new_menu):
        """ Method used for switching menu views """

        cls.current_menu = new_menu
        cls.clear_screen()
        cls.current_menu.print_menu()
        cls.perform_actions()

    @classmethod
    def perform_actions(cls):
        """ Method used for performing actions linked to the given menu options """

        while True:
            action_id = raw_input("\nEnter your choice: ")
            action = cls.current_menu.get_action(action_id)

            if action is not None:
                break

            print "Invalid option"

        cls.clear_screen()
        cls.current_menu.print_action_header(action["text"])

        new_menu = None

        while True:
            if new_menu is not None:
                break

            new_menu = action["func"]()

        cls.change_menu(new_menu())

    @classmethod
    def print_logo(cls):
        """ Prints the application logo """

        print r"""
       _    _ _                     ____  ____
      / \  | | |__  _   _ _ __ ___ |  _ \| __ )
     / _ \ | | '_ \| | | | '_ ` _ \| | | |  _ \
    / ___ \| | |_) | |_| | | | | | | |_| | |_) |
   /_/   \_\_|_.__/ \__,_|_| |_| |_|____/|____/
                                     version 1.1"""
        print

    @classmethod
    def clear_screen(cls):
        """ Method used for clearing the console screen """

        os.system('cls' if os.name == 'nt' else 'clear')
        cls.print_logo()
