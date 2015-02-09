//============================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: getGeometricMean.c
// Purpose: This module computes the geometric mean of the values within
//          an array.
//
//  Compile: gcc -c -Wall -m64 -o getGeometricMean.o getGeometricMean.c
//
//============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern double getGeometricMean(double *, long int);

double getGeometricMean(double array1[], long int counter)
{
    int i;
    double total = fabs(array1[0]);
    double geoMean;

    for (i = 1; i < counter; ++i)
        total *= (fabs(array1[i]));

    geoMean = (pow(total, (1.0 / counter)));

    return geoMean;

}
