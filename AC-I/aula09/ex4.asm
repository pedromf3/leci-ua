	.data
	.eqv	SIZE, 5
str:	.asciiz "Insira um numero: "
str2:	.asciiz	"Valor maximo do array: "
	.align 8
array:	.space 40
	.text
	.globl main
	
main:	
	addiu	$sp,	$sp,	-4
	sw	$ra,	0($sp)
	
	li	$t2, 	0
	la	$t3,	array
for:
	bge	$t2,	SIZE,	endfor
	
	sll	$t4,	$t2,	3
	add	$t4,	$t4,	$t3
	
	la	$a0,	str
	li	$v0, 	4
	syscall
	
	li	$v0,	7
	syscall
	s.d	$f0,	0($t4)
	
	addiu	$t2,	$t2,	1
	j	for
endfor:
	la	$a0,	array
	li	$a1,	SIZE
	jal	max
	
	la	$a0,	str2
	li	$v0, 	4
	syscall
	
	li	$v0,	3
	mov.d	$f12,	$f0
	syscall
	
	li	$v0,	0
	
	lw	$ra,	0($sp)
	addiu	$sp,	$sp,	4
	jr	$ra



max:
	move 	$t0,	$a0
	move	$t1,	$a1
	
	addi	$t1,	$t1,	-1
	sll	$t1,	$t1,	3
	add	$t1,	$t1,	$t0
	
	
	l.d	$f0,	0($t0)
	addiu	$t0,	$t0,	8
	
for2:
	bgt	$t0,	$t1, 	endfor2
if:	
	l.d 	$f2, 	0($t0)
	c.le.d	$f2,	$f0, 	
	bc1t	endif
	mov.d	$f0,	$f2	
endif:
	addiu	$t0,	$t0,	8
	j	for2
endfor2:
	jr	$ra