%{
#ifdef PRINT
#define RETURN(typearg,token) printf(#typearg" "#token "\n")
#else
#define RETURN(typearg,token) return(token)
#endif
%}
delim        [ \t\n]
ws           {delim}+
letter       [a-zA-Z]
digit        [0-9]
character    '{letter}'
id           {letter}({letter}|{digit})*
number       {digit}+
%%
             int k;
{ws}         ;
ENDP         RETURN(keyword,ENDP);
DECLARATIONS RETURN(keyword,DECLARATIONS);
CODE         RETURN(keyword,CODE);
TYPE         RETURN(keyword,TYPE);
CHARACTER    RETURN(keyword,CHARACTER_TYPE);
INTEGER      RETURN(keyword,INTEGER_TYPE);
REAL         RETURN(keyword,REAL_TYPE);
IF           RETURN(keyword,IF);
THEN         RETURN(keyword,THEN);
ENDIF        RETURN(keyword,ENDIF);
ELSE         RETURN(keyword,ELSE);
DO           RETURN(keyword,DO);
WHILE        RETURN(keyword,WHILE);
ENDDO        RETURN(keyword,ENDDO);
ENDWHILE     RETURN(keyword,ENDWHILE);
FOR          RETURN(keyword,FOR);
IS           RETURN(keyword,IS);
BY           RETURN(keyword,BY);
TO           RETURN(keyword,TO);
ENDFOR       RETURN(keyword,ENDFOR);
WRITE        RETURN(keyword,WRITE);
NEWLINE      RETURN(keyword,NEWLINE);
READ         RETURN(keyword,READ);
NOT          RETURN(keyword,NOT);
AND          RETURN(keyword,AND);
OR           RETURN(keyword,OR);
OF           RETURN(keyword,OF);
">="         RETURN(operator,GREATER_THAN_OR_EQUAL);
"<="         RETURN(operator,LESS_THAN_OR_EQUAL);
"<>"         RETURN(operator,NOT_EQUAL);
"<"          RETURN(operator,LESS_THAN);
">"          RETURN(operator,GREATER_THAN);
"="          RETURN(operator,EQUAL);
"->"         RETURN(operator,ASSIGNEMENT);
"-"          RETURN(operator,MINUS);
"+"          RETURN(operator,PLUS);
"*"          RETURN(operator,TIMES);
"/"          RETURN(operator,DIVIDE);
"("          RETURN(separator,BRA);
")"          RETURN(separator,KET);
":"          RETURN(separator,COLON);
"."          RETURN(separator,PERIOD);
","          RETURN(separator,COMMA);
";"          RETURN(separator,SEMICOLON);
{character}  RETURN(character,CHARACTER);
{id}         RETURN(identifier,IDENTIFIER);
{number}     {
                k = atoi(yytext);
                RETURN(decimal_number,NUMBER);
                };
