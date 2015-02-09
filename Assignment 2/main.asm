;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 2
; Due: 2012-Feb-21
; File: main.asm
; Author's Email: jeffdbx@gmail.com
; Purpose:  This program practices inputting/outputting arrays as well has peforming various mathematical operations   
;           on them. The following tasks are executed:
;   
;      1) Prompt the user to input data for two integer arrays.
;      2) Display both arrays.
;      3) Perform vector addition on both arrays and store the result in a third array.    
;      4) Display the third array.
;      5) Sort the third array.
;      6) Display the newly sorted third array.
;      7) Compute the vector dot product of the first two arrays and store the result in the third array.
;      8) Display the vector dot product.
;      9) Exit the program with a 'good-bye' message.
;
;
; Allocation of registers:
;   
;   rdi = 1st input parameter (CCC-64)
;   rsi = 2nd input parameter (CCC-64)
;   rdx = 3rd input parameter (CCC-64)
;   rcx = 4th input parameter (CCC-64)
;
; Call the assembler:  nasm -f elf64 -o main.o main.asm
;   LINK WITH G++, NOT GCC!!!!
;  
;----------------------------------------------------------------------------------------------------------------------

extern printf, scanf, readintarray, writeintarray, addvectors, sortintarray, vectordotproduct


segment .data                       ; Initialized data
;
    msg1            db "Welcome to very fast array processing for integer data. ", 10, 0
    msg2            db "Your array is ", 0
    msg3            db "The sum of the arrays is ", 0   
    msgFirstArray   db "Enter data for the first array: ", 0    
    msgSecondArray  db "Enter data for the second array.  For correct results you must enter exactly ", 0
    msgValues       db " value(s): ", 0 
    msgSorted       db "The sorted array is ", 0    
    msgProduct      db "The component-wise product of the two arrays is: ", 0   
    msgDotProduct   db "The dot product of the two arrays is: ", 0  
    msgBye          db "I hope you enjoyed my fast array program as much as I enjoyed making it!", 10, 0        
    stringFormat    db "%s", 0  
    intFormat       db "%lld", 0        
    newline         db 10, 0
;

segment .bss                        ; Un-initialized data  (stored in memory)
;
    firstIntArray   resq 50         ; Reserve space for the first array of 50 maximum integers
    secondIntArray  resq 50         ; Reserve space for the second array of 50 maximum integers
    thirdIntArray   resq 50         ; Reserve space for the third array of 50 maximum integers  
    counter         resq 1          ; A variable to hold the total number of elements in the array
    dotproduct      resq 1          ; A variable to hold the result from vectordotproduct
;

segment .text
;
global mainASM
mainASM:

; Populate the the first array

    mov qword [counter], 0          ; Zero out the counter

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msg1               ; Prepare msg1 for printf
    call    printf                  ; Print "Welcome to very fast array processing for integer data. "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, newline            ; Prepare newline for printf
    call    printf                  ; Print a newline

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msgFirstArray      ; Prepare msgFirstArray for printf
    call    printf                  ; Print "Enter data for the first array: "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, firstIntArray      ; Prepare the first array for data input
    call    readintarray            ; Call external module to read data into the first array
        
    mov     [counter], rax          ; Save the total number of elements in our array into counter

; Print the first array

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msg2               ; Prepare msg2 for printf
    call    printf                  ; Print "Your array is: "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, firstIntArray      ; Prepare the first array for output    
    mov     rsi, [counter]          ; Pass the counter to writeintarray
    call    writeintarray           ; Call external module to output the first array to the screen

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, newline            ; Prepare newline for printf
    call    printf                  ; Print a newline

; Populate the second array

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msgSecondArray     ; Prepare msgFirstArray for printf
    call    printf                  ; Print "Enter data for the second array.  For correct results you must enter exactly "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, intFormat          ; Prepare string formatting for printf
    mov     rsi, [counter]          ; Prepare the counter for printf
    call    printf                  ; Print the counter

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msgValues          ; Prepare msgValues for printf
    call    printf                  ; Print "values: "
    
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, secondIntArray     ; Prepare the second array for data input       
    call    readintarray            ; Call external module to read data into the second array

; Print the second array

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msg2               ; Prepare msg2 for printf
    call    printf                  ; Print "Your array is: "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, secondIntArray     ; Prepare the second array for output
    mov     rsi, [counter]          ; Pass the value of the counter to the writeintarray module 
    call    writeintarray           ; Call external module to output the second array to the screen

; Add the two arrays and store the result in thirdIntArray

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, firstIntArray      ; Prepare firstintarray to be passed as the first parameter
    mov     rsi, secondIntArray     ; Prepare secondintarray to be passed as the second parameter
    mov     rdx, thirdIntArray      ; Prepare thirdintarray to be passed as the third parameter
    mov     rcx, [counter]          ; Prepare the counter to be passed as the fourth parameter
    call    addvectors              ; Call addvectors which will add the first and second arrays together and
                                    ;   put the result in the third array

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, newline            ; Prepare newline for printf
    call    printf                  ; Print a newline
    
; Print out the sum of the arrays (stored in thirdintarray)

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msg3               ; Prepare msg2 for printf
    call    printf                  ; Print "The sum of the arrays is: "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, thirdIntArray      ; Prepare thirdintarray to be passed as the first parameter
    mov     rsi, [counter]          ; Prepare the counter to be passed as the second parameter
    call    writeintarray           ; Call writeintarray which will print the values of thirdintarray

; Sort thirdintarray and print it again

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, thirdIntArray      ; Prepare thirdintarray to be passed as the first parameter
    mov     rsi, [counter]          ; Prepare the counter to be passed as the second parameter
    call    sortintarray            ; Sort the third array

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msgSorted          ; Prepare msgSorted for printf
    call    printf                  ; Print "The sorted array is "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, thirdIntArray      ; Prepare thirdintarray to be passed as the first parameter
    mov     rsi, [counter]          ; Prepare the counter to be passed as the second parameter
    call    writeintarray           ; Call writeintarray which will print the sorted values of thirdintarray

; Calculate the vector dot product of firstintarray and secondintarray

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, firstIntArray      ; Prepare firstintarray to be passed as the first parameter
    mov     rsi, secondIntArray     ; Prepare secondintarray to be passed as the second parameter
    mov     rdx, thirdIntArray      ; Prepare thirdintarray to be passed as the third parameter
    mov     rcx, [counter]          ; Prepare the counter to be passed as the fourth parameter
    call    vectordotproduct        ; Call vectordotproduct which will then call 2 other subprograms to find
        
    mov     [dotproduct], rax;      ; Save the result from vectordotproduct for later use

; Print the component-wise product of the two arrays (this step was not required but I did it for debugging purposes and to
;  make sure that my arrays were being multiplied correctly before summing them to get the dot product)

    ;mov    qword rax, 0            ; No vector registers used, zero is the number of variant parameters    
    ;mov    rdi, stringFormat       ; Prepare string formatting for printf
    ;mov    rsi, msgProduct         ; Prepare msgDotProduct for printf
    ;call   printf                  ; Print "The product of the two arrays is: "

    ;mov    qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    ;mov    rdi, thirdIntArray      ; Prepare thirdintarray to be passed as the first parameter
    ;mov    rsi, [counter]          ; Prepare the counter to be passed as the second parameter
    ;call   writeintarray           ; Call writeintarray which will print the sorted values of thirdintarray

; Print the dot product
    
    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters    
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msgDotProduct      ; Prepare msgDotProduct for printf
    call    printf                  ; Print "The DOT product of the two arrays is: "

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, intFormat          ; Prepare integer formatting for printf
    mov     rsi, [dotproduct]       ; Prepare the dotproduct for printf
    call    printf                  ; Print the dot product of firstintarray and secondintarray

; Print the goodbye message

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, newline            ; Prepare newline for printf
    call    printf                  ; Print a newline

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, newline            ; Prepare newline for printf
    call    printf                  ; Print a newline

    mov     qword rax, 0            ; No vector registers used, zero is the number of variant parameters
    mov     rdi, stringFormat       ; Prepare string formatting for printf
    mov     rsi, msgBye             ; Prepare msgBye for printf
    call    printf                  ; Print "I hope you enjoyed my fast array program as much as I enjoyed making it!"
    
    xor     rax, rax                ; return 0 to the Operating System if the program executes successfully
    ret                             ; End program
;







