This program takes 3 sides of a triangle (input from the user) and then uses Heron's Formula to
calculate the area.  The formula is:  Area = sqrt( s(s-a)(s-b)(s-c) )  Where 's' is the semi-perimeter.

All number storage and calculations are done within the x87 FPU registers (st0, st1, etc.) in order
to maintain high precision.  