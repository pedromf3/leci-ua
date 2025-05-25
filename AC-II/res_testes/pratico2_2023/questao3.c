#include <detpic32.h>

void putc(char byte){
    while(U2STAbits.UTXBF == 1);
    U2TXREG = byte;
}

void putstr(char *str)
{
    for(; *str != '\0'; *str++){
        putc(*str);
    }
}

volatile int value = 0;

int main(void){
    // Configure  LED
    TRISE = TRISE & 0xFFF0;
    LATE = LATE & 0xFFF0; 

    // Configure UART2
    U2MODEbits.BRGH = 0;
    U2MODEbits.PDSEL = 1; // 8 data bits, even parity
    U2MODEbits.STSEL = 1; // 2 stop bits
    U2BRG = 521;
    U2STAbits.UTXEN = 1; // Enable transmitter
    U2STAbits.URXEN = 1; // Enable receiver
    U2MODEbits.ON = 1; // Enable UART2

    // Configure Interrupts UART2
    IEC1bits.U2RXIE = 1; // Enable RX interrupts
    IEC1bits.U2TXIE = 0; // Disable TX interrupts
    IPC8bits.U2IP = 2; // Set UART2 priority level to 2
    IFS1bits.U2RXIF = 0; // Clear RX interrupt flag
    U2STAbits.URXISEL = 0; // Interrupt on every character received

    EnableInterrupts(); // Enable global interrupts

    while(1){
        IdleMode(); // Enter idle mode
    }
    return 0;
}

void _int_(32) isr_uart2(void) {
    if (IFS1bits.U2RXIF == 1){
        char c;
        c = U2RXREG;
        putc(c); // Echo 
        putstr("\n");
        if (c == 'C'){
            value = 0;
            putstr("VALOR MINIMO\n");
        } else if (c == 'F'){
            if (value > 9){
                value = 0;
            } else {
                value += 1;
            }
        }
    
        LATE = (LATE & 0xFFF0) | value;
    }
    IFS1bits.U2RXIF = 0; // Clear RX interrupt flag
}



