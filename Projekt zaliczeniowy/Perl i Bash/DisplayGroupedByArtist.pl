#!/usr/bin/perl
#Jakub Jas, grupa 2

use ArtistObj qw(new getTrackNum getTrackTitle getTrackAlbum getTrackYear);
use POSIX;
use GetInfo qw(get_track_info);
use SetInfo qw(set_track_info);
use FindLongestString qw(find_longest_string);

my $absolute_path = shift;
my @files = @ARGV;
my %artists;

foreach $file (@files)
{
  my $artist = get_track_info($absolute_path . "/" . $file, "artist");
  my $album = get_track_info($absolute_path . "/" . $file, "album");
  my $year = get_track_info($absolute_path . "/" . $file, "year");
  my $number = get_track_info($absolute_path . "/" . $file, "track");
  my $title = get_track_info($absolute_path . "/" . $file, "title");

  $artist_data = new ArtistObj($number, $title, $album, $year);
  push @{$artists{"$artist"}}, $artist_data;
}

print "\n";

foreach my $artist (sort { $a cmp $b } keys %artists)
{
  my @tracks = @{$artists{$artist}};
  my @titles = ();
  my @albums = ();
  my @years = ();
  my @numbers = ();

  foreach (@tracks)
  {
    my $track = $_;
    push @titles, $track->getTrackTitle();
    push @albums, $track->getTrackAlbum();
    push @years, $track->getTrackYear();
    push @numbers, $track->getTrackNum();
  }

  $longest_title = find_longest_string(\@titles);
  $longest_album = find_longest_string(\@albums);
  $longest_year = find_longest_string(\@years);
  $longest_num = find_longest_string(\@numbers);

  if ($longest_title > length("Title"))
  {
    $col1_width = $longest_title;
  }
  else
  {
    $col1_width = length("Title");
  }

  if ($longest_album > length("Album"))
  {
    $col2_width = $longest_album;
  }
  else
  {
    $col2_width = length("Album");
  }

  if ($longest_year > length("Year"))
  {
    $col3_width = $longest_year;
  }
  else
  {
    $col3_width = length("Year");
  }

  $width = $col1_width + length(" | ") + $col2_width + length(" | ") + $col3_width;

  $frame_horizontal = "+-";
  $frame_horizontal .= ("-" x $width);
  $frame_horizontal .= "-+\n";

  print $frame_horizontal;

  $header = "| ";
  $spacer = " " x (floor(($width - length($artist))/2));
  $header .= $spacer;
  $header .= $artist;
  $header .= $spacer;

  if (($width - length($artist)) % 2)
  {
    $header .= "  |\n";
  }
  else
  {
    $header .= " |\n";
  }

  print $header;
  print $frame_horizontal;

  my $title_h_format = "| ";
  my $title_h_spacer = " " x ( floor($col1_width - length("Title")) );

  my $album_h_format = " ";
  my $album_h_spacer = " " x ( floor($col2_width - length("Album")) );

  my $year_h_format = " ";
  my $year_h_spacer = " " x ( floor($col3_width - length("Year")) );

  $title_h_format .= "Title";
  $title_h_format .= $title_h_spacer;
  $title_h_format .= " |";

  $album_h_format .= "Album";
  $album_h_format .= $album_h_spacer;
  $album_h_format .= " |";

  $year_h_format .= "Year";
  $year_h_format .= $year_h_spacer;
  $year_h_format .= " |";

  print $title_h_format . $album_h_format . $year_h_format . "\n";
  print $frame_horizontal;

  foreach (@tracks)
  {
    my $track = $_;

    my $title_format = "| ";
    my $title_spacer = " " x ( floor($col1_width - length($track->getTrackTitle())) );

    my $album_format = " ";
    my $album_spacer = " " x ( floor($col2_width - length($track->getTrackAlbum())) );

    my $year_format = " ";
    my $year_spacer = " " x ( floor($col3_width - length($track->getTrackYear())) );

    $title_format .= $track->getTrackTitle();
    $title_format .= $title_spacer;
    $title_format .= " |";

    $album_format .= $track->getTrackAlbum();
    $album_format .= $album_spacer;
    $album_format .= " |";

    $year_format .= $track->getTrackYear();
    $year_format .= $year_spacer;
    $year_format .= " |";

    print $title_format . $album_format . $year_format . "\n";
  }

  print $frame_horizontal . "\n";
}
