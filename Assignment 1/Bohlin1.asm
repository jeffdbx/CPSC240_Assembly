;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 1
; Due: 2011-Feb-7
; File: Bohlin1.asm
; Author's Email: jeffdbx@csu.fullerton.edu
; Purpose: Basic assignment to multiply and divide two integers. Also learning how to use C
;          for I/O (printf / scanf).
;
; Allocation of registers:
;    rax   io   ; Sometimes rax is set to zero indicating 0 is the number of variant parameters for printf and scanf
;    rdi        ; First parameter passed (string, integer, or hex formatting)
;    rsi        ; Second parameter passed (prompt messages, integer values, etc.)
;    rdx:rax    ; Used to store overflow from multiplication
;    
;
; Call the assembler:  nasm -f elf64 -o Bohlin1.o Bohlin1.asm
; 
;----------------------------------------------------------------------------------------------------------------------
extern printf
extern scanf

segment .data                           ; Initialized data
;
    prompt1         db "Enter the first signed integer: ", 0
    prompt2         db "Enter the second signed integer: ", 0    
    msg1            db "You entered ", 0    
    msgProd         db "The product is ", 0    
    msgDiv          db "The quotient is ", 0    
    msgRem          db "The remainder is ", 0
    msgInt          db " (signed decimal) = ", 0
    msgHex          db " (unsigned hex)", 10, 0    
    msgOverflow     db "The product requires more than 64 bits. Its value is: ", 10, 0    
    msgBye          db "I hope you enjoyed using my program as much as I enjoyed making it. Bye!", 10, 0    
    stringFormat    db "%s", 0    
    intFormat       db "%lld", 0
    hexFormatShort  db "%lx", 0
    hexFormatLong   db "%.16llx", 0     ; This forces printf to output 16 digits
    newline         db 10, 0
;

segment .bss                            ; Un-initialized data  (stored in memory)
;
    integer1        resq 1
    integer2        resq 1
    product         resq 1    
    remainder       resq 1
    quotient        resq 1    
    overflowRDX     resq 1              ; Holds the overflow data during multiplication from rdx
    overflowRAX     resq 1              ; Holds the overflow data during multiplication from rax
;

segment .text
;
global welcome
welcome:
;

; Input first integer

    mov     qword rax, 0                ; Zero out rax before any call to printf/scanf
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, newline                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print a new line
    
    mov     qword rax, 0        
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, prompt1                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "Enter the first signed integer:"
    
    mov     qword rax, 0
    mov     rdi, intFormat              ; Prepare integer format code for scanf (parameter 1)
    mov     rsi, integer1               ; This places the address that integer1 points to in rsi (parameter 2)
    call    scanf                       ; This will read in an int and put that as the value into integer1

; Output first integer in decimal and in hex
    
    mov     qword rax, 0                ; Zero out rax before any call to printf/scanf
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msg1                   ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "You entered "
    
    mov     qword rax, 0    
    mov     rdi, intFormat              ; Prepare integer formatting code for printf (parameter 1)
    mov     rsi, [integer1]             ; Prepare the first integer for printf (parameter 2)    
    call    printf                      ; Print first integer in decimal

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgInt                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(signed decimal) = "

    mov     qword rax, 0        
    mov     rdi, hexFormatShort         ; Prepare 8 digit hex formatting code for printf (parameter 1)
    mov     rsi, [integer1]             ; Prepare the first integer for printf (parameter 2)
    call    printf                      ; Print first integer in hex

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgHex                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(unsigned hex)"

; Input second integer
    
    mov     qword rax, 0                ; Zero out rax before any call to printf/scanf
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, prompt2                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "Enter the second signed integer:"
    
    mov     qword rax, 0
    mov     rdi, intFormat              ; Prepare integer format code for scanf (parameter 1)
    mov     rsi, integer2               ; this places the address that integer2 points to in rsi (parameter 2)
    call    scanf                       ; this will read in an int and put that as the value into integer2
    
; Output second integer in decimal and in hex

    mov     qword rax, 0                ; Zero out rax before any call to printf/scanf
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msg1                   ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "You entered "
        
    mov     qword rax, 0
    mov     rdi, intFormat              ; Prepare integer formatting code for printf (parameter 1)
    mov     rsi, [integer2]             ; Prepare the second integer for printf (parameter 2)
    call    printf                      ; Print second integer in decimal

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgInt                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(signed decimal) = "

    mov     qword rax, 0
    mov     rdi, hexFormatShort         ; Prepare 8 digit hex formatting code for printf (parameter 1)
    mov     rsi, [integer2]             ; Prepare the second integer for printf (parameter 2)
    call    printf                      ; Print second integer in hex

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgHex                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(unsigned hex)"    

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, newline                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print a new line

; Multiply both integers
    
    mov     qword rax, 0                ; Zero out rax before any call imul
    mov     rax, [integer1]             ; Prepare the first integer by moving it into rax    
    mov     rcx, [integer2]             ; Prepare the second integer by moving it into rcx
    imul    rcx                         ; Multiply rax by rcx and store result in rax (rdx:rax if overflow)
    
    jo      yesOverflow                 ; If there was overflow during multiplication, jump to warning message
    
    mov     [product], rax              ; Store the product for later use

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgProd                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "the product is "

    mov     qword rax, 0        
    mov     rdi, intFormat              ; Prepare integer formatting code for printf (parameter 1)
    mov     rsi, [product]              ; Prepare the product for printf (parameter 2)
    call    printf                      ; Print the product in decimal

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgInt                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(signed decimal) = "

    mov     qword rax, 0
    mov     rdi, hexFormatLong          ; Prepare 8 digit hex formatting code for printf (parameter 1)
    mov     rsi, [product]              ; Prepare the product for printf (parameter 2)
    call    printf                      ; Print the product in hex

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgHex                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(unsigned hex)"

    jmp     Divide                      ; Jump to the Divide code section

yesOverflow:                            ; Print out the hex value of the overflow

    mov     [overflowRAX], rax          ; Store the low-order bits of the overflow for later use
    mov     [overflowRDX], rdx          ; Store the high-order bits of the overflow for later use

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgOverflow            ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "The product requires more than 64 bits. It's value is: "

    mov     qword rax, 0
    mov     rdi, hexFormatLong          ; Prepare 16 digit hex formatting code for printf (parameter 1)
    mov     rsi, [overflowRDX]          ; Prepare high-order bits for printf (parameter 2)
    call    printf                      ; Print the high-order bits of the overflow in 16 digit hex

    mov     qword rax, 0                ; Prepare 16 digit hex formatting code for printf (parameter 1)
    mov     rdi, hexFormatLong          ; Prepare low-order bits for printf (parameter 2)
    mov     rsi, [overflowRAX]          ; Print the low-order bits of the overflow in 16 digit hex
    call    printf    

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, newline                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print a new line
    
; Divide both integers
Divide:
                                        ; In order to use "idiv" with one operand, the integers 
                                        ;  to be divided must be in rax and rcx

    mov     rax, [integer1]             ; Put the first integer into rax (dividend)
    cqo                                 ; Sign extend rax all the way through rdx:rax (needed for dividing a negative int)
    mov     rcx, [integer2]             ; Put the second integer into rcx (divisor)
    idiv    rcx                         ; Divide rax by rcx (int1 / int2)

    mov     [quotient], rax             ; Store the quotient for later use
    mov     [remainder], rdx            ; Store the remainder for later use

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgDiv                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "The quotient is "

    mov     qword rax, 0
    mov     rdi, intFormat              ; Prepare integer formatting code for printf (parameter 1)
    mov     rsi, [quotient]             ; Prepare the quotient for printf (parameter 2)
    call    printf                      ; print quotient in decimal
            
    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgInt                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(signed decimal) = "

    mov     qword rax, 0
    mov     rdi, hexFormatLong          ; Prepare 16 digit hex formatting code for printf (parameter 1)
    mov     rsi, [quotient]             ; Prepare the quotient for printf (parameter 2)
    call    printf                      ; Print the quotient in hex

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgHex                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(unsigned hex)"

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgRem                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "The remainder is "

    mov     qword rax, 0
    mov     rdi, intFormat              ; Prepare integer formatting code for printf (parameter 1)
    mov     rsi, [remainder]            ; Prepare the remainder for printf (parameter 2)
    call    printf                      ; Print the remainder in decimal

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgInt                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "(signed decimal) = "

    mov     qword rax, 0
    mov     rdi, hexFormatLong          ; Prepare 16 digit hex formatting code for printf (parameter 1)
    mov     rsi, [remainder]            ; Prepare the remainder for printf (parameter 2)
    call    printf                      ; Print the remainder in hex

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgHex                 ; Prepare string for printf (parameter 2)
    call    printf                      ; "(unsigned hex)"

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, newline                ; Prepare string for printf (parameter 2)
    call    printf                      ; Print a new line

    mov     qword rax, 0
    mov     rdi, stringFormat           ; Prepare string formatting code for printf (parameter 1)
    mov     rsi, msgBye                 ; Prepare string for printf (parameter 2)
    call    printf                      ; Print "I hope you enjoyed using my program as much as I enjoyed making it. Bye!"

    xor     rax, rax                    ; return 0 to the operating system if the program executes successfully

    ret                                 ; End program


