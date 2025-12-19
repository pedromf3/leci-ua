# Mapa de registos:
# f1: $a0 -> $s3
# k: $a1 -> $s1
# av: $a2 -> $s2
# i: $s0
# res: $t0
# **************************************************
        .data
        .eqv    SIZE, 15
str1:   .asciiz "Invalid argc"
        .text
        .globl  func1
func1:
        addiu   $sp, 	$sp,	 -20
        sw      $ra, 	0($sp)
        sw      $s2, 	4($sp)
        sw      $s1, 	8($sp)
        sw      $s0, 	12($sp)
        sw	$s3,	16($sp)

        move    $s1, $a1
        move    $s2, $a2
        move    $s3, $a0

if:
        blt     $s1, 2, else
        bgt     $s1, SIZE, else
        li      $s0, 2
do:
	sll     $t0, $s0, 2      # $t0 = i * 4
        addu    $t1, $s2, $t0    
        lw      $a0, 0($t1)
        jal     toi

	sll	$t0,	$s0,	2
        addu    $t1, $s3, $t0   
        sw      $v0, 0($t1)

        addiu   $s0, $s0, 1
while:  
	blt     $s0, $s1, do
        move    $a0, $s3
        move    $a1, $s1
        jal     avz

        move    $t0,	$v0
        move 	$a0,	$t0
        li      $v0, 1
        syscall

        j       endif
else:
        li      $v0, 4
        la      $a0, str1
        syscall
        li      $t0, -1
        
        move 	$v0,	$t0

endif:
        move    $v0, $t0
        lw      $ra, 0($sp)
        lw      $s2, 4($sp)
        lw      $s1, 8($sp)
        lw      $s0, 12($sp)
        lw	$s3, 	16($sp)
        addiu   $sp, $sp, 20

        jr      $ra