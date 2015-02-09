//==========================================================================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: getVariance.cpp
// Purpose:  This module computes the varianc of all values within an array.
//
// The variance (σ2) is a measure of how far each value in the data set is from the mean. Here is how it is defined:
//
//   1) Subtract the mean from each value in the data. This gives you a measure of the distance of each value from the mean.
//   2) Square each of these distances (so that they are all positive values), and add all of the squares together.
//   3) Divide the sum of the squares by the number of values minus one in the data set (Notice that this is for a "Sample"
//      variance and NOT a "population" variance). 
//
//  Compile: g++ -c -Wall -m64 -o getVariance.o getVariance.cpp
//
//==========================================================================================================================

#include <iostream>
#include <cmath>
#include <iomanip>
using namespace std;

extern "C" double getVariance(double *, long int, double);

double getVariance(double array1[], long int counter, double mean)
{
    double sum = 0.0;

    for(int i = 0; i < counter; ++i)
        sum += pow((array1[i] - (mean)), 2);

    return (sum / (counter - 1));
}
