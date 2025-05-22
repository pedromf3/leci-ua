#include <detpic32.h>

void _int_(32) isr_uart2(void)
{
if (IFS1bits.U2RXIF == 1){
    if (U2RXREG == 'T'){    // Read character from FIFO (U2RXREG)
        LATCbits.LATC14 = 1;
        }
    if (U2RXREG == 't'){    // Read character from FIFO (U2RXREG)
        LATCbits.LATC14 = 0;
        }
    IFS1bits.U2RXIF = 0; // Clear UART2 Rx interrupt flag
    }
}

int main(void)
{
// Configure LED RC14
    TRISCbits.TRISC14 = 0; // Set RC14 as output
    LATCbits.LATC14 = 0;   // Set RC14 to 0

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
    IEC1bits.U2RXIE = 1; // enable U2RXIE, disable U2TXIE (register IEC1)
    IEC1bits.U2TXIE = 0; 
    // set UART2 priority level (register IPC8)
    IPC8bits.U2IP = 1;
    // clear Interrupt Flag bit U2RXIF (register IFS1)
    IFS1bits.U2RXIF = 0;
    // define RX interrupt mode (URXISEL bits)
    U2STAbits.URXISEL = 0;
    // Enable global Interrupts
    EnableInterrupts();

    while(1){
        IdleMode();
    }

return 0;
}
