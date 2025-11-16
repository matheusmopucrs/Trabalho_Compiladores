#include <stdio.h>

int a; 
int b; 
int c;
int ma;
int me;

int main() {  
    a = b = c = 10;

    ++b;
    c--;

    me = a<=b && a<=c ? a : b <= c ? b : c; 
    ma = a>=b && a>=c ? a : b >= c ? b : c;    

    printf (" a = %d\n", a );
    printf (" b = %d\n", b );
    printf (" c = %d\n", c );
    printf (" me = %d\n", me );
    printf (" ma = %d\n", ma );

}

