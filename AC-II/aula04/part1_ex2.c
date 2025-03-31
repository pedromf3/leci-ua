#include <detpic32.h>

int main (void){
    TRISE = TRISE & 0xFF87; // 0xFF87 = 1111 1111 1000 0111
    // or 
    // TRISEbits.TRISE3 = 0;
    // TRISEbits.TRISE4 = 0;
    // TRISEbits.TRISE5 = 0;
    // TRISEbits.TRISE6 = 0;

    int counter = 0;

    while(1){
        LATE = (LATE & 0xFF87) | counter << 3;
        resetCoreTimer(); 
        while( readCoreTimer() < 4347826 );
        counter = (counter + 1) % 10;
    }
    return 0;
}