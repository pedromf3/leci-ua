# mapa de registos
# i: $t0
# lista: $t1
# lista + i: $t2
	.data
	.eqv	SIZE, 5	# define SIZE 5
lista:	.space	20	# reserva espaço para lista[SIZE]
str:	.asciiz "\nIntroduza um numero:"
	.align	2
	.text
	.globl main
	
main:		# void main(void){
	li	$t0,	0	#int i;
	li 	$t3, 	SIZE 
for: 	
	bge	$t0,	$t3,	endf #for(i=0; i < SIZE; i++){

	la 	$a0,	str
	li 	$v0,	4
	syscall			#print_string(str);
	
	li 	$v0,	5
	syscall
	
	la	$t1,	lista 		# endereço da lista para $t1
	sll	$t2,	$t0,	2	# 
	addu 	$t2,	$t1,	$t2
	sw	$v0,	0($t2)
	addi	$t0, 	$t0,	1	#lista[i] = read_int();

	j	for
endf:			#}
	jr	$ra	#}
	
