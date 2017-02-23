#!/var/bin/python
# Jakub Jas, grupa 2

# Numbers module

import re


def check_int_number(num):
    pattern_1 = r"^\d+[-+]?$"
    pattern_2 = r"^[-+]?\d+$"

    if re.match(pattern_1, str(num)) or re.match(pattern_2, str(num)):
        sign_l = num[:1]
        sign_r = num[-1:]

        if sign_l == '-':
            return_value = num[1:]
            if 2 <= float(return_value) <= 5:
                return True
        elif sign_r == '-':
            return_value = num[:1]
            if 2 <= float(return_value) <= 5:
                return True
        elif sign_l == '+':
            return_value = num[1:]
            if 2 <= float(return_value) <= 5:
                return True
        elif sign_r == '+':
            return_value = num[:1]
            if 2 <= float(return_value) <= 5:
                return True
        else:
            if 2 <= float(num) <= 5:
                return True
    else:
        return False


def check_float_number(num):
    pattern = r"^[-+]?(?:[0-9]+(?:\.[0-9]*)?|\.[0-9]+)(?:[eE|dD|qQ|\^][-+]?[0-9]+)?$"

    if re.match(pattern, str(num)):
        if 2 <= float(num) <= 5:
            return True
        else:
            return False
    else:
        return False


def convert_mark_to_num(mark):
    if check_int_number(mark):
        sign_l = mark[:1]
        sign_r = mark[-1:]

        if sign_l == '-':
            return_value = float(mark[1:])
            return return_value-0.25
        elif sign_r == '-':
            return_value = float(mark[:1])
            return return_value-0.25
        elif sign_l == '+':
            return_value = float(mark[1:])
            return return_value+0.25
        elif sign_r == '+':
            return_value = float(mark[:1])
            return return_value+0.25
        else:
            return float(mark)

    elif check_float_number(mark):
        return float(mark)

    else:
        return 0
