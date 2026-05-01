grammar BigIntCalc;

program
    : stat* EOF
    ;

stat
    : display_expr NEWLINE
    | assignment NEWLINE
    | NEWLINE
    ;

display_expr
    : DISPLAY expr ';'
    ;

assignment
    : ID '<=' expr ';'
    ;

expr
    : op=('+'|'-') expr                #unaryExpr
    | expr op=('*'|'/'|'%') expr       #mulDivModExpr
    | expr op=('+'|'-') expr           #addSubExpr
    | '(' expr ')'                     #parenExpr
    | NUM                              #numExpr
    | ID                               #idExpr
    ;

DISPLAY : 'display';
NUM : [0-9]+;
ID : [a-z]+;
NEWLINE : [\r\n]+;
WS : [ \t]+ -> skip;
COMMENT : '--' ~[\r\n]* -> skip;
