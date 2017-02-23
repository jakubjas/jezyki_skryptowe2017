#!/var/bin/python
# Jakub Jas, grupa 2

# Numbers module

import re


def check_if_integer(num):
    integer_pattern = r"^\d+$"
    if re.match(integer_pattern, str(num)):
        return True
    else:
        return False


def check_if_valid_number(num):
    float_pattern = r"[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE|dD|qQ|\^][-+]?[0-9]+)?$"
    if re.match(float_pattern, str(num)):
        return True
    else:
        return False
