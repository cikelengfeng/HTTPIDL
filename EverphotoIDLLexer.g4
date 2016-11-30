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

POST
    : 'POST'
    ;

PUT
    : 'PUT'
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

FLOAT
    : 'FLOAT'
    ;

STRING
    : 'STRING'
    ;

FILE
    : 'FILE'
    ;

STREAM
    : 'STREAM'
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

