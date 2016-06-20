library ieee;
use ieee.std_logic_1164.all;

entity control is
port(
	clk: in std_logic;
	start: in std_logic;
	rst_l: out std_logic;
	s0: out std_logic;
	s1: out std_logic;
	stop: out std_logic
);
end entity control;

architecture behav of control is
	type state_type is (IDLE,RESET,LOAD,SHIFT1,SHIFT2,SHIFT3,SHIFT4);
	signal state: state_type;
begin

fsm: process (clk,start)
begin
	if start='1' then
		state <= RESET;
		rst_l <= '0';
		stop <= '0';
	elsif clk='1' and clk'event then
		case state is
			when RESET => 
				if start='0' then
					state <= LOAD;
				end if;
				rst_l <= '1';
				stop <= '0';
				s1 <= '1';
				s0 <= '1';
			when LOAD => 
				state <= SHIFT1;
				rst_l <= '1';
				stop <= '0';
				s1 <= '0';
				s0 <= '1';
			when SHIFT1 => 
				state <= SHIFT2;
				rst_l <= '1';
				stop <= '0';
				s1 <= '0';
				s0 <= '1';
			when SHIFT2 => 
				state <= SHIFT3;
				rst_l <= '1';
				stop <= '0';
				s1 <= '0';
				s0 <= '1';
			when SHIFT3 => 
				state <= SHIFT4;
				rst_l <= '1';
				stop <= '0';
				s1 <= '0';
				s0 <= '1';
			when SHIFT4 => 
				state <= IDLE;
				rst_l <= '1';
				stop <= '1';
				s1 <= '0';
				s0 <= '0';
			when IDLE => 
				rst_l <= '1';
				stop <= '1';
				s1 <= '0';
				s0 <= '0';
		end case;
	end if;
end process fsm;

end architecture behav;