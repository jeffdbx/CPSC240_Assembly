//============================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: getMean.cpp
// Purpose: This module computes the arithmetic mean (average) of all values
//          within an array.
//
//  Compile: g++ -c -Wall -m64 -o getMean.o getMean.cpp
//
//============================================================================

#include <iostream>
using namespace std;

extern "C" double getMean(double *, long int);

double getMean(double array1[], long int counter)
{
    int i;
    double total = 0.0;

    // prevent division by zero
    if (counter == 0) return total;

    for (i = 0; i < counter; ++i)
        total += array1[i];

    total /= counter;

    return total;

}
