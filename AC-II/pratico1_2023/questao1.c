#include <detpic32.h>

void delay(unsigned int ms){
    resetCoreTimer();
    while(readCoreTimer() < ms);
}

int main(void){
    // Configuration
    TRISE = TRISE & 0xFF03; // 1111 1111 0000 0011 
    
    // Switches DS1 and DS3 (RB0 and RB2)
    TRISBbits.TRISB0 = 1;
    TRISBbits.TRISB2 = 1;

    int ms = 2739726;
    int count = 3;

    LATE = (LATE & 0xFF03) | (count << 2);


    while(1){

        LATE = (LATE & 0xFF03) | (count << 2);   

        if (PORTBbits.RB0 == 1 && PORTBbits.RB2 == 1){
            ms = 4347826;
        } else if (PORTBbits.RB0 == 0 && PORTBbits.RB2 == 0) {
            ms = 2739726;
        }

        delay(ms);

        if (48 == count){
            count = 3;
        } else {
            count = count << 1;
        }
    }
    return 0;
}
