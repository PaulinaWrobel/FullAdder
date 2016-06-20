library ieee;
use ieee.std_logic_1164.all;

entity control_tb is
end entity control_tb;

architecture behav of control_tb is
	signal clk_i: std_logic := '0';
	signal start_i, rst_i, s1_i, s0_i, stop_i: std_logic;

begin

	UUT: entity work.control
	port map(
		clk => clk_i,
		start => start_i,
		rst_l => rst_i,
		s0 => s0_i,
		s1 => s1_i,
		stop => stop_i
	);

	clk_i <= not clk_i after 50 ns;
	start_i <= '0', '1' after 110 ns, '0' after 1030 ns, '1' after 1810 ns, '0' after 1820 ns;

	sim_end_process: process
	begin
		wait for 2000 ns;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
	end process sim_end_process;

end architecture behav;




