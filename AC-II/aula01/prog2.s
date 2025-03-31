    .data
    .text
    .globl main

main:           # int main(void){
    li $t0, 0   # int cnt = 0;

do:             #  do {
    li      $v0, 2  
    syscall             
    move    $a0, $v0    # c = getChar();
    li      $v0, 3      
    syscall                 # printInt(c);
    addi    $t0,$t0 , 1     # cnt++;
    bne     $t0, '\n', do   # } while (c != '\n');    

    move    $a0, $t0
    li      $a1, 10
    li      $v0, 6 
    syscall             #printInt(cnt, 10);
    li      $v0, 0
    jr      $ra         # return 0;
