#include <stdio.h>
int main() {
int a,b;
char c;
float d,e;
scanf(" %d", &a);
scanf(" %d", &b);
if (a > b){
printf("%s","A");
} else {
printf("%s","B");
}
printf("\n");
scanf(" %f", &d);
e = d * 2.3;
printf("%f", e);
printf("\n");
scanf(" %c", &c);
printf("%c", c);
printf("\n");
return 0;
}
