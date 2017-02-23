#!/usr/bin/perl
#Jakub Jas, grupa 2

use Getopt::Long;
use v5.10;
use Data::Dumper;

my $h;
my $c;
my $n;
my $p;

GetOptions(
    'h' => \$h,
    'c' => \$c,
    'n' => \$n,
    'p' => \$p
) or die "Usage: $0 -h -c -n -p <files>\n-h:\tskip comments but count the lines\n-c:\tprint all and number the lines\n-n:\tnumber only the visible lines\n-p:\tnumber all files separately\n";

if ($#ARGV == -1)
{
	print "Usage: $0 -h -c -n -p <files>\n-h:\tskip comments but count the lines\n-c:\tprint all and number the lines\n-n:\tnumber only the visible lines\n-p:\tnumber all files separately\n";
}
else
{
	if (!$h && !$c && !$n && !$p)
	{
		foreach $i (0 .. $#ARGV) 
		{
			open(FILE,$ARGV[$i]);
			while (<FILE>) 
			{
				print;
			}
			close FILE;
		}
	}
	elsif ( ($h && !$c && !$n && !$p) || ($h && $c && !$n && !$p) )
	{
		my $count = 0;
		foreach $i (0 .. $#ARGV) 
		{
			open(FILE,$ARGV[$i]);
			while (<FILE>)
			{
				$count++;
				next if /^\s*#/;
				print "$count: $_"
			}
			close FILE;
		}
	}
	elsif (!$h && $c && !$n && !$p)
	{
		my $count = 0;
		foreach $i (0 .. $#ARGV) 
		{
			open(FILE,$ARGV[$i]);
			while (<FILE>)
			{
				$count++;
				print "$count: $_"
			}
			close FILE;
		}
	}
	elsif (!$h && !$c && $n && !$p)
	{
		my $count = 0;

		foreach $i (0 .. $#ARGV) 
		{
			open(FILE,$ARGV[$i]);
			while (<FILE>)
			{
				next if /^\s*#/;
				$count++;
				print "$count: $_"
			}
			close FILE;
		}
	}
	elsif (!$h && !$c && !$n && $p)
	{
		foreach $i (0 .. $#ARGV) 
		{
			open(FILE,$ARGV[$i]);
			my $count = 0;
			while (<FILE>)
			{
				$count++;
				print "$count: $_"
			}
			close FILE;
		}
	}
	else
	{
		print "Usage: $0 -h -c -n -p <files>\n-h:\tskip comments but count the lines\n-c:\tprint all and number the lines\n-n:\tnumber only the visible lines\n-p:\tnumber all files separately\n";
	}
}

