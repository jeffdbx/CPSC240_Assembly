//============================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: getMax.c
// Purpose:  This module finds the maximum value within an array.
//
//  Compile: gcc -c -Wall -m64 -o getMax.o getMax.c
//
//============================================================================

#include <stdio.h>
#include <stdlib.h>

extern double getMax(double *, long int);

double getMax(double array[], long int counter)
{
    int i;
    double max = array[0];

    for(i = 1; i < counter; ++i)
        if(max < array[i]) max = array[i];

    return max;

}
