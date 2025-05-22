#include <detpic32.h>

volatile t_buf txbuf; 

void putstrInt(char *s)
{
while(txbuf.nchar > 0); // Wait while the buffer is not empty
// Copy all characters of the string "s" to the buffer, and update
// "nchar"
while(...) {
...
}
}

// Initialize "posrd" variable with 0
txbuf.posrd = 0;

typedef struct
{
char mem[100]; // Storage area
int nchar; // Number of characters to be transmitted
int posrd; // Position of the next character to be transmitted
} t_buf;



int main(void)
{
    // Configure UART2: 115200, N, 8, 1
    U2BRG = 42; // 20000000/(4*115200)-1
    U2MODEbits.BRGH = 1;
    // Configure number of data bits, parity and number of stop bits
    U2MODEbits.PDSEL = 0; // 8 data bits, no parity
    U2MODEbits.STSEL = 0; // 1 stop bit
    // Enable the trasmitter and receiver modules (see register U2STA)
    U2STAbits.UTXEN = 1; // Enable transmitter
    U2STAbits.URXEN = 1; // Enable receiver
    // Enable UART2 (see register U2MODE)
    U2MODEbits.ON = 1; // Enable UART2

// Configure UART2 interrupts, with RX interrupts enabled and TX interrupts disabled:
    IEC1bits.U2RXIE = 0; // enable U2RXIE, disable U2TXIE (register IEC1)
    IEC1bits.U2TXIE = 1; 
    // set UART2 priority level (register IPC8)
    IPC8bits.U2IP = 1;
    // clear Interrupt Flag bit U2TXIF (register IFS1)
    IFS1bits.U2TXIF = 0;
    // define RT interrupt mode (UTXISEL bits)
    U2STAbits.UTXISEL = 0;
    // Enable global Interrupts
    EnableInterrupts();

    while(1){
        IdleMode();
    }

return 0;
}