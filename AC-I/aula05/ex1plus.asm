	.data
	.eqv	SIZE, 	10	#define SIZE 10
	.eqv	print_str, 4
	.eqv	print_int, 1
	.eqv	print_char, 11
	.eqv	read_int, 5
lista:	.space 40		#static int lista[SIZE];
str1:	.asciiz "Insere 10 valores inteiros:\n"
str2:  	.asciiz "\nArray ordenado:\n"
	.text
	.globl main

# mapa de registos
# i = $t0
# j = $t1
# lista = $t3
# lista + i = $t4
# lista + j = $t5
# lista[i] = $t6
# lista[j] = $t7
# SIZE = $t8
# aux = $t9

main: 	# void main(void){
	#int i, j, aux;
	li	$t0,	0
	li	$t8,	SIZE
	la	$t3,	lista
for:
	bge	$t0,	$t8, 	endfor	# for(i = 0; i < SIZE; i++) {
	
	li	$v0,	print_str
	la	$a0, 	str1
	syscall				# printf("Insere 10 valores inteiros:\n")
	
	sll	$t9,	$t0,	2
	add	$t4,	$t9,	$t3
	
	li	$v0,	read_int
	syscall
	sw	$v0,	0($t4)

	addiu	$t0,	$t0, 	1
	j	for
        				# readstr lista[i]
endfor:	#    }

	li	$t0,	0
for2:			# for(i = 0; i < SIZE - 1; i++) {
	li	$t8,	SIZE
	addi	$t8, 	$t8,	-1	# SIZE - 1
	bge	$t0, 	$t8,	endfor2
	addiu	$t1,	$t0,	1	# j = i + 1
for3:			# 	for(j = i + 1; j < SIZE; j++) {
	li	$t8,	SIZE
	bge	$t1, 	$t8,	endfor3
if:	
	sll	$t4,	$t0,	2
	sll	$t5,	$t1,	2
	addu	$t4,	$t4,	$t3
	addu	$t5,	$t5, 	$t3
	lw	$t6,	0($t4)
	lw	$t7,	0($t5)
	ble	$t6,	$t7,	endif	# if(lista[i] > lista[j]) {
        move	$t9,	$t6        	# aux = lista[i];
        sw	$t7,	0($t4)        	# lista[i] = lista[j];
        sw	$t9,	0($t5)        	# lista[j] = aux;
endif:				#	}
	addiu	$t1,	$t1, 	1
	j	for3

endfor3:	#	}
       addiu	$t0,	$t0, 	1
       j	for2
endfor2:	#    }
    
	li	$v0,	print_str
	la	$a0, 	str2
	syscall	 			# printf("\nArray ordenado:\n");
	
	li	$t0,	0
	li	$t8,	SIZE
for4:
	bge	$t0, 	$t8,	endfor4	#for(i = 0; i < SIZE; i++) {
	sll	$t9,	$t0,	2
	addu	$t4,	$t3,	$t9
	lw	$a0,	0($t4)
	li	$v0,	print_int
        syscall		# printf(lista[i]);
        
        li	$a0,	','
        li	$v0,	print_char
        syscall
        
        addi	$t0,	$t0, 	1
        j	for4
        
endfor4:	#    }
	li	$v0,	0
	jr	$ra	#}
