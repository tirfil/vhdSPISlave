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

-- CPOL = 0 
-- CPHA = 0
-- 8 bits - MSB first

entity spislave is
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
end spislave;

architecture rtl of spislave is
type state_t is (S_IDLE,S_WAIT_CAPTURE,S_WAIT_OUTPUT,S_END);
signal state : state_t;
signal sck_asy, sck_i, sck_q : std_logic;
signal ss_asy,ss_i, ss_q : std_logic;
signal mosi_asy, mosi_i : std_logic;
signal sckup,sckdown,ssdown : std_logic;
signal sout : std_logic_vector(7 downto 0);
signal sin : std_logic_vector(7 downto 0);
signal cnt : INTEGER;
signal capture_edge, output_edge : std_logic;
signal start : std_logic;
begin

	RSYNC: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			ss_asy <= '1';
			ss_i <= '1';
			sck_asy <= '0'; -- CPOL = 0;
			sck_i <= '0';
			sck_q <= '0';
			mosi_asy <= '0';
			mosi_i <= '0';
			ID <= '1';
		elsif (MCLK'event and MCLK = '1') then
			ss_asy <= SS;
			sck_asy <= SCK;
			mosi_asy <= MOSI;
			ss_i <= ss_asy;
			sck_i <= sck_asy;
			mosi_i <= mosi_asy;
			sck_q <= sck_i;
			ss_q <= ss_i;
			ID <= start;
		end if;
	end process RSYNC;
	
	sckup <= not(sck_q) and sck_i;
	sckdown <= sck_q and not(sck_i);
	ssdown <= ss_q and not(ss_i);
	
	capture_edge <= sckup;  -- CPOL=0;
	output_edge <= sckdown;
	
	OTO: process(MCLK, nRST)
	begin
		if (nRST = '0') then
			MISO <= '0';
			state <= S_IDLE;
			POUT <= (others=>'0');
			RDYIN <= '0';
			RDYOUT <= '0';
			sout <= (others=>'0');
			sin <= (others=>'0');
			cnt <= 0;
			start <= '1';
		elsif (MCLK'event and MCLK = '1') then
			if (state = S_IDLE) then
				RDYOUT <= '0';
				--if (ssdown = '0') then
				if (ss_i = '0') then
					sout <= PIN(6 downto 0) & '0';
					MISO <= PIN(7);
					RDYOUT <= '0';
					RDYIN <= '0';
					cnt <= 0;
					state <= S_WAIT_CAPTURE;
				else
					start <= '1';
					state <= S_IDLE;
					RDYOUT <= '0';
					RDYIN <= '0';
					cnt <= 0;
					MISO <= '0';					
				end if;
			elsif (state = S_WAIT_CAPTURE) then
				RDYIN <= '0';
				if (ss_i = '1') then
					start <= '1';
					state <= S_IDLE;
					RDYIN <= '0';
					RDYOUT <= '0';
					cnt <= 0;
					MISO <= '0';
				elsif (capture_edge = '1') then
					if (cnt = 0) then
						RDYIN <= '1';
					end if;
					sin(0) <= mosi_i;
					sin(7 downto 1) <= sin(6 downto 0);
					state <= S_WAIT_OUTPUT;
			    end if;
			elsif (state = S_WAIT_OUTPUT) then
				RDYIN <= '0';
				if (output_edge = '1') then
					MISO <= sout(7);
					sout(7 downto 1) <= sout(6 downto 0);
					if (cnt = 7) then
						cnt <= 0;
						state <= S_END;
					else
						cnt <= cnt + 1;
						state <= S_WAIT_CAPTURE;
					end if;
				end if;
			elsif (state = S_END) then
				POUT <= sin;
				RDYOUT <= '1';
				state <= S_IDLE;
				start <= '0';
			end if;
		end if;
	end process OTO;
end rtl;

