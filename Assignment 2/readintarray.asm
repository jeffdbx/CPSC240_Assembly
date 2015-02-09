;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 2
; Due: 2012-Feb-21
; File: readintarray.asm
; Author's Email: jeffdbx@gmail.com
; Purpose:  This module reads integer data into an array that has been passed in
;           from 'main.asm'.
;
; Allocation of registers:
;  
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   r12 = counter to keep track of the total number of array elements
;   r13 = character storage for the user's 'Y' or 'N' decision
;   r14 = address of the array passed in from 'main.asm'
;
; Call the assembler:  nasm -f elf64 -o readintarray.o readintarray.asm
; 
;----------------------------------------------------------------------------------------------------------------------
extern printf, scanf, getchar

segment .data                       ; Initialized data
;
    msg2            db "Do you have more data (Y or N)?: ", 0
    msg3            db "Enter next value: ", 0
    charFormat      db "%c", 0
    intFormat       db "%lld", 0    
    stringFormat    db "%s", 0
    newline         db 10, 0
;

segment .bss                        ; Un-initialized data  (stored in memory)
;
;

segment .text
;
global readintarray
readintarray:

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

    mov     r14, rdi                ; Store the address of the array that was passed in
    mov     qword r12, 0            ; Zero out r12, which will be used as an index counter  
    push    qword 0                 ; Push 64 zeros onto the stack, essentially clearing a spot for input
    
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, intFormat          ; Prepare integer formatting for scanf
    mov     rsi, rsp                ; Move the address of the current stack location (64 zeros) to rsi
    call    scanf                   ; Read in an integer inputted by the user
    
    pop     rdx                     ; Pop the integer that the user inputted into rdx
    mov     [r14 + 8 * r12], rdx    ; move the inputted integer into firstarray[index]
    inc     r12                     ; Increment the counter by 1
    call    getchar                 ; Eat the end-of-the-line whitespace that's still in the buffer

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat       ; Prepare string formatting code for printf
    mov     rsi, msg2               ; Prepare msg2 for printf
    call    printf                  ; Print "Do you have more data (Y or N)?: "

    push    qword 0                 ; Push 64 zeros onto the stack, essentially clearing a spot for input
    
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, charFormat         ; Prepare character formatting for scanf
    mov     rsi, rsp                ; Move the address of the current stack location (64 zeros) to rsi
    call    scanf                   ; Read in the user's answer (Y or N)
    
    pop     r13                     ; Save the user's answer in r13
    call    getchar                 ; Eat the end-of-the-line whitespace that's still in the buffer
    cmp     r13, 78                 ; Check to see if the user inputted 'N'
    je      noMoreData              ; If the user entered 'N', jump to the end of the program

getMoreData:

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting code for printf 
    mov     rsi, msg3               ; Prepare msg3 for printf 
    call    printf                  ; Print "Enter next value: "

    push    qword 0                 ; Push 64 zeros onto the stack, essentially clearing a spot for input
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, intFormat          ; Prepare integer formatting for scanf
    mov     rsi, rsp                ; Move the address of the current stack location (64 zeros) to rsi
    call    scanf                   ; Read-in the integer inputted from the user
    
    pop     rdx                     ; Pop the integer that the user inputted into rdx
    mov     [r14 + 8 * r12], rdx    ; Move the inputted integer into array[index]
    inc     r12                     ; Increment r12
    call    getchar                 ; Eat the end-of-the-line whitespace that's still in the buffer
    
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat       ; Prepare string formatting for printf 
    mov     rsi, msg2               ; Prepare msg2 for printf 
    call    printf                  ; Print "Do you have more data (Y or N)?: "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    push    qword 0                 ; Push 64 zeros onto the stack, essentially clearing a spot for input
    mov     rdi, charFormat         ; Prepare character formatting code for printf
    mov     rsi, rsp                ; Move the address of the current stack location (64 zeros) to rsi
    call    scanf                   ; Read-in the integer inputted from the user
    
    pop     r13                     ; Save the user's answer in r13
    call    getchar                 ; Eat the end-of-the-line whitespace that's still in the buffer
    cmp     r13, 78                 ; Check to see if the user entered 'N'
    je      noMoreData              ; If the user entered 'N', then jump to noMoreData
    jmp     getMoreData             ; Else, repeat the loop

noMoreData:

    mov     rax, r12                ; Return the value of r12 to counter in main.asm

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




