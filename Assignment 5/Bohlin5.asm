;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 5
; Due: 4/17/2012
; File: Bohlin5.asm
; Author's Email: jeffdbx@gmail.com
; 
; Purpose:  This program determines the amount of time (in nanoseconds) that my 2.1Ghz computer can calculate 
;           the harmonic sum ≥ x, where x is a non-zero float entered by the user.  See the note below that 
;           describes how to calculate a harmonic sum in greater detail.
;
; Acknowledgements: 
            Thanks to Flavio De Pucol and Professor Holliday for the software 
;           that prints a floating point number to 80-bit precision.
;
; Allocation of registers:
;   
;   rax and int stack(0) for reading in user input
;   st(x) for all floating point calculations
;
;
; Call the assembler: nasm -f elf64 -l Bohlin5.lis -o Bohlin5.o Bohlin5.asm
;  
;----------------------------------------------------------------------------------------------------------------------

%include "debug.inc"    
extern printf                           ; External C function for printing.
extern  __isoc99_scanf                  ; Externmal C function for inputting 80-bit precision floats.

segment .data                           ; Place initialized data here.
;
    welcome             db "This program computes the sum of a harmonic series!", 10, 0
    bye                 db "Have a harmonic day, Bye!", 10, 0
    prompt1             db "Enter a non-zero float value for x: ", 0
    msgTerms            db "The smallest number of terms with harmonic sum greater than x is %.0Lf", 0
    msgSum              db " and that sum is %.25Lf", 10, 0
    msgClockStart       db "The current time on the clock is ", 0
    msgClockStop        db "The result has been computed and the clock shows ", 0   
    msgCompRequired     db "The computation required ", 0
    msgNanos            db " cycles which is %.lld ns on my 2.1GHz machine.", 10, 0 
    intFormat           db "%ld", 0
    stringFormat        db "%s", 0
    floatReadInFormat   db "%Lf", 0     ; Be sure to use upper case 'L'.
    newline             db 10, 0

    clock_start         dq 0
    clock_stop          dq 0
    total_cycles        dq 0
    clock_rate          dq 2.1          ; 2.1 GHz, will be used as the divisor of total_cycles.
    nano_seconds        dq 0
;

segment .bss                            ; Place un-initialized data here.
;
;   
;

segment .text
;

global mainASM
mainASM:
                                
; Safe programming practices: Save the caller frame and any registers that may be used during this program.

    push    rbp                         ; Save point to the caller frame.
    mov     rbp, rsp                    ; Set our frame.

    push    rdi                         ; It's best to push an even number of registers which helps avoid any
    push    rsi                         ;   problems when doing I/O on the FP stack.

; Output the welcome message.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     qword rdi, stringFormat     ; Prepare string formatting for printf.
    mov     qword rsi, welcome          ; Prepare welcome for printf.
    call    printf                      ; Print "Welcome to the harmonic series program!"

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a new line.


;======================================================================================
; 
; NOTE: 
;   As described in our assignment: "The Harmonic series has nth partial sum:
;   
;       Hn = 1 + 1/2 + 1/3 ... 1/n
;   
;       It is known from mathematical studies that Hn grows arbitrarily large as n goes  
;   to infinity. The question is how big must n be in order for Hn to exceed a given 
;   number. In other words, for a given input x what is the smallest n such that     
;   Hn ≥ x ?"
;
;   Let's find out!
;  
;       The general process for this assignment will require a lot of movement around 
;   the FP registers.  I will be using the "fld1" command extensively, which simply
;   pushes the constant 1.0 into st0.  This will be my constant numerator which I 
;   will divide by the incrementing denominator, 'n'.  The result of this will be added 
;   to the accumulating harmonic sum.  After each iteration of this process, a comparison 
;   will be made between the harmonic sum and 'x'.  Once Hn ≥ x, then the loop will 
;   terminate.  Finally, the results are printed to the screen.  Notice, that 'n' will
;   be equal to the total number of terms and thus an integer term counter is not 
;   necessary.
;   
;======================================================================================


; Before we do any calculations, let's do some prep work!

; 1) Do a general initialization of the FP stack.

    finit                               ; Initialize the FPU to its default state. It flags all registers as empty, 
                                        ;   though it does not actually change their values. 

; 2) Initialize the value of 'n' to one. This will be the incrementing denominator.

    fld1

; 3) Get the value of 'x' from the user.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, prompt1                ; Prepare prompt1 for printf.
    call    printf                      ; Print "Enter a float value for x: "

    mov     qword rax, 0                ; Clear out rax by moving 64 zeros into it.
    push    rax                         ; Push 64 zeros onto the stack to clear room for input (push #1).
    push    rax                         ; Push another 64 zeros for a total of 128 bits of clean space (push #2).           

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, floatReadInFormat      ; Prepare long float formatting for scanf.
    mov     qword rsi, rsp              ; Move the address of the top of the integer stack to rsi.
    call    __isoc99_scanf              ; Use new scanf to get the floating point value of 'x'.

    fld     tword [rsp]                 ; Push 'x' onto the FP stack at st0.

    pop     rax                         ; Pop rax to reverse push #2.
    pop     rax                         ; Pop rax to reverse push #1.

; 4) Initialize the accumulating harmonic sum to zero.

    mov     qword rax, 0                ; Clear out rax by moving 64 zeros into it.
    push    rax                         ; Push 64 zeros onto the stack to clear room for input (push #1).
    push    rax                         ; Push another 64 zeros for a total of 128 bits of clean space (push #2).

    fld tword [rsp]                     ; Zero out st0. These zeros will be pushed up the stack where the sum will reside.

    pop     rax                         ; Pop rax to reverse push #2.
    pop     rax                         ; Pop rax to reverse push #1.

; 5) Push the constant numerator (1.0) onto the stack.

    fld1                                ; All of the previous locations get bumped up one slot.

;======================================================================================
;
; NOTE: Very Important! 
;
;   Issues when using constants such as fld1: If a constant is sitting in st0, 
;   attempting to use a command such as fstp to pop it off does NOT work. I've tested 
;   it extensively.  So, what happens when a constant is in st0 and you try use 
;   a pop command like fstp?
;
;   The answer is:  the next location on the stack above the constant is
;   popped off instead!  So, by looking at the picture below, invoking the
;   fstp command will pop st1, and shift the other cells down 1 spot. 
;   
;   I CAN however use faddp, fsubp, etc to manipulate the constant and only then
;   does it pop off the stack. Weird.
;
;======================================================================================


                                        ; Here is a current snapshot of the FP stack. More pictures will appear throughout
                                        ;   the program (it helps me keep track of what's going on):
                                        ;
                                        ;         --------------
                                        ;     st3 |      n     |
                                        ;         --------------
                                        ;     st2 |      x     |    = 0.0
                                        ;         --------------
                                        ;     st1 |     Sum    |    = 1.0
                                        ;         --------------
                                        ;     st0 |  Constant  |    = 1.0
                                        ;         --------------
                                        ;

; Start the clock!                      ; Side note: The clock is stored in the lower 32 bits of rax, and
                                        ;   overflows into the lower 32 bits of rdx.

    mov     qword rax, 0                ; Clear out rax by moving 64 zeros into it.
    mov     qword rdx, 0                ; Clear out rdx by moving 64 zeros into it.

    cpuid                               ; Makes the machine stop loading future instructions until all currently 
                                        ;   executing instructions have completed.
    rdtsc                               ; Read the clock's start time.
    mov     [clock_start], eax          ; Move the lower 32 bits of rax into the lower 32 bits of clock_start.
    mov     [clock_start + 4], edx      ; Move the lower 32 bits of rdx into the upper 32 bits of clock_start.

; Now we can begin our loop. Notice ALL calculations are done on the FP stack.

Loop:

    fdiv    st0, st3                    ; Divide st0 (1) by st3 (n) and store the result in st0.
    faddp   st1, st0                    ; Add the result from the previous step to the harmonic sum and pop the stack
                                        ;   to clear out the copy still left in st0.
    

                                        ;         --------------
                                        ;     st2 |      n     |    
                                        ;         --------------
                                        ;     st1 |      x     |    
                                        ;         --------------
                                        ;     st0 |     Sum    |    
                                        ;         --------------


    fcom                                ; Compare st0 (sum) to st1 (x)

    fstsw   ax                          ; These next two commands copy the FPU flags into the 64 bit rflags register.
    sahf                                ;    What that means is, that in order for conditional jumps to work,
                                        ;    such as jnb (jump if not below), or jmp (just a standard jump)
                                        ;    you have to move the flags into the 64 bit rflags.  The reason for
                                        ;    this is because there are no conditional jumps that will work on
                                        ;    the FPU flags.  Sounds confusing, but google "ftstsw" for more info.

    
    jnb     printResults                ; After comparing the sum to x: Is sum ≥ x? If yes, then print the results.
                                        ; If not, then continue.

    fld1                                ; Push 1.0 back onto the stack at st0.
    fadd    st3, st0                    ; Increment n by 1.0 (basically n++).


                                        ;         --------------
                                        ;     st3 |    n + 1   |
                                        ;         --------------
                                        ;     st2 |      x     |
                                        ;         --------------
                                        ;     st1 |     Sum    |
                                        ;         --------------
                                        ;     st0 |  Constant  |    = 1.0
                                        ;         --------------


    jmp     Loop                        ; Repeat the loop.




printResults:           

; Stop the clock!               

    mov     qword rax, 0                ; Clear out rax by moving 64 zeros into it.
    mov     qword rdx, 0                ; Clear out rdx by moving 64 zeros into it.

    cpuid                               ; Makes the machine stop loading future instructions until all currently 
                                        ;   executing instructions have completed.
    rdtsc                               ; Read the clock's stop time.

;showregisters 1                        ; Show the current status of the registers after the clock is read.

    mov     [clock_stop], eax           ; Move the lower 32 bits of rax into the lower 32 bits of clock_stop.
    mov     [clock_stop + 4], edx       ; Move the lower 32 bits of rdx into the upper 32 bits of clock_stop.



; Output the clock start time.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     qword rdi, stringFormat     ; Prepare string formatting for printf.
    mov     qword rsi, msgClockStart    ; Prepare msgClockStart for printf.
    call    printf                      ; Print "The current time on the clock is "

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     qword rdi, intFormat        ; Prepare integer formatting for printf.
    mov     qword rsi, [clock_start]    ; Prepare clock_start for printf.
    call    printf                      ; Print out the clock start time.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a new line.

; Output the clock stop time.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     qword rdi, stringFormat     ; Prepare string formatting for printf.
    mov     qword rsi, msgClockStop     ; Prepare msgClockStop for printf.
    call    printf                      ; Print "The result has been computed and the clock shows "

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     qword rdi, intFormat        ; Prepare integer formatting for printf.
    mov     qword rsi, [clock_stop]     ; Prepare clock_stop for printf.
    call    printf                      ; Print out the clock stop time.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a new line.

                                        ; Snapshot of the FP stack after all calculations are done:
                                        ;
                                        ;         --------------
                                        ;     st2 |      n     |    
                                        ;         --------------
                                        ;     st1 |      x     |    
                                        ;         --------------
                                        ;     st0 |     Sum    |    
                                        ;         --------------

; Output the total number of terms.

    fxch    st2                         ; Swap sum and n, so that I can print out the number of terms first.
                                        ; Notice that a seperate term counter is not needed.

                                        ;         --------------
                                        ;     st2 |     Sum    |    
                                        ;         --------------
                                        ;     st1 |      x     |    
                                        ;         --------------
                                        ;     st0 |      n     |    
                                        ;         --------------

    mov     qword rax, 0                ; Clear out rax by moving 64 zeros into it.
    push    rax                         ; Push 64 zeros onto the stack to clear room for input (push #1).
    push    rax                         ; Push another 64 zeros for a total of 128 bits of clean space (push #2).

    fstp    tword [rsp]                 ; Pop st0 (n) onto the integer stack.

    mov     rdi, msgTerms               ; Prepare msgTerms for printf.
    mov     qword rax, 1                ; Let printf know to expect a float.
    call    printf                      ; Print msgTerms along with the value of n.
    
    pop     rax                         ; Pop rax to reverse push #2.
    pop     rax                         ; Pop rax to reverse push #1.

; Output the harmonic sum.

    fxch    st1                         ; Swap x and sum, so that I can print out the harmonic sum.

                                        ;         --------------
                                        ;     st1 |      x     |    
                                        ;         --------------
                                        ;     st0 |     Sum    |    
                                        ;         --------------


    mov     qword rax, 0                ; Clear out rax by moving 64 zeros into it.
    push    rax                         ; Push 64 zeros onto the stack to clear room for input (push #1).
    push    rax                         ; Push another 64 zeros for a total of 128 bits of clean space (push #2).

    fstp    tword [rsp]                 ; Pop st0 (sum) onto the integer stack.

    mov     rdi, msgSum                 ; Prepare msgSum for printf.
    mov     qword rax, 1                ; Let printf know to expect a float.
    call    printf                      ; Print msgSum along with the harmonic sum.
    
    pop     rax                         ; Pop rax to reverse push #2.
    pop     rax                         ; Pop rax to reverse push #1.

; Output the total clock cycles and nanoseconds needed to perform the computation.

;======================================================================================
;
; NOTE: Converting clock cycles (ticks) to nanoseconds:
;
;   First, take as an example a 3.0GHz computer.  This computer is able to perform:
;     3 billion ticks per second
;   = 3 billion ticks per 1 billion nanoseconds
;   = 3 ticks per 1 nanosecond
;
;   Thus, we can use the formula (total_clock_cycles / GHz) to determine the time in
;   nanoseconds of an operation.
;
;   Example:
;
;   If a 3.0GHz computer takes 36040 total clock cycles to perform some task, how 
;   many nanoseconds is that?
;
;   (36040/3.0) = 12013.333333333 ns
;
;   As of 4/14/2012, this program was executed on my slow 2.1GHz processor.  Thus,
;   the equivalent answer on this machine would be:
;
;   (36040/2.1) = 17161.904761905 ns
;
;======================================================================================


    fld     qword [clock_start]         ; Push the clock start time onto the FP stack.
    fld     qword [clock_stop]          ; Push the clock stop time onto the FP stack.
    fsub    st0, st1                    ; Subtract the start time from the stop time to determine the total cycles.
    fstp    qword [total_cycles]        ; Pop the result of the previous step and save it in memory.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgCompRequired        ; Prepare msgCompRequired for printf.
    call    printf                      ; Print "The computation required ".

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, intFormat              ; Prepare integer formatting for printf.
    mov     rsi, [total_cycles]         ; Prepare the total_cycles for printf.
    call    printf                      ; Print the total clock cycles that were needed to perform the operation.

    fld     qword [clock_rate]          ; Push my computer's clock rate (2.1GHz) onto the FP stack.
    fld     qword [total_cycles]        ; Push the total clock cycles onto the FP stack.
    fdiv    st0, st1                    ; Divide the total clock cycles by the clock rate. The result is nanoseconds.
    fstp    qword [nano_seconds]        ; Pop the result of the previous step and save it in memory.

                                        ; Side note:  When dividing the clock rate by 2.1, I should be getting a float
                                        ;   value.  After taking many steps to print it out as a float it refuses to
                                        ;   cooperate.  I tried initializing nano_seconds as a float; I tried using many
                                        ;   variations of the printf code format for float output; I also tried setting
                                        ;   rax to 1 to expect a float as usual.  Finally, I tried changing the clock cycles
                                        ;   to floats even though the machine returns them as integers.  Nothing.  Yet, it 
                                        ;   will print out nano_seconds correctly as an integer.
                                        ;   
                                        ;    Perhaps it's because I am dividing an integer (total_cycles) by a float (clock_
                                        ;    rate) that it forces the answer to be an integer.  I don't know. It is probably
                                        ;    something very basic that I am missing.  Luckily for this assignment the output
                                        ;    of nanoseconds does not have to be a float :)
                    
    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, msgNanos               ; Prepare string formatting for printf.
    mov     rsi, [nano_seconds]         ; Prepare nano_seconds for printf.
    call    printf                      ; Print " cycles which is [nano_seconds] ns on my 2.1GHz machine."

; Output the goodbye message.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a new line.

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, bye                    ; Prepare bye for printf.
    call    printf                      ; Print "Have a harmonic day, Bye!"

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a new line.

; Restore all registers and the caller frame.

    pop     rsi
    pop     rdi

    mov     rsp, rbp                    ; Restore the caller frame
    pop     rbp

    mov     qword rax, 0                ; Return 0 to the operating system if the program executes successfully
    ret                                 ; End program
;



