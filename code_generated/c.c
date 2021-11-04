#include <stdio.h>
#include <stdlib.h>
int main()
{
    int a;
    for (a = 1; (a - 13) * (1 / abs(1)) <= 0; a += 1)
    {
        if (!(a == 7))
        {
            printf("%d", a);
            printf("\n");
        }
    }
    a = 0;
    do
    {
        a = a + 1;
        if (!(a == 6 && a != 8))
        {
            printf("%d", a);
            printf("\n");
        }
    } while (a < 14);
    a = 0;
    while (a < 12)
    {
        printf("%d", a);
        a = a + 1;
    }
    printf("\n");
    return 0;
}
