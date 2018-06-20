# vhdSPISlave
SPI slave in mode 0

## signals:
+ MCLK : main clock
+ nRST : reset active low
+ SS   : chip select active low (input)
+ MISO : master in slave out (output)
+ SCK : serial clock (input)
+ MOSI : master out slave in (input)
+ POUT : parallel out (output) 8 bit (master -> slave)
+ PIN  : parallel in (input) 8 bit (slave -> master)
+ RDYOUT : data valid on POUT (output)
+ RDYIN : data on PIN could change (output)
+ ID : first byte on POUT (output) (to use with RDYOUT signal)

## example : SPI LEDs management

serial format:

| ID (8bit) | value (8 bit) |
|:---:|:-----:|


| ID  |Comment        |LEDs operation|
|:---:| -------------:|-------:|
| 00h | clear all leds| 00 |
| 01h | set leds      | OR value |
| 02h | reset leds    | AND NOT(value)
| 03h | toggle leds   | XOR value |
| 10h | force leds value | value |
