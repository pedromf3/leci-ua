	.data
val:	.double 9.0
xn:	.double 1.0
k1:	.double 0.0
k2:	.double 0.5
	.eqv 	print_double, 3
	.text
	.globl main
	
# mapa de registos
# aux:  $f2
# xn:	$f4
# i:	$t0
# 0.0:	$f6
# 0.5	$f8

main:
	addiu	$sp,	$sp,	-4
	sw	$ra,	0($sp)
	
	la	$t0,	val
	l.d	$f12,	0($t0)
	jal	sqrt
	
	mov.d	$f12,	$f0
	li	$v0,	print_double
	syscall
	
	lw	$ra,	0($sp)
	addiu	$sp,	$sp,	4
	
	jr	$ra
	
sqrt:
	la	$t0,	xn
	l.d	$f4,	0($t0)
	li	$t0,	0
	
	la	$t1,	k1
	l.d	$f6,	0($t1)
	
	la	$t1,	k2
	l.d	$f8,	0($t1)
	
if:
	c.le.d	$f12,	$f6
	bc1t	else
	
do:
	mov.d	$f2,	$f4
	div.d 	$f10,	$f12,	$f4
	add.d	$f4,	$f4,	$f10
	mul.d	$f4,	$f8 ,	$f4
	
while:
	c.eq.d	$f2,	$f4
	bc1t	enddo
	addiu	$t0,	$t0,	1
	bge	$t0,	25,	enddo
	j	do
enddo:
	
	j	endif
	
else:
	mov.d	$f4,	$f6

endif:	
	mov.d	$f0,	$f4
	 jr	$ra
