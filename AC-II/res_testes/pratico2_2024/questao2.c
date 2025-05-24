#include <detpic32.h>

// Function to convert a decimal value to Binary-Coded Decimal (BCD)
unsigned char toBcd(unsigned char value)
{
    return ((value / 10) << 4) + (value % 10); // Combine tens and units into BCD format
}

void send2displays(unsigned int value)
{
    static const char disp7Scodes[] = {
        0x3F, 0x06, 0x5B, 0x4F,
        0x66, 0x6D, 0x7D, 0x07,
        0x7F, 0x6F, 0x77, 0x7C,
        0x39, 0x5E, 0x79, 0x71
    };

    static char displayFlag = 1; 

    if (displayFlag) {
        LATD = ( LATD & 0xFF9F ) | 0x0040; 
        LATB = ( LATB & 0x80FF ) | (disp7Scodes[value >> 4] << 8); 
        displayFlag = 0;
    } else {
        LATD = ( LATD & 0xFF9F ) | 0x0020; 
        LATB = ( LATB & 0x80FF ) | (disp7Scodes[value & 0x0F] << 8); 
        displayFlag = 1;
    }
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while (readCoreTimer() < ms);   
}

volatile unsigned char voltage; 

int main(void){
    // Configure ADC
    TRISBbits.TRISB4 = 1; // RB4 as input
    AD1PCFGbits.PCFG4 = 0; // RB4 as analog input
    AD1CHSbits.CH0SA = 4; // Select AN4 as input for conversion
    AD1CON1bits.SSRC = 7; // Internal counter ends sampling and starts conversion
    AD1CON3bits.SAMC = 16; // Sample time is 16 TAD
    AD1CON2bits.SMPI = 2-1; // Interrupt after 2 samples
    AD1CON1bits.CLRASAM = 1; // Clear ASAM bit
    AD1CON1bits.ON = 1; // Enable ADC

    // Configure Timer 3
    T3CONbits.TCKPS = 1; // 1:2 prescaler
    TMR3 = 0; 
    PR3 = 39999;
    T3CONbits.TON = 1; // Enable Timer 3

    // Configure interrupts
    IPC3bits.T3IP = 2; // Set Timer 3 priority
    IEC0bits.T3IE = 1; // Enable Timer 3 interrupts
    IFS0bits.T3IF = 0; // Clear Timer 3 interrupt flag

    // Configure display
    TRISD = TRISD & 0xFF9F; // RD5 and RD6 as outputs
    TRISB = TRISB & 0x80FF; // RB8-RB15 as outputs

    EnableInterrupts();

    while (1){
        AD1CON1bits.ASAM = 1; // Start sampling
        while (IFS1bits.AD1IF == 0); // Wait for ADC conversion)
        int some = ADC1BUF0 + ADC1BUF1; // Read ADC values
        voltage = (some / 2) * (73 - 7) / 1023 + 7;
        IFS1bits.AD1IF = 0; // Clear ADC interrupt flag
        delay(4000000); // Adjusted delay for 200ms
    } return 0;
} 

//Interropt service routine (interrupt handler)
void _int_(12) isr_T3(void) {
    send2displays(toBcd(voltage)); // Send ADC value to displays
    printInt(voltage, 10 | 3 << 16); // Print voltage value
    putChar('\n'); // New line
    IFS0bits.T3IF = 0; // Clear Timer 3 interrupt flag
}

