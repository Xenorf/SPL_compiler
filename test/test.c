#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char** Isolateterms(char src[], char *arithmetic_terms[])
{
    
    int toknum = 0, i = 0;
    const char delimiters[] = "+*-/()";
    printf("%s\n",src);
    char *token = strtok(src, delimiters);
    while (token != NULL)
    {
        arithmetic_terms[i] = malloc(strlen(token) + 1);
        strcpy(arithmetic_terms[i], token);
        printf("%d: [%s]\n", ++toknum, token);
        token = strtok(NULL, delimiters);
        i+=1;
    }
    return arithmetic_terms;
}

int main(void)
{
    char* arithmetic_terms[10];
    char src[] = "e+(toto)-5/8";
    printf("%s\n",Isolateterms(src, arithmetic_terms)[1]);
    return 0;
}
