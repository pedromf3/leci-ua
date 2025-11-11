from cryptography.hazmat.primitives.asymmetric import rsa

from cryptography.hazmat.primitives import serialization

import sys

def main():
    key_size = int(sys.argv[3])

    key_pair = rsa.generate_private_key( public_exponent=65537, key_size=key_size )

    priv_key_pem = key_pair.private_bytes( encoding=serialization.Encoding.PEM,
                                        format=serialization.PrivateFormat.TraditionalOpenSSL,
                                        encryption_algorithm=serialization.NoEncryption() )
    
    pub_key_pem = key_pair.public_key().public_bytes( encoding=serialization.Encoding.PEM,
                                        format=serialization.PublicFormat.SubjectPublicKeyInfo )
    with open(sys.argv[1], 'wb') as priv_file:
        priv_file.write(priv_key_pem)
    with open(sys.argv[2], 'wb') as pub_file:
        pub_file.write(pub_key_pem)
    return 0

if __name__ == "__main__":
    main()