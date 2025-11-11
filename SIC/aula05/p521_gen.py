#!/usr/bin/python3

import sys
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.backends import default_backend


def list_curves():
    print("List of available curves:\n")
    for curve in ec._CURVE_TYPES:
        print("  -", curve)


def main():
    if len(sys.argv) != 5:
        print("Usage: ecc_gen <password> <curve_name> <private_key_file> <public_key_file>")
        print("Example: ecc_gen mypass P-521 priv.pem pub.pem")
        print("\nAvailable curves:")
        list_curves()
        sys.exit(1)

    password = sys.argv[1].encode()
    curve_name = sys.argv[2]
    priv_file = sys.argv[3]
    pub_file = sys.argv[4]

    try:
        curve_class = ec._CURVE_TYPES[curve_name]
        curve = curve_class()
    except KeyError:
        print(f"Error: Unsupported curve '{curve_name}'")
        print("Use one of:")
        list_curves()
        sys.exit(1)

    private_key = ec.generate_private_key(curve, default_backend())

    public_key = private_key.public_key()

    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.BestAvailableEncryption(password)
    )

    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    with open(priv_file, "wb") as f:
        f.write(private_pem)
    with open(pub_file, "wb") as f:
        f.write(public_pem)

    print(f"Key pair generated successfully with curve {curve_name}")
    print(f"Private key → {priv_file}")
    print(f"Public  key → {pub_file}")


if __name__ == "__main__":
    main()
