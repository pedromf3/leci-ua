import sys
import time
from pydbus import SystemBus

# Get access to the local device using its D-Bus path
bus = SystemBus()
bluez = bus.get("org.bluez", "/org/bluez/hci0")
def pair_device(mac_address):
    # Get access to the remote device using its D-Bus path
    device_path = "/org/bluez/hci0/dev_" + mac_address.replace(":", "_")
    print(f"Looking for device at {device_path}")
    try:
        device = bus.get("org.bluez", device_path)
        print("Pairing...")
        device.Pair() # This will initiate pairing
        # Wait a moment to let pairing complete
        for _ in range(10):
        # Get the device's properties and see if they indicate that it is paired
            props = device.GetAll("org.bluez.Device1")
        if props.get("Paired", False):
            print("Successfully paired!")
            return True
        time.sleep(1)
        print("Pairing timed out or failed.")
        return False
    except Exception as e:
        print(f"Error during pairing: {e}")
    return False

if __name__ == "__main__":
    success = pair_device(sys.argv[1])
    if success:
        print("Device paired.")
    else:
        print("Failed to pair device.")