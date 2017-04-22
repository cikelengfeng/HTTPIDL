lexer grammar HTTPIDLLexer;

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

SLASH
    : '/'
    ;

LCURLY
    : '{'
    ;

RCURLY
    : '}'
    ;

LPAREN
    : '('
    ;

RPAREN
    : ')'
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

SEMICOLON
    : ';'
    ;

ESCAPE
    : '\\'
    ;

INT32
    : 'INT32'
    ;

UINT32
    : 'UINT32'
    ;

INT64
    : 'INT64'
    ;

UINT64
    : 'UINT64'
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

ANYCHAR
    : .
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

