%{
void yyerror(char *s);
int yylex(void);
%}
%token ENDP DECLARATIONS CODE TYPE CHARACTER_TYPE INTEGER_TYPE REAL_TYPE IF THEN ENDIF ELSE DO WHILE ENDDO ENDWHILE FOR IS BY TO ENDFOR WRITE NEWLINE READ NOT AND OR OF GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL NOT_EQUAL LESS_THAN GREATER_THAN EQUAL ASSIGNEMENT MINUS PLUS TIMES DIVIDE BRA KET COLON PERIOD COMMA SEMICOLON IDENTIFIER NUMBER CHARACTER
%%
program : identifier COLON block ENDP identifier PERIOD
    ;
block : DECLARATIONS declaration_block CODE statement_list | CODE statement_list
    ;
declaration_block : identifier_list OF TYPE type SEMICOLON | identifier_list OF TYPE type SEMICOLON declaration_block
    ;
identifier_list : identifier | identifier_list COMMA identifier
    ;
type : CHARACTER_TYPE | INTEGER_TYPE | REAL_TYPE
    ;
statement_list : statement | statement_list SEMICOLON statement
    ;
statement : assignment_statement | if_statement | do_statement | while_statement | for_statement | write_statement | read_statement
    ;
assignment_statement : expression ASSIGNEMENT identifier
    ;
if_statement : IF conditional THEN statement_list ENDIF
				| IF conditional THEN statement_list ELSE statement_list ENDIF
    ;
do_statement : DO statement_list WHILE conditional ENDDO
    ;
while_statement : WHILE conditional DO statement_list ENDWHILE
    ;
for_statement : FOR identifier IS expression BY expression TO expression DO statement_list ENDFOR
    ;
write_statement : WRITE BRA output_list KET | NEWLINE
    ;
read_statement : READ BRA identifier KET
    ;
output_list : value | output_list COMMA value
    ;
conditional : NOT conditional | expression comparator expression AND conditional | expression comparator expression OR conditional | expression comparator expression
    ;
comparator : EQUAL | NOT_EQUAL | LESS_THAN | GREATER_THAN | GREATER_THAN_OR_EQUAL | LESS_THAN_OR_EQUAL
    ;
expression : term | expression PLUS term | expression MINUS term 
    ;
term : value | term TIMES value | term DIVIDE value  
    ;
value : identifier | constant | BRA expression KET
    ;
constant : character_constant | number_constant
    ;
character_constant : CHARACTER
    ;
number_constant : MINUS integer | MINUS integer PERIOD integer | integer PERIOD integer | integer
    ;
integer : integer number | number
    ;
identifier : IDENTIFIER
    ;
number : NUMBER
    ;
%%
#include "lex.yy.c"