import bluetooth
import sys

def get_device_name(mac_address, timeout=10):
    print(f"Looking up name for MAC address: {mac_address}")
    name = bluetooth.lookup_name(mac_address, timeout=timeout)
    if name:
        print(f"Device name: {name}")
    else:
        print("Could not find device name (timeout or not in range).")
    return name

if __name__ == "__main__":
    get_device_name( sys.argv[1] )
