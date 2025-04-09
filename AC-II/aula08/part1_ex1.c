#include <detpic32.h>

int main(void)
{
    // Configure Timer T3 (2 Hz with interrupts disabled)
    T3CONbits.TCKPS = 7;    // 
    PR3 = 39062;            // 
    TMR3 = 0;               // Clear timer T3 count register
    T3CONbits.TON = 1;      // Enable timer T3 (must be the last command of the timer configuration sequence)
    IPC3bits.T3IP = 2;      // Timer T3 priority = 2
    IEC0bits.T3IE = 1;      // Enable timer T3 interrupts
    IFS0bits.T3IF = 0;      // Reset timer T3 interrupt flag

    while(1)
    {
        while (IFS0bits.T3IF == 0); // Wait while T3IF = 0
        IFS0bits.T3IF = 0;          // Reset T3IF
        putChar('.');
    }
    return 0;
}