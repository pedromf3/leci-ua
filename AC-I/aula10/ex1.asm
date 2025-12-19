	.data
result:	.float 1.0
x:	.float 3
	.eqv	print_float, 2
	.text
	.globl main
	
# mapa de registos
# x:  $f12  -> $f20
# y:  $a0 -> $s0
# i:  $t0
# result: $f0
#abs(y):  $t1
	
main:
	addiu	$sp,	$sp,	-4	# safeguard $ra
	sw	$ra,	0($sp)
	li	$a0,	2	# exp
	la	$t0,	x	
	l.s	$f12,	0($t0)	# float = 3 (base)
	
	jal	xtoy	
	
	mov.s	$f12,	$f0	
	li	$v0,	print_float
	syscall			# print float
	
	lw	$ra,	0($sp)
	addiu	$sp,	$sp,	4

	jr	$ra
	
	
xtoy:
	addiu	$sp,	$sp,	-12 	# safeguard $ra
	sw	$ra,	0($sp)
	sw	$s0,	4($sp)
	s.s	$f20,	8($sp)
	
	move	$s0,	$a0		# int y
	mov.s	$f20,	$f12		# float x
	
	
	li	$t0,	0		# int i = 0
	la	$t2,	result
	l.s	$f0,	0($t2)		# result = 1.0
	jal	abs			# abs(y)
	move	$t1,	$v0
for:	
	bge	$t0,	$t1,	endfor  # for(i=0, result=1.0; i < abs(y); i++)
	
if1:					
	ble	$s0,	$0,	else    # if(y > 0)
	mul.s	$f0,	$f0,	$f20	# result *= x;
	j	endif1
else:					# else
	div.s	$f0,	$f0,	$f20	# result /= x;

endif1:
		
	addiu	$t0,	$t0,	1	# i++		
	j	for
endfor:
	
	lw	$ra,	0($sp)
	lw	$s0,	4($sp)
	l.s	$f20,	8($sp)	
	addiu	$sp,	$sp,	12
	

	jr 	$ra
	
abs:
if:	bge	$a0,	$0,	endif	# if(val < 0)
	sub	$a0,	$0,	$a0	# val = -val;
endif:
	move 	$v0,	$a0		# return val;
	
	jr	$ra
	
