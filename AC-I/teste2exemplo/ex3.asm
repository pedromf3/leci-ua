#	---------   Alinhamento  -----  Dimensão -----   Offset
# int acc	        4                  4               0
# unsigned char nm      1                  1               4
# double grade          8                  8               5 -> 8
# char quest[14]        1                 14 	           16
# int cq                4                  4               30 -> 32
# t_kvd                 8                 36 -> 40 
	.data
k1:	.double 0.0 
	.text
	.globl func3
	
func3:
	li	$t0, 	0
	move	$t1,	$a1
	la	$t2,	k1
	l.d	$f4,	0($t2)
for:
	li	$t2,	0
	bge	$t0,	$a0,	endfor
do:	
	addi	$t3,	$t1,	16
	add	$t3,	$t3,	$t2
	lbu	$t4,	0($t3)
	
	mtc1	$t4,	$f2
	cvt.d.w	$f2,	$f2
	
	add.d	$f4,	$f4,	$f2
	
	addi	$t2,	$t2,	1
	
	addi	$t3,	$t1,	4
	lbu	$t5,	0($t3)
	bge	$t2,	$t5,	enddo	
	j	do
enddo:
	addi	$t3,	$t1,	8
	l.d	$f6,	0($t3)
	div.d	$f6,	$f4,	$f6
	
	cvt.w.d $f6,	$f6
	mfc1	$t6,	$f6
	
	sw	$t6,	0($t1)

	addi	$t1,	$t1,	40
	addi	$t0,	$t0,	1
	j	for
endfor:
	addi  	$t1, 	$t1	-40
	addi	$t3,	$t1,	8
	l.d	$f6,	0($t3)
		
	addi	$t3,	$t1,	32
	lw	$t7,	0($t3)
	mtc1	$t7,	$f2
	cvt.d.w	$f2,	$f2
	
	mul.d	$f0,	$f2,	$f6

	jr	$ra
