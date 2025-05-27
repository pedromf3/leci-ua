#include <detpic32.h>

// Function to convert a decimal value to Binary-Coded Decimal (BCD)
unsigned char toBcd(unsigned char value)
{
    return ((value / 10) << 4) + (value % 10); // Combine tens and units into BCD format
}

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms);
}

void send2displays(unsigned int value)
{
    static const char disp7Scodes[] = {
        0x3F, 0x06, 0x5B, 0x4F,
        0x66, 0x6D, 0x7D, 0x07,
        0x7F, 0x6F, 0x77, 0x7C,
        0x39, 0x5E, 0x79, 0x71
    };

    static char flag = 1; // Display flag

    if (flag == 1){
        LATD = (LATD & 0xFF9F) | 0x0040; // Enable display 1
        LATB = (LATB & 0x80FF) | (disp7Scodes[value >> 4] << 8 ); // Send high nibble
    } else {
        LATD = (LATD & 0xFF9F) | 0x0020; // Enable display 2   
        LATB = (LATB & 0x80FF) | (disp7Scodes[value & 0x0F] << 8 ); // Send low nibble
    }
    flag = !flag; // Toggle display flag
}

volatile unsigned char tp; // Variable to store temperature

int main(void){
    // Configuration Timer 3
    T3CONbits.TCKPS = 2; // 1:4 prescaler;
    PR3 = 35714;
    TMR3 = 0; // Reset Timer 3
    T3CONbits.TON = 1; // Enable Timer 3

    // Configure AN4/RB4
    TRISBbits.TRISB4 = 1; // RB4 as input
    AD1PCFGbits.PCFG4 = 0; // RB4 as analog input
    AD1CHSbits.CH0SA = 4; // Select AN4 as input for A/D conversion
    AD1CON2bits.SMPI = 2-1; // 2 samples in each conversion sequence
    AD1CON1bits.SSRC = 7; // Internal counter ends sampling and starts conversion
    AD1CON1bits.CLRASAM = 1; // Clear ASAM bit
    AD1CON3bits.SAMC = 16; // Sample time is 16 TAD
    AD1CON1bits.ON = 1; // Enable A/D converter

    // Configure display
    TRISB = TRISB & 0x80FF; // RB8-RB14 as outputs
    TRISD = TRISD & 0xFF9F; // RD5-RD6 as outputs

    //Interrupts configuration
    IPC3bits.T3IP = 2; // Set Timer 3 priority
    IEC0bits.T3IE = 1; // Enable Timer 3 interrupts
    IFS0bits.T3IF = 0; // Clear Timer 3 interrupt flag
    EnableInterrupts();

    int media = 0; // Variable to store the average value

    while(1){
        AD1CON1bits.ASAM = 1; // Start conversion
        while( IFS1bits.AD1IF == 0 ); // Wait while conversion not done
        media = (ADC1BUF0 + ADC1BUF1)/2;
        tp = (media * (75 - 10))/1023 + 10;
        delay(4000000); 
        IFS1bits.AD1IF = 0; // Reset AD1IF flag
    }
    return 0;
}

void _int_(12) isr_T3(void)
{
    send2displays(toBcd(tp)); // Send temperature in BCD format to displays
    printInt(tp, 10 | 3 << 16); // Print temperature value in decimal format
    putChar('\n'); // New line
    IFS0bits.T3IF = 0; // Reset Timer 3 interrupt flag
}
