import sys
import os
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir)))

from database import Database


class AlbumManager:
    """ This class offers all methods related to the management of the database contents """

    def __init__(self, database='music.db'):
        self.database = Database.DatabaseLayer(database)
        self.database.query(
            "CREATE TABLE IF NOT EXISTS Collection(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, TrackNumber INTEGER NOT NULL, Artist TEXT NOT NULL, TrackName TEXT NOT NULL, AlbumName TEXT NOT NULL, ReleaseYear INTEGER NOT NULL)")

    def delete_database(self):
        self.database.query("DROP DATABASE Collection")

    def add_track(self, track_number, artist, track_title, album_name, release_year):
        self.database.query("INSERT INTO Collection (TrackNumber, Artist, TrackName, AlbumName, ReleaseYear) VALUES (?, ?, ?, ?, ?)",
                            (track_number, artist, track_title, album_name, release_year))

    def delete_album(self, artist, album_name):
        self.database.query("DELETE FROM Collection WHERE Artist=? AND AlbumName=?", (artist, album_name))

    def delete_track(self, artist, track_title):
        self.database.query("DELETE FROM Collection WHERE Artist=? AND TrackName=?", (artist, track_title))

    def delete_all_by_artist(self, artist):
        self.database.query("DELETE FROM Collection WHERE Artist=?", (artist,))

    def get_albums(self, key='Artist'):
        return self.database.query("SELECT Artist, AlbumName, ReleaseYear FROM Collection GROUP BY Artist, AlbumName, ReleaseYear ORDER BY " + key)

    def get_album(self, artist, album_name, key='TrackNumber'):
        return self.database.query("SELECT TrackNumber, Artist, TrackName, AlbumName, ReleaseYear FROM Collection WHERE Artist=? AND AlbumName=? ORDER BY " + key, (artist, album_name,))

    def get_by_artist(self, artist, key='ReleaseYear'):
        return self.database.query(
            "SELECT Artist, AlbumName, ReleaseYear FROM Collection WHERE Artist LIKE '%" + artist + "%' GROUP BY Artist, AlbumName, ReleaseYear ORDER BY " + key)

    def get_by_name(self, album_name, key='Artist'):
        return self.database.query(
            "SELECT Artist, AlbumName, ReleaseYear FROM Collection WHERE AlbumName LIKE '%" + album_name + "%' GROUP BY Artist, AlbumName, ReleaseYear ORDER BY " + key)

    def get_by_year(self, release_year, key='Artist'):
        return self.database.query(
            "SELECT Artist, AlbumName, ReleaseYear FROM Collection WHERE ReleaseYear=? GROUP BY Artist, AlbumName, ReleaseYear ORDER BY " + key,
            (release_year,))

    def get_by_track_name(self, track_name, key='Artist'):
        return self.database.query(
            "SELECT Artist, AlbumName, ReleaseYear FROM Collection WHERE TrackName LIKE '%" + track_name + "%' GROUP BY Artist, AlbumName, ReleaseYear ORDER BY " + key)
