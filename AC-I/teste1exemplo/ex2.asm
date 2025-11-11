# mapa de registos
# i $t0
# v $t1
# val $t2
# val[i] $t3
# val[i+SIZE/2] $t4
# SIZE/2 $t5
# SIZE $t6
# aux $t8
	.data
	.eqv print_str, 4
	.eqv print_int, 1
	.eqv print_char, 11
	.eqv	SIZE, 8
val:	.word   8, 4, 15, -1987, 327, -9, 27, 16
str:	.asciiz	"Result is: "
	.text
	.globl main
	
main:
	li	$t0,	0
	la	$t2,	val
	li	$t6,	SIZE
do:
	sll	$t3,	$t0,	2
	addu	$t3,	$t2,	$t3
	lw 	$t1,	0($t3)
	
	srl	$t5,	$t6,	1
	sll	$t7,	$t5,	2
	sll	$t4,	$t0,	2
	addu	$t4,	$t7,	$t4
	addu	$t4,	$t2,	$t4
	lw	$t7,	0($t4)
	sw	$t7,	0($t3)
	sw	$t1,	0($t4)
	
	addiu	$t0,	$t0, 	1
	bge	$t0,	$t5,	enddo
	j	do
	
enddo:
	li	$v0, 	print_str
	la	$a0,	str
	syscall
	
	li	$t0,	0
	
do2:
	sll	$t3,	$t0,	2
	addu	$t3,	$t2,	$t3
	lw 	$a0,	0($t3)
	li	$v0, 	print_int
	syscall
	
	addiu	$t0,	$t0,	1

	li	$v0, 	print_char
	li	$a0,	';'
	syscall
	
	bge	$t0,	$t6,	enddo2
	j	do2
	
enddo2:
	jr	$ra
	
	
	
	
	
	
	