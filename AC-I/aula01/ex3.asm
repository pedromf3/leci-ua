	.data
	.text
	.globl main

main: 
	ori  $t0,  $0,  2  # x = 2
	ori  $v0,  $0,  5 
	syscall            # syscall "read_int()"
	
	or  $t0,  $0,  $v0   # $t0 = $v0
	ori $t2,  $0,  8     # $t2 = 8
	add $t1,  $t0, $t0   # 2 * x
	sub $t1,  $t1, $t2   # y = 2 * x - 8

	or  $a0,  $0,  $t1   # $a0 = y
	ori $v0,  $0,  1 
	syscall            # syscall "print_int10()"
	
	ori $a0,  $0,  '\n'
	ori $v0,  $0,  11
	syscall
	
	or  $a0,  $0,  $t1   # $a0 = y
	ori $v0,  $0,  34
	syscall            # syscall "print_int16()"
	
	ori $a0,  $0,  '\n'
	ori $v0,  $0,  11
	syscall
	
	or  $a0,  $0,  $t1   # $a0 = y	
	ori $v0,  $0,  36
	syscall            # syscall "print_intu10()"
	
	jr  $ra # end
