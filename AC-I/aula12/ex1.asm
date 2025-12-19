#                ---------   Alinhamento  -----  Dimensão -----   Offset
# unsigned int id_number;        4                  4                0
# char first_name[18];           1                  18               4
# char last_name[15];            1         	    15               22
# float grade;                   4                  4                37 -> 40
#                                4                  44

	.data
	.eqv 	MAX_STUDENTS, 4
student:	.space 44
media:	.space 4
st_array: .space 176
str1:	.asciiz "\nMedia:" 
str2:	.asciiz "N. Mec: "
str3:	.asciiz "Primeiro Nome: "
str4: 	.asciiz "Ultimo Nome: "
str5: 	.asciiz "Nota: " 
k1:	.float -20.0
k2:	.float 0.0
	.text
	.globl main
	
main:
    	addi 	$sp, 	$sp, 	-20
    	sw   	$s0, 	0($sp)
    	sw   	$a0, 	4($sp)
   	sw   	$a1, 	8($sp)
    	sw   	$a2, 	12($sp) 
    	sw	$ra,	16($sp)    

    	la	$a0,	st_array   # Arg1: array
    	li     	$a1, 	4          # Arg2: ns 
    	jal    	read_data      

	la    	$a0,    st_array
	li	$a1,	4
    	la    	$a2,    media
    	jal    	max             
    	
	move    $s0, 	$v0  

    	la      $a0, 	str1
    	li      $v0, 	4
    	syscall
	
	la	$t6, 	media
	l.s     $f12, 	0($t6) 
    	li      $v0, 	2 
    	syscall


    	move    $a0, 	$s0        
    	jal     print_student   

	li      $v0, 	0         
    
    	lw	$ra,	16($sp)
	lw   	$a2, 	12($sp)
    	lw   	$a1, 	8($sp)
    	lw   	$a0, 	4($sp)
    	lw   	$s0, 	0($sp)
    	addi 	$sp, 	$sp, 	16
    
    	jr      $ra            
	
read_data:
	move 	$t0, 	$a0   # st
	move 	$t2, 	$a1   # ns
	
	li	$t1,	0   	# i=0
while:
	bge	$t1,	$t2,	end_w	# i < ns
	
	la	$a0,	str2
	li	$v0,	4
	syscall			# print_string("N. Mec: ");
	
	mul	$t3,	$t1,	44
	addu 	$t3, 	$t0,	$t3
	
	li	$v0,	5
	syscall			# st[i].id_number = read_int();
	sw	$v0,	0($t3)
	
	###
	
	la	$a0,	str3
	li	$v0,	4
	syscall 		# print_string("Primeiro Nome: ");
	
	addiu	$a0,	$t3,	4
	li	$a1,	17
	li	$v0,	8
	syscall			# read_string(st[i].first_name, 17);
	
	###
	
	la	$a0,	str4
	li	$v0,	4
	syscall			# print_string("Ultimo Nome: ");
	
	addiu	$a0,	$t3,	22
	li	$a1,	14
	li	$v0,	8
	syscall			# read_string(st[i].last_name, 14);
	
	### 
	
	la	$a0,	str5
	li	$v0,	4
	syscall			# print_string("Nota: ");
	
	li	$v0,	6
	syscall			# st[i].grade = read_float();
	s.s	$f0,	40($t3)
	
	addiu	$t1,	$t1, 	1 	# i++
	j	while
end_w:
	jr $ra
	
	###
max:	
	move    $t0, 	$a0          # p = st 
    	move    $v0, 	$a0
	
	la 	$t4,	k1		# k1 = -20.0
	l.s	$f2,	0($t4)
	la	$t5, 	k2		# k2 = 0.0
	l.s	$f4,	0($t5)
	mov.s	$f10,	$f4
	
	li      $t9, 	44
    	mul     $t1, 	$a1, 	$t9     # offset = ns * 44
    	add     $t1, 	$a0, 	$t1     # limite ($t1) = st + offset
    	
for:
	bge	$t0,	$t1,	endfor
		
	l.s	$f0,	40($t0)
	add.s 	$f10, 	$f10, 	$f0
	
if:	c.le.s 	$f0,	$f4
	bc1t 	endif
	
	mov.s   $f2, 	$f4         # max_grade = grade
    	move    $v0, 	$a0
    
	
endif:
	addiu   $t0, 	$t0, 	44     # p += 44
	j	for
	
endfor:

	mtc1    $a1, 	$f6          
    	cvt.s.w $f6, 	$f6          
    
    	div.s 	$f0, 	$f10, 	$f6  
    
    	s.s     $f0, 	0($a2)
	
	jr	$ra
	
print_student:
	move 	$t0,	$a0
	
	li      $v0,    11   
    	li      $a0,    '\n'
    	syscall	
	
	lw	$a0,	0($t0)	
	li	$v0,	36
	syscall		
	
	li      $v0,    11   
    	li      $a0,    '\n'
    	syscall	
	
	addiu	$a0,	$t0,	4
	li	$v0,	4
	syscall	
	
	li      $v0,    11   
    	li      $a0,    '\n'
    	syscall	
	
	addiu	$a0,	$t0,	22
	li	$v0,	4
	syscall	
	
	li      $v0,    11   
    	li      $a0,    '\n'
    	syscall		
	
	l.s	$f12,	40($t0)
	li	$v0,	2
	syscall
	
	li      $v0,    11   
    	li      $a0,    '\n'
    	syscall	

	jr 	$ra
