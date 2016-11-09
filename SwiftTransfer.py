idl_to_swift_type = { 'INT32': 'Int', 'INT64': 'Int64', 'FLOAT': 'Float', 'STRING': 'String', 'FILE': 'URL', 'BLOB': 'Data'}

def swift_array_type_name(genericType):
    return '[' + idl_to_swift_type[genericType] + ']'

def swift_dict_type_name(keyGenericType, valueGenericType):
    return '[' + idl_to_swift_type[keyGenericType] + ':' + idl_to_swift_type[valueGenericType] + ']'