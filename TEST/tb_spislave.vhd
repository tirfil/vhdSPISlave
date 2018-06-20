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

entity tb_spislave is
end tb_spislave;

architecture stimulus of tb_spislave is

-- COMPONENTS --
	component spislave
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SCK		: in	std_logic;
			MOSI		: in	std_logic;
			MISO		: out	std_logic;
			SS		: in	std_logic;
			POUT		: out	std_logic_vector(7 downto 0);
			PIN		: in	std_logic_vector(7 downto 0);
			ID		: out	std_logic;
			RDYIN		: out	std_logic;
			RDYOUT		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SCK		: std_logic;
	signal MOSI		: std_logic;
	signal MISO		: std_logic;
	signal SS		: std_logic;
	signal POUT		: std_logic_vector(7 downto 0);
	signal PIN		: std_logic_vector(7 downto 0);
	signal ID		: std_logic;
	signal RDYIN		: std_logic;
	signal RDYOUT		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_spislave_0 : spislave
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SCK		=> SCK,
			MOSI		=> MOSI,
			MISO		=> MISO,
			SS		=> SS,
			POUT		=> POUT,
			PIN		=> PIN,
			ID => ID,
			RDYIN		=> RDYIN,
			RDYOUT		=> RDYOUT
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
		PIN <= "00001111";  --0F
		SS <= '1';
		MOSI <= '0';
		SCK <= '0';
		wait for 1000 ns;
		nRST <= '1';
		wait for 100 ns;
		SS <= '0';
		wait for 100 ns;
		send("00111100"); ----3C
		PIN <= "11110000"; --F0
		send("11001100"); ----CC
		PIN <= "10100101"; --A3
		wait for 100 ns;
		SS <= '1';
		wait for 100 ns;
		SS <= '0';		
		wait for 100 ns;
		send("11001100"); --CC
		PIN <= "00001111";  --0F
		send("00111100"); --3C
		wait for 100 ns;					
		SS <= '1';
		wait for 100 ns;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
