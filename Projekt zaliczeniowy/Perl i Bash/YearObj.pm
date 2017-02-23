#!/usr/bin/perl
#Jakub Jas, grupa 2

package YearObj;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(new getTrackNum getTrackArtist getTrackTitle getTrackAlbum);

sub new
{
  my $class = shift;
  my $self = {
    _trackNum => shift,
    _trackArtist => shift,
    _trackTitle => shift,
    _trackAlbum => shift
  };
  bless $self, $class;
  return $self;
}

sub getTrackNum
{
  my ($self) = @_;
  return $self->{_trackNum};
}

sub getTrackArtist
{
  my ($self) = @_;
  return $self->{_trackArtist};
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

1;
