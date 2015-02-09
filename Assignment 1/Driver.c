// Author: Jeff Bohlin
// Course: CPSC240
// Assignment number: 1
// Due: 2011-Feb-2
// Author's Email: jeffdbx@gmail.com
// Purpose: Basic assignment to multiply and divide two integers. Also learning how to use C
//          for I/O. (This is the driver for Bohlin1.asm)
//
// NOTE: Professor Holliday's "triangle.c" file was used as a template 
// Compile: 
//  gcc -c -m64 Bohlin1Driver.c
//
// Link with Assembly file: 
//  gcc -m64 -o Bohlin1 Bohlin1.o Bohlin1Driver.o

#include <stdio.h>
#include <stdlib.h>

extern unsigned long int welcome();

int main()
{
    // Need to find out how to print the real result code
    unsigned long int result = 1;   
    printf("\n");
    printf("%s\n", "Welcome to Jeff's Arithmetic assignment!");
    result = welcome();
    printf("%s%lu%s\n", "The result code is ", result, "\n");
    return result;
}
