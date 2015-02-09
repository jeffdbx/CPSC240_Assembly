//============================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: getMin.c
// Purpose:  This module finds the minimum value within an array.
//
//  Compile: gcc -c -Wall -m64 -o getMin.o getMin.c
//
//============================================================================

#include <stdio.h>
#include <stdlib.h>

extern double getMin(double *, long int);

double getMin(double array[], long int counter)
{
    int i;
    double min = array[0];

    for(i = 1; i < counter; ++i)
        if(min > array[i]) min = array[i];

    return min;

}
