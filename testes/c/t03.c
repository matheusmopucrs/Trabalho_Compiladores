#include <stdio.h>

int a; 
int b; 
int c;

int main() {  
    a = 1;
    a = a++ + ++a;
    printf(" a =  %d\n", a );    
    
    a = 1;
    a += a++ + ++a;
    printf(" a =  %d\n", a );    
    
   
    b = 10;
    c = --b + b--;
    printf(" b =  %d\n", b );    
    printf(" c =  %d\n", c );    
    
    
    return 0;
}

