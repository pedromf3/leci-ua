        .data
point:  .asciiz "."

        .text
        .globl main

main:               # int main(void){
        li      $t0, 0   # int cnt = 0;
do:
        li      $v0, 0    
        syscall             
        move    $a0, $v0    # c = inkey(); 
        beq     $a0, 0, else
        li      $v0, 3
        syscall
        j       endif	# jump to target
        

else:
        la      $a0, point
        li      $v0, 3            
        syscall
        j       endif	# jump to target

endif:

        bne     $t0, '\n', do   # } while (c != '\n'); 
        move    $a0, $t0
        li      $a1, 10
        li      $v0, 6 
        syscall       
        jr      $ra         # return 0;
