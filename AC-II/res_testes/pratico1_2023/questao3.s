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
    andi    $t1, $t1, 0xFF83    # 1111 1111 1000 0011  
    sw      $t1, TRISE($t0)

    li      $t2, 0
    
while: 
    lw      $t1, LATE($t0)
    sll     $t3, $t2, 2  
    andi    $t1, $t1, 0xFF83    
    or      $t1, $t1, $t3        
    sw      $t1, LATE($t0)       

    move    $a0, $t2
    li      $a1, 0x00050002 
    li      $v0, 6
    syscall

    li      $v0, 3
    li      $a0, '\n'
    syscall

    li      $v0, 12
    syscall
wait:
    li      $v0, 11
    syscall
    blt     $v0, 4347826, wait

    beq	    $t2, 0, max
    addi	$t2, $t2, -1
    j		while
    
max:
    li      $t2, 24
    j       while
    jr      $ra

