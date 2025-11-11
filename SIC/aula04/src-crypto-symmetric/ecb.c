#include <stdint.h>
#include <memory.h>
#include <assert.h>

#include "aes.h"
#include "ecb.h"

void
aes128_ecb_enc ( const void * ctx, const uint8_t * plaintext, const int plain_size, uint8_t * ciphertext )
{
    assert( ctx != 0 && plaintext != 0 && ciphertext != 0);
    assert( plain_size % 16 == 0);

    int blocks = plain_size / 16;
    for (int i = 0; i < blocks; ++i){
        aes128_block_enc( ctx, plaintext + i * 16, ciphertext + i * 16);
    }
}

void
aes128_ecb_dec ( const void * ctx, const uint8_t * ciphertext, const int cipher_size, uint8_t * plaintext )
{
    assert( ctx != 0 && plaintext != 0 && ciphertext != 0);
    assert( cipher_size % 16 == 0);

    int blocks = cipher_size / 16;
    for (int i = 0; i < blocks; ++i){
        aes128_block_dec( ctx, ciphertext + i * 16, plaintext + i * 16);
    }
}
