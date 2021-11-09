#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main()
{
    char *yytext = "-2147483648";
    if (strlen(yytext) >= strlen("2147483647") && !strpbrk(yytext,"-")){if (strcmp("2147483647", yytext) < 0){
fprintf(stderr,"\033[0;33m[WARNING]\033[0m Value of the number is too big (%s)\n",yytext);}
} else if(strlen(yytext) >= strlen("-2147483647")) {
if (strcmp("-2147483647", yytext) < 0)
{
            fprintf(stderr,"\033[0;33m[WARNING]\033[0m Value of the number is too small (%s)\n",yytext);
        }
    }
    return 0;
}
