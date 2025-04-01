#include <detpic32.h>

int main(void)
{
    // Configurations
    TRISBbits.TRISB4 = 1; // RB4 digital output disconnected
    AD1PCFGbits.PCFG4 = 0; // RB4 configured as analog input (AN4)
    AD1CHSbits.CH0SA = 4; // Selects AN4 as input for the A/D converter
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;
    AD1CON3bits.SAMC = 1;
    AD1CON2bits.SMPI = 1-1;
    AD1CON1bits.ON = 1;

    IPC6bits.AD1IP = 2;
    IFS1bits.AD1IF = 0;
    IEC1bits.AD1IE = 1;
    EnableInterrupts(); // Global Interrupt Enable
    AD1CON1bits.ASAM = 1;
    // Start A/D conversion
    while(1);
    return 0;
}

void _int_(27) isr_adc(void){           // Replace VECTOR by the A/D vector number
    printInt(ADC1BUF0, 16 | 3 << 16);   // Print ADC1BUF0 value 
    putChar('\r');                      // Print character 'r'
    IFS1bits.AD1IF = 0;                 // Reset AD1IF flag
    AD1CON1bits.ASAM = 1;               // Start A/D conversion
}   