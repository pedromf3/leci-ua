from cryptography.hazmat.primitives.asymmetric import rsa, padding

from cryptography.hazmat.primitives import serialization, hashes

def main():
    with open("ciphertext.txt", "rb") as filecipher:
        ciphertext = filecipher.read()

    with open("priv.txt", "rb") as filepriv:
        priv_key = serialization.load_pem_private_key(filepriv.read(), password=None)

    plaintext = priv_key.decrypt(ciphertext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )

    with open("plaintext.txt", "wb") as fileplain:
        fileplain.write(plaintext)

if __name__ == "__main__":
    main()      