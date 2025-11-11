	.data
	.eqv	SIZE, 5 #define SIZE 10
	.eqv	printdouble, 3
	.eqv	readdouble, 7
k1:	.double 0.0
	.align 3
array:	.space 80
	.text
	.globl main
	
main:	# int main(void){
	# static double a[SIZE];
	# int i;
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)
	li	$t0, 	0	
	
for:
	bge	$t0,	SIZE, 	endfor # for(i = 0; i < SIZE; i++){
	
	la	$t1,	array
	sll	$t2,	$t0,	3
	addu	$t1,	$t1,	$t2
	
	li	$v0,	readdouble
	syscall
	
	s.d	$f0,	0($t1)				# a[i] = read_double();
	addiu	$t0,	$t0,	1
	j	for
	
endfor:		#}

	la	$a0,	array
	li	$a1,    SIZE
	jal	average
	mov.d	$f12,	$f0
	
	li	$v0,	printdouble
	syscall		# print_double( average(a, SIZE) );
	
	li	$v0,	0  #return 0;
	
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra	#}

average:	# double average(double *array, int n){	
#	move	$t2,	$a0	
	addi	$t0,	$a1,	-1		# int i = n-1;
	la	$t1,	k1
	l.d	$f2,	0($t1)	# double sum = 0.0;

for2:		# for(; i >= 0; i--)
	blt	$t0,	$0, 	endfor2	# {
	sll	$t1,	$t0,	3
	addu	$t1,	$t1,	$a0
	l.d	$f4,	0($t1)
	add.d	$f2,	$f4,	$f2	#sum += array[i];
	addi	$t0,	$t0,	-1
	j	for2
endfor2:		#}

	mtc1	$a1,	$f6
	cvt.d.w	$f6,	$f6	# (float)val
	div.d	$f0,	$f2,	$f6 # return sum / (double)n;
	jr	$ra	# }
	