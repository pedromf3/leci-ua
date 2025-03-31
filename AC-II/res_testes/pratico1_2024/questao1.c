#include <detpic32.h>

void delay(unsigned int freq){
    resetCoreTimer();
    while(readCoreTimer() < freq);
}

int main(void){
    TRISE = TRISE & 0xFFC3; // 1111 1111 1100 0011
    TRISBbits.TRISB2 = 1;

    int count = 0;

    while (1){
        if (count <= 0) {
            count = 11;
        } else {
            count--;
        }

        LATE = (LATE & 0xFFC3) | (count << 2);

        printInt(count, 10 | (2 << 16));
        putChar('\n');

        if (PORTBbits.RB2 == 0) {
            delay(8695652);
        } else {
            delay(3636363);
        }
    }
    return 0;
}
