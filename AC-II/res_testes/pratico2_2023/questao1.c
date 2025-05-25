#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms);
}

void setDutyCycle(unsigned int dc){
    OC2RS = ((PR3 + 1) * dc) /100; // Set duty cycle for OC2
}

int main(void){
    //Configuration RB0 and RB2 as inputs
    TRISB = TRISB | 0x0005; // RB0 and RB2 as inputs

    // Configuration Timer 3
    T3CONbits.TCKPS = 2; // 1:4 prescaler
    PR3 = 41666;
    TMR3 = 0; // Reset Timer 3
    T3CONbits.TON = 1; // Enable Timer 3

    //Configuration OC2 
    OC2CONbits.OCM = 6; // PWM mode without fault pin
    OC2CONbits.OCTSEL = 0; // Use Timer 3 as clock source
    OC2CONbits.ON = 1; // Enable OC2
    int dc = 75;
    setDutyCycle(dc); // Set initial duty cycle to 75%
    while(1){
        if  (PORTBbits.RB0 == 0 && PORTBbits.RB2 == 0){
            dc = 30; // Set duty cycle to 30%
        } else if (PORTBbits.RB0 == 1 && PORTBbits.RB2 == 1) {
            dc = 55; // Set duty cycle to 55%
        }
        setDutyCycle(dc); // Update duty cycle
        delay(7200);
    }
    return 0;
}

