;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 4
; Due:
; File: Bohlin4.asm
; Author's Email: jeffdbx@gmail.com
; 
; Purpose: This program takes 3 sides of a triangle (inputted from the user) and then use's Heron's Formula to
;      calculate the area.  The formula is:  Area = sqrt( s(s-a)(s-b)(s-c) )  Where 's' is the semiperimeter.
;      All number storage and calculations are done within the x87 FPU registers (st0, st1, etc.) in order
;      to maintain high precision.  
;
; Allocation of registers:
;   
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   st(x) = used for floating point calculations
;
; Call the assembler:  nasm -f elf64 -o Bohlin4.o Bohlin4.asm
; Call the linker:     gcc -m64 -o Bohlin4 Bohlin4.o Bohlin4Driver.c debug.o
;
;----------------------------------------------------------------------------------------------------------------------
%include "debug.inc"                        ; Include the debugger.  This is a utility provided by Prof. Holiday.
extern printf, scanf, getchar               ; Include external C functions

segment .data                               ; Initialized data is placed in this segment
;
    welcome             db "This program will find the area of your triangle.", 10, 0
    msgSide1            db "Please enter the length of the first side and press enter: ", 0
    msgSide2            db "Please enter the length of the second side and press enter: ", 0
    msgSide3            db "Please enter the length of the third side and press enter: ", 0
    msgEntered          db "You entered ", 0
    msgSemi             db "The semi-perimeter is ", 0  
    msgRadicand         db "The radicand is ", 0    
    msgArea             db "The area is ", 0
    msgBye              db "I hope you enjoyed your triangles, bye!", 10, 0
    msgSum              db "The sum is ", 0 
    msgMoreData         db "Do you have more input data (Y or N): ", 0      
    msgError            db "The area cannot be computed.  Check your data and try again.", 10, 0
    stringFormat        db "%s", 0
    charFormat          db "%c", 0
    floatInputFormat    db "%llf", 0        ; Both %llf and %Lf (long double) and perform the same  WRONG! USE "%Lf"
    floatOutputFormat   db "%19.20llf", 0
    divideByTwo         dw 2, 0             ; This has to be either 16 (dw) or 32 (dd) bit for fidiv to work
    testFormat          db "%lld", 0
    newline             db 10, 0
;

segment .bss                                ; Un-initialized data (stored in memory) is placed in this segment
                                            ; Each of these variables are 80 bits in size.  'rest' means reserve
                                            ;   a tword (tword = ten bytes).  This should allow me to keep 80 bit
                                            ;   precision throughout the program.
;   
    side1               rest 1
    side2               rest 1
    side3               rest 1
    semiPerimeter       rest 1
    semiMinusA          rest 1
    semiMinusB          rest 1
    semiMinusC          rest 1
    radicand            rest 1
    tArea               rest 1
;

segment .text                               ; Begin executable code
;
global mainASM
mainASM:

; Safe programming practice: Save the registers that may be used
;   during this program.

    push    rdi
    push    rsi
    push    rdx
    push    rcx
    push    r8
    push    r9 
    push    rbp


startLoop:

; Output the welcome message

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat         ; Prepare string formatting for printf
    mov     qword rsi, welcome              ; Prepare welcome for printf
    call    printf                          ; Print "This program will find the area of your triangle."

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a new line

; Ask the user to input Side 1 of the triangle

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat         ; Prepare string formatting for printf
    mov     qword rsi, msgSide1             ; Prepare msgSide1 for printf
    call    printf                          ; Print "Please enter the length of the first side and press enter: "

; Read-in Side 1 from the keyboard

    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    mov     qword rax, 1                    ; Let scanf know to expect a float
    mov     qword rdi, floatInputFormat     ; Prepare float formatting for scanf
    mov     qword rsi, rsp                  ; Move the address of the top of the integer stack to rsi
    call    scanf                           ; Read in Side 1

    fld     tword [rsp]                     ; Push Side 1 (that's in the integer stack) onto the st stack (st0)
    fstp    tword [side1]                   ; Pop Side 1 into a variable to save for later

    pop     rax                             ; Pop rax to reverse push #2
    pop     rax                             ; Pop rax to reverse push #1

; Output Side 1 of the triangle

;======================================================================================
; 
; NOTE: 
;       For these next steps, in order to print the decimal form of Side 1, I need
;   to first pop Side 1 into memory (for some reason I was having issues with the xmm0
;   register to print out the float in decimal form. It seems that simply sending
;   "%19.20llf" to printf works [as far as I can tell]).  However, I would still 
;   like to keep a copy inside of the st register to use for calculations later. 
;   Using 'fst' won't work in this case (it brings up an error when trying  to assemble). 
;   So 'fstp' must be used instead which will pop Side 1 out of st0.
;
;       The solution to this problem is to pop (from st0) Side 1 onto the integer stack,                            
;   and then immediately re-push it back into st0. Notice that doing it this way keeps
;   a copy of Side 1 in both st0 and the integer stack.
;
; Additional Note: "%19.20llf" tells printf to print up to 19 digits before the decimal
;    point, and 20 digits after the decimal point. It appears that the calculations
;    are being outputted correctly, and to the correct precision.  But there is no real
;    way to tell for sure without seeing the correct outputs that are expected from 
;    Professor Holliday. I could be wrong however, but let's hope it doesn't bomb
;    my output grade for this assignment! :] 
;   
; UPDATE: 4/12/2012.  Using "%Lf" for printf will work so long as ALL  calculations are
;     done with in the FP stack. Using variables in memory will not provide correct
;     precision!
;   
;======================================================================================


    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    fld     tword [side1]                   ; Push Side 1 onto the st stack (st0), (this must be done first in order to get the 
                                            ;    data into rsp.  ("push tword [side1]" does not assemble.
    fstp    tword [rsp]                     ; Pop Side 1 onto the integer stack

showregisters 1


    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgEntered                 ; Prepare msgEntered for printf 
    call    printf                          ; Print "You entered "

    mov     qword rax, 1                    ; Let printf know to expect a float
    mov     rdi, floatOutputFormat          ; Prepare float formatting for printf
    mov     rsi, [rsp]                      ; Prepare Side 1 for printf 
    call    printf                          ; Print Side 1

    pop     rax                             ; Reverse push #2
    pop     rax                             ; Reverse push #1

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a new line
    

; Ask the user to input Side 2 of the triangle

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat         ; Prepare string formatting for printf
    mov     qword rsi, msgSide2             ; Prepare msgSide1 for printf
    call    printf                          ; Print "Please enter the length of the first side and press enter: "

; Read-in Side 2 from the keyboard

    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    mov     qword rax, 1                    ; Let scanf know to expect a float 
    mov     qword rdi, floatInputFormat     ; Prepare float formatting for scanf
    mov     qword rsi, rsp                  ; Move the address of the top of the integer stack to rsi
    call    scanf                           ; Read in Side 2

    fld     tword [rsp]                     ; Push Side 2 (that's in the integer stack) onto the st stack (st0)
    fstp    tword [side2]                   ; Pop Side 2 into our variable for use later
    
    pop     rax                             ; Pop rax to reverse push #2
    pop     rax                             ; Pop rax to reverse push #1

    
; Output Side 2 of the triangle
                                            ; [The same steps that were used to print Side 1 must be done here as well. 
                                            ;  Refer to the NOTE back with Side 1.]

    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    fld     tword [side2]                   ; Push Side 2 onto the st stack (st0), (this must be done first in order to get the 
                                            ;    data into rsp.  ("push tword [side2]" does not assemble.
    fstp    tword [rsp]                     ; Pop the Side 2 onto the integer stack

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgEntered                 ; Prepare msgEntered for printf 
    call    printf                          ; Print "You entered "

    mov     qword rax, 1                    ; Let printf know to expect a float
    mov     rdi, floatOutputFormat          ; Prepare float formatting for printf
    mov     rsi, [rsp]                      ; Prepare Side 2 for printf 
    call    printf                          ; Print Side 2

    pop     rax                             ; Pop rax to reverse push #2
    pop     rax                             ; Pop rax to reverse push #1

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a new line

; Ask the user to input Side 3 of the triangle

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat         ; Prepare string formatting for printf
    mov     qword rsi, msgSide3             ; Prepare msgSide3 for printf
    call    printf                          ; Print "Please enter the length of the third side and press enter: "

; Read-in Side 3 from the keyboard

    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    mov     qword rax, 1                    ; Let scanf know to expect a float 
    mov     qword rdi, floatInputFormat     ; Prepare float formatting for scanf
    mov     qword rsi, rsp                  ; Move the address of the top of the integer stack to rsi
    call    scanf                           ; Read in Side 3

    fld     tword [rsp]                     ; Push Side 3 (that's in the integer stack) onto the st stack (st0)
    fstp    tword [side3]

    pop     rax                             ; Pop rax to reverse push #2
    pop     rax                             ; Pop rax to reverse push #1

; Output Side 3 of the triangle

                                            ; [The same steps that were used to print Side 1 and Side 2 must be done here as well.]                             
                                            ;  Refer to the NOTE back with Side 1.]
    mov     qword rax, 0
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    fld     tword [side3]                   ; Push Side 3 onto the st stack (st0), (this must be done first in order to get the 
                                            ;    data into rsp.  ("push tword [side2]" does not assemble.
    fstp    tword [rsp]                     ; Pop Side 3 onto the integer stack

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgEntered                 ; Prepare msgEntered for printf 
    call    printf                          ; Print "You entered "

    mov     qword rax, 1                    ; Let printf know to expect a float
    mov     rdi, floatOutputFormat          ; Prepare float formatting for printf
    mov     rsi, [rsp]                      ; Prepare Side 3 for printf 
    call    printf                          ; Print Side 3

    pop     rax                             ; Pop rax to reverse push #2
    pop     rax                             ; Pop rax to reverse push #1

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a new line

; Calculate the semiperimeter

    fld     tword [side1]                   ; Push Side 1 onto the st stack
    fld     tword [side2]                   ; Push Side 2 onto the st stack
    fadd                                    ; Add Side 1 and Side 2 and store the sum in st0
    fld     tword [side3]                   ; Push Side 3 onto the st stack (Side 3 goes into  st0, and the sum of
                                            ;   of Side 1 + Side 2 moves up to st1)
    fadd                                    ; Add Side 3 to the previous sum to get the final total of all three sides

    fidiv   dword [divideByTwo]             ; Divide the sum in st0 by integer 2 then store the result
                                            ;   in st0. (But am I losing precision here?!)

    fstp    tword [semiPerimeter]           ; Save the newly calculated semi perimeter in a memory variable for later use


; Calculate the area of the triangle (Having fun with Heron's Formula.)

;======================================================================================
; NOTE: 
;       Heron's formula calculates the area of a triangle:
;       Area = sqrt( s(s-a)(s-b)(s-c) )
;
;   Where 's' is the semiperimeter and 'a', 'b', 'c' are the sides of the triangle.
;
;   In order to do this I have to perform the operations in small steps and shuffle
;  values up and down the floating point stack (AKA a nightmare). I will conduct the                            
;  steps according to the normal order of mathematical operations. The order of the steps
;  is as follows:
;
;   Step 1: Calculate (s-a) and save that value in memory.
;   Step 2: Calculate (s-b) and save that value in memory.
;   Step 3: Calculate (s-c) and save that value in memory.
;   Step 4: Calculate s(Step 1)(Step 2)(Step 3) and save that value in memory.
;           This is the radicand, we must also test to make sure that it is
;           non-negative. If it is negative, then output an error.
;   Step 5: Calculate sqrt(Step 4) and save that value in memory
;           This is the total area of the triangle.
;   
;======================================================================================


; Step 1

    fld     tword [semiPerimeter]           ; Push the semi perimeter onto the st stack (st0)
    fld     tword [side1]                   ; Push the Side 1 onto the st stack (st0, semi perimeter is now in st1)
    fsub                                    ; Subtract Side 1 from the semi perimeter (s-a)
    fstp    tword [semiMinusA]              ; Store the result in a semiMinusA for later use

; Step 2

    fld     tword [semiPerimeter]           ; Push the semi perimeter onto the st stack (st0)
    fld     tword [side2]                   ; Push the Side 2 onto the st stack (st0, semi perimeter is now in st1)
    fsub                                    ; Subtract Side 2 from the semi perimeter (s-b)
    fstp    tword [semiMinusB]              ; Store the result in a semiMinusB for later use

; Step 3

    fld     tword [semiPerimeter]           ; Push the semi perimeter onto the st stack (st0)
    fld     tword [side3]                   ; Push the Side 3 onto the st stack (st0, semi perimeter is now in st1)
    fsub                                    ; Subtract Side 3 from the semi perimeter (s-c)
    fstp    tword [semiMinusC]              ; Store the result in a semiMinusC for later use

; Step 4
    
    fld     tword [semiMinusA]              ; Push (s-a) onto the st stack (st0)
    fld     tword [semiMinusB]              ; Push (s-b) onto the st stack bumping (s-a) up to st1
    fmul                                    ; Multiply (s-a) times (s-b) and store the result in st0
    fld     tword [semiMinusC]              ; Push (s-c) onto the st stack bumping the previous product into st1
    fmul                                    ; Multiply (s-c) times the product of (s-a)(s-b) and store the result in st0
    fld     tword [semiPerimeter]           ; Push the semiperimeter onto the st stack bumping the previous product into st1
    fmul                                    ; Multiply the semiperimeter times the product of (s-a)(s-b)(s-c)
    fstp    tword [radicand]                ; The final result is the radicand. Save this for later.
    fld     tword [radicand]                ; Push the radicand back onto the st stack (st0)
    
    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the integer stack
    push    rax                             ; Push another 64 zeros onto the integer stack (effectively making it 128bit)
    
    fld     tword [rsp]                     ; Push zeros into st(0) in order to compare it with the radicand in the next step
    
    fcom                                    ; Compare st(0) and st(1)
    fstsw   ax                              ; These next two commands copy the FPU flags into the 64 bit rflags register.
    sahf                                    ;    What that means is, that in order for conditional jumps to work,
                                            ;    such as jnb (jump if not below), or jmp (just a standard jump)
                                            ;    you have to move the flags into the 64 bit rflags.  The reason for
                                            ;    this is because there are no conditional jumps that will work on
                                            ;    the FPU flags.  Sounds confusing, but google "ftstsw" for more info.

    jnb     isNegative                      ; "Jump if not below".  I'm not exactly sure what this means, I'm assuming
    jmp     isPositive                      ;    it means compare both numbers in st(0) and st(1) and if zero is "not
                                            ;    below" the radicand (meaning the radicand is negative) then jump.  I'm
                                            ;    sure there is a more eloquent of way of doing this, but after spending 
                                            ;    way too many hours getting it to work, I am pleased with this result.

isNegative:

    pop     rax                             ; Reverse push #2
    pop     rax                             ; Reverse push #1

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgError                   ; Prepare msgError for printf
    call    printf                          ; Print "The area cannot be computed.  Check your data and try again."

    jmp     askMoreData                     ; Jump to the section that asks the user to enter more data

isPositive: 
    
    pop     rax                             ; Reverse push #2
    pop     rax                             ; Reverse push #1

; Step 5

    fld     tword [radicand]                ; Push the radicand onto the st stack (st0)
    fsqrt                                   ; Calculate the square root of the radicand and store the result in st0
    fstp    tword [tArea]                   ; The final result is the total area of the triangle. Save this for later.

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a new line

; Output the semiperimeter

    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    fld     tword [semiPerimeter]           ; Push the semiperimeter onto the st stack (st0)
    fstp    tword [rsp]                     ; Pop the semiperimeter onto the integer stack

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgSemi                    ; Prepare msgSemi for printf
    call    printf                          ; Print "The semi-perimeter is "

    mov     qword rax, 1                    ; Let printf know to expect a float
    mov     rdi, floatOutputFormat          ; Prepare float formatting for printf
    mov     rsi, [rsp]                      ; Prepare the semiperimeter for printf
    call    printf                          ; Print the semiperimeter

    pop     rax                             ; Reverse push #1
    pop     rax                             ; Reverse push #2

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a newline

; Output the area of the triangle

    mov     qword rax, 0                    ; Clear out rax by moving 64 zeros into it
    push    rax                             ; Push 64 zeros onto the stack to clear room for input (push #1)
    push    rax                             ; Push another 64 zeros for a total of 128 bits of clean space (push #2)

    fld     tword [tArea]                   ; Push the total area onto the st stack (st0)
    fstp    tword [rsp]                     ; Pop the total area onto the integer stack

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgArea                    ; Prepare msgArea for printf
    call    printf                          ; Print "The area is "

    mov     qword rax, 1                    ; Let printf know to expect a float
    mov     rdi, floatOutputFormat          ; Prepare float format for printf
    mov     rsi, [rsp]                      ; Prepare the total area for printf
    call    printf                          ; Print the total area

    pop     rax                             ; Reverse push #2
    pop     rax                             ; Reverse push #1

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a newline


; Ask the user if they have more data

askMoreData:

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a newline

    call    getchar                         ; Input and discard the end-of-line char that is still in the buffer

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, msgMoreData                ; Prepare msgMoreData for printf
    call    printf                          ; Print "Do you have more input data (Y or N): "

    push    qword 0                         ; Push 64 zeros onto the integer stack

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, charFormat                 ; Prepare character formatting for scanf
    mov     rsi, rsp                        ; Move the address of the top of the integer stack to rsi
    call    scanf                           ; Read in the user's answer ('Y' or 'N')

    pop r15                                 ; Save the answer in r15

    mov     qword rax, 0                    ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a newline

    cmp r15, 89                             ; Check to see if the user entered 'Y'

    je  startLoop                           ; If the user entered 'Y' then jump to the start of the loop

; Restore all registers

    pop     rbp
    pop     r9
    pop     r8
    pop     rcx
    pop     rdx
    pop     rsi
    pop     rdi

    mov     qword rax, 0                    ; Return 0 to the operating system if the program executes successfully
    ret                                     ; End program
;



