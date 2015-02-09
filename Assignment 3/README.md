This program performs basic arithmetic operations on real numbers (floating point numbers).  It practices
the use of the x87 FPU and SSE2 hardware. Meaning, practice using the st (st0, st1, ..., st8) register 
stack as well as the xmm registers (xmm0, xmm1, ..., xmm8).

For this program, the st register stack is used to read-in and perform operations on floating point numbers.
They are then moved into the xmm0 register to be printed out in decimal form.