;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 2
; Due: 2012-Feb-21
; File: writeArray.asm
; Author's Email: jeffdbx@gmail.com
; Purpose: This module simply prints out the contents of an array that is passed in from 'main.asm'.
;
; Allocation of registers:
;
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   r12: used as an index counter
;   r14: stores the address of the array passed in from 'main.asm'
;
;
; Call the assembler:  nasm -f elf64 -o writeArray.o writeArray.asm
; 
;----------------------------------------------------------------------------------------------------------------------
extern printf, scanf

segment .data                               ; Initialized data
;
    floatOutputFormat   db "%-#19.19lf", 0  
    intFormat           db "%d", 0  
    stringFormat        db "%s", 0  
    newline             db 10, 0
;

segment .bss                                ; Un-initialized data  (stored in memory)
;   
    count               resq 1              ; counter used for looping
;

segment .text
;
global writeArray
writeArray:

; Safe programming practices: Save the caller frame and any registers that may be used during this program.

    push    rbp                             ; Save point to the caller frame.
    mov     rbp, rsp                        ; Set our frame.

    push    rdi                             ; It's best to push an even number of registers which helps avoid any
    push    rsi                             ;   problems when doing I/O on the FP stack.
    ;push   rdx


    mov     r14, rdi                        ; Save the address of the array that was passed in from main
    mov     [count], rsi                    ; Save the value of counter (from main.asm) in a local variable here
    mov     r12, 0                          ; Set r12 to zero so we can use it to step through the array index

    jmp     skip_first_newline              ; Don't print a newline during the first time through the loop
                                            ;   (simply for aesthetics).

printArray:
    
    mov     qword rax, 0                    ; Clear out rax to prepare for I/O
    mov     rdi, stringFormat               ; Prepare string formatting for printf
    mov     rsi, newline                    ; Prepare newline for printf
    call    printf                          ; Print a newline

skip_first_newline:

    mov     qword rax, 1                    ; Tell printf to expect 1 floating point number
    mov     qword rdi, floatOutputFormat    ; Prepare double output formatting for  printf
    movsd   xmm0, [r14 + 8 * r12]           ; Prepare the value in the array at the current index for printf.
                                            ;   The syntax "[r14 + 8*r12]" means take the beginning address of the array
                                            ;   which is stored in r14 and add (8 * r12) bytes from that point. r12 is the 
                                            ;   index. For example, if the index is at 0, then print out [r14 + (8*0)],
                                            ;   which is evaluates to [r14] (the first value in the array). If the index
                                            ;   is at 2, then print out [r14 + 16] which will print the 3rd value in the
                                            ;   the array.  Remember, each cell is 64 bits in size.

    call    printf                          ; Print out the value in the array at the current index
    
    inc     r12                             ; Increment r12 by 1


    cmp     r12, [count]                    ; This compares the total number of values in the array stored in counter with r12.
                                            ;   r12 is my "indexer".  Essentially, the indexer starts at 0, and then increments 
                                            ;   until it is 1 less than value in counter.  Think of this as a C++ for loop:
                                            ;   for(int index = 0; index < counter; index++)


    jl      printArray                      ; If r12 (the indexer) is less than the total number of elements in the array, then
                                            ;   go through the loop again.
    
    mov     qword rax, -1                   ; The caller expects a return value, so let's just use a dummy value of -1


; Restore all registers and the caller frame.


    ;pop    rdx
    pop     rsi
    pop     rdi

    mov     rsp, rbp                        ; Restore the caller frame
    pop     rbp

    mov     qword rax, 0                    ; Return 0
    ret                                     ; End program
;

