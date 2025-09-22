import bluetooth

def scan_bluetooth_devices():
    try:
        print("Scanning for Bluetooth devices...")
        nearby_devices = bluetooth.discover_devices(duration=3, lookup_names=True)
        print(f"Found {len(nearby_devices)} devices.")
        for addr, name in nearby_devices:
            print(f"Device: {name}, Address: {addr}")
    except bluetooth.BluetoothError as e:
        print(f"Bluetooth error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    scan_bluetooth_devices()