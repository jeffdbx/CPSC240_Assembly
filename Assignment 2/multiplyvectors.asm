;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 2
; Due: 2012-Feb-21
; File: multiplyvectors.asm
; Author's Email: jeffdbx@gmail.com
; Purpose:  This module takes three integer arrays and a counter passed from 'main.asm.'  The firstIntArray and the
;           secondIntarray are multiplied together using vector multiplication and the result is stored in thirdIntArray. 
;           Since these arrays were passed by reference, there is no need to return anything to 'main' from this module.
;
; Allocation of registers:
;  
;   r11: used for vector multiplication
;   r12: used as an index counter
;   r13: stores the address of firstIntArray
;   r14: stores the address of secondIntArray
;   r15: stores the address of thirdIntArray
;
; Call the assembler:  nasm -f elf64 -o multiplyvectors.o multiplyvectors.asm
; 
;----------------------------------------------------------------------------------------------------------------------
extern printf
extern scanf

segment .data                        ; Initialized data
;
    stringFormat    db "%s", 0
    intFormat       db "%lld", 0    
    newline         db 10, 0
;

segment .bss                         ; Un-initialized data  (stored in memory)
;
    count           resq 1           ; Local variable to hold the total number of elements in the array
;

segment .text
;
global multiplyvectors
multiplyvectors:

; Safe programming practice.  Save all registers (except rax) onto the stack as a precaution.

    push    rbx
    push    rcx
    push    rdx
    push    rdi
    push    rsi
    push    rbp
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
;

    mov     r13, rdi                    ; Store the address of firstIntArray in r13
    mov     r14, rsi                    ; Store the address of secondIntArray in r14
    mov     r15, rdx                    ; Store the address of thirdIntArray in r15
    mov     [count], rcx                ; Store the total number of elements of our array into count
    mov     qword r12, 0                ; Set r12 to zero so we can use it to step through the array index

                                        ; Two derefences in one command will NOT work, for example:
                                        ;   mov [r15 + 8], [r14 + 8]
doMultiplication:

    mov     r11, [r13 + 8 * r12]        ; Move firstIntArray[index] into r11 to prepare for addition
    imul    r11, [r14 + 8 * r12]        ; multiply r11 by secondIntArray[index]
    mov     [r15 + 8 * r12], r11        ; Move the result from the multiplication into thirdIntArray[index]

    inc     r12                         ; Increment the r12 (the indexer)

    cmp     r12, [count]                ; This compares the total number of values in the array stored in counter with r12.
                                        ;   r12 is my "indexer".  Essentially, the indexer starts at 0, and then increments 
                                        ;   until it is 1 less than value in counter.  Think of this as a C++ for loop:
                                        ;   for(int index = 0; index < counter; index++)

    jl      doMultiplication            ; If index (r12) is less than that counter (total number of elements in the array)
                                        ;    then repeat the loop.


    mov     qword rax, -1               ; The caller expects a return value, so let's just use a dummy value of -1

; Restore all registers back to their original state.

    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     rbp
    pop     rsi
    pop     rdi
    pop     rdx
    pop     rcx
    pop     rbx

    ret                                 ; End module


