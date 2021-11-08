#include <stdio.h>
#include <stdlib.h>
int main() {
char a;
register int _by1;
for (a='a';_by1=1,(a-('g'))*((_by1 > 0) - (_by1 < 0)) <= 0; a+=_by1) {
printf("%c", a);
}
printf("\n");
return 0;
}
