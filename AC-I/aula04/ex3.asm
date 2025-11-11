	.data
	.eqv	SIZE, 4 	#define SIZE 4
	.eqv 	print_int10, 1
array:	.word	7692, 23, 5, 234	# int array[4] = {7692, 23, 5, 234}; // Declara um array global de 4
	
	.text
	.globl main

# mapa de registos
# p -> $t0
# pultimo -> $t1
# *p -> $t2
# soma -> $t3
# SIZE -> $t4

main:	#void main (void){
	li 	$t3,	0	#int soma = 0;
	la 	$t0,	array	#p = array; // "p" é preenchido com o endereço
	li	$t4, 	SIZE
	addi	$t4,	$t4,	-1	#pultimo=array+SIZE-1; // "pultimo" é inicializado com o endereço do último elemento do
	sll	$t4,	$t4, 	2	#// array, i.e., &array[SIZE-1]
	add	$t1,	$t0,	$t4	
	
while:	#while( p <= pultimo ){
	bgt	$t0,	$t1,	endw
	lw	$t2,	0($t0)	
	addu	$t3, 	$t3,	$t2 	#soma = soma + (*p);
	addiu	$t0,	$t0, 	4	#p++;
	j 	while
endw:	#}
	li 	$v0, 	print_int10
	move	$a0,	$t3
	syscall
	#print_int10(soma);
	li 	$v0, 	0	
	jr	$ra	#}