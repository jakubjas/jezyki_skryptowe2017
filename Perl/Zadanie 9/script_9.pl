#!/usr/bin/perl
#Jakub Jas, grupa 2

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0));
use PerlNumbers::Float qw(check_if_valid_number);
use PerlNumbers::Integer qw(check_if_integer);
use Getopt::Long;
use feature 'say';

my ($c, $l, $m, $w, $d, $i, $e);
my $no_options = 0;

GetOptions(
    'c' => sub { $c = 1; $m = 0 },
    'l' => \$l,
    'm' => sub { $m = 1; $c = 0 },
    'w' => \$w,
    'd' => \$d,
    'i' => \$i,
    'e' => \$e
) or die "Usage: $0 -c -l -m -w -d -i -e <files>
-c:\tThe number of bytes in each input file is written to the standard output. This will cancel out any prior usage of the -m option.
-l:\tThe number of lines in each input file is written to the standard output.
-m:\tThe number of characters in each input file is written to the standard output. This will cancel out any prior usage of the -c option.
-w:\tThe number of words in each input file is written to the standard output.
-d:\tThe number of numeric values in each input file is written to the standard output.
-i:\tThe number of integers in each input file is written to the standard output.
-e:\tIgnore lines starting with #\n";

if (!$c && !$l && !$m && !$w && !$d && !$i && !$e)
{
    $no_options = 1;
}

if ($#ARGV == -1)
{
    if ($no_options)
    {
        $m = 1;
        $l = 1;
        $w = 1;
    }

    my ($lines, $words, $chars, $numbers, $integers) = (0,0,0,0,0);
    my @input;

    while (<>) 
    {
        push @input, $_;
        last if eof STDIN;
    }

    foreach $line (@input)
    {
        if ($e)
        {
            if ($line =~ /^\s*#/)
            {
                next;
            }
        }

        @elements = split(' ', $line);

        if ($l)
        {
            $lines++; 
        }
        
        if ($m)
        {
            $chars += length($line); 
        }
        
        if ($w)
        {
            $words += scalar(@elements); 
        }
        
        foreach $word (@elements)
        {
            if (check_if_valid_number($word))
            {
                if ( (check_if_integer($word)) && $i )
                {
                    $integers++;
                }

                if ($d)
                {
                   $numbers++; 
                }
            }
        }
    }

    print STDOUT "\n\n";

    if ($l)
    {
        printf STDOUT ("%10s ", "Lines");
    }

    if ($w)
    {
        printf STDOUT ("%10s ", "Words");
    }

    if ($m)
    {
        printf STDOUT ("%10s ", "Chars");
    }

    if ($d)
    {
        printf STDOUT ("%10s ", "Numbers");
    }

    if ($i)
    {
        printf STDOUT ("%10s ", "Integers");
    }

    print STDOUT "\n";

    if ($l)
    {
        printf STDOUT ("%10s ", $lines);
    }

    if ($w)
    {
        printf STDOUT ("%10s ", $words);
    }

    if ($m)
    {
        printf STDOUT ("%10s ", $chars);
    }

    if ($d)
    {
        printf STDOUT ("%10s ", $numbers);
    }

    if ($i)
    {
        printf STDOUT ("%10s ", $integers);
    }

    print STDOUT "\n";
}
else 
{
    my $header_printed = 0;
    my ($global_lines, $global_words, $global_chars, $global_numbers, $global_integers, $global_bytes) = (0,0,0,0,0,0);

    if ($no_options)
    {
        $c = 1;
        $l = 1;
        $w = 1;
    }

    for my $file (@ARGV) 
    {
        open(FILE, $file) or die "Could not open file: $!";

        if (!$header_printed)
        {
            if ($l)
            {
                printf STDOUT ("%10s ", "Lines");
            }

            if ($w)
            {
                printf STDOUT ("%10s ", "Words");
            }

            if ($m)
            {
                printf STDOUT ("%10s ", "Chars");
            }

            if ($d)
            {
                printf STDOUT ("%10s ", "Numbers");
            }

            if ($i)
            {
                printf STDOUT ("%10s ", "Integers");
            }

            if ($c)
            {
                printf STDOUT ("%10s ", "Bytes");
            }

            printf STDOUT ("\n");

            $header_printed = 1;
        }

        my ($lines, $words, $chars, $numbers, $integers, $bytes) = (0,0,0,0,0,0);
        
        if ($c)
        {
            $bytes = -s $file;
            $global_bytes += $bytes;
        }

        while (<FILE>) 
        {
            if ($e)
            {
                next if /^\s*#/;
            }

            @elements = split(' ', $_);

            if ($l)
            {
                $lines++;
                $global_lines++;
            }
            
            if ($m)
            {
                $chars += length($_); 
                $global_chars += length($_);
            }
            
            if ($w)
            {
                $words += scalar(@elements);
                $global_words += scalar(@elements);
            }
            
            foreach $word (@elements)
            {
                if (check_if_valid_number($word))
                {
                    if ( (check_if_integer($word)) && $i )
                    {
                        $integers++;
                        $global_integers++;
                    }

                    if ($d)
                    {
                       $numbers++;
                       $global_numbers++;
                    }
                }
            }
        }

        if ($l)
        {
            printf STDOUT ("%10s ", $lines);
        }

        if ($w)
        {
            printf STDOUT ("%10s ", $words);
        }

        if ($m)
        {
            printf STDOUT ("%10s ", $chars);
        }

        if ($d)
        {
            printf STDOUT ("%10s ", $numbers);
        }

        if ($i)
        {
            printf STDOUT ("%10s ", $integers);
        }

        if ($c)
        {
            printf STDOUT ("%10s ", $bytes);
        }

        printf STDOUT ("%s \n", $file);

        close FILE;
    }

    if ($#ARGV != 0)
    {
        if ($l)
        {
            printf STDOUT ("%10s ", $global_lines);
        }

        if ($w)
        {
            printf STDOUT ("%10s ", $global_words);
        }

        if ($m)
        {
            printf STDOUT ("%10s ", $global_chars);
        }

        if ($d)
        {
            printf STDOUT ("%10s ", $global_numbers);
        }

        if ($i)
        {
            printf STDOUT ("%10s ", $global_integers);
        }

        if ($c)
        {
            printf STDOUT ("%10s ", $global_bytes);
        }

        print STDOUT ("total \n");
    }
}