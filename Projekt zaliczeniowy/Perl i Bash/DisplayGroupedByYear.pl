#!/usr/bin/perl
#Jakub Jas, grupa 2

use YearObj qw(new getTrackNum getTrackArtist getTrackTitle getTrackAlbum);
use POSIX;
use GetInfo qw(get_track_info);
use SetInfo qw(set_track_info);
use FindLongestString qw(find_longest_string);

my $absolute_path = shift;
my @files = @ARGV;
my %years;

foreach $file (@files)
{
  my $artist = get_track_info($absolute_path . "/" . $file, "artist");
  my $album = get_track_info($absolute_path . "/" . $file, "album");
  my $year = get_track_info($absolute_path . "/" . $file, "year");
  my $number = get_track_info($absolute_path . "/" . $file, "track");
  my $title = get_track_info($absolute_path . "/" . $file, "title");

  $year_data = new YearObj($number, $artist, $title, $album);
  push @{$years{"$year"}}, $year_data;
}

print "\n";

foreach my $year (sort {$a <=> $b} keys %years)
{
  my @tracks = @{$years{$year}};
  my @numbers = ();
  my @artists = ();
  my @titles = ();
  my @albums = ();

  foreach (@tracks)
  {
    my $track = $_;
    push @numbers, $track->getTrackNum();
    push @artists, $track->getTrackArtist();
    push @titles, $track->getTrackTitle();
    push @albums, $track->getTrackAlbum();
  }

  $longest_num = find_longest_string(\@numbers);
  $longest_artist = find_longest_string(\@artists);
  $longest_title = find_longest_string(\@titles);
  $longest_album = find_longest_string(\@albums);

  if ($longest_artist > length("Artist"))
  {
    $col1_width = $longest_artist;
  }
  else
  {
    $col1_width = length("Artist");
  }

  if ($longest_title > length("Title"))
  {
    $col2_width = $longest_title;
  }
  else
  {
    $col2_width = length("Title");
  }

  if ($longest_album > length("Album"))
  {
    $col3_width = $longest_album;
  }
  else
  {
    $col3_width = length("Album");
  }

  $width = $col1_width + length(" | ") + $col2_width + length(" | ") + $col3_width;

  $frame_horizontal = "+-";
  $frame_horizontal .= ("-" x $width);
  $frame_horizontal .= "-+\n";

  print $frame_horizontal;

  $header = "| ";
  $spacer = " " x (floor(($width - length($year))/2));
  $header .= $spacer;
  $header .= $year;
  $header .= $spacer;

  if (($width - length($year)) % 2)
  {
    $header .= "  |\n";
  }
  else
  {
    $header .= " |\n";
  }

  print $header;
  print $frame_horizontal;

  my $artist_h_format = "| ";
  my $artist_h_spacer = " " x ( floor($col1_width - length("Artist")) );

  my $title_h_format = " ";
  my $title_h_spacer = " " x ( floor($col2_width - length("Title")) );

  my $album_h_format = " ";
  my $album_h_spacer = " " x ( floor($col3_width - length("Album")) );

  $artist_h_format .= "Artist";
  $artist_h_format .= $artist_h_spacer;
  $artist_h_format .= " |";

  $title_h_format .= "Title";
  $title_h_format .= $title_h_spacer;
  $title_h_format .= " |";

  $album_h_format .= "Album";
  $album_h_format .= $album_h_spacer;
  $album_h_format .= " |";

  print $artist_h_format . $title_h_format . $album_h_format . "\n";
  print $frame_horizontal;

  foreach (@tracks)
  {
    my $track = $_;

    my $artist_format = "| ";
    my $artist_spacer = " " x ( floor($col1_width - length($track->getTrackArtist())) );

    my $title_format = " ";
    my $title_spacer = " " x ( floor($col2_width - length($track->getTrackTitle())) );

    my $album_format = " ";
    my $album_spacer = " " x ( floor($col3_width - length($track->getTrackAlbum())) );

    $artist_format .= $track->getTrackArtist();
    $artist_format .= $artist_spacer;
    $artist_format .= " |";

    $title_format .= $track->getTrackTitle();
    $title_format .= $title_spacer;
    $title_format .= " |";

    $album_format .= $track->getTrackAlbum();
    $album_format .= $album_spacer;
    $album_format .= " |";

    print $artist_format . $title_format . $album_format . "\n";
  }

  print $frame_horizontal . "\n";
}
