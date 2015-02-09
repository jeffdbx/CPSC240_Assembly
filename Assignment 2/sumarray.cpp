// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-Feb-21
// File name: sumarray.cpp
// Function name: sumarray
// Purpose: This module calculates the sum of all of the elements in an array.  It
//	        then returns the result to 'vectordotproduct.asm'.
//
// Compile with this command: g++ -c -Wall -m64 -l sumarray.lis -o sumarray.o sumarray.cpp
//
#include <iostream>
using namespace std;

// Prototype:
extern "C" long int sumarray(long int arr[], int n);


// Definition:
// Note: Because I am using qwords in assembly, I MUST use long integers in arr[] here.  Before, I had
//       only specified 'int arr[]' and each time I would have an error.

long int sumarray(long int arr[], int counter)
{
	long int sum = 0;

	for (int i = 0; i < counter; i++)
		sum += arr[i];

    // return sum to rax
	return sum;	
}
