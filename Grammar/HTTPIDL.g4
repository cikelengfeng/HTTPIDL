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
    : LPAREN identifier RPAREN
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
    ( SLASH  uriPathComponent
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
    | LPAREN
    | RPAREN
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
    : ESCAPE
    (
     SLASH
    | LCURLY
    | RCURLY
    | DOLLAR
    | LABRACKET
    | RABRACKET
    | LPAREN
    | RPAREN
    | COMMA
    | ASSIGN
    | SEMICOLON
    | ESCAPE
    )
    ;

structBody
    :
    LCURLY (singleParameter? | parameterMap*) RCURLY
    ;

singleParameter
    :
    paramType SEMICOLON
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
