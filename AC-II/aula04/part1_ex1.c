#include <detpic32.h>

int main(void){
    // Configure RC14 as output        
    TRISC = TRISC & 0xBFFF; // 0xBFFF = 1011 1111 1111 1111
    // or TRISCbits.TRISC14 = 0; 

    LATC = LATC | 0x4000;   // 0x4000 = 0100 0000 0000 0000
    // or LATCbits.LATC14 = 1;

while(1){              
    // CoreTimer 
    resetCoreTimer();
    while(readCoreTimer() < PBCLK/2); // Wait 0.5s 
                
    LATC = LATC ^ 0x4000; // Toggle RC14 port value
    // # or LATCbits.LATC14 = !LATCbits.LATC14;
    }
return 0;
}