#!/bin/bash
for i in {0..127}
do
	i2cset -y 4 0x50 $i $(cat edid.bin | tail -c +$(( $i + 1 )) | head -c 1 | hexdump -v -e '"0x" 1/1 "%02X" " "') i
done
