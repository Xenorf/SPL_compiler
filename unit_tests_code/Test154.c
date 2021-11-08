#include <stdio.h>
#include <stdlib.h>
int main() {
int a;
register int _by1;
for (a=-5;_by1=1,(a-(5))*((_by1 > 0) - (_by1 < 0)) <= 0; a+=_by1) {
printf("%d", a);
}
printf("\n");
return 0;
}
