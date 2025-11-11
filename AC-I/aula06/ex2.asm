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
	
# $t0 : SIZE
# $t1 : p
# $t2 : pultimo

main:
	la 	$t1,	array
	li	$t0, 	SIZE
	sll	$t0,	$t0, 	2
	addu	$t2,	$t1,	$t0 	# pultimo
for: 	bge 	$t1, 	$t2,	endfor
	
	lw	$a0,	0($t1)
	li	$v0, 	print_str
	syscall
	
	li	$a0,	'\n'
	li	$v0,	print_char
	syscall
	
	addi	$t1, 	$t1,	4
	j	for
endfor:
	jr	$ra