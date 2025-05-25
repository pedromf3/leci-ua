#include <detpic32.h>

void putc(char byte)

int main(void){
    // Configure UART2:
    // 1 - Configure BaudRate Generator
    U2BRG = 42; // 20000000/(4*115200)-1
    U2MODEbits.BRGH = 1; 
    // 2 – Configure number of data bits, parity and number of stop bits
    U2MODEbits.PDSEL = 0; // 8 data bits, no parity
    U2MODEbits.STSEL = 0; // 1 stop bit
    // (see U2MODE register)
    // 3 – Enable the trasmitter and receiver modules (see register U2STA)
    U2STAbits.UTXEN = 1; // Enable transmitter
    U2STAbits.URXEN = 1; // Enable receiver
    // 4 – Enable UART2 (see register U2MODE)
    U2MODEbits.ON = 1; // Enable UART2

    while(1) {
        putc('+');
    // wait 1 s
    resetCoreTimer();
    while(readCoreTimer() < 20000000); // 20Mhz -> 1s
    }
    return 0;
}

void putc(char byte)
{
    while (U2STAbits.UTXBF == 1);// wait while UART2 UTXBF == 1
    U2TXREG = byte; // Copy "byte" to the U2TXREG register
}