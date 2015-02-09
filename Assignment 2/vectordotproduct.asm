;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 2
; Due: 2012-Feb-21
; File: vectordotproduct.asm
; Author's Email: jeffdbx@gmail.com
; Purpose:  This module calculates the vector dot product of firstIntArray and secondIntArray. This is done
;           by first calling the 'multiplyvectors' module which performs vector multiplication on the two
;           arrays.  The result is then stored in thirdIntArray.  Next, 'sumarray' is called  which totals all
;           all of the elements in thirdIntArray.  This is our dot product and is finally returned to 'main'.
;
; Allocation of registers:
;
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   rdx = 3rd input parameter (CCC-64)
;   rcx = 4th input parameter (CCC-64)
;   r13: stores the address of firstIntArray
;   r14: stores the address of secondIntArray
;   r15: stores the address of thirdIntArray    
;
; Call the assembler:  nasm -f elf64 -o vectordotproduct.o vectordotproduct.asm
; 
;----------------------------------------------------------------------------------------------------------------------
extern printf, scanf, multiplyvectors, sumarray

segment .data                       ; Initialized data
;
    stringFormat    db "%s", 0
;

segment .bss                        ; Un-initialized data  (stored in memory)
;
    count           resq 1          ; Local variable to hold the total number of elements in the array
    sumArrayResult  resq 1          ; Local variable to hold the result of sumarray
;

segment .text
;
global vectordotproduct
vectordotproduct:
;

; Safe programming practice.  Save all registers (except rax) onto the stack as a precaution.

    push rbx
    push rcx
    push rdx
    push rdi
    push rsi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15


; Saving the addresses of the arrays is probably unncessary here, but I am doing it as good practice
;  of the CCC-64 convention.

    mov     r13, rdi                ; Store the address of firstIntArray in r13
    mov     r14, rsi                ; Store the address of secondIntArray in r14
    mov     r15, rdx                ; Store the address of thirdIntArray in r15
    mov     [count], rcx            ; Store the total number of elements of our array into count

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, r13                ; Prepare firstintarray to be passed as the first parameter
    mov     rsi, r14                ; Prepare secondintarray to be passed as the second parameter
    mov     rdx, r15                ; Prepare thirdintarray to be passed as the third parameter
    mov     rcx, [count]            ; Prepare the counter to be passed as the fourth parameter
    call    multiplyvectors         ; Call multiplyvectors which will multiply firstintarray times secondintarray
                                    ;   and store the result in thirdintarray
    
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, r15                ; Prepare thirdintarray to be passed as the first parameter
    mov     rsi, [count]            ; Prepare the counter to be passed as the second parameter
    call    sumarray                ; Call sumarray which will calculate the sum of all elements in thirdintarray

                                    ; Note: This step is not necessary, but I put it here so that I can remind myself that the
                                    ;       sum returned from sumarray will be stored in rax, immediately after the function
                                    ;       is called.  So if I wanted to ever do more operations with that sum, I would need
                                    ;       to save it some place.  In this, case, because the sum is simply going to be forwarded
                                    ;       from here to 'main' anyways, I don't really have to do anything with it.  I can just save 
                                    ;       rax inside of the 'main' instead.

    mov     [sumArrayResult], rax

                                    ; Do more operations here with the sum if I wanted to ...

    mov     rax, [sumArrayResult]   ; Un-necessary step, but just practice.  The caller is expecting a value to 
                                    ;  be returned to rax, so let's return the sum! (In fact, that is what 'main'
                                    ;  was asking for in the first place, well it just so happens that this sum is
                                    ;  our final dot product)

; Restore all registers back to their original state.

    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbp
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    
    ret                             ; End module


