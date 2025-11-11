# mapa de registos
# val: $t0
# n: $t1
# min: $t2
# max: $t3
	.data
	.eqv print_str, 4
	.eqv print_int, 1
	.eqv print_char, 11
	.eqv read_int, 5
str1:	.asciiz	"Digite ate 20 inteiros (zero para terminar)"
str2:	.asciiz	"Maximo/minimo sao: "
	.text
	.globl 	main

main:
	li	$t2,	0x7FFFFFFF
	li	$t3,	0x80000000
	li	$t1, 	0
	
	li	$v0, 	print_str
	la	$a0,	str1
	syscall
	
do:
	li	$v0,	read_int
	syscall
	move	$t0,	$v0
if:
	beq	$t0,	0,	endif
	
if2:	
	ble	$t0,	$t3,	endif2
	move	$t3,	$t0
endif2:

if3:	
	bge	$t0,	$t2,	endif3
	move	$t2,	$t0
endif3:

endif:
	addiu 	$t1,	$t1,	1
	bge	$t1,	20,	enddo
	beq	$t0,	0,	enddo
	j	do
enddo:
	
	li	$v0, 	print_str
	la	$a0,	str2
	syscall
	
	li	$v0, 	print_int
	move	$a0,	$t3
	syscall
	
	li	$v0, 	print_char
	li	$a0,	':'
	syscall
	
	li	$v0, 	print_int
	move	$a0,	$t2
	syscall
	
	jr	$ra
	
