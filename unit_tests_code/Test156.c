#include <stdio.h>
#include <stdlib.h>
int main() {
float a;
register int _by1;
for (a=0.1;_by1=0.1,(a-(0.5))*((_by1 > 0) - (_by1 < 0)) <= 0; a+=_by1) {
printf("%f", a);
printf("\n");
}
printf("\n");
return 0;
}
