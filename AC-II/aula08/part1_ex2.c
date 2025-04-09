#include <detpic32.h>

int main(void)
{
// Configure Timer T3 with interrupts enabled
    // Configure Timer T3 (2 Hz with interrupts disabled)
    T3CONbits.TCKPS = 7;    
    PR3 = 39062;           
    TMR3 = 0;               // Clear timer T3 count register
    T3CONbits.TON = 1;      // Enable timer T3 (must be the last command of the timer configuration sequence)
    IPC3bits.T3IP = 2;      // Timer T3 priority = 2
    IEC0bits.T3IE = 1;      // Enable timer T3 interrupts
    IFS0bits.T3IF = 0;      // Reset timer T3 interrupt flag
    
EnableInterrupts();
while(1)
{
    IdleMode(); // CPU enters Idle mode (CPU is halted,but peripherals continue to operate)
}
return 0;
}

void _int_(12) isr_T3(void) // Replace VECTOR by the timer T3 vector number
{
putChar('.');
IFS0bits.T3IF = 0;      // Reset timer T3 interrupt flag
}