import sqlite3


class DatabaseLayer:
    """ Provides a layer for communication with the database """

    def __init__(self, database='music.db'):
        self.database = database

    def query(self, statements, data=()):
        """ Method used for querying the database """

        with sqlite3.connect(self.database) as connection:
            connection.text_factory = lambda x: unicode(x, "utf-8", "ignore")
            connection.row_factory = sqlite3.Row
            cursor = connection.cursor()
            result = cursor.execute(statements, data)
            connection.commit()

        return result
