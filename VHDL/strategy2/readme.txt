Strategy2
=========

Instead of the resynchronization of MOSI , SS and SCK inputs with FPGA clock domain,
SPI serial operations are performed directly in SCK clock domain.
Delay between SCK input and MISO output is then reduced.
Resynchronisation occurs on parallel output bus and related signals.
SS signal is managed as a reset signal for this part.

First byte sent contents generally the command intruction.
For read operation, the timing between command decoding and output data setup is too short. 
A workaround is to manage the first nibble (4 MSB bits) of first byte 
for early setup data for next byte 's output. 


