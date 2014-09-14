#!/bin/bash
ghdl -a ../src/rgb2yuv.vhd
ghdl -a yuv_tb.vhd
ghdl -e yuv_tb
echo run yuv_tb
ghdl -r yuv_tb --stop-time=100ns --wave=yuv.ghw
gtkwave -c 2 -o yuv.ghw -a yuv.gtkw
ghdl --clean
rm yuv.ghw work-obj93.cf
