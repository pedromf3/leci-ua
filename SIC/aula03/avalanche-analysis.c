#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <assert.h>

// gcc -O2 -Wall avalanche-analysis.c -o avalanche-analysis -lcrypto

#include <openssl/types.h>
#include <openssl/evp.h>
#include <openssl/md5.h>
#include <openssl/sha.h>

#ifndef MAX
#define MAX(x,y) (x > y ? x : y)
#endif

// this is big enough for all our targets: sha256 and md5
#define HASH_OUTPUT_MAX_BYTES   MAX( MD5_DIGEST_LENGTH,SHA256_DIGEST_LENGTH )
#define HASH_OUTPUT_MAX_BITS	(8 * HASH_OUTPUT_MAX_BYTES)
#define HASH_OUTPUT_BLOCK_SIZE	HASH_OUTPUT_MAX_BYTES

int bad_usage( const char *p ) {
    fprintf(stderr, "Usage:\n\t%s  M  N\n\n"
                    "\tM: the size in bytes of the initial source message\n"
                    "\tN: the number of one-bit altered messages\n"
                    "\n",p);
    return -2;
}

static int ones[16] = {
    0, 1, 1, 2, // 0 to 3
    1, 2, 2, 3, // 4 to 7
    1, 2, 2, 3, // 8 to 11
    2, 3, 3, 4  // 12 to 15
};

/*
 * Counts 1's in a byte
*/
int
count_1s( uint8_t c )
{
    return ones[c & 0xF] + ones[c >> 4];
}

/*
 * Returns the number of bits at 1 within the first `size` bytes
*/
int
count_diff_bits( const uint8_t *h1, const uint8_t *h2, const uint32_t size )
{
    int n = 0;

    for (int i = 0; i < size; i++) {
        n += count_1s( h1[i] ^ h2[i] );
    }

    assert(n <= 8 * size);

    return n;
}

/*
 * Copies `source` to `working_buf` and changes a bit on `working_buf`
 * also writes the index of the bit changed to `track_mods`
 *
 * track_mods: one byte per source byte; each bit in track_mods[i] marks a
 *            bit of source[i] that has already been modified.
*/
void change_me_a_bit( const uint8_t *source, const uint32_t source_size,
		      uint8_t *track_mods, uint8_t *working_buf)
{
    memcpy( working_buf, source, source_size );

    uint32_t bit_idx = (rand() % (source_size * 8)); // the (random) bit index
    uint32_t byte_idx = bit_idx / 8;
    uint32_t bit_offset = bit_idx % 8;
    uint8_t bit_mask = 1 << bit_offset;

    uint32_t try = 0;

    while (track_mods[byte_idx] & bit_mask) { // Deja vu bit?
	try++;

        assert( try < source_size * 8); // if all bits were already modified

	bit_idx = (bit_idx + 1) % (source_size * 8); // Try next bit
	byte_idx = bit_idx / 8;
	bit_offset = bit_idx % 8;
	bit_mask = 1 << bit_offset;
    }

    working_buf[byte_idx] ^= bit_mask; // change the bit
    track_mods[byte_idx] |= bit_mask; // stores the action

    assert( count_diff_bits( source, working_buf, source_size ) == 1);
}

void change_me_a_byte( const uint8_t *source, const uint32_t source_size,
                       uint8_t *track_mods, uint8_t *working_buf )
{
    memcpy( working_buf, source, source_size );

    uint32_t byte_idx = rand() % source_size; // random byte index
    uint32_t try = 0;

    uint32_t track_idx = byte_idx;           // index into track_mods (one entry per source byte)
    uint8_t bit_mask = 1 << (byte_idx % 8);  // choose a bit inside track_mods[track_idx]

    // Note: using the same bitmap logic as change_me_a_bit.
    // If the chosen bit is already set, try the next byte.
    while (track_mods[track_idx] & bit_mask) {
        try++;
        assert( try < source_size ); // all bytes already modified?
        byte_idx = (byte_idx + 1) % source_size;
        track_idx = byte_idx;
        bit_mask = 1 << (byte_idx % 8);
    }

    // Modify the whole byte - flip all bits (XOR with 0xFF).
    // Could also use a random different value; flipping is deterministic and fine.
    working_buf[byte_idx] ^= 0xFF;

    // Mark the byte as modified using one bit in track_mods[track_idx]
    track_mods[track_idx] |= bit_mask;

    // Ensure we changed at least 1 and at most 8 bits in the message
    int diff = count_diff_bits( source, working_buf, source_size );
    assert( diff >= 1 && diff <= 8 );
}

/* 
 * Produces sha256 from `data` with `data_size` bytes and writes the output to `output_hash`
*/
void
sha256( const uint8_t *data, const uint32_t data_size, uint8_t *output_hash )
{
    EVP_MD_CTX * ctx = EVP_MD_CTX_new(); // The generic hashing context

    EVP_DigestInit( ctx, EVP_sha256() ); // Context initialization

    // Process the entire data and Compute the the final hash value
    EVP_DigestUpdate( ctx, data, data_size );
    EVP_DigestFinal( ctx, output_hash, 0 );

    EVP_MD_CTX_free( ctx );
}

/* 
 * Produces md5 from `data` with `data_size` bytes and writes the output to `output_hash`
*/
void
md5( const uint8_t *data, const uint32_t data_size, uint8_t *output_hash )
{
    EVP_MD_CTX * ctx = EVP_MD_CTX_new();

    EVP_DigestInit( ctx, EVP_md5() );
    EVP_DigestUpdate( ctx, data, data_size );
    EVP_DigestFinal( ctx, output_hash, 0 );

    EVP_MD_CTX_free( ctx );
}

int main( int argc, char *argv[] )
{
    // we want 2 arguments
    if (argc != 3) {
        return bad_usage( argv[0] );
    }

    // get the numbers
    uint32_t source_size;
    uint32_t n_variations;

    assert( sscanf( argv[1], "%d", &source_size ) );
    assert( sscanf( argv[2], "%d", &n_variations ) );

    fprintf(stderr,"Working with M=%d and N=%d...\n",source_size,n_variations);

    assert( n_variations <= source_size * 8 );

    // get some space for histogram and fill it with zeros
    uint32_t histogram[HASH_OUTPUT_MAX_BITS + 1];
    memset( histogram, 0, sizeof(histogram) );

    // space for source
    uint8_t * source = malloc( source_size );
    assert( source != 0 );

    // space for variation
    uint8_t * mod = malloc( source_size );
    assert( mod != 0 );

    /*
     * Used to avoid repetition on the 1bit modification...
     * calloc zeros it (one byte per source byte; each byte is used as a mask)
    */
    uint8_t * track_mods = calloc( source_size, 1 );
    assert( track_mods != NULL );

    // Fill source with random data from /dev/urandom
    int fd = open( "/dev/urandom", O_RDONLY );
    assert(fd >= 0);
    ssize_t rr = read( fd, source, source_size );
    (void) rr; // ignore return for now
    close ( fd );

    uint8_t source_hash[HASH_OUTPUT_BLOCK_SIZE];
    uint8_t mod_hash[HASH_OUTPUT_BLOCK_SIZE];

    const int size_of_hash = SHA256_DIGEST_LENGTH;

    // seed PRNG for choosing modification positions and byte values
    srand((unsigned)time(NULL) ^ (uintptr_t)source);

    sha256( source, source_size, source_hash );

    /*
     * Create N different one-bit variations, hash each, and build histogram.
     */
    for (uint32_t i = 0; i < n_variations; i++) {
        change_me_a_bit( source, source_size, track_mods, mod );
        sha256( mod, source_size, mod_hash );

        const int n = count_diff_bits( source_hash, mod_hash, size_of_hash );
        histogram[n]++;
    }

    // make sure we have used N different 1-bit modifications
    uint8_t * zeros = calloc( source_size, 1 );
    assert( zeros != NULL );

    // count_diff_bits(track_mods, zeros, source_size) returns number of set bits in track_mods
    assert(count_diff_bits( track_mods, zeros, source_size ) == (int)n_variations);

    printf( "The results are (Hamming distance in bits -> occurrences):\n" );
    for (int i = 0; i <= size_of_hash * 8; i++) {
        if (histogram[i]>0){
            printf( "%d %u\n", i, histogram[i] );
        }
    }

    /*
     * Clean up
    */
    free(source);
    free(mod);
    free(track_mods);
    free(zeros);

    return 0;
}