#include <detpic32.h>

int main(void){
    // Configure UART2:
    // 1 - Configure BaudRate Generator
    U2BRG = 10; // 20000000/(16*115200)-1
    U2MODEbits.BRGH = 0;
    // 2 – Configure number of data bits, parity and number of stop bits
    U2MODEbits.PDSEL = 0; // 8 data bits, no parity
    U2MODEbits.STSEL = 0; // 1 stop bit
    // (see U2MODE register)
    // 3 – Enable the trasmitter and receiver modules (see register U2STA)
    U2STAbits.UTXEN = 1; // Enable transmitter
    U2STAbits.URXEN = 1; // Enable receiver
    // 4 – Enable UART2 (see register U2MODE)
    U2MODEbits.ON = 1; // Enable UART2
} 