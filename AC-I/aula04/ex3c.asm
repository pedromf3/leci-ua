	.data
	.eqv	SIZE, 4 	#define SIZE 4
	.eqv 	print_int10, 1
array:	.word	7692, 23, 5, 234	# int array[4] = {7692, 23, 5, 234}; // Declara um array global de 4
	
	.text
	.globl main

# mapa de registos
# i -> $t0
# &array -> $t1
# array[i] -> $t2
# soma -> $t3
# SIZE -> $t4

main:	#void main (void){
	li 	$t3,	0	#int soma = 0;
	la 	$t1,	array
	li	$t4, 	SIZE
	li	$t0,	0
	
while:	#while( i <= SIZE ){
	bge	$t0,	$t4,	endw
	sll	$t2,	$t0,	2
	add	$t2,	$t2,	$t1
	lw	$t2,	0($t2)	
	addu	$t3, 	$t3,	$t2 	# soma = soma + array[i]
	addiu	$t0,	$t0, 	1	# i++
	j 	while
endw:	#}
	li 	$v0, 	print_int10
	move	$a0,	$t3
	syscall
	#print_int10(soma);
	li 	$v0, 	0	
	jr	$ra	#}