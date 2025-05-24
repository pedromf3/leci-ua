#include <detpic32.h>

void delay(unsigned int ms) {
    resetCoreTimer();
    while (readCoreTimer() < ms); 
}

void setDuty(unsigned int dc){
    OC4RS = ((PR3 + 1) * dc) /100;
}

int main(void) {
    T3CONbits.TCKPS = 2; // 1:4 prescaler
    T3CONbits.TON = 1;
    PR3 = 38461;
    OC4CONbits.OCM = 6;
    OC4CONbits.OCTSEL = 1;
    OC4CONbits.ON = 1;
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
