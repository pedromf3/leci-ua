import sys
from pydbus import SystemBus
bus = SystemBus()
def connect_device(mac_address):
    device_path = "/org/bluez/hci0/dev_" + mac_address.replace(":", "_")
    device = bus.get("org.bluez", device_path)
    try:
        print("Connecting to device...")
        device.Connect() # This connects all available services
        print("Connected!")
        return True
    except Exception as e:
        print(f"Failed to connect: {e}")
    return False

if __name__ == "__main__":
    connect_device( sys.argv[1] )