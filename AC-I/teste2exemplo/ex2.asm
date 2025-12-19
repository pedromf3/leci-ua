	.data
k1:	.float 	-1.0 	# oldg
k2:	.float 	1.0	# g
k3:	.float	0.0	# s
	.text
	.globl func2
	
func2:
	la	$t0,	k1
	l.s	$f2,	0($t0)	# oldg
	la	$t0,	k2
	l.s	$f4,	0($t0)	# g
	la	$t0,	k3
	l.s	$f6,	0($t0)	# s
	
	li	$t0,	0
for:
	bge	$t0,	$a1,	endfor
	
	sll	$t5,	$t0,	2
	add	$t5,	$a0,	$t5
	l.s	$f10, 	0($t5)
while:
	sub.s	$f18,	$f4,	$f2
	c.le.s	$f18,	$f12
	bc1t	endw
	mov.s	$f2,	$f4
	
	add.s	$f4,	$f4,	$f10
	div.s	$f4,	$f4,	$f12
	
	j	while
endw:
	add.s	$f6,	$f6,	$f4
	s.s	$f4,	0($t5)	
	
	addi	$t0,	$t0,	1
	j	for
endfor:
	mtc1	$a1,	$f8
	cvt.s.w	$f8,	$f8
	div.s	$f0,	$f6,	$f8

	jr	$ra