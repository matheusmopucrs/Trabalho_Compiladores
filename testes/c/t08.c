#include <stdio.h>

int num;


int main() {
   do {
    		printf("Informe um numero <= 0:\n");
    		scanf("%d", &num);
    		printf("Valor lido: %d\n", num);
   } while ( num > 0 );        
 }

