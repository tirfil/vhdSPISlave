
ghdl -a ..\VHDL\spislave.vhd
ghdl -a ..\test\tb_spislave.vhd
ghdl -e tb_spislave
ghdl -r tb_spislave --wave=spislave.ghw
