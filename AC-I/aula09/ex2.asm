	.data
	.eqv	readdouble, 7
	.eqv	printdouble, 3
k1:	.double	5.0
k2:	.double	9.0
k3:	.double	32.0
	.text
	.globl main
	
main:
   	addiu $sp, $sp, -4
    	sw    $ra, 0($sp)
    	
	li	$v0,	readdouble
	syscall
	mov.d	$f12,	$f0
	jal	f2c
	
	mov.d	$f12,	$f0
	li	$v0,	printdouble
	syscall
	
	lw    $ra, 0($sp)
   	addiu $sp, $sp, 4
    	
	li	$v0,	0
	jr	$ra
	
f2c:		# double f2c(double ft) {
	mov.d	$f0, 	$f12	
	la	$t0,	k1
	la	$t1,	k2
	la	$t2,	k3
	l.d	$f2,	0($t0)
	l.d	$f4,	0($t1)
	l.d	$f6,	0($t2)
	
	sub.d	$f0,	$f0,	$f6
	mul.d	$f0,	$f2,	$f0
	div.d	$f0,	$f0,	$f4		# return (5.0 / 9.0 * (ft – 32.0));
	# }
	
	jr	$ra	
	
	
