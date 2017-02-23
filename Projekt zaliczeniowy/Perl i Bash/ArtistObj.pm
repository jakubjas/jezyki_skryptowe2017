#!/usr/bin/perl
#Jakub Jas, grupa 2

package ArtistObj;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(new getTrackNum getTrackTitle getTrackAlbum getTrackYear);

sub new
{
  my $class = shift;
  my $self = {
    _trackNum => shift,
    _trackTitle => shift,
    _trackAlbum => shift,
    _trackYear => shift
  };
  bless $self, $class;
  return $self;
}

sub getTrackNum
{
  my ($self) = @_;
  return $self->{_trackNum};
}

sub getTrackTitle
{
  my ($self) = @_;
  return $self->{_trackTitle};
}

sub getTrackAlbum
{
  my ($self) = @_;
  return $self->{_trackAlbum};
}

sub getTrackYear
{
  my ($self) = @_;
  return $self->{_trackYear};
}

1;
