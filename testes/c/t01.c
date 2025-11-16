#include <stdio.h>

int a; 
int b; 
int c;

int main() {  
    a = b = c = 5;
    
    printf(" a =  %d\n", a );
    printf(" b =  %d\n", b );
    printf(" c =  %d\n", c );

    a = (b = (c = 7) * 3) + 2;
    printf("\n");
    printf(" a =  %d\n", a );
    printf(" b =  %d\n", b );
    printf(" c =  %d\n", c );

    return 0;
}

