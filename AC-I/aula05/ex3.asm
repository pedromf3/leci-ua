# Mapa de registos
# ptr: $t0
# SIZE: $t1
# lista + SIZE: $t2
# aux: $t3
# houve_troca: $t4
# i: $t5
# lista: $t6
# lista + i: $t7
# lista + i + 1: $t8
	.data
	.eqv 	SIZE, 10 	#define SIZE 10
	.eqv	TRUE, 1		#define TRUE 1
	.eqv	FALSE, 0	#define FALSE 0
	.eqv	print_str, 4
	.eqv 	read_int, 5
	.eqv	print_int, 1
	.eqv	print_char, 11
lista:	.space  40	
str1:	.asciiz	"Insere 10 valores inteiros:\n"
str2:	.asciiz "\nArray ordenado:\n"
	.text
	.globl main

main: 	#void main(void){
    	# static int lista[SIZE];
    	# int houveTroca, i, aux;
    	# int *ptr;

    	li	$v0,	print_str 
    	la 	$a0, 	str1
    	syscall		# printf("Insere 10 valores inteiros:\n");
    
	li	$t1,	SIZE	
    	sll	$t1,	$t1,	2 	# SIZE: $t1
    	la	$t6,	lista		# lista: $t6
    	addu	$t2,	$t6, 	$t1	# lista + SIZE: $t2
    	la	$t0,	lista		# ptr = lista: $t0 
    
for:	# for (ptr = lista; ptr < lista + SIZE; ptr++) {
	bge	$t0,	$t2,	endfor
	li	$v0,	read_int # scanf(ptr); 
	syscall
        sw	$v0,	0($t0) 
        addiu 	$t0,	$t0, 	4	# ptr++
        j	for
endfor:	#}

        li	$t1,	SIZE
        addiu	$t1,	$t1, 	-1
do:	#    do {
        li	$t4,	FALSE	# houveTroca = FALSE;
        li	$t5, 	0	# i = 0;
for2:				# for (i = 0; i < SIZE - 1; i++) {
	bge 	$t5,	$t1, 	endfor2
	
	addiu	$t8,	$t5,	1
	sll	$t7,	$t5,	2
	sll	$t8,	$t8,	2
	addu	$t7,	$t7,	$t6
	addu	$t8,	$t8,	$t6
	lw	$t2,	0($t7)		# $t2 = lista[i]
	lw	$t9,	0($t8)		# $t9 = lista[i+1]
if:
       ble	$t2,	$t9, 	endif #   if (lista[i] > lista[i + 1]) {
       move	$t3,	$t2	# aux = lista[i];
       sw	$t9,	0($t7)  # lista[i] = lista[i + 1];
       sw	$t3,	0($t8)  # lista[i + 1] = aux;
       li	$t4,	TRUE    # houveTroca = TRUE;
endif:	# }
	addiu	$t5,	$t5, 	1
	j	for2
endfor2: # }
	bne	$t4, 	TRUE,	enddo	# } while (houveTroca == TRUE);
	j	do

enddo:

    	li	$v0,	print_str 
    	la 	$a0, 	str2
    	syscall	# printf("\nArray ordenado:\n");
    	li	$t5,	0
    	li	$t1,	SIZE
for3:	#for (i = 0; i < SIZE; i++) {
	bge	$t5,	$t1, 	endfor3
	sll	$t3,	$t5, 	2
	addu	$t3,	$t3,	$t6
	lw	$a0,	0($t3)
	li	$v0,	print_int
	syscall #  printf(lista[i]);
	
	li	$a0,	','
	li	$v0,	print_char
	syscall #  printf(lista[i]);
	
	addiu 	$t5, 	$t5,	1
	j	for3
endfor3: 	# }
	li	$v0,	0	#return 0;

	jr 	$ra	#}
