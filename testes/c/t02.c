#include <stdio.h>

int a; 
int b; 
int c;

int main() {
    a = b = c = 1;  
    a += b += c += 5;
    
    printf(" a =  %d\n", a );    
    printf(" b =  %d\n", b );    
    printf(" c =  %d\n", c );    
    
    a += 1;
    b += 2;
    c += 3;

    printf("\n a =  %d\n", a );    
    printf(" b =  %d\n", b );    
    printf(" c =  %d\n", c );    
    
    return 0;
}

