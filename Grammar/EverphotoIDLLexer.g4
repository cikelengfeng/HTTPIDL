lexer grammar EverphotoIDLLexer;

MESSAGE
    : 'MESSAGE'
    ;

STRUCT
    : 'STRUCT'
    ;

GET
    : 'GET'
    ;

HEAD
    : 'HEAD'
    ;

TRACE
    : 'TRACE'
    ;

CONNECT
    : 'CONNECT'
    ;

OPTIONS
    : 'OPTIONS'
    ;

POST
    : 'POST'
    ;

PUT
    : 'PUT'
    ;

PATCH
    : 'PATCH'
    ;

DELETE
    : 'DELETE'
    ;

REQUEST
    : 'REQUEST'
    ;

RESPONSE
    : 'RESPONSE'
    ;

BACKSLASH
    : '/'
    ;

LCURLY
    : '{'
    ;

RCURLY
    : '}'
    ;

DOLLAR
    : '$'
    ;

LABRACKET
    : '<'
    ;

RABRACKET
    : '>'
    ;

COMMA
    : ','
    ;

ASSIGN
    : '='
    ;

INT32
    : 'INT32'
    ;

INT64
    : 'INT64'
    ;

BOOL
    : 'BOOL'
    ;

DOUBLE
    : 'DOUBLE'
    ;

STRING
    : 'STRING'
    ;

FILE
    : 'FILE'
    ;

BLOB
    : 'BLOB'
    ;

ARRAY
    : 'ARRAY'
    ;

DICT
    : 'DICT'
    ;

SEMICOLON
    : ';'
    ;
COMMENT
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;
NL
    : '\r'? '\n' -> channel(HIDDEN)
    ;
WS
    : [ \t]+ -> channel(HIDDEN)
    ;

IDENT
    :   (ALPHA | UNDERSCORE) (ALPHA | DIGIT | UNDERSCORE)*
    ;

fragment ALPHA
    : [a-zA-Z]
    ;
fragment DIGIT
    : [0-9]
    ;

fragment UNDERSCORE
    : '_'
    ;

