grammar csv;

program
    : stat* EOF
    ;

stat
    : (TEXT SEP)* TEXT NEWLINE?
    | NEWLINE
    ;

TEXT: [a-zA-Z0-9]+;
SEP: ',';
NEWLINE: [\r\n]+;
WS: [ \t]+ -> skip;
COMMENT: '#' ~[\r\n]* -> skip;


