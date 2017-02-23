#!/usr/bin/perl
#Jakub Jas, grupa 2

use Scalar::Util qw(looks_like_number);
use feature 'say';

sub trim 
{ 
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s;
}

my $separator = shift;
my $start = shift;
my $end = shift;
my @files = @ARGV;

if (!looks_like_number($start) || !looks_like_number($end))
{
	if (!looks_like_number($start))
	{
		say STDERR "$start is not a number";
	}
	if (!looks_like_number($end))
	{
		say STDERR "$end is not a number";
	}
	
	exit 1;
}

foreach $file (@files)
{
	local $/=undef;
	open FILE, "$file" or die "Couldn't open file: $!";
	$string = <FILE>;
	close FILE;

	my @text_array = split($separator, $string);

	foreach $word (@text_array)
	{
		$word = trim($word);
	}

	if ($start > $end)
	{
		if ($start > $#text_array)
		{
			$start = $#text_array;
		}

		$result = join(' ', reverse @text_array[$end..$start]);
	}
	else
	{
		if ($end > $#text_array)
		{
			$end = $#text_array;
		}

		$result = join(' ', @text_array[$start..$end]);
	}

	say $result;
}