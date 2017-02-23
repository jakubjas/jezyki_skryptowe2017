#!/usr/bin/perl
#Jakub Jas, grupa 2

use POSIX;
use GetInfo qw(get_track_info);
use SetInfo qw(set_track_info);
use FindLongestString qw(find_longest_string);

my $absolute_path = shift;
my @files = @ARGV;
my %albums;

foreach $file (@files)
{
  my $artist = get_track_info($absolute_path . "/" . $file, "artist");
  my $album = get_track_info($absolute_path . "/" . $file, "album");
  my $year = get_track_info($absolute_path . "/" . $file, "year");
  my $number = get_track_info($absolute_path . "/" . $file, "track");
  my $title = get_track_info($absolute_path . "/" . $file, "title");

  push @{$albums{"$artist - $album ($year)"}}, "$number. $title";
}

print "\n";

foreach my $album (sort { $a cmp $b } keys %albums)
{
  my @tracks = @{$albums{$album}};
  my $width;

  $header_length = length($album);
  $max_track_length = find_longest_string(\@tracks);

  if ($header_length > $max_track_length)
  {
    $width = $header_length;
  }
  else
  {
    $width = $max_track_length;
  }

  $frame_horizontal = "+-";
  $frame_horizontal .= ("-" x $width);
  $frame_horizontal .= "-+\n";

  print $frame_horizontal;

  $header = "| ";
  $spacer = " " x (floor(($width - length($album))/2));
  $header .= $spacer;
  $header .= $album;
  $header .= $spacer;

  if (($width - length($album)) % 2)
  {
    $header .= "  |\n";
  }
  else
  {
    $header .= " |\n";
  }

  print $header;
  print $frame_horizontal;

  foreach (@tracks)
  {
    my $track = $_;
    my $track_format = "| ";
    my $track_spacer = " " x ( floor($width - length($track)) );

    $track_format .= $track;
    $track_format .= $track_spacer;
    $track_format .= " |";

    print $track_format . "\n";
  }

  print $frame_horizontal . "\n";
}
