// Author: Jeff Bohlin
// Course: CPSC240
// Assignment number: 4
// Due:
// Author's Email: jeffdbx@gmail.com
// Purpose: This is the driver for 'Bohlin4.asm'.  Very simply, it calls 'Bohlin4.asm' and then outputs the 
//          resulting return code after the program is done executing. This will serve as a generic
//          driver for all assembly projects in this class. A full description of what this program
//          accomplishes can be found in 'Bohlin4.asm'.
//
// Compile: 
//  gcc -c -m64 Bohlin4Driver.c
//
// Link:
//  gcc -m64 -o Bohlin4 Bohlin4.o Bohlin4Driver.c

#include <stdio.h>
#include <stdlib.h>


extern unsigned long int mainASM();

int main()
{
    // 1 is just an arbitrary 'default' code
    unsigned long int result = 1;

    printf("\n");
    printf("%s\n", "Welcome to Jeff Bohlin's CPSC240 Assignment 4.");

    // Store the return code of mainASM() in 'result'
    result = mainASM();
    printf("%s%lu%s\n", "The return code is ", result, ".\n");
    return result;
}
