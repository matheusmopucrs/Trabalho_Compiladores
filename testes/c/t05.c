#include <stdio.h>

int i;
int j;

int main() {
   
   printf("> teste for 01\n"); 
   for (i=1;i<=5;i++)
        printf(" i =  %d\n", i); 
   
   printf("\n> teste for 02\n");
   i = 10;
   for (;i<=13;) {
        printf(" i =  %d\n", i); 
        i++;
   }
        
   printf("\n> teste for 03\n");
   i = 100;
   for (;;) {
        i++;
        if (i<105) continue;
        if (i>110) break;
        printf(" i =  %d\n", i); 
   }   
   
   printf("\n> teste for 04\n");
   for (i=1; i<=3;i++) 
       for (j=1; j<=3;j++) 
           printf(" i*j =  %d\n", i*j); 
        
   printf("\n> teste for 05\n");
   for (i=1; i<=3;i+=1) 
       for (j=1; j<=3;j+=1) 
           printf(" i*j =  %d\n", i*j); 

   printf("\n> Have a nice day!\n");

   return 0;
 } 

