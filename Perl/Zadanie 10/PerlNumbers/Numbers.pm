#Jakub Jas, grupa 2

package PerlNumbers::Numbers;
use Exporter qw(import);
our @EXPORT_OK = qw(check_int_number check_float_number convert_mark_to_num);

sub check_int_number
{
	my ($value) = @_;

	if ($value =~ /^\d+[-+]?$/ || $value =~ /^[-+]?\d+$/)
	{
		my $sign_l = substr $value, 0, 1;
		my $sign_r = substr $value, -1, 1;

		if ($sign_l eq '-')
		{
			my $return_value = substr $value, 1;
			if ($return_value >= 2 && $return_value <= 5)
			{
				return 1;
			}
		}
		elsif ($sign_r eq '-')
		{
			my $return_value = substr $value, 0, length($value-1);
			if ($return_value >= 2 && $return_value <= 5)
			{
				return 1;
			}
		}
		elsif ($sign_l eq '+')
		{
			my $return_value = substr $value, 1;
			if ($return_value >= 2 && $return_value <= 5)
			{
				return 1;
			}
		}
		elsif ($sign_r eq '+')
		{
			my $return_value = substr $value, 0, length($value-1);
			if ($return_value >= 2 && $return_value <= 5)
			{
				return 1;
			}
		}
		else
		{
			if ($return_value >= 2 && $return_value <= 5)
			{
				return 1;
			}
		}
	}
	else
	{
		return 0;
	}
}

sub check_float_number
{
	my ($value) = @_;

	if ($value =~ /^[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE|dD|qQ|\^][-+]?[0-9]+)?$/)
	{
		if ($value >= 2 && $value <= 5)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}
}

sub convert_mark_to_num
{
	my ($value) = @_;

	if (check_int_number($value))
	{
		my $sign_l = substr $value, 0, 1;
		my $sign_r = substr $value, -1, 1;

		if ($sign_l eq '-')
		{
			my $return_value = substr $value, 1;
			return $return_value-0.25;
		}
		elsif ($sign_r eq '-')
		{
			my $return_value = substr $value, 0, length($value-1);
			return $return_value-0.25;
		}
		elsif ($sign_l eq '+')
		{
			my $return_value = substr $value, 1;
			return $return_value+0.25;
		}
		elsif ($sign_r eq '+')
		{
			my $return_value = substr $value, 0, length($value-1);
			return $return_value+0.25;
		}
		else
		{
			return $value;
		}
	}
	elsif (check_float_number($value))
	{
		return $value;
	}
	else
	{
		return 0;
	}
}