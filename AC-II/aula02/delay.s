    .equ    READ_CORE_TIMER,11
    .equ    RESET_CORE_TIMER,12
    .equ    PUT_CHAR, 3
    .equ    PRINT_INT, 6
    .data
    .text
    .globl main
    
main:
    li  $s0, 0                   #counter = 0
while:                           #while (1){
    li   $a0, '\r'               #putChar('\r')
    li   $v0, PUT_CHAR
    syscall

    move $a0, $s0                #printInt(counter)
    li   $a1, 0x0004000A
    li   $v0, PRINT_INT          #printInt()
    syscall

    li   $a0,  1
    jal  delay
    addi    $t0, $t0, 1     #counter++;}
    j    while

    jr   $ra                 

delay:
    move  $t0, $a0
    li    $v0, RESET_CORE_TIMER
    syscall
    mulou $t1, $t0, 20000
while1:
    li    $v0, READ_CORE_TIMER
    syscall
    blt   $v0, $t1, while1
end:
    li    $v0, 0
    jr    $ra