#include <stdio.h>
#include <stdlib.h>
int main() {
int a;
a = 1;
do {
printf("%d", a);
a = a+1;
} while (a <= 0);
printf("\n");
return 0;
}
