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

entity spisfr0 is
	port(
		SCK			: in	std_logic;
		SS			: in	std_logic;
		MOSI		: in	std_logic;
		MISO		: out	std_logic;
		PIN			: out	std_logic_vector(7 downto 0) := (others=>'0');
		VALID		: out	std_logic;
		POUT		: in	std_logic_vector(7 downto 0);
		LOAD		: out	std_logic;
		NIBBLE		: out	std_logic_vector(3 downto 0);
		VALNIB		: out 	std_logic
	);
end spisfr0;

architecture rtl of spisfr0 is
signal counter : integer range 0 to 7;
signal next_counter : integer range 0 to 7;
signal sin : std_logic_vector(7 downto 0);
signal sout : std_logic_vector(6 downto 0);
signal first : std_logic;
begin

	next_counter <= 0 when counter = 7 else counter + 1;

	PCNT: process(SCK, SS)
	begin
		if (SS = '1') then
			counter <= 0;
		elsif (SCK'event and SCK = '0') then
			counter <= next_counter;
		end if;
	end process PCNT;
	
	PRIN: process(SCK, SS)
	begin
		if (SS = '1') then
			sin <= (others => '0');
		elsif (SCK'event and SCK = '1') then
			sin(0) <= MOSI;
			sin(7 downto 1) <= sin(6 downto 0);
		end if;
	end process PRIN;
	
	PIN0: process(SCK, SS)
	begin
		if (SS = '1') then
			VALID <= '0';
		elsif (SCK'event and SCK = '1') then
			if (counter = 7) then
				PIN <= sin(6 downto 0) & MOSI;
				VALID <= '1';
			else
				VALID <= '0';
			end if;
		end if;
	end process PIN0;
	
	MISO <= POUT(7) when counter = 0 else sout(6);
	
	POUT0: process(SCK, SS)
	begin
		if (SS = '1') then
			sout <= (others => '0');
		elsif (SCK'event and SCK = '0') then
			if (counter = 0) then
				sout(6 downto 0) <= POUT(6 downto 0);
			else
				sout(6 downto 1) <= sout(5 downto 0);
			end if;
		end if;
	end process POUT0;
	
	LOAD <= '0' when counter = 0 else '1';
	
	PFIRST: process(SCK, SS)
	begin
		if (SS = '1') then
			first <= '1';
		elsif (SCK'event and SCK = '0') then
			if (counter = 7) then
				first <= '0';
			end if;
		end if;
	end process PFIRST;
	
	PNIBBLE: process(SCK, SS)
	begin
		if (SS = '1') then
			NIBBLE <= (others => '0');
			VALNIB <= '0';
		elsif (SCK'event and SCK = '1') then
			if (first = '1' and counter = 3) then
				NIBBLE <= sin(2 downto 0) & MOSI;
				VALNIB <= '1';
			else
				VALNIB <= '0';
			end if;
		end if;
	end process PNIBBLE;
	

end rtl;

