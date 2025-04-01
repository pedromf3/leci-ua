    .data
    .equ ADDR_BASE_HI,0xBF88    # Base address: 16 MSbits 
    .equ TRISE,0x6100           # TRISE address is 0xBF886100 
    .equ PORTE,0x6110           # PORTE address is 0xBF886110 
    .equ LATE, 0x6120           # LATE  address is 0xBF886120
    .equ TRISD,0x60C0           # TRISD address is 0xBF8860C0
    .equ PORTD,0x60D0           # PORTD address is 0xBF8860D0
    .equ LATD, 0x60E0           # LATD address is 0xBF8860E0
    .text
    .globl main

main:
    lui     $t1,ADDR_BASE_HI       # $t1 = 0xBF880000
    lw      $t0,TRISE($t1)           
    andi    $t0,$t0,0xFFFE         # Configure Output
    sw      $t0,TRISE($t1)          

    lw      $t0,TRISD($t1)           
    ori     $t0,$t0,0x0100          # Configure Input
    sw      $t0,TRISD($t1)           

while:
    lw      $t0, PORTD($t1)        
    andi    $t0, $t0, 0x0100     
    xori    $t0, $t0, 0x0100     
    srl     $t0, $t0, 8

    lw      $t2, LATE($t1)            
    andi    $t2, $t2, 0xFFFE   
    or      $t2, $t2, $t0 
    sw      $t2, LATE($t1) 

    j       while
    jr      $ra