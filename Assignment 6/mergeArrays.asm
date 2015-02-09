;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 6
; Due: 2012-May-10
; File: mergeArrays.asm
; Author's Email: jeffdbx@gmail.com
; Purpose: This module combines two arrays that are passed in from the main module.  The two arrays generate a new
;          third array that is returnd to main.
;
; Allocation of registers:
;
;   rax = 1st return value (CCC-64)
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   rdx = 3rd input parameter (CCC-64)
;   rcx = 4th input parameter (CCC-64)
;
;   Storage:
;   r12 = Address of first array
;   r13 = Address of second array
;   r14 = Array 1 and Array 3 counter
;   r15 = Array 2 counter 
;   st0 = float computation
;
; Call the assembler:  nasm -f elf64 -o mergeArrays.o mergeArrays.asm
;  
;----------------------------------------------------------------------------------------------------------------------
    
extern printf, test, writeArray

segment .data                               ; Initialized data
;
;
;

segment .bss                                ; Un-initialized data  (stored in memory)
;
    mergedArray resq 50
    counter1    resq 1
    counter2    resq 1
;

segment .text
;

global mergeArrays
mergeArrays:


; Safe programming practices: Save the caller frame and some registers that may be used during this program.

    push    rbp                             ; Save point to the caller frame.
    mov     rbp, rsp                        ; Set our frame.

    push    rdi                             ; It's best to push an even number of registers which helps avoid any
    push    rsi                             ;   problems when doing I/O on the FP stack.

    finit                                   ; Re-initializes the FPU stack  

    mov     r12, rdi                        ; Save the address of the first array that was passed in from main
    mov     r13, rsi                        ; Save the address of the second array that was passed in from main
    mov     [counter1], rdx                 ; Save the counter of the first array
    mov     [counter2], rcx                 ; Save the counter of the second array
    mov     r14, 0                          ; Set r14 to zero. This will serve as an index counter for array 1 and the new
                                            ;   array 3 that we are creating.
    mov     r15, 0                          ; Set r15 to zero. This will serve as the index counter for array 2.

;======================================================================================
;
; NOTE:
;
;   The syntax "[r12 + 8 * r14]" means take the beginning address of the array
;   which is stored in r12 and add (8 * r14) bytes from that point. r14 is the 
;   index. For example, if the index is at 0, then print out [r12 + (8*0)],
;   which is evaluates to [r12] (the first value in the array). If the index
;   is at 2, then print out [r12 + 16] which will print the 3rd value in the
;   the array.  Remember, each cell is 64 bits in size.
;
;======================================================================================

mergeFirstArray:
    
    mov     qword rax, 0                    ; Zero out rax.
    fld     qword [r12 + 8 * r14]           ; Push firstArray[i] onto the FP stack at st0 ('i' meaning r14, the index)

    fstp    qword [mergedArray + 8 * r14]   ; Pop the float that's in st0 into mergedArray[i]
    inc     r14                             ; Increment r14 by 1

    cmp     r14, [counter1]                 ; This compares the total number of values in the array stored in counter with r14.
                                            ;   r14 is my "indexer".  Essentially, the indexer starts at 0, and then increments 
                                            ;   until it is 1 less than value in counter.  Think of this as a C++ for loop:
                                            ;   for(int index = 0; index < counter; index++)

    jl      mergeFirstArray                 ; If r14 (the indexer) is less than the total number of elements in the array, then
                                            ;   go through the loop again.


mergeSecondArray:

    mov     qword rax, 0            
    fld     qword [r13 + 8 * r15]           ; Push secondArray[i] onto the FP stack at st0 ('i' meaning r12, the index)

    fstp    qword [mergedArray + 8 * r14]   ; Pop the float that's in st0 into mergedArray[i]


    inc     r14                             ; Increment r14 by 1, [Notice this continues to keep track of the new array's index]
    inc     r15                             ; Increment r15 by 1

    cmp     r15, [counter2]                 ; Check to see if the current index is less than the total size of the second array.

    jl      mergeSecondArray                ; If r12 (the indexer) is less than the total number of elements in the array, then
                                            ;   go through the loop again.

; Restore all registers and the caller frame.

    pop     rsi
    pop     rdi

    mov     rsp, rbp                        ; Restore the caller frame
    pop     rbp

    mov     rax, mergedArray                ; Return the address of the newly created array to the caller.
    mov     rdi, r14                        ; Return the total number of elements in the new array.
    ret                                     ; End module
;






