# Enable pyserial extensions
import pyftdi.serialext

import time

# Open a serial port on the second FTDI device interface (IF/2) @ 3Mbaud
port = pyftdi.serialext.serial_for_url('ftdi://ftdi:232:AB0K3Q4S/1', baudrate=9600, bytesize=8, stopbits=1, parity='N', xonxoff=False, rtscts=False)

#'ftdi://ftdi:2232h/2'
#ftdi://ftdi:232:AB0JNVIE/1
# Send bytes
#for i in range(1,24024):
#	port.write(b'U')
#	print(i)

while (1):
    data_list = [0, 255, 0x10, 0x27]
    port.write(bytearray(data_list))
    time.sleep(1.0)
    data_list = [0, 0, 0, 0]
    port.write(bytearray(data_list))
    time.sleep(1.0)

# Receive bytes
# for i in range(1,1024):
	# data = port.read(10)
	# print(data)


