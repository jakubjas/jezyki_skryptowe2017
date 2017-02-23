#!/usr/bin/perl
#Jakub Jas, grupa 2

use utf8;
no warnings 'utf8';
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0));
use PerlNumbers::Numbers qw(convert_mark_to_num);

sub trim 
{ 
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s;
}

sub horizontal_line
{
	for (my $i; $i <= 90; $i++)
	{
		print STDOUT "-";
	}

	print STDOUT "\n";
}

my @files = @ARGV;
my @avrg_global;
my $count_global = 0;

if ($#ARGV == -1)
{
	print STDERR "Proszę podać plik z listą.\n";
	exit 1;
}

foreach $file (@files)
{
	my %people;
	open FILE, '<:encoding(UTF-8)', $file
    or die "Can't open file: '$file'";

	while (<FILE>)
	{
		$line = $_;
		my @words = split(' ', $line);
		my $name = trim(ucfirst(lc($words[0])));
		my $surname = trim(ucfirst(lc($words[1])));
		my $person = "$surname $name";
		my $mark = trim($words[2]);

		if (convert_mark_to_num($mark) != 0 && $name ne '' && $surname ne '')
		{
			push @{$people{$person}}, $mark;
		}
		else
		{
			print STDERR "$line";
		}
		
	}

	close FILE;

	my $header = "";
	$header .= (" " x (90 - length("Plik: $file")));
	$header .= "Plik: $file";

	print STDOUT "\n";

	printf STDOUT "$header\n\n";

	$surname_name_h = "Nazwisko i imię";
	$marks_l_h = "Lista ocen";
	$average_h = "Średnia";
	$surname_name_h .= (" " x (40 - length($surname_name_h)));
	$marks_l_h .= (" " x (40 - length($marks_l_h)));
	$average_h .= (" " x (10 - length($average_h)));

	horizontal_line();

	print STDOUT "$surname_name_h";
	print STDOUT "$marks_l_h";
	printf STDOUT "$average_h\n";

	horizontal_line();

	foreach my $person (sort {lc $a cmp lc $b} keys %people) 
	{
		my @marks = @{$people{$person}};
		my $marks_count = @marks;
		my $sum = 0;

		foreach (@marks)
		{
			$sum = $sum + convert_mark_to_num($_);
		}

		my $average = $sum/$marks_count;
		my $marks_string = "@{$people{$person}}";
		
		$person .= (" " x (40 - length($person)));
		$marks_string .= (" " x (40 - length($marks_string)));
		$average .= (" " x (10 - length($average)));
		print STDOUT $person;
		print STDOUT "$marks_string";
		printf STDOUT ("%.2f\n", $average);

		push @avrg_global, $average;
		$count_global++;
	}

	print STDOUT "\n";
}

horizontal_line();

my $sum = 0;

foreach (@avrg_global)
{
	$sum = $sum + $_;
}

$avrg = $sum/$count_global;
$avrg_formatted = sprintf("%.2f", $avrg);

my $global_avrg = "";
$global_avrg .= (" " x (90 - length("Średnia ogółem: $avrg_formatted")));
$global_avrg .= "Średnia ogółem: $avrg_formatted";

printf STDOUT "$global_avrg\n";