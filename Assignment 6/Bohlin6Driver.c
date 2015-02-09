// Author: Jeff Bohlin
// Course: CPSC240
// Assignment number: 3
// Due: 2012-Mar-06
// Author's Email: jeffdbx@gmail.com
// Purpose: This is the driver for 'Bohlin6.asm'.  Very simply, it calls 'Bohlin6.asm' and then outputs the 
//          resulting return code after the program is done executing. This will serve as a generic
//          driver for all assembly projects in this class. A full description of what this program
//          accomplishes can be found in 'Bohlin6.asm'.
//
// Compile: 
//  gcc -c -m64 Bohlin6Driver.c
//
// Link:  
// [NOTE: When .cpp files are being included, you MUST link with g++ NOT gcc or it will not work!]
//
//  g++ -m64 -o Bohlin6 Bohlin6main.o Bohlin6Driver.o readArray.o writeArray.o

#include <stdio.h>
#include <stdlib.h>

extern unsigned long int mainASM();

int main()
{
    // 1 is just an arbitrary 'default' code
    unsigned long int result = 1;

    printf("\n");
    printf("%s\n", "Welcome to Jeff Bohlin's CPSC240 Assignment 6.");

    // Store the return code of mainASM() in 'result'
    result = mainASM();
    printf("%s%lu%s\n", "Have a nice day. The return code is ", result, ". Bye.\n");
    return result;
}







