class AlbumPrinter:
    """ This class offers functionality required for printing
        the database contents """

    def __init__(self):
        pass

    @classmethod
    def print_albums(cls, data):

        data = list(data)

        if not data:
            print "No results."
            return

        header = ["Artist", "Album name", "Release year"]
        widths = [len(header[0]), len(header[1]), len(header[2])]
        max_values = []

        max_values.append(max([len(row['Artist']) for row in data]))
        max_values.append(max([len(row['AlbumName']) for row in data]))
        max_values.append(max([len(str(row['ReleaseYear'])) for row in data]))

        for i in range(3):
            if max_values[i] > widths[i]:
                widths[i] = max_values[i]

        separator = "+"
        row_format = "|"

        for width in widths:
            row_format += " %-" + "%ss |" % (width,)
            separator += "-" * width + "--+"

        print separator
        print (row_format % (header[0], header[1], header[2]))
        print separator

        for row in data:
            print (row_format % (row["Artist"], row["AlbumName"], row["ReleaseYear"]))

        print separator

    @classmethod
    def print_album(cls, data):

        data = list(data)

        if not data:
            print "\nNo results."
            return

        print ("Release year: %s" % data[0]["ReleaseYear"])

        print "\nTracklist: "

        for row in data:
            print ("%d. %s" % (row["TrackNumber"], row["TrackName"]))
