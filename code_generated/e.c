#include <stdio.h>
#include <stdlib.h>
int main() {
int integer,i;
scanf(" %d", &integer);
if (integer <= 5 || integer >= 12){
printf("%d", integer);
}
printf("%d",(36 - 1));
printf("%d",(7 + 4.0));
printf("\n");
for (integer=-1;(integer-(-5))*(-1/abs(-1))<=0;integer+=-1){
printf("%d", integer);
printf("\n");
}
i = -1;
for (integer=i * i * i;(integer-(i * i * i + i + i + i + i))*(i * i * i * i * i/abs(i * i * i * i * i))<=0;integer+=i * i * i * i * i){
printf("%d", integer);
printf("\n");
}
return 0;
}
