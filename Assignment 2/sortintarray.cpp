// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-Feb-21
// File name: sortintarray.cpp
// Function name: sortintarray
// Purpose: This module takes an array that's passed in from 'main.asm' and sorts it from
//          smallest to largest.
//
//
// Compile with this command: g++ -c -Wall -m64 -l sortintarray.lis -o sortintarray.o sortintarray.cpp
//
#include <iostream>
using namespace std;

// Prototype:
extern "C" void sortintarray(long int arr[], int n);

// Definition:
// Note: Because I am using qwords in assembly, I MUST use long integers in arr[] here.  Before, I had
//       only specified 'int arr[]' and each time I would have an error.

// Bubblesort.  Not the best, but simple.
void sortintarray(long int arr[], int counter)
{
    bool swapped = true;
    int j = 0;
    long int tmp;

    while (swapped)
    {
        swapped = false;
        j++;
        for (int i = 0; i < counter - j; i++)
        {
            if (arr[i] > arr[i + 1])
            {
                tmp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = tmp;
                swapped = true;
            }
        }
    }
}


