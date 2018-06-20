
ghdl -a ..\VHDL\spislave.vhd
ghdl -a ..\VHDL\ledmngt.vhd
ghdl -a ..\VHDL\spileds.vhd
ghdl -a ..\test\tb_spileds.vhd
ghdl -e tb_spileds
ghdl -r tb_spileds --wave=spileds.ghw
