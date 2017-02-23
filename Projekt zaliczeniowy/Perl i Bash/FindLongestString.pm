#!/usr/bin/perl
#Jakub Jas, grupa 2

package FindLongestString;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(find_longest_string);

sub find_longest_string
{
    my $max = -1;
    my @array = @{$_[0]};

    foreach (@array)
    {
        if (length > $max)
        {
            $max = length;
        }
    }

    return $max;
}
