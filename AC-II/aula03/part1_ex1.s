    .data
    .equ ADDR_BASE_HI,0xBF88    # Base address: 16 MSbits 
    .equ TRISE,0x6100           # TRISE address is 0xBF886100 
    .equ PORTE,0x6110           # PORTE address is 0xBF886110 
    .equ LATE, 0x6120           # LATE  address is 0xBF886120
    .equ TRISB,0x6040           # TRISB address is 0xBF886040
    .equ PORTB,0x6050           # PORTB address is 0xBF886050
    .equ LATB,0x6060            # LATB  address is 0xBF886060
    .text
    .globl main

main:                           # TRIS configuration (input/output)
    lui     $t1,ADDR_BASE_HI    # $t1=0xBF880000 --- Base address

    lw      $t0,TRISE($t1)           
    andi    $t0,$t0,0xFFFE      # Configure Output
    sw      $t0,TRISE($t1)           

    lw      $t0,TRISB($t1)           
    or      $t0,$t0,0x0001      # Configure Input     
    sw      $t0,TRISB($t1)           

while:
    lw      $t0, PORTB($t1)     # Read 
    andi    $t0, $t0, 0x0001     
    xori    $t0, $t0, 0x0001    # Negate bit

    lw      $t2, LATE($t1)      # Read   
    andi    $t2, $t2, 0xFFFE
    or      $t2, $t2, $t0       # Write         
    sw      $t2, LATE($t1)         

    j       while
    jr      $ra   
