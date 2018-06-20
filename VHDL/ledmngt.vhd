--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ledmngt is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		ID		: in	std_logic;
		LOAD		: in	std_logic;
		NXT		: in	std_logic;
		PIN		: out	std_logic_vector(7 downto 0);
		POUT		: in	std_logic_vector(7 downto 0);
		LED		: out	std_logic_vector(7 downto 0)
	);
end ledmngt;

architecture rtl of ledmngt is
signal ledi : std_logic_vector(7 downto 0);
signal idreg : std_logic_vector(7 downto 0);
begin

	P0: process(MCLK, nRST)
	variable temp : std_logic_vector(7 downto 0);
	begin
		if (nRST = '0') then
			idreg <= (others=>'1');
			ledi <= (others=>'0');
			temp := (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
			if (LOAD = '1') then
				if (ID = '1') then
					idreg <= POUT;
				else
					case idreg is
						when x"00" => -- clear all
							temp := (others=>'0');
						when x"01" => -- set
							temp := ledi or POUT;
						when x"02" => -- reset
							temp := ledi and not(POUT);
						when x"03" => -- toggle
							temp := ledi xor POUT;
						when x"10" => --force
							temp := POUT;
						when others => -- nothing
							temp := ledi;
					end case;
					ledi <= temp;
				end if;			
			end if; 
		end if;
	end process P0;
	
	P1: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			PIN <= (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
			if (NXT='1') then
				if (ID = '1') then
					PIN <= ledi;
				else
					PIN <= (others=>'0');
				end if;
			end if;
		end if;
	end process P1;
		
	
	--PIN <= ledi;
	LED <= ledi;
	
end rtl;

