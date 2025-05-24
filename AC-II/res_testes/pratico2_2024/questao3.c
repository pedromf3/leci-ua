#include <detpic32.h>

void putc(char byte){
    while(U2STAbits.UTXBF == 1); // Wait while UTXBF is 1
    U2TXREG = byte; // Write character to transmit register
}

void putstr(char *str)
{
    for (;*str != '\0'; *str++){ // iterate until the end of the string:
        putc(*str);      // use putc() function to send each charater ('\0' should not be sent)
    }
}

void _int_(32) isr_uart2(void) {
    if(IFS1bits.U2RXIF == 1){
        putstr("\n");
        char c = U2RXREG; // Read character from FIFO (U2RXREG)
        putc(c); // Echo the received character back to the terminal

        if(c == 'D'){
            int value = PORTB & 0x000F; // Read the value from RB0-RB3
            int dezenas = value / 10; // Calculate the tens digit
            int unidades = value % 10; // Calculate the units digit
            putstr("\nDSD="); 
            putc(dezenas + '0'); // Tens digit as a character
            putc(unidades + '0'); // Units digit as a character
        }

        LATEbits.LATE7 = !LATEbits.LATE7; // Toggle RE7
    }
    IFS1bits.U2RXIF = 0; // Clear RX interrupt flag
}


int main(void) {
    // Configuration UART2
    U2BRG = 129; // (20000000 + 8*9600)/(16*9600) - 1 
    U2MODEbits.BRGH = 0;

    U2MODEbits.PDSEL = 2; // 8 data bits, odd parity
    U2MODEbits.STSEL = 1; // 2 stop bit

    U2STAbits.UTXEN = 1; // Enable transmitter
    U2STAbits.URXEN = 1; // Enable receiver

    U2MODEbits.ON = 1; // Enable UART2

    // Configuration LED7
    TRISEbits.TRISE7 = 0; // RE7 as output
    LATEbits.LATE7 = 0; // Initialize RE7 to 0

    // Configuration DS0-DS3
    TRISB = TRISB | 0x000F; // RB0-RB3 as inputs

    // Configuration Interrupts UART2
    IEC1bits.U2RXIE = 1; // RX interrupts enabled 
    IEC1bits.U2TXIE = 0; // TX interrupts disabled
    IPC8bits.U2IP = 2; // Set UART2 priority level to 2
    IFS1bits.U2RXIF = 0; // Clear RX interrupt flag
    U2STAbits.URXISEL = 0; // Interrupt on every character received

    // Enable global interrupts
    EnableInterrupts();

    while(1) { 
        IdleMode();
    }
    return 0;
}

