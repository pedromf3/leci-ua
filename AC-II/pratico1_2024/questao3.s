    .data
    .equ ADDR_BASE_HI,0xBF88    # Base address: 16 MSbits 
    .equ TRISE,0x6100           # TRISE address is (0xBF88)6100 
    .equ PORTE,0x6110           # PORTE address is (0xBF88)6110 
    .equ LATE, 0x6120           # LATE  address is (0xBF88)6120
    .text
    .globl main

main:
    lui     $t0, ADDR_BASE_HI 
    lw      $t1, TRISE($t0) 
    andi    $t1, $t1, 0xFFC1    # 1111 1111 1100 0001
    sw      $t1, TRISE($t0)

    li      $t2, 0x0001

while:

    lw      $t1, LATE($t0)
    andi    $t1, $t1, 0xFFC1 
    sll     $t3, $t2, 1
    
    or      $t1, $t1, $t3
    sw      $t1, LATE($t0)   

    li      $v0, 6
    move    $a0, $t2
    li      $a1, 0x00050002 
    syscall

    li      $v0, 3
    li      $a0, '\n'
    syscall

    li      $v0, 12             # resetCoreTimer
    syscall

wait:
    li      $v0, 11             # readCoreTimer
    syscall
    blt		$v0, 8695652, wait

    sll     $t2, $t2, 1
    srl	    $t5, $t2, 5
    or      $t2, $t5, $t2
    andi    $t2, $t2, 0x001F   # 0000 0000 0001 1111    
    
    j		while
    jr      $ra
    