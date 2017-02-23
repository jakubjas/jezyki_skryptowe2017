#!/usr/bin/perl
#Jakub Jas, grupa 2

package GetInfo;

use MP3::Tag;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(get_track_info);

sub get_track_info
{
  my $file = shift;
  my $type = shift;

  $mp3 = MP3::Tag->new($file);
  $mp3->get_tags();

  if (exists $mp3->{ID3v1})
  {
    return $mp3->{ID3v1}->$type;
  }
  else
  {
    return "";
  }

  $mp3->close();
}
