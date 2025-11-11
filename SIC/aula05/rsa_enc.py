from cryptography.hazmat.primitives.asymmetric import rsa, padding

from cryptography.hazmat.primitives import serialization, hashes

def main():
    with open("plaintext.txt", "rb") as fileplain:
        plaintext = fileplain.read()

    with open("pub.txt", "rb") as filepub:
        public_key = serialization.load_pem_public_key(filepub.read())

    ciphertext = public_key.encrypt(plaintext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )

    with open("ciphertext.txt", "wb") as filecipher:
        filecipher.write(ciphertext)


if __name__ == "__main__":
    main()      