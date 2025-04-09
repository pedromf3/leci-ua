#include <detpic32.h>

int main(void)
{
    // Configure Timers T1 and T3 with interrupts enabled)
    // Reset T1IF and T3IF flags
    T3CONbits.TCKPS = 4;    // Timer T3 prescaler = 16    
    PR3 = 50000;           
    TMR3 = 0;               // Clear timer T3 count register
    T3CONbits.TON = 1;      // Enable timer T3 (must be the last command of the timer configuration sequence)
    IPC3bits.T3IP = 3;      // Timer T3 priority = 2
    IEC0bits.T3IE = 1;      // Enable timer T2 interrupts
    IFS0bits.T3IF = 0;      // Reset timer T3 interrupt flag

    T1CONbits.TCKPS = 2;    // Timer T1 prescaler = 8
    PR1 = 62499;           
    TMR1 = 0;               // Clear timer T1 count register
    T1CONbits.TON = 1;      // Enable timer T1 (must be the last command of the timer configuration sequence)
    IPC1bits.T1IP = 2;      // Timer T1 priority = 2
    IEC0bits.T1IE = 1;      // Enable timer T1 interrupts
    IFS0bits.T1IF = 0;      // Reset timer T1 interrupt flag

    EnableInterrupts(); // Global Interrupt Enable
while(1)
{
IdleMode();
}
return 0;
}
void _int_(4) isr_T1(void)
{
    putChar('1');       // print character '1'
    IFS0bits.T1IF = 0;  // Reset T1IF flag
}
void _int_(12) isr_T3(void)
{
    putChar('3');       // print character '3'
    IFS0bits.T3IF = 0;  // Reset T3IF flag
}