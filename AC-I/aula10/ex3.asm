	.data
	.align 3          
array:		.space  80  
const1:		.double 1.0
const0: 	.double 0.0
const0_5:	.double 0.5
one_float:  	.float  1.0 
newline:	.asciiz "\n"
    	.eqv    SIZE, 10
    	.text
    	.globl main
    
main:
    	addiu   $sp,	$sp,	-4
    	sw      $ra, 	0($sp)

    	li      $t0, 	0          # i = 0
        la      $t1, 	array  
read_loop:
    	bge     $t0, 	SIZE,	end_read
    	
    	sll	$t2,	$t0,	3
    	add	$t2,	$t2,	$t1
    
    	li      $v0, 	7       # read_double
    	syscall                 
    	s.d     $f0, 0($t2)     # guarda no array
    
    	addiu   $t0, $t0, 1     # i++
    	j       read_loop
    	
end_read:
    	la      $a0, 	array
    	li      $a1, 	SIZE
    	jal     average         

    	mov.d   $f12, 	$f0      
    	li      $v0, 	3         
    	syscall
    
    	la      $a0, 	newline    
    	li      $v0, 	4
   	syscall

    	la      $a0,	 array
    	li      $a1,	 SIZE
    	jal     var           

    	mov.d   $f12, 	$f0
    	li      $v0, 	3
    	syscall

    	la      $a0, 	newline
    	li      $v0, 	4
    	syscall

	la      $a0, 	array
    	li      $a1, 	SIZE
    	jal     stdev     

    	mov.d   $f12, 	$f0
    	li      $v0, 	3
    	syscall
    	
    	li      $v0, 0

    	lw      $ra, 	0($sp)
    	addiu   $sp, 	$sp, 	4
    	jr      $ra

var:
    	addiu   $sp, 	$sp, 	-24  
    	sw      $ra, 	20($sp)      
    	sw      $s0, 	16($sp)      
    	sw      $s1, 	12($sp)      
    	sw      $s2, 	8($sp)       
    	swc1    $f20, 	4($sp)       
    	swc1    $f22, 	0($sp)       

    	move    $s0, 	$a0            # $s0 = array
    	move    $s1,	$a1            # $s1 = nval

	jal     average
    
	cvt.s.d $f20, 	$f0          

    	mtc1    $zero, 	$f22         
    	cvt.s.w $f22, 	$f22

    	li      $s2, 	0              # i = 0
    	
loop_var:
    	bge     $s2,	 $s1,	 end_loop_var
    	sll     $t0,	 $s2, 	3         # offset = i * 8
    	addu    $t0,	 $s0, 	$t0       
    	l.d     $f4,	 0($t0)         
    	cvt.s.d $f4,	 $f4            

    	sub.s   $f12, 	 $f4, 	$f20 
    	li      $a0, 2              
    
    	jal     xtoy                

    	add.s   $f22, 	$f22, 	$f0     # soma += resultado
    
    	addiu   $s2, 	$s2, 	1         # i++
    	j       loop_var

end_loop_var:
    	# return (double)soma / (double)nval
    	cvt.d.s $f0, 	$f22           
    	mtc1    $s1, 	$f4            
    	cvt.d.w $f4, 	$f4            
    	div.d   $f0, 	$f0, 	$f4       

    
    	lwc1    $f22, 	0($sp)
    	lwc1    $f20, 	4($sp)
    	lw      $s2, 	8($sp)
    	lw      $s1, 	12($sp)
    	lw      $s0, 	16($sp)
    	lw      $ra, 	20($sp)
    	addiu   $sp, 	$sp, 	24
    
    	jr      $ra

average:
    	move    $t0, 	$a0            # t0 = array pointer
    	move    $t1, 	$a1            # t1 = n (contador)
    
    	mtc1    $zero,	$f0          
    	cvt.d.w $f0,	$f0            # sum = 0.0

avg_loop:
    	ble     $t1, 	0,	avg_end
    
    	l.d     $f2, 	0($t0)         
    	add.d   $f0, 	$f0,	$f2    # sum += val
    
    	addiu   $t0, 	$t0, 	8      
    	addiu   $t1, 	$t1, 	-1     # decrementa contador
    	j       avg_loop
	
avg_end:
    	mtc1    $a1, 	$f2
    	cvt.d.w $f2, 	$f2            # converte n para double
    	div.d   $f0, 	$f0, 	$f2    # sum / n
    
    	jr      $ra
    	
xtoy:
    	addiu   $sp, 	$sp, 	-8
    	sw      $ra, 	4($sp)
    	sw      $s0, 	0($sp)

    	move    $s0, 	$a0           
    	mov.s   $f2, 	$f12           

    	# Abs(y)
    	move    $a0, 	$s0
    	jal     my_abs             
    	move    $t1, 	$v0            

    	li      $t0, 	0              # i = 0

    	la      $t2, 	one_float      
    	l.s     $f0, 	0($t2)         # result = 1.0

xtoy_loop:
    	bge     $t0, 	$t1, 	xtoy_end
    
    	ble     $s0, 	0, 	xtoy_else  
    	mul.s   $f0, 	$f0, 	$f2      
    	j       xtoy_next
xtoy_else:
    	div.s   $f0, 	$f0, 	$f2       
xtoy_next:
    	addiu   $t0, 	$t0, 	1
    	j       xtoy_loop

xtoy_end:
    	lw      $s0, 	0($sp)
    	lw      $ra, 	4($sp)
    	addiu   $sp, 	$sp, 	8
    	jr      $ra

my_abs:
    	bge     $a0, 	0, 	abs_end
    	sub     $a0, 	$zero, 	$a0
abs_end:
    	move    $v0, 	$a0
    	jr      $ra

stdev:
    	addiu   $sp, 	$sp,	-4
    	sw      $ra, 	0($sp)

    	jal     var                 
    
    	mov.d   $f12, 	$f0           
    	jal     my_sqrt             
    
    	lw      $ra, 	0($sp)
    	addiu   $sp, 	$sp, 	4
    	jr      $ra

my_sqrt:
    	la      $t0, const0
    	l.d     $f4, 0($t0)         
   	c.le.d  $f12, $f4           
    	bc1t    sqrt_zero

    	la      $t0, const1
    	l.d     $f0, 0($t0)         
    
    	la      $t0, const0_5
    	l.d     $f6, 0($t0)         
    
    	li      $t0, 0              
sqrt_loop:
    	bge     $t0, 20, sqrt_end   

    	mov.d   $f2, $f0            
    	div.d   $f8, $f12, $f0      
    	add.d   $f0, $f0, $f8       
    	mul.d   $f0, $f0, $f6           
    	addiu   $t0, $t0, 1
    	j       sqrt_loop

sqrt_zero:
    	mov.d   $f0, $f4	# return 0.0
    	
sqrt_end:
    	jr      $ra