#include <stdio.h>

int yyparse(void);

int main(void)
{
    #if YYDEBUG == 1
    extern int yydebug;
    yydebug = 1;
    #endif
    return(yyparse());
}

void yyerror(char *s)
{
    fprintf(stderr, "\033[0;31m[ERROR]\033[0m Exiting %s\n", s);
}