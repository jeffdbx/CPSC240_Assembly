;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 6
; Due: 2012-May-10
; File: getStandardDeviation.asm
; Author's Email: jeffdbx@gmail.com
; Purpose:  This module computes th standard deviation of values within an array. This is simply 
            the square root of the variance.
;
; Allocation of registers:
;
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   rdx = 3rd input parameter (CCC-64)
;   rcx = 4th input parameter (CCC-64)
;   st0 = float computation
;   st1 = float computation
;   xmm0 = float return value
;
; Call the assembler:  nasm -f elf64 -o getStandardDeviation.o getStandardDeviation.asm
;  
;----------------------------------------------------------------------------------------------------------------------
    
extern printf

segment .data                           ; Initialized data
;
    stringFormat    db "%s", 0
    floatOUT        db "%-#19.2lf", 0
    newline         db 10, 0
;

segment .bss                            ; Un-initialized data  (stored in memory)
;
    variance        resq 1
    stdDeviation    resq 1
;

segment .text
;

global getStandardDeviation
getStandardDeviation:


; Safe programming practices: Save the caller frame and any registers that may be used during this program.

    push    rbp                         ; Save point to the caller frame.
    mov     rbp, rsp                    ; Set our frame.

    push    rdi                         ; It's best to push an even number of registers which helps avoid any
    push    rsi                         ;   problems when doing I/O on the FP stack.

    mov     r14, [rdi]                  ; rdi holds the address of the variance passed in from 'main'.  Let's set r14
                                        ;   to point to that address so that I can access the actual variance value 
                                        ;   itself in the next step. (See note below).

    mov     qword [variance], r14       ; Copy the value of the variance into a variable for storage
    fld     qword [variance]            ; Push the variance onto the FP stack

;======================================================================================
;
; NOTE to self:
;
;   Notice that I can not do 'fld qword [rdi]' because, in this case, that would
;   be pushing an ADDRESS (namely the address of the variance) onto the FP stack.  
;   Nor would 'fld qword rdi' work because then I would be pushing the ADDRESS
;   of the rdi register onto the stack!  So that is why I must first set r14 as a
;   pointer to the address of the variance, and then access the VALUE from there. 
;
;   After some trial and error, I found that even though I can access the value in
;   r14, when I try to do 'fld qword [r14]', I get a segmentation fault.  Perhaps that
;   has to do with trying to push the value of a pointer that points to a memory 
;   location which was allocated in a different module (main).  I don't know.  The 
;   solution, however, is to copy the value of r14 into a variable that I call
;   "variance" and then proceed as usual.
;
;   Also, one thing I have yet to understand is how the assembler is able to    
;   differentiate between using the value vs address of a register.  For example, the
;   code 'mov r14, [rdi]'  changes the address of r14 to whatever the value is in rdi.
;   Notice I have to use brackets to access the value in rdi.  Yet, in the next line of
;   code 'mov qword [variance], r14' it changes the value of variance to the value inside
;   (not the address) of r14.  Maybe this only occurs when moving data from a register 
;   into a user defined variable, because doing something like 'mov qword [variance],
;   [r14]' would result in an assembling error due to double dereferencing. Strange.
;
;======================================================================================

    fsqrt                               ; Calculate the square root of the variance (which is the standard deviation)

    fstp    qword [stdDeviation]        ; Save the result in a variable


; Restore all registers and the caller frame.

    pop     rsi
    pop     rdi

    mov     rsp, rbp                    ; Restore the caller frame
    pop     rbp

    movsd   xmm0, [stdDeviation]        ; Return the standard deviation (a double) in xmm0 to the caller
    ret                                 ; End module
;






