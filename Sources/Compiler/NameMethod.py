def underline_to_upper_camel_case(str):
    return ''.join(map(upper_first_letter, str.split('_')))

def underline_to_lower_camel_case(str):
    return lower_first_letter(''.join(map(upper_first_letter, str.split('_'))))

def upper_first_letter(str):
    return str[0].upper() + str[1:]

def lower_first_letter(str):
    return str[0].lower() + str[1:]

