#include <detpic32.h>

void delay(unsigned int ms) {
    resetCoreTimer();
    while (readCoreTimer() < ms); 
}

void setDuty(unsigned int dc) {
    // Set duty cycle for OC4
    OC4RS = ((PR3 + 1) * dc) / 100;
}

int main(void) {
    // Configure Timer 3 with 1:4 prescaler
    T3CONbits.TCKPS = 2; 
    T3CONbits.TON = 1; // Enable Timer 3
    PR3 = 38461; // Set Timer 3 period

    // Configure Output Compare 4 (PWM mode)
    OC4CONbits.OCM = 6; // PWM mode without fault pin
    OC4CONbits.OCTSEL = 0; // Use Timer 3 as clock source
    OC4CONbits.ON = 1; // Enable OC4

    // Configure RB1 as input
    TRISBbits.TRISB1 = 1; 

    setDuty(50);
    int flag = 0;

    while (1) {
        if (PORTBbits.RB1 == 0) {
            if (flag == 0) {
                setDuty(25);
            } else {
                setDuty(75);
            }
            delay(26000000);
            flag = !flag;
        }
    }
    return 0;
}
