%{
#ifdef PRINT
#define RETURN(typearg,token) printf(#typearg" "#token "\n");
#define RETURN_ID(typearg,token) printf("%s " #token"\n",yytext);
#define RETURN_CHAR(typearg,token) printf("%s " #token"\n",yytext);
#define RETURN_NUMBER(typearg,token) printf("%d " #token"\n",atoi(yytext));
#else
#define RETURN(typearg,token) return(token);
#define RETURN_ID(typearg,token) yylval.iVal = installId(yytext); return(token);
#define RETURN_CHAR(typearg,token) yylval.iVal = installId(yytext); return(token);
#define RETURN_NUMBER(typearg,token) if (strlen(yytext) >= strlen("2147483647")){if (strcmp("2147483647", yytext)<0) {fprintf(stderr,"\033[0;33m[WARNING]\033[0m Value of the integer is out of scope (%s)\n",yytext);}};yylval.iVal = atoi(yytext); return(token);
#endif
#ifndef PRINT
#include <string.h>
/* Declare Symbol Table Type and Array as imported types*/
extern SYMTABNODEPTR symTab[SYMTABSIZE];
extern int currentSymTabSize;
int installId(char *);
#endif
%}
delim        [ \t\n\r]
ws           {delim}+
letter       [a-zA-Z]
digit        [0-9]
character    '{letter}'
id           {letter}({letter}|{digit})*
number       {digit}+
%%
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
{character}  RETURN_CHAR(character,CHARACTER);
{id}         RETURN_ID(identifier,IDENTIFIER);
{number}     RETURN_NUMBER(decimal_number,NUMBER);
.            fprintf(stderr,"\033[0;31m[ERROR]\033[0m Unexpected symbol in the lexer %s\n",yytext);exit(1);

%%
#ifndef PRINT
/* Here is the code for the library of symbol table routines */

/* code for a simple symbol table, which is an array of pointers to
   structs, each of which contains an identifier.
*/
SYMTABNODEPTR newSymTabNode()
{
    return ((SYMTABNODEPTR)malloc(sizeof(SYMTABNODE)));
}

int lookup(char *s)
{
    extern SYMTABNODEPTR symTab[SYMTABSIZE];
    extern int currentSymTabSize;
    int i;

    for(i=0; i<currentSymTabSize; i++)
    {
        if(strncmp(s,symTab[i]->identifier,IDLENGTH) == 0)
        {
            return (i);
        }
    }
    return (-1);    
}

/* Look up an identifier in the symbol table, if its there return
   its index.  If its not there, put it in the end position,
   as long as the table isn't full, and return its index.
*/

int installId(char *id) 
{
    extern SYMTABNODEPTR symTab[SYMTABSIZE]; 
    extern int currentSymTabSize;
    int index;

    index = lookup(id);
    if (index >= 0)
    {
        return (index);
    }
    else 
       if (currentSymTabSize >= SYMTABSIZE) 
          /* SYMTAB is full */
          return (NOTHING) ;
    else
    {
       symTab[currentSymTabSize] = newSymTabNode();
	   if (symTab[currentSymTabSize] == NULL) { 
	      fprintf(stderr, "\033[0;31m[ERROR]\033[0m installId:Out of memory: %s %lu\n", id, sizeof(SYMTABNODEPTR)); 
		  return(NOTHING);
		  }
       /* Recommended code for preventing buffer overrun on bounded strings */
       strncpy(symTab[currentSymTabSize]->identifier,id,IDLENGTH);
       symTab[currentSymTabSize]->identifier[IDLENGTH-1] = '\0';
       return(currentSymTabSize++);
    }
}
#endif