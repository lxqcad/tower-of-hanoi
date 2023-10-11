; Tower of Hanoi using recursion for LC3
    .ORIG x3000
; Display message
    LEA R0, Welcome
    TRAP x22

; Read the number of disks
    TRAP x23
    LD R3, AsciiZero
    ADD R2, R0, R3 ; Number of disks in R2

; Check negative number of Disks
    AND R1, R1, #0
    ADD R1, R1, #-1
    ADD R1, R1, R2
    BRnz Error

    LEA R3, Post1 ; R3 represents post1
    LEA R4, Post2 ; R4 is the middle post
    LEA R5, Post3 ; R5 represents post3
    LD R6, Stack  ; Load Stack Address

    STR R2, R6, #3 ; push the number of disks
    STR R3, R6, #4 ; push post1
    STR R4, R6, #5 ; push post2
    STR R5, R6, #6 ; push post3

    ; SUB(n, post1, post2, post3)
    JSR SUB
    HALT

; Hanoi Subroutine
SUB
    STR R7, R6, #1 ; push the return address

    LDR R2, R6, #3 ; get the number of disks
    LDR R3, R6, #4 ; get post1
    LDR R4, R6, #5 ; get post2
    LDR R5, R6, #6 ; get post3

    ; Check if n == 1, if yes return
    AND R1, R1, #0
    ADD R1, R1, #-1
    ADD R1, R1, R2
    BRz DisplayAndReturn

    ADD R2, R2, #-1

    STR R6, R6, #9 ; push the current frame pointer
    ADD R6, R6, #7 ; move the frame pointer

    ; Push the values to stack before recursion
    STR R2, R6, #3
    STR R3, R6, #4
    STR R5, R6, #5
    STR R4, R6, #6

    ; SUB(n-1, post1, post3, post2)
    JSR SUB

    ; restore register values from the stack
    LDR R2, R6, #3
    LDR R3, R6, #4
    LDR R4, R6, #5
    LDR R5, R6, #6

    JSR Display

    ADD R2, R2, #-1

    STR R6, R6, #9 ; push the current frame pointer
    ADD R6, R6, #7 ; move the frame pointer

    ; Push the values to stack before recursion
    STR R2, R6, #3
    STR R4, R6, #4
    STR R3, R6, #5
    STR R5, R6, #6

    ; SUB(n-1, post2, post1, post3)
    JSR SUB

    LDR R7, R6, #1 ; restore the return address
    LDR R6, R6, #2 ; restore the previous frame pointer
    RET

; Display Negative Value Error
Error
    LEA R0, NegVal
    TRAP x22
    HALT

Display
    ST R7, LocR7
    ; Source Post
    AND R0, R0, #0
    ADD R0, R0, R3
    TRAP x22

    LEA R0, StringTo
    TRAP x22

    ; Destination
    AND R0, R0, #0
    ADD R0, R0, R5
    TRAP x22

    ; Newline character
    AND R0, R0, #0
    ADD R0, R0, xA
    TRAP x21
    LD R7, LocR7

    RET

DisplayAndReturn
    JSR Display
    LDR R7, R6, #1 ; restore the return address
    LDR R6, R6, #2 ; restore the previous frame pointer
    RET
LocR7
    .BLKW 1
Welcome
    .STRINGZ "Instructions for moving 'n' disks from Post 1 to Post 3: "
StringTo
    .STRINGZ " to "
Post1
    .STRINGZ "Post 1"
Post2
    .STRINGZ "Post 2"
Post3
    .STRINGZ "Post 3"
Stack
    .FILL x5000
AsciiZero
    .FILL xFFD0 ; -48
NegVal
    .STRINGZ "\nNo negative values\n"

    .END