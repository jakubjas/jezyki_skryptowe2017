#!/usr/bin/perl
#Jakub Jas, grupa 2

use File::Basename qw(basename);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0));
use ArtistObj;
use POSIX;
use SetInfo qw(set_track_info);

sub print_header
{
  my $file = shift;
  $header = "File: " . basename($file);
  $frame_horizontal = "+-";
  $frame_horizontal .= ("-" x length($header));
  $frame_horizontal .= "-+\n";

  print $frame_horizontal;

  my $file_format = "| ";
  $file_format .= $header;
  $file_format .= " |\n";

  print $file_format;
  print $frame_horizontal . "\n";
}

$a_flag = 0;
$b_flag = 0;
$n_flag = 0;
$t_flag = 0;
$y_flag = 0;

my @settings = split(//, shift);

foreach my $arg (@settings)
{
  if ($arg eq "a")
  {
    $a_flag = 1;
  }
  elsif ($arg eq "b")
  {
    $b_flag = 1;
  }
  elsif ($arg eq "n")
  {
    $n_flag = 1;
  }
  elsif ($arg eq "t")
  {
    $t_flag = 1;
  }
  elsif ($arg eq "y")
  {
    $y_flag = 1;
  }
}

my $absolute_path = shift;
my @files = @ARGV;

print "\n";

foreach $file (@files)
{
  my $track_number = "";
  my $track_artist = "";
  my $track_title = "";
  my $track_album = "";
  my $track_year = "";

  if (($n_flag eq 0) && ($a_flag eq 0) && ($t_flag eq 0) && ($b_flag eq 0) && ($y_flag eq 0))
  {
    print_header($file);

    do
    {
      print "Track number: ";
      chop ($track_number = <STDIN>);
    } until ($track_number ne "");

    do
    {
      print "Artist: ";
      chop ($track_artist = <STDIN>);
    } until ($track_artist ne "");

    do
    {
      print "Title: ";
      chop ($track_title = <STDIN>);
    } until ($track_title ne "");

    do
    {
      print "Album: ";
      chop ($track_album = <STDIN>);
    } until ($track_album ne "");

    do
    {
      print "Year: ";
      chop ($track_year = <STDIN>);
    } until ($track_year ne "");

    set_track_info($absolute_path . "/" . $file, "track", $track_number);
    set_track_info($absolute_path . "/" . $file, "artist", $track_artist);
    set_track_info($absolute_path . "/" . $file, "title", $track_title);
    set_track_info($absolute_path . "/" . $file, "album", $track_album);
    set_track_info($absolute_path . "/" . $file, "year", $track_year);
  }
  else
  {
    print_header($file);

    if ($n_flag eq 1)
    {
      do
      {
        print "Track number: ";
        chop ($track_number = <STDIN>);
      } until ($track_number ne "");

      set_track_info($absolute_path . "/" . $file, "track", $track_number);
    }

    if ($a_flag eq 1)
    {
      do
      {
        print "Artist: ";
        chop ($track_artist = <STDIN>);
      } until ($track_artist ne "");

      set_track_info($absolute_path . "/" . $file, "artist", $track_artist);
    }

    if ($t_flag eq 1)
    {
      do
      {
        print "Title: ";
        chop ($track_title = <STDIN>);
      } until ($track_title ne "");

      set_track_info($absolute_path . "/" . $file, "title", $track_title);
    }

    if ($b_flag eq 1)
    {
      do
      {
        print "Album: ";
        chop ($track_album = <STDIN>);
      } until ($track_album ne "");

      set_track_info($absolute_path . "/" . $file, "album", $track_album);
    }

    if ($y_flag eq 1)
    {
      do
      {
        print "Year: ";
        chop ($track_year = <STDIN>);
      } until ($track_year ne "");

      set_track_info($absolute_path . "/" . $file, "year", $track_year);
    }
  }

  print "\n";

}
