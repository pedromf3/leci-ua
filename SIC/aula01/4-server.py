import bluetooth

server_sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
server_sock.bind(("", bluetooth.PORT_ANY))
server_sock.listen(1)
port = server_sock.getsockname()[1]
bluetooth.advertise_service(server_sock, "BTChatServer",
                                        service_classes=[bluetooth.SERIAL_PORT_CLASS],
                                        profiles=[bluetooth.SERIAL_PORT_PROFILE])

print(f"[*] Waiting for connection on RFCOMM channel {port}")
client_sock, client_info = server_sock.accept()
print(f"[+] Accepted connection from {client_info}")
try:
    while True:
        data = client_sock.recv(1024)
        if not data:
            break
    print(f"[Client]: {data.decode('utf-8')}")
    msg = input("[You]: ")
    client_sock.send(msg.encode('utf-8'))
except OSError:
    pass
    
print("[*] Disconnected.")
client_sock.close()
server_sock.close()