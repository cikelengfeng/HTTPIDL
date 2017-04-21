parser grammar HTTPIDL;

options {
    tokenVocab = HTTPIDLLexer;
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
    MESSAGE messageName? uri LCURLY
        ( request
        | response
        )*
        RCURLY
    ;

messageName
    : LABRACKET identifier RABRACKET
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
    | HEAD
    | TRACE
    | CONNECT
    | OPTIONS
    ;

uri
    :
    ( BACKSLASH  uriPathComponent
    )*
    ;

uriPathComponent
    : parameterInUri
    | string
    ;

parameterInUri
    :
    DOLLAR identifier
    ;

string
    : stringElement+
    ;

stringElement
    : MESSAGE
    | STRUCT
    | GET
    | HEAD
    | TRACE
    | CONNECT
    | OPTIONS
    | POST
    | PUT
    | PATCH
    | DELETE
    | REQUEST
    | RESPONSE
    | RCURLY
    | DOLLAR
    | LABRACKET
    | RABRACKET
    | COMMA
    | INT32
    | UINT32
    | INT64
    | UINT64
    | BOOL
    | DOUBLE
    | STRING
    | FILE
    | BLOB
    | ARRAY
    | DICT
    | COMMENT
    | IDENT
    | escaped
    | ANYCHAR
    ;

escaped
    : SLASH
    (
     BACKSLASH
    | LCURLY
    | RCURLY
    | DOLLAR
    | LABRACKET
    | RABRACKET
    | COMMA
    | ASSIGN
    | SEMICOLON
    | SLASH
    )
    ;

structBody
    :
    LCURLY parameterMap* RCURLY
    ;

parameterMap
    :
    paramType key (ASSIGN value)? SEMICOLON
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
    : LABRACKET paramType RABRACKET
    ;

dictGenericParam
    : LABRACKET baseType COMMA paramType RABRACKET
    ;

baseType
    : INT32
    | UINT32
    | INT64
    | UINT64
    | BOOL
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
    string
    ;

structName:
    identifier
    ;

identifier
    :  IDENT
    ;
