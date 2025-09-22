import bluetooth

def run_client():
# Discover nearby devices
    print("[*] Scanning for devices...")
    nearby_devices = bluetooth.discover_devices(duration=10, lookup_names=True)
    if not nearby_devices:
        print("[!] No devices found.")
        return
    for i, (addr, name) in enumerate(nearby_devices):
        print(f"{i}: {name} [{addr}]")
    choice = int(input("Select device to connect to: "))
    addr = nearby_devices[choice][0]

    print(f"[*] Connecting to {addr}...")

    # Look for the BluetoothChat service on the device
    service_matches = bluetooth.find_service(address=addr)
    port = None
    for match in service_matches:
        if match["name"] == "BluetoothChat":
            port = match["port"]
            break

    if port is None:
        port = 1 # fallback to port 1 (SPP)
    
    sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    sock.connect((addr, port))
    print(f"[+] Connected to {addr} on port {port}")
    
    try:
        while True:
            msg = input("[You] ")
            sock.send(msg)
            data = sock.recv(1024)
            print(f"[Server] {data.decode().strip()}")
    except OSError:
        print("[!] Connection lost.")
    finally:
        sock.close()
        print("[*] Disconnected.")

if __name__ == "__main__":
    run_client()