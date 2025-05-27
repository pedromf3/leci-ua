#include <detpic32.h>

int main(){
    // Configuration guide
    // Configure LEDs
    TRISE = TRISE & 0xFFF0; // Set RE0-RE3 as outputs

    // Configure switches
    TRISBbits.TRISB0 = 1;   // RB0 as input

    // Configure Segments display
    TRISD = TRISD & 0xFF9F; // Set RD5-RD6 as outputs
    TRISB = TRISB & 0x80FF; // RB8-RB14 as outputs

    // Configure Timer (e.g. Timer 3 and 15Hz)
    T3CONbits.TCKPS = 5; // Set prescaler: [20M/((65535+1)*15)] = [20.34...] = 21
    PR3 = 4166; // Set period register for 15Hz: (20M/32)/15 - 1 = 41665.66... 
    TMR3 = 0; // Reset Timer 3
    T3CONbits.TON = 1; // Enable Timer 3

    // Configure Interrupts for Timer 3
    IPC3bits.T3IP = 2; // Set Timer 3 interrupt priority to 2
    IFS0bits.T3IF = 0; // Reset Timer 3 interrupt flag
    IEC0bits.T3IE = 1; // Enable Timer 3 interrupts

    // Configure Output Compare (OC) for PWM (e.g. OC4)
    OC4CONbits.OCM = 6; // PWM mode without fault pin
    OC4CONbits.OCTSEL = 1; // Use Timer 3 as clock source (=0 for Timer 2)
    OC4CONbits.ON = 1; // Enable OC4

    // Configure ADC (e.g. AN4 as input)
    TRISBbits.TRISB4 = 1; // RB4 as input
    AD1PCFGbits.PCFG4 = 0; // RB4 as analog input
    AD1CHSbits.CH0SA = 4; // Select AN4 as input for A/D conversion
    AD1CON2bits.SMPI = 2-1; // 2 samples in each conversion sequence
    AD1CON1bits.SSRC = 7; // Internal counter ends sampling and starts conversion
    AD1CON1bits.CLRASAM = 1; // Clear ASAM bit
    AD1CON3bits.SAMC = 16; // Sample time is 16 TAD
    AD1CON1bits.ON = 1; // Enable A/D converter

    //Configure ADC interrupts
    IPC6bits.AD1IP = 2; // Set ADC interrupt priority to 2
    IFS1bits.AD1IF = 0; // Reset ADC interrupt flag
    IEC1bits.AD1IE = 1; // Enable ADC interrupts

    // Configure UART (e.g. 115200 baud rate, 8 data bits, no parity, 1 stop bit - UART2)
    U2MODEbits.BRGH = 0; // Set BRGH to 0 for 16x baud clock
    U2BRG = 10; // Set baud rate to 115200: (20M + 8 * 115200) / (16 * 115200) - 1 = 10
    U2MODEbits.PDSEL = 0; // No parity, 8 data bits
    U2MODEbits.STSEL = 0; // 1 stop bit
    U2STAbits.URXEN = 1; // Enable receiver
    U2STAbits.UTXEN = 1; // Enable transmitter
    U2MODEbits.ON = 1; // Enable UART2

    // Configure interrupts for UART (e.g. UART2)
    IPC8bits.U2IP = 2; // Set UART2 interrupt priority to 2
    IFS1bits.U2RXIF = 0; // Reset UART2 RX interrupt flag
    IEC1bits.U2RXIE = 1; // Enable UART2 RX interrupt

    // Enable global interrupts
    EnableInterrupts();

    return 0;
}
