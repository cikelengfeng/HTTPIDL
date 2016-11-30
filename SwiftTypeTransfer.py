idl_to_swift_type = { 'INT32': 'Int32', 'INT64': 'Int64', 'FLOAT': 'Float', 'STRING': 'String', 'FILE': 'MultipartFile', 'STREAM': 'InputStream'}


def swift_base_type_name_from_idl_base_type(type_name):
    if type_name in idl_to_swift_type:
        builtin_type_name = idl_to_swift_type[type_name]
        return builtin_type_name
    return type_name


def swift_type_name(idl_param_type_context):
    base_type = idl_param_type_context.baseType()
    if base_type is not None:
        return swift_base_type_name(base_type)
    else:
        generic_type = idl_param_type_context.genericType()
        dict_type = generic_type.dictGenericParam()
        if dict_type is not None:
            return swift_dict_type_name(dict_type)
        else:
            array_type = generic_type.arrayGenericParam()
            return swift_array_type_name(array_type)


def swift_base_type_name(base_type_context):
    struct_name = base_type_context.structName()
    if struct_name is not None:
        return struct_name.getText()
    else:
        return idl_to_swift_type[base_type_context.getText()]


def swift_dict_type_name(dict_param_context):
    key_type = swift_base_type_name_from_idl_base_type(dict_param_context.baseType()[0].getText())
    value_type = swift_base_type_name_from_idl_base_type(dict_param_context.baseType()[1].getText())
    return '[' + key_type + ': ' + value_type + ']'


def swift_array_type_name(array_param_context):
    element_type = swift_base_type_name_from_idl_base_type(array_param_context.baseType().getText())
    return '[' + element_type + ']'