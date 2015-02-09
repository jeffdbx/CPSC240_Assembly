// Author: Jeff Bohlin
// Course: CPSC240
// Assignment number: 2
// Due: 2012-Feb-21
// Author's Email: jeffdbx@gmail.com
// Purpose: This is the driver for 'main.asm'.  Very simply, it calls 'main.asm' and then outputs the 
//          resulting return code after the program is done executing. This will serve as a generic
//          driver for all assembly projects in this class. A full description of what this program
//          accomplishes can be found in 'main.asm'.

#include <stdio.h>
#include <stdlib.h>

// Compile: 
//  gcc -c -m64 Bohlin2Driver.c
//
// Link with Assembly files (use g++ because some files were created with C++ and it won't link otherwise):
//  g++ -m64 -o Bohlin2 main.o readintarray.o Bohlin2Driver.o writeintarray.o addvectors.o sortintarray.o vectordotproduct.o 
//  multiplyvectors.o sumarray.o


extern unsigned long int mainASM();

int main()
{
    unsigned long int result = 1;           // 1 is just an arbitrary 'default' code

    printf("\n");
    printf("%s\n", "CPSC240 Assignment 2 by Jeff Bohlin.");

    result = mainASM();             // Store the return code of mainASM() in 'result'
    printf("%s%lu%s\n", "The return code is ", result, "\n");
    return result;
}
