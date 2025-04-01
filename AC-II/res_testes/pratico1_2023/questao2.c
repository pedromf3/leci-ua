#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms);
}

 int main(void) {

    static const int segments[] = {0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x77, 0x7C, 0x39};

    // AD Configuration
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4= 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1; 
    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 4-1;
    AD1CHSbits.CH0SA = 4;
    AD1CON1bits.ON = 1;

    //DS2 Configuration (RB1)
    TRISBbits.TRISB1 = 1;

    //RB14...RB8 Configuration
    TRISB = TRISB & 0x80FF;   //1000 0000 1111 1111

    //RD6, RD5 configuration
    TRISDbits.TRISD6 = 0;
    TRISDbits.TRISD5 = 0;
    
    //LED4 Configuration (RE4)
    TRISEbits.TRISE4 = 0;
    LATEbits.LATE4 = 0;

    int media;

    while(1){
        AD1CON1bits.ASAM = 1;
        while (IFS1bits.AD1IF == 0);

        media = (ADC1BUF0 + ADC1BUF1 + ADC1BUF2 + ADC1BUF3)/4;

        printInt(media, 2 | 10 << 16);
        putChar('\n');

        if (PORTBbits.RB1 == 0){
            LATDbits.LATD5 = 1;
            LATDbits.LATD6 = 0;
        } else {
            LATDbits.LATD6 = 1;
            LATDbits.LATD5 = 0;
        }

        int volt = media/(1024/10);
         
        LATB = (LATB & 0x80FF) | (segments[volt] << 8);

        delay(1666667);

        LATEbits.LATE4 = !LATEbits.LATE4;
        IFS1bits.AD1IF = 0;
    }
    return 0;
}

