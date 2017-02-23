#Jakub Jas, grupa 2

package PerlNumbers::Integer;
use Exporter qw(import);
our @EXPORT_OK = qw(check_if_integer);

sub check_if_integer
{
	my ($value) = @_;

	if ($value =~ /^\d+$/)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}