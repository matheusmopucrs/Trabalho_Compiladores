#include <stdio.h>

int i;
int j;

int main() {
   i = 0;
   
   while (1) {
        
        printf("\n>i =  %d\n", i); 
        
        if (i>3) break;
         
        j = 0;
        while (j<=6) {
           j++;
           if (j < 2 || j > 4) continue;
           printf(" j =  %d\n", j );    
        }
        
        i++;
    }
    
    return 0;
 } 

