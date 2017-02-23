#!/usr/bin/perl
#Jakub Jas, grupa 2

use Scalar::Util qw(looks_like_number);
use feature 'say';

my $first_word = shift;
my $second_word = shift;
my @files = @ARGV;

if (!looks_like_number($first_word) || !looks_like_number($second_word))
{
	if (!looks_like_number($first_word))
	{
		say STDERR "$first_word is not a number";
	}
	if (!looks_like_number($second_word))
	{
		say STDERR "$second_word is not a number";
	}
	
	exit 1;
}

foreach $file (@files)
{
	local $/=undef;
	open FILE, "$file" or die "Couldn't open file: $!";
	$string = <FILE>;
	close FILE;

	my @text_array = split(' ', $string);

	if ($text_array[$first_word] ne '')
	{
		say $text_array[$first_word];
	}
	else
	{
		say STDERR "Error reading word number $first_word";
	}

	if ($text_array[$second_word] ne '')
	{
		say $text_array[$second_word];
	}
	else
	{
		say STDERR "Error reading word number $second_word";
	}
}