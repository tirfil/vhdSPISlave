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

entity spileds is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SS		: in	std_logic;
		MOSI		: in	std_logic;
		SCK		: in	std_logic;
		MISO		: out	std_logic;
		LED		: out	std_logic_vector(7 downto 0)
	);
end spileds;

architecture struct of spileds is
-- COMPONENTS --
	component ledmngt
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
	end component;
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
	
	signal RDYIN, RDYOUT, ID : std_logic;
	signal PIN,POUT : std_logic_vector(7 downto 0);
	
begin
-- PORT MAP --
	I_ledmngt_0 : ledmngt
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			ID		=> ID,
			LOAD		=> RDYOUT,
			NXT		=> RDYIN,
			PIN		=> PIN,
			POUT		=> POUT,
			LED		=> LED
		);
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


end struct;

