;----------------------------------------------------------------------------------------------------------------------
; Author: Jeff Bohlin
; Course: CPSC240
; Assignment number: 6
; Due: 2012-May-10
; File: Bohlin6main.asm
; Author's Email: jeffdbx@gmail.com
; Purpose:  This program practices inputting/outputting arrays as well has peforming various mathematical operations   
;           on them. The following tasks are executed:
;   
;       1) Prompts the user to input data for two floating point arrays.
;       2) Calculates the sum of each array.
;       3) Finds the smallest value in each array.
;       4) Finds the largest value in each array.
;       5) Calculates the arithmetic mean of each array.
;       6) Calculates the sample variance of each array.
;       7) Calculates the sample standard deviation of each array.
;       8) Calculates the geometric mean of each array.
;       9) Concatenates both arrays into a third array and repeats tasks 2 - 8 for the new array.
;      10) Outputs all data and calculations to the screen.
;      11) Exits the program with a 'good-bye' message.
;
; Allocation of registers:
;
;   rdi  = 1st input parameter and 1st return value (CCC-64).
;   rsi  = 2nd input parameter (CCC-64).
;   rdx  = 3rd input parameter and 2nd return value (CCC-64).
;   rcx  = 4th input parameter (CCC-64).
;   xmm0 = 1st float input parameter and 1st float return value (CCC-74).
;   
;
; Call the assembler:  nasm -f elf64 -o Bohlin6main.o Bohlin6main.asm
;
; Call the linker: g++ -m64 -o Bohlin6 Bohlin6main.o Bohlin6Driver.o readArray.o writeArray.o getSum.o getMin.o 
;          getMax.o getMean.o getVariance.o getStandardDeviation.o getGeometricMean.o mergeArrays.o debug.o
;
;  
;----------------------------------------------------------------------------------------------------------------------

                                        ; Declare external functions (full descriptions can be found within each module)
        
extern printf, scanf, readArray, writeArray, getSum, getMin, getMax
extern getMean, getVariance, getStandardDeviation, getGeometricMean, mergeArrays

segment .data                           ; Initialized data
;
    welcome         db "This program acts as a Statistical Analyzer", 10, 0
    bye             db "Statistical analysis will now terminate and return to the main driver.", 10, 0  

    msgArray        db "The array is:", 10, 0
    msgFirstArray   db "Enter data for the first array: ", 0    
    msgSecondArray  db "Enter data for the second array: ", 0
    msgCatArray     db "The concatenated array is: ", 0
    msgSum          db "The sum is ", 0
    msgMin          db "The smallest value is ", 0
    msgMax          db "The largest value is ", 0
    msgMean         db "The arithmetic mean is ", 0
    msgVariance     db "The sample variance is ", 0
    msgStdDev       db "The sample standard deviation is ", 0
    msgGeoMean      db "The geometric mean is ", 0
    msgData1        db "First Array Statistical Analysis", 10, 0
    msgData2        db "Second Array Statistical Analysis", 10, 0

    stringFormat    db "%s", 0  
    floatIN         db "%lf", 0
    floatOUT        db "%-#19.19lf", 0
    floatOUT2       db "%-#19.19lf", 0
    newline         db 10, 0
;

segment .bss                            ; Un-initialized data  (stored in memory)
;
    floatArray1     resq 50             ; Reserve space for the first array of 50 maximum floats.
    floatArray2     resq 50             ; Reserve space for the second array of 50 maximum floats.
    mergedArray     resq 1              ; A pointer variable that will hold the address to the mergedArray. 
    counter1        resq 1              ; The total number of elements in the first array.
    counter2        resq 1              ; The total number of elements in the second array.
    counter3        resq 1              ; The total number of elements in the concatenated array.
    sum             resq 1              ; The sum of all elements in an array.
    min             resq 1              ; The smallest value in the array.
    max             resq 1              ; The largest value in the array.
    mean            resq 1              ; The mean (average) of all elements in the array.
    variance        resq 1              ; The variance of all elements in the array.
    stdDev          resq 1              ; The standard deviation of all elements in the array.
    geoMean         resq 1              ; The geometric mean of all elements in the array.
;

segment .text                           ; Begin executable code
;

global mainASM
mainASM:

; Safe programming practices: Save the caller frame and some registers that may be used during this program.

    push    rbp                         ; Save point to the caller frame.
    mov     rbp, rsp                    ; Set our frame.

    push    rdi                         ; It's best to push an even number of registers which helps avoid any
    push    rsi                         ;   problems when doing I/O on the FP stack.  If for some reason segmentaion
                                        ;   faults continue, then try playing around with more/less pushes.
; Populate the first array

    mov     qword [counter1], 0         ; Zero out counter1.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgFirstArray          ; Prepare msgFirstArray for printf.
    call    printf                      ; Print "Enter data for the first array: "

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, 50                     ; Move the max size of the array into rsi.
    mov     rdx, counter1               ; Move address of counter1 into rdx.
    call    readArray                   ; Call external module to read data into the first array.

; Populate the second array

    mov     qword [counter2], 0         ; Zero out counter2.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgSecondArray         ; Prepare msgSecondArray for printf.
    call    printf                      ; Print "Enter data for the second array: ".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.
    mov     rsi, 50                     ; Move the max size of the array into rsi
    mov     rdx, counter2               ; Move address of counter2 into rdx.
    call    readArray                   ; Call external module to read data into the second array.
    
; FIRST ARRAY - Statistical Data

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgData1               ; Prepare msgData1 for printf.
    call    printf                      ; Print "First Array Statistical Analysis".

; 1a) Output each component of the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgArray               ; Prepare msgArray for printf.
    call    printf                      ; Print "The array is".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi. 
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    call    writeArray                  ; Call external module to print out the array.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 2a) Output the sum of the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    call    getSum                      ; Call getSum to calculate the sum of the first array.

    movsd   [sum], xmm0                 ; getSum returns a double, which is in xmm0.  Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgSum                 ; Prepare msgSum for printf.
    call    printf                      ; Print "The sum is".

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for  printf
    movsd   xmm0, [sum]                 ; Move the sum (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the sum.

; 3a) Output the smallest value in the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMin                 ; Prepare msgMin for printf.
    call    printf                      ; Print "The smallest value is "

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    call    getMin                      ; Call external module to find the smallest value in the array.

    movsd   [min], xmm0                 ; getMin returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for  printf.
    movsd   xmm0, [min]                 ; Move min (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the smallest value in the array.

; 4a) Output the largest value in the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMax                 ; Prepare msgMax for printf.
    call    printf                      ; Print "The largest value is ".
    
    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi. 
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    call    getMax                      ; Call external module to find the largest value in the array.

    movsd   [max], xmm0                 ; getMax returns a double, which is xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for printf.
    movsd   xmm0, [max]                 ; Move max (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the largest value in the array.

; 5a) Output the arithmetic mean of the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMean                ; Prepare msgMean for printf.
    call    printf                      ; Print "The arithmetic mean is ".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    call    getMean                     ; Call external module to find the arithmetic mean of the array.

    movsd   [mean], xmm0                ; getMean returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [mean]                ; Move mean (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the arithmetic mean.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 6a) Output the sample variance of the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgVariance            ; Prepare msgVariance for printf.
    call    printf                      ; Print "The variance is ".

    mov     qword rax, 1                ; Tell getVariance to expect 1 floating point number. 
    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    movsd   xmm0, [mean]                ; Move mean (a double) into xmm0 to prepare for function call.
    call    getVariance                 ; Call external module to calculate the variance of the array.

    movsd   [variance], xmm0            ; getVariance returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [variance]            ; Move variance (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the variance.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 7a) Output the sample standard deviation of the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, variance               ; Move the address of variance into rdi.

;======================================================================================
;
; NOTE: In this previous step, "mov rdi, variance", I chose to pass the address of the
;   variance to getStandardDeviation.  Normally, I should have passed the value
;   via xmm0, but after trying multiple times to retrieve the value from xmm0
;   inside of the getStandardDeviation module, it would not work.  I kept getting
;   garbage.  So, in the interest of my sanity and to save time I had to find an
;   alternative method.  Whether or not this is acceptable is for you to decide,
;   Professor, but the problem was solved none-the-less!
;
;======================================================================================

    call    getStandardDeviation        ; Call external module to calculate the standard deviation.

    movsd   [stdDev], xmm0              ; getStandardDeviation returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgStdDev              ; Prepare msgStdDev for printf.
    call    printf                      ; Print "The standard deviation is ".

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [stdDev]              ; Move stdDev (a double) into xmm0 to prepare for printf.
    call    printf                      ; Print out the standard deviation.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.
    
; 8a) Output the geometric mean of the first array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    call    getGeometricMean            ; Call external module to calculate the geometric mean.

    movsd   [geoMean], xmm0             ; getGeometricMean returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgGeoMean             ; Prepare msgGeoMean for printf.
    call    printf                      ; Print "The geometric mean is ". 

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for printf.
    movsd   xmm0, [geoMean]             ; Move geoMean (a double) into xmm0 to prepare for printf.
    call    printf                      ; Print out the geometric mean.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; SECOND ARRAY - Statistical Data

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgData2               ; Prepare msgData2 for printf.
    call    printf                      ; Print "Second Array Statistical Analysis".

; 1b) Output each component of the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgArray               ; Prepare msgArray for printf.
    call    printf                      ; Print "The array is".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.    
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    writeArray                  ; Call external module to print out the array.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 2b) Output the sum of the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    getSum                      ; Call getSum to calculate the sum of the second array.

    movsd   [sum], xmm0                 ; getSum returns a double, which is in xmm0.  Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgSum                 ; Prepare msgSum for printf.
    call    printf                      ; Print "The sum is".

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for  printf
    movsd   xmm0, [sum]                 ; Move the sum (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the sum.
        
; 3b) Output the smallest value in the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMin                 ; Prepare msgMin for printf.
    call    printf                      ; Print "The smallest value is "

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    getMin                      ; Call external module to find the smallest value in the array.

    movsd   [min], xmm0                 ; getMin returns a double, which is in xmm0. Save this for later..

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for  printf.
    movsd   xmm0, [min]                 ; Move min (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the smallest value in the array.

; 4b) Output the largest value in the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMax                 ; Prepare msgMax for printf.
    call    printf                      ; Print "The largest value is ".
    
    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi. 
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    getMax                      ; Call external module to find the largest value in the array.

    movsd   [max], xmm0                 ; getMax returns a double, which is xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for printf.
    movsd   xmm0, [max]                 ; Move max (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the largest value in the array.

; 5b) Output the arithmetic mean of the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMean                ; Prepare msgMean for printf.
    call    printf                      ; Print "The arithmetic mean is ".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    getMean                     ; Call external module to find the arithmetic mean of the array.

    movsd   [mean], xmm0                ; getMean returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2            ; Prepare double output formatting for  printf.
    movsd   xmm0, [mean]                ; Move mean (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the arithmetic mean.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 6b) Output the sample variance of the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgVariance            ; Prepare msgVariance for printf.
    call    printf                      ; Print "The variance is ".

    mov     qword rax, 1                ; Tell getVariance to expect 1 floating point number. 
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    movsd   xmm0, [mean]                ; Move mean (a double) into xmm0 to prepare for function call.
    call    getVariance                 ; Call external module to calculate the variance of the array.

    movsd   [variance], xmm0            ; getVariance returns a double, which is in xmm0. Save this for later

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [variance]            ; Move variance (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the variance.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 7b) Output the sample standard deviation of the second array

    mov     qword rax, 1                ; Zero out rax.
    mov     rdi, variance               ; Move the address of variance into rdi.
    call    getStandardDeviation        ; Call external module to calculate the standard deviation.

    movsd   [stdDev], xmm0              ; getStandardDeviation returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgStdDev              ; Prepare msgStdDev for printf.
    call    printf                      ; Print "The standard deviation is ".

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [stdDev]              ; Move stdDev (a double) into xmm0 to prepare for printf.
    call    printf                      ; Print out the standard deviation.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.
    
; 8b) Output the geometric mean of the second array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, floatArray2            ; Move the address of the second array into rdi.
    mov     rsi, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    getGeometricMean            ; Call external module to calculate the geometric mean.

    movsd   [geoMean], xmm0             ; getGeometricMean returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgGeoMean             ; Prepare msgGeoMean for printf.
    call    printf                      ; Print "The geometric mean is ". 

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for printf.
    movsd   xmm0, [geoMean]             ; Move geoMean (a double) into xmm0 to prepare for printf.
    call    printf                      ; Print out the geometric mean.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; CONCATENATE BOTH ARRAYS

    mov     rdi, floatArray1            ; Move the address of the first array into rdi.
    mov     rsi, floatArray2            ; Move the address of the second array into rdi.
    mov     rdx, [counter1]             ; Move the value of counter1 (an integer) into rsi.
    mov     rcx, [counter2]             ; Move the value of counter2 (an integer) into rsi.
    call    mergeArrays                 ; Call external module to combine array 1 and 2 into a new array.

    mov     r14, rax                    ; The address of the new array is in rax, move this to r14.
    mov     qword [mergedArray], r14    ; Move the address from the previous step into a variable for later use.
    mov     [counter3], rdi             ; The total number of elements of the new array is in rdi. Save this for later. 

; CONCATENATED ARRAY - Statistical Data

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgCatArray            ; Prepare msgCatArray for printf.
    call    printf                      ; Print "Concatenated Statistical Analysis".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 1c) Output each component of the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgArray               ; Prepare msgArray for printf.
    call    printf                      ; Print "The array is".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi.   
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    call    writeArray                  ; Call external module to print out the array.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 2c) Output the sum of the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi.
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    call    getSum                      ; Call getSum to calculate the sum of the new array.

    movsd   [sum], xmm0                 ; getSum returns a double, which is in xmm0.  Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgSum                 ; Prepare msgSum for printf.
    call    printf                      ; Print "The sum is".

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for  printf
    movsd   xmm0, [sum]                 ; Move the sum (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the sum.

; 3c) Output the smallest value in the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMin                 ; Prepare msgMin for printf.
    call    printf                      ; Print "The smallest value is "

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi.
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    call    getMin                      ; Call external module to find the smallest value in the array.

    movsd   [min], xmm0                 ; getMin returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for  printf.
    movsd   xmm0, [min]                 ; Move min (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the smallest value in the array.

; 4c) Output the largest value in the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMax                 ; Prepare msgMax for printf.
    call    printf                      ; Print "The largest value is ".
    
    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi. 
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    call    getMax                      ; Call external module to find the largest value in the array.

    movsd   [max], xmm0                 ; getMax returns a double, which is xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT         ; Prepare double output formatting for printf.
    movsd   xmm0, [max]                 ; Move max (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the largest value in the array.

; 5c) Output the arithmetic mean of the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgMean                ; Prepare msgMean for printf.
    call    printf                      ; Print "The arithmetic mean is ".

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi.
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    call    getMean                     ; Call external module to find the arithmetic mean of the array.

    movsd   [mean], xmm0                ; getMean returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [mean]                ; Move mean (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the arithmetic mean.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 6c) Output the sample variance of the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgVariance            ; Prepare msgVariance for printf.
    call    printf                      ; Print "The variance is ".

    mov     qword rax, 1                ; Tell getVariance to expect 1 floating point number. 
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi.
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    movsd   xmm0, [mean]                ; Move mean (a double) into xmm0 to prepare for function call.
    call    getVariance                 ; Call external module to calculate the variance of the array.

    movsd   [variance], xmm0            ; getVariance returns a double, which is in xmm0. Save this for later

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [variance]            ; Move variance (a double) into xmm0 to prepare printf.
    call    printf                      ; Print out the variance.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; 7c) Output the sample standard deviation of the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, variance               ; Move the address of variance into rdi.
    call    getStandardDeviation        ; Call external module to calculate the standard deviation.

    movsd   [stdDev], xmm0              ; getStandardDeviation returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgStdDev              ; Prepare msgStdDev for printf.
    call    printf                      ; Print "The standard deviation is ".

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number.
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for  printf.
    movsd   xmm0, [stdDev]              ; Move stdDev (a double) into xmm0 to prepare for printf.
    call    printf                      ; Print out the standard deviation.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.
    
; 8c) Output the geometric mean of the new array

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, [mergedArray]          ; Move the address of the new array into rdi.
    mov     rsi, [counter3]             ; Move the value of counter2 (an integer) into rsi.
    call    getGeometricMean            ; Call external module to calculate the geometric mean.
        
    movsd   [geoMean], xmm0             ; getGeometricMean returns a double, which is in xmm0. Save this for later.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, msgGeoMean             ; Prepare msgGeoMean for printf.
    call    printf                      ; Print "The geometric mean is ". 

    mov     qword rax, 1                ; Tell printf to expect 1 floating point number
    mov     qword rdi, floatOUT2        ; Prepare double output formatting for printf.
    movsd   xmm0, [geoMean]             ; Move geoMean (a double) into xmm0 to prepare for printf.
    call    printf                      ; Print out the geometric mean.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

; Print goodbye message
    
    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf  

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, newline                ; Prepare newline for printf.
    call    printf                      ; Print a newline.

    mov     qword rax, 0                ; Zero out rax.
    mov     rdi, stringFormat           ; Prepare string formatting for printf.
    mov     rsi, bye                    ; Prepare
    call    printf                      ; Print 

; Restore all registers and the caller frame.

    pop     rsi                         ; Restore rsi
    pop     rdi                         ; Restore rdi

    mov     rsp, rbp                    ; Restore the caller frame
    pop     rbp

    mov     qword rax, 0                ; Return 0 to the operating system if the program executes successfully
    ret                                 ; End program
;


