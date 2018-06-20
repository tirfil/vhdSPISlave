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

entity tb_spileds is
end tb_spileds;

architecture stimulus of tb_spileds is

-- COMPONENTS --
	component spileds
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SS		: in	std_logic;
			MOSI		: in	std_logic;
			SCK		: in	std_logic;
			MISO		: out	std_logic;
			LED		: out	std_logic_vector(7 downto 0)
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SS		: std_logic;
	signal MOSI		: std_logic;
	signal SCK		: std_logic;
	signal MISO		: std_logic;
	signal LED		: std_logic_vector(7 downto 0);

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_spileds_0 : spileds
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SS		=> SS,
			MOSI		=> MOSI,
			SCK		=> SCK,
			MISO		=> MISO,
			LED		=> LED
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
	procedure send(value : std_logic_vector) is
		variable temp : std_logic_vector(7 downto 0);
	begin
		temp := value;
		for I in 0 to 7 loop
			MOSI <= temp(7); 
			wait for 100 ns;
			SCK <= '1';
			wait for 100 ns;
			SCK <= '0';
			temp(7 downto 1) := temp(6 downto 0);
		end loop;
	end send;
	begin
		nRST <= '0';
		MOSI <= '0';
		SS <= '1';
		SCK <= '0';
		wait for 1000 ns;
		nRST <= '1';
		wait for 1000 ns;
		SS <= '0';
		send(x"10"); -- force AA
		send(x"AA");
		SS <='1';
		wait for 100 ns;
		SS <= '0';  
		send(x"01"); -- set 55 -> FF
		send(x"55");
		SS <='1';
		wait for 100 ns;
		SS <= '0';
		send(x"02"); -- reset AA -> 55
		send(x"AA");
		SS <='1';
		wait for 100 ns;
		SS <= '0';
		send(x"03"); -- toggle -> AA
		send(x"FF");
		SS <='1';
		wait for 100 ns;
		SS <= '0';   -- reset AA -> 00
		send(x"02");
		send(x"AA");
		SS <='1';
		wait for 100 ns;
		SS <= '0';   -- dummy
		send(x"FF");
		send(x"00");
		SS <='1';
		wait for 1000 ns;				
		RUNNING <= '0';
		wait;
	end process GO;
	
	P_MISO: process(SCK,SS)
	variable temp : std_logic_vector(7 downto 0);
	variable i : integer;
	begin
		if (SS='1') then
			temp := (others=>'0');
			i := 0;
		elsif (SCK='1' and SCK'event) then
			temp(7 downto 1) := temp(6 downto 0);
			temp(0) := MISO;
			i := i mod 8 + 1;
			assert(i/=8) report "=> " & integer'image(to_integer(unsigned(temp)));
		end if;
	end process P_MISO;

end stimulus;
