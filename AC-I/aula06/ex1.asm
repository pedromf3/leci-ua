	.data
	.eqv 	SIZE, 3
	.eqv	print_str, 4
	.eqv	print_char, 11
array:	.word	str1, str2, str3
str1:	.asciiz	"Array"
str2:	.asciiz "de"
str3:	.asciiz "Ponteiros"
	.text
	.globl main
	
# $t0 = i
# $t1 = p[0]
# $t2 = p[i]

main:
	li 	$t0, 	0
for: 	bge 	$t0, 	SIZE,	endfor
	la 	$t1,	array 		# $t1 = &array[0]
	sll 	$t2,	$t0,	2 	
	addu 	$t2,	$t2,	$t1
	
	lw	$a0,	0($t2)
	li	$v0, 	print_str
	syscall
	
	li	$a0,	'\n'
	li	$v0,	print_char
	syscall
	
	addi	$t0, 	$t0,	1
	j	for
endfor:
	jr	$ra