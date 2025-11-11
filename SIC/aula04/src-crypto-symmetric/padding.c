// Helper file for SIC Lab on Symmetric Cryptography

#include <stdint.h>
#include <assert.h>

#include "aes.h"
#include "padding.h"

// Adds PKCS#7 padding and returns the new plaintext length

int
add_padding( uint8_t * plain, const int plain_size )
{
    assert( plain != 0 );
    int pad_len = 16 - (plain_size % 16);

    for (int i = 0; i < pad_len; ++i){
        plain[plain_size + i] = (uint8_t)pad_len;
    }
    
    return plain_size + pad_len;
}

/*
 * Checks PKCS#7 padding and returns the original plaintext length (w/o padding)
 * If an error is found in the padding, it returns -1.
*/

int
rm_padding( uint8_t * padded, const int full_size )
{
    assert( padded != 0 );
    int pad_len = padded[full_size - 1];

    if (pad_len < 1 || pad_len > 16 || pad_len > full_size){
        return -1;
    }

    for(int i = 0; i < pad_len; ++i){
        if (padded[full_size - 1 - i] != pad_len) return -1;
    }

    return full_size - pad_len;
}
