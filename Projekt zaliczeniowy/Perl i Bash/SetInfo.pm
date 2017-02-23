#!/usr/bin/perl
#Jakub Jas, grupa 2

package SetInfo;

use MP3::Tag;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(set_track_info);

sub set_track_info
{
  my $file = shift;
  my $type = shift;

  $mp3 = MP3::Tag->new($file);
  $mp3->get_tags();

  if (exists $mp3->{ID3v1})
  {
    $mp3->{ID3v1}->$type("@_");
    $mp3->{ID3v1}->write_tag();
  }
  else
  {
    $mp3->new_tag("ID3v1");
    $mp3->{ID3v1}->$type("@_");
    $mp3->{ID3v1}->write_tag();
  }

  $mp3->close();
}
