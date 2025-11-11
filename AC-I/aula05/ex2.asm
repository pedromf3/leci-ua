	.data
	.eqv	SIZE, 10	#define SIZE 10
	.eqv	print_int10, 1
	.eqv	print_str, 4
lista:	.word	8, -4, 3, 5, 124, -15, 87, 9, 27, 15 	#static int lista[]={8, -4, 3, 5, 124, -15, 87, 9, 27, 15};
str:	.asciiz "\nConteudo do array:\n"
point:	.asciiz	"; "
	.text
	.globl main
#mapa de registos
# lista + SIZE -> $t0
# p -> $t1
# *p -> $t2

main:	#void main(void){
	#int *p; // Declara um ponteiro para inteiro (reserva
	#// espaço para o ponteiro, mas não o inicializa)
	la	$t1,	lista	#p
	li	$t0, 	SIZE
	sll	$t0,	$t0, 	2
	
	li	$v0,	print_str
	la 	$a0,	str
	syscall		#print_string("\nConteudo do array:\n");
	
	add	$t0,	$t0,	$t1		# lista + SIZE
for:		#for(p = lista; p < lista + SIZE; p++) {
	bge	$t1,	$t0,	endfor
	lw	$t2,	0($t1)
	
	move 	$a0,	$t2
	li	$v0,	print_int10
	syscall		#print_int10( *p ); // Imprime o conteúdo da posição do array cujo endereço é "p"
	
	li	$v0,	print_str
	la 	$a0,	point
	syscall	#print_string("; ");
	
	addiu	$t1, 	$t1,	4
	j	for
endfor:	#}
	li    $v0, 0
	jr	$ra
#}