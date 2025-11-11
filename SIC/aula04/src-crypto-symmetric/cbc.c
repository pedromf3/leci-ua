// Helper file for SIC Lab on Symmetric Cryptography

#include <stdint.h>
#include <memory.h>
#include <assert.h>

#include "aes.h"
#include "cbc.h"

void
aes128_cbc_enc( void * ctx, const uint8_t * iv, const uint8_t * plaintext, const int plain_size, uint8_t * ciphertext )
{
    assert( ctx != 0 && iv != 0 && plaintext != 0 && ciphertext != 0);
    assert( plain_size % 16 == 0);

    uint8_t prev[16];
    memcpy(prev, iv, 16);

    int blocks = plain_size / 16;
    for (int i = 0; i < blocks; ++i){
        uint8_t xored[16];
        const uint8_t *in = plaintext + i * 16;
        uint8_t *out = ciphertext + i * 16;

        for (int j = 0; j < 16; ++j) xored[j] = in[j] ^ prev[j];

        aes128_block_enc(ctx, xored, out);

        memcpy(prev, out, 16);
    }
}

void
aes128_cbc_dec( void * ctx, const uint8_t * iv, const uint8_t * ciphertext, const int cipher_size, uint8_t * plaintext )
{
    assert( ctx != 0 && iv != 0 && plaintext != 0 && ciphertext != 0);
    assert(cipher_size % 16 == 0);

    uint8_t prev[16];
    memcpy(prev, iv, 16);

    int blocks = cipher_size / 16;
    for (int i = 0; i < blocks; ++i){
        uint8_t dec[16];
        const uint8_t *in = ciphertext + i * 16;
        uint8_t *out = plaintext + i * 16;

        aes128_block_dec(ctx, in, dec);

        for (int j = 0; j < 16; ++j) out[j] = dec[j] ^ prev[j];

        memcpy(prev, in, 16);
    }
}