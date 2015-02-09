//============================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: getSum.c
// Purpose:  This module computes the sum of all values within an array.
//
//  Compile: gcc -c -Wall -m64 -o getSum.o getSum.c
//
//============================================================================

#include <stdio.h>
#include <stdlib.h>

extern double getSum(double *, long int);

double getSum(double array1[], long int counter)
{
    int i;
    double total = 0.0;

    for(i = 0; i < counter; ++i)
        total += array1[i];

    return total;

}
