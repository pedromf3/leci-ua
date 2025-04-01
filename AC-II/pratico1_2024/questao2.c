# include <detpic32.h>

// delay function
void delay(unsigned int freq){
    resetCoreTimer();
    while(readCoreTimer() < freq);
}

int main(void){

    static const int segments[]={0x3F, 0x06, 0x5b, 0x4F, 0x66, 0x6D, 0x7d, 0x07, 0x7F, 0x67};

    // AD Configuration
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4= 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1; 
    AD1CON3bits.SAMC = 16;
    AD1CON2bits.SMPI = 2-1;
    AD1CHSbits.CH0SA = 4;
    AD1CON1bits.ON = 1;

    // Led Configuration
    TRISEbits.TRISE1 = 0;
    LATEbits.LATE1 = 0;
    
    // Display COnfiguration
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;
    LATDbits.LATD5 = 1;
    LATDbits.LATD6 = 0;

    TRISB = TRISB & 0x80FF;     //  1000 0000 1111 1111

    int media;

    while(1){
        AD1CON1bits.ASAM = 1;
        while( IFS1bits.AD1IF == 0 );

        media = (ADC1BUF0 + ADC1BUF1)/2;

        printInt(media, 16 | 3 << 16);
        putChar('\r');

        int volt = media/(1024/10);

        LATB = (LATB & 0x80FF) | (segments[volt] << 8);

        LATEbits.LATE1 = !LATEbits.LATE1;
         
        delay(3333333);

        IFS1bits.AD1IF = 0;
    }
    return 0;
}
