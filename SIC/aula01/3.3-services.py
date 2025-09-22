import bluetooth
import sys

def discover_services(device_addr):
    services = bluetooth.find_service(address=device_addr)
    if services:
        print(f"Services and UUIDs for device {device_addr}:")
    for service in services:
        print(f"|--| Service Classes: {service['service-classes']}")
        print(f"| | Service UUID: {service['service-id']}")
        print(f"|")
    else:
        print(f"No services found for {device_addr}.")
        
if __name__ == "__main__":
    discover_services( sys.argv[1] )