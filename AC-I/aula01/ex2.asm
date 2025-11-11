	.data
	
	.text
	.globl main

main: 
	ori  $t0,  $0,  2  # x = 2
	ori  $t2,  $0,  8  # $t2 = 8
	
	add  $t1,  $0,  $t0  # $t1 = 2*x
	sub  $t1, $t1,  $t2  # $t1 = 2*x - 8 
	
	jr  $ra
