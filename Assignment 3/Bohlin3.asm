;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 3
; Due: 2012-Mar-06
; File: Bohlin3.asm
; Author's Email: jeffdbx@gmail.com
; 
; Purpose: 
;
;   This program performs basic arithmetic operations on real numbers (floating point numbers).  It practices
;   the use of the x87 FPU and SSE2 hardware. Meaning, practice using the st (st0, st1, ..., st8) register 
;   stack as well as the xmm registers (xmm0, xmm1, ..., xmm8).
;
;   For this program, the st register stack is used to read-in and perform operations on floating point numbers.
;   They are then moved into the xmm0 register to be printed out in decimal form.
;
; Allocation of registers:
;   
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   st(x) = used for floating point calculations
;   xmm(x) = used for decimal printing
;
; Call the assembler:  nasm -f elf64 -o Bohlin3.o Bohlin3.asm
;  
;----------------------------------------------------------------------------------------------------------------------
extern printf, scanf                    ; Include external C functions

segment .data                           ; Initialized data is placed in this segment
;
    welcome             db "This program performs arithmetic operations on floating point numbers.", 10, 0
    prompt1             db "Please enter a floating point number: ", 0
    prompt2             db "Please enter another floating point number: ", 0
    msgEntered          db "You entered ", 0
    msgSum              db "The sum is ", 0
    msgDiff             db "The difference is ", 0
    msgProd             db "The product is ", 0
    msgQuot             db "The quotient is ", 0
    msgBye              db "I hope you enjoyed using my program as much as I enjoyed making it.  Bye.", 10, 0   
    stringFormat        db "%s", 0
    doubleInFormat      db "%lf", 0
    doubleOutFormat     db "%-#19.19lf", 0  ;I may not even need to use the xmm registers when I use this format code!
    hexoutputformat     db "%16lx", 0
    newline             db 10, 0
;

segment .bss                            ; Un-initialized data (stored in memory) is placed in this segment
;
    firstFloat          resq 1
    secondFloat         resq 1
    floatSum            resq 1
    floatDifference     resq 1  
    floatProduct        resq 1
    floatQuotient       resq 1
;

segment .text                           ; Begin executable code
;
global mainASM
mainASM:

; Safe programming practice: Save all registers

    push    rdi
    push    rsi
    push    rdx
    push    rcx
    push    r8
    push    r9 
    push    rbp

; Output the welcome message

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat     ; Prepare string formatting for printf
    mov     qword rsi, welcome          ; Prepare welcome for printf
    call    printf                      ; Print "This program performs arithmetic operations on floating point numbers."

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Ask the user to input the first floating point number

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat     ; Prepare string formatting for printf
    mov     qword rsi, prompt1          ; Prepare prompt1 for printf
    call    printf                      ; Print "Please enter a floating point number: "

; Read-in the first number from the keyboard

    push    qword 0                     ; Push 64 zeros onto the stack, essentially clearing a spot for input

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, doubleInFormat   ; Prepare double input formatting for scanf
    mov     qword rsi, rsp              ; Move the address of the current stack location (64 zeros) to rsi
    call    scanf                       ; Read-in a floating point number inputted from the user

    pop     qword [firstFloat]          ; Save the inputted number in firstFloat

; Output the first floating point number

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, msgEntered             ; Prepare msgEntered for printf
    call    printf                      ; Print "You entered "

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, doubleOutFormat  ; Prepare double output formatting for  printf
    movsd   xmm0, [firstFloat]          ; Move firstFloat to the xmm0 register to allow for decimal printing
    call    printf                      ; Print out the first floating point number

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Ask the user to input the second floating point number
        
    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, stringFormat     ; Prepare string formatting for printf
    mov     qword rsi, prompt2          ; Prepare prompt2 for printf
    call    printf                      ; Print "Please enter another floating point number: "

; Read-in the second number from the keyboard

    push    qword 0                     ; Push 64 zeros onto the stack, essentially clearing a spot for input

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     qword rdi, doubleInFormat   ; Prepare double input formatting for scanf
    mov     qword rsi, rsp              ; Move the address of the current stack location (64 zeros) to rsi
    call    scanf                       ; Read-in a floating point number inputted from the user

    pop     qword [secondFloat]         ; Save the inputted number in secondFloat

; Output the second floating point number

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, msgEntered             ; Prepare msgEntered for printf
    call    printf                      ; Print "You entered "

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, doubleOutFormat  ; Prepare double output formatting for  printf
    movsd   xmm0, [secondFloat]         ; Move secondFloat to the xmm0 register to allow for decimal printing
    call    printf                      ; Print out the first floating point number

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Add the two floating point numbers together

    fld     qword [firstFloat]          ; Push the first floating point number onto the st stack (st0)
    fadd    qword [secondFloat]         ; Add the second floating point number to the first float in st0
    fst     qword [floatSum]            ; Pop the sum that's in st0 (the top of the st stack) to floatSum

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, msgSum                 ; Prepare msgSum for printf
    call    printf                      ; Print "The sum is "

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, doubleOutFormat  ; Prepare double output formatting for  printf
    movsd   xmm0, [floatSum]            ; Move floatSum to the xmm0 register to allow for decimal printing
    call    printf                      ; Print out the sum of the first and second float

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Find the difference of the two floating point numbers

    fld     qword [firstFloat]          ; Push the first floating point number onto the st stack (st0)
    fsub    qword [secondFloat]         ; Subtract the second floating point number from the first float in st0
    fst     qword [floatDifference]     ; Pop the difference that's in st0 (the top of the st stack) to floatDifference

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, msgDiff                ; Prepare msgDiff for printf
    call    printf                      ; Print "The difference is "

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, doubleOutFormat  ; Prepare double output formatting for  printf
    movsd   xmm0, [floatDifference]     ; Move floatDifference to the xmm0 register to allow for decimal printing
    call    printf                      ; Print out the difference between the first and second float

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Find the product of the two floating point numbers

    fld     qword [firstFloat]          ; Push the first floating point number onto the st stack (st0)
    fmul    qword [secondFloat]         ; Multiply the first floating point number in st0 by the second float
    fst     qword [floatProduct]        ; Pop the product that's in st0 (the top of the st stack) to floatProduct

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, msgProd                ; Prepare msgProd for printf
    call    printf                      ; Print "The product is "

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, doubleOutFormat  ; Prepare double output formatting for  printf
    movsd   xmm0, [floatProduct]        ; Move floatDifference to the xmm0 register to allow for decimal printing
    call    printf                      ; Print out the product of the first and second float

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Find the quotient of the two floating point numbers

    fld     qword [firstFloat]          ; Push the first floating point number onto the st stack (st0)
    fdiv    qword [secondFloat]         ; Divide the first floating point number in st0 by the second float
    fst     qword [floatQuotient]       ; Pop the quotient that's in st0 (the top of the st stack) to floatQuotient

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, msgQuot                ; Prepare msgQuot for printf
    call    printf                      ; Print "The quotient is "

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, doubleOutFormat  ; Prepare double output formatting for  printf
    movsd   xmm0, [floatQuotient]       ; Move floatQuotient to the xmm0 register to allow for decimal printing
    call    printf                      ; Print out the quotient of the first and second float

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

    mov     qword rax, 0                ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat           ; Prepare string formatting for printf
    mov     rsi, newline                ; Prepare newline for printf
    call    printf                      ; Print a new line

; Restore all registers

    pop     rbp
    pop     r9
    pop     r8
    pop     rcx
    pop     rdx
    pop     rsi
    pop     rdi

    mov     qword rax, 0                ; Return 0 to the operating system if the program executes successfully
    ret                                 ; End program
;



