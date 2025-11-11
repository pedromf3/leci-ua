	.data
	.eqv 	SIZE, 3
	.eqv	print_str, 4
	.eqv	print_int10, 1
	.eqv	print_char, 11
array:	.word	str1, str2, str3
str1:	.asciiz	"Array"
str2:	.asciiz "de"
str3:	.asciiz "Ponteiros"
str4:	.asciiz "\nString #"
str5:	.asciiz ": "
	.text
	.globl main
	
# $t0 : SIZE	
# $t1 : i
# $t2 : j
# $t3 : array[i][j]

main:
	li 	$t0,	SIZE
	li 	$t1,	0
for: 	bge 	$t1, 	$t0,	endfor
	la	$a0, 	str4
	li 	$v0,	print_str
	syscall
	
	move	$a0, 	$t1
	li 	$v0,	print_int10
	syscall
	
	la 	$a0, 	str5
	li 	$v0,	print_str
	syscall
	
	li	$t2,	0
	
while:
	la 	$t3,	array 		# $t3 = &array[0]
	sll 	$t4,	$t1,	2 	#
	addu 	$t3,	$t3,	$t4 	# $t3 = &array[i]
	lw 	$t3,	0($t3) 		# $t3 = array[i] = &array[i][0]
	addu 	$t3,	$t3,	$t2	# $t3 = &array[i][j]
	lb 	$t3, 	0($t3)		# $t3 = array[i][j]
	
	move	$a0,	$t3
	li	$v0,	print_char
	syscall
	
	li	$a0,	'-'
	syscall
	
	addi	$t2, 	$t2,	1
		
	beq 	$t3, 	'\0', endwhile
	j 	while

endwhile:
	addi	$t1, 	$t1,	1
	j	for
	
endfor:
	jr	$ra