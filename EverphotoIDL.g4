parser grammar EverphotoIDL;

options {
    tokenVocab = EverphotoIDLLexer;
}

entry
    :
    ( message
    | struct
    )*
    | EOF
    ;

message
    :
    MESSAGE uri LCURLY
        ( request
        | response
        )*
        RCURLY
    ;

struct
    : STRUCT structName structBody
    ;

request
    :
    method REQUEST structBody
    ;

response
    :
    method RESPONSE structBody
    ;

method
    : GET
    | POST
    | DELETE
    | PUT
    | PATCH
    ;

uri
    :
    ( BACKSLASH  uriPathComponent
    )*
    ;

uriPathComponent
    : ( identifier
      | parameterInUri
      )
    ;

structBody
    :
    LCURLY parameterMap* RCURLY
    ;

parameterInUri
    :
    DOLLAR identifier
    ;

parameterMap
    :
    paramType key ASSIGN paramType? value SEMICOLON
    ;

paramType
    : genericType
    | baseType
    ;

genericType
    : (ARRAY arrayGenericParam)
    | (DICT dictGenericParam)
    ;

arrayGenericParam
    : LABRACKET baseType RABRACKET
    ;

dictGenericParam
    : LABRACKET baseType COMMA baseType RABRACKET
    ;

baseType
    : INT32
    | INT64
    | DOUBLE
    | STRING
    | FILE
    | BLOB
    | structName
    ;

key:
    identifier
    ;

value:
    identifier
    ;

structName:
    identifier
    ;

identifier
    :  IDENT
    ;
