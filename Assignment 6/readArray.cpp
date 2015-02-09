//============================================================================
// Author: Jeff Bohlin
// Email: jeffdbx@gmail.com
// Course: CPSC240
// Due: 2012-May-10
// File name: readArray.cpp
// Purpose:  This module reads data, inputted by the user, into an array.
//
//  Compile: g++ -c -Wall -m64 -o readArray.o readArray.cpp
//
//============================================================================

#include <iostream>
#include <cctype>
using namespace std;

extern "C" void readArray(double myArray[], long int MAX_SIZE, long int &counter);

void readArray(double myArray[], long int MAX_SIZE, long int &counter)
{
    char choice;

    if (counter == MAX_SIZE)
        cout << "The array is full." << endl;
    else
    {
        do
        {
            cout << "Enter a float number: ";
            cin >> myArray[counter];
            counter++;
            cout << "Do you have more data (Y/N)? ";
            cin >> choice;
            if (cin.fail())
            {
                cout << "\nInput was not an integer. Try again." << endl;
                cin.clear();
                break;
            }

        } while ((tolower(choice) != 'n') && (counter < MAX_SIZE));
    }
}



