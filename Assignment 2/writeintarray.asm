;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 2
; Due: 2012-Feb-21
; File: writeintarray.asm
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
; Call the assembler:  nasm -f elf64 -o writeintarray.o writeintarray.asm
; 
;----------------------------------------------------------------------------------------------------------------------
extern printf, scanf

segment .data                       ; Initialized data
;
    intFormat       db "%lld", 0        
    stringFormat    db "%s", 0
    oneSpace        db " ", 0   
    newline         db 10, 0
;

segment .bss                        ; Un-initialized data  (stored in memory)
;   
    count           resq 1          ; counter used for looping
;

segment .text
;
global writeintarray
writeintarray:

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

    mov     r14, rdi                ; Save the address of the array that was passed in from main
    mov     [count], rsi            ; Save the value of counter (from main.asm) in a local variable here
    mov     r12, 0                  ; Set r12 to zero so we can use it to step through the array index


printArray:

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, intFormat          ; Prepare integer formatting for printf
    mov     rsi, [r14 + 8 * r12]    ; Prepare the value in the array at the current index for printf.
                                    ;   The syntax "[r14 + 8*r12]" means take the beginning address of the array
                                    ;   which is stored in r14 and add (8 * r12) bytes from that point. r12 is the 
                                    ;   index. For example, if the index is at 0, then print out [r14 + (8*0)],
                                    ;   which is evaluates to [r14] (the first value in the array). If the index
                                    ;   is at 2, then print out [r14 + 16] which will print the 3rd value in the
                                    ;   the array.  Remember, each cell is 64 bits in size.

    call    printf                  ; Print out the value in the array at the current index
    
    inc     r12                     ; Increment r12 by 1

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, oneSpace           ; Prepare oneSpace for printf
    call    printf                  ; Print out a blank space

    cmp     r12, [count]            ; This compares the total number of values in the array stored in counter with r12.
                                    ;   r12 is my "indexer".  Essentially, the indexer starts at 0, and then increments 
                                    ;   until it is 1 less than value in counter.  Think of this as a C++ for loop:
                                    ;   for(int index = 0; index < counter; index++)
    jl      printArray              ; If r12 (the indexer) is less than the total number of elements in the array, then
                                    ;   go through the loop again.

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, newline            ; Prepre newline for printf
    call    printf                  ; Print out a newline

    
    mov     qword rax, -1           ; The caller expects a return value, so let's just use a dummy value of -1

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

    ret                             ; End module, return to caller
;

