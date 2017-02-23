#Jakub Jas, grupa 2

package PerlNumbers::Float;
use Exporter qw(import);
our @EXPORT_OK = qw(check_if_valid_number);

sub check_if_valid_number
{
	my ($value) = @_;

	if ($value =~ /^[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE|dD|qQ|\^][-+]?[0-9]+)?$/)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}