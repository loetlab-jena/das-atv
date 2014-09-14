EDID-Support of DAS ATV System
==============================

Flashing EEPROM on HDMI2RGB
---------------------------
For proper function of the HDMI2RGB board for analog ATV transmission you have to set your HDMI output to 567i. When the EEPROM is flashed with the content of edid.bin your computer gets automatically configured to the correct timing after connecting HDMI2RGB to your pc.
You can flash the EEPROM over HDMI. You have to connect the board via HDMI and then do the following things.

  - load i2c device support to get access to your i2c busses:
    *sudo modprobe i2c-dev*
  - install required tools and libs
    *sudo apt-get install i2c-tools edid-decode*
  - find the i2c bus of your HDMI port:
    *sudo i2cdetect -y X* with X the number of the i2c bus where the output looks only like this when the board is connected(connect/unconnect the board to check it)

```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --
```

  - generate binary file with edid.m(matlab or octave) - please change the serial number for every new device

  - write the content of edid.bin to the EEPROM
    *./edid_write.sh X* with X as your i2c bus

  - check for correct EEPROM content
    *sudo edid-rw/edid-rw X | edid-decode* with X as your i2c bus
    the last lines should look like this:

```
Manufacturer: DAS Model 25 Serial Number 1
Made week 37 of 2014
EDID version: 1.3
Digital display
Maximum image size: 100 cm x 100 cm
Gamma: 1.0
Supported color formats: RGB 4:4:4, YCrCb 4:2:2
First detailed timing is preferred timing
Established timings supported:
Standard timings supported:
Detailed mode: Clock 27.000 MHz, 10 mm x 10 mm
               1440 1440 1441 1594 hborder 22
                576  576  577  591 vborder 0
               -hsync -vsync interlaced
Monitor name: DAS DB0HL
Monitor ranges: 50-50HZ vertical, 15-32kHz horizontal, max dotclock 30MHz
ASCII string: DL3YC
Checksum: 0x66
```
