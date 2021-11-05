#include <stdio.h>
#include <stdlib.h>
int main() {
int a;
register int _by;
for (a=1;_by=1,(a-(13))*((_by > 0) - (_by < 0)) <= 0; a+=_by) {
if (!(a == 7)){
printf("%d", a);
printf("\n");
}
}
a = 0;
do {
a = a+1;
if (!(a == 6 && a != 8)){
printf("%d", a);
printf("\n");
}
} while (a < 14);
a = 0;
while (a < 12){
printf("%d", a);
a = a+1;
}
printf("\n");
return 0;
}
