#include <stdio.h>
#include <stdlib.h>
int main() {
int a,b;
char c;
float d,e;
scanf(" %d", &a);
scanf(" %d", &b);
if (a > b){
printf("%c",'A');
} else {
printf("%c",'B');
}
printf("\n");
scanf(" %f", &d);
e = 450;
e = d*2.3;
printf("%f", e);
printf("\n");
scanf(" %c", &c);
printf("%c", c);
printf("\n");
return 0;
}
