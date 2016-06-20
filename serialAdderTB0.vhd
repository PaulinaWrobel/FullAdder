library ieee;
use ieee.std_logic_1164.all;

entity serialAdderTB is

end entity serialAdderTB;

architecture behav of serialAdderTB is
    signal A_i: std_logic_vector(3 downto 0):= "0010";
    signal B_i: std_logic_vector(3 downto 0):= "0011";
    signal start_ii: std_logic:='0';
    signal stop_o: std_logic;
    signal clk_ii: std_logic:='0';
    signal outputs_o: std_logic_vector(4 downto 0);

begin
	UUT: entity work.serialAdder
	port map(
		start_i=>start_ii,
		clk_i=>clk_ii,
		IN_A =>A_i,
		IN_B=>B_i,
		leds=>outputs_o,
		stop=>stop_o 
	);

	clk_process: process
  	begin
    	wait for 50 ns;    
    	clk_ii <= not clk_ii;
  	end process clk_process;
	
	start_ii <= '0', '1' after 110 ns, '0' after 1030 ns, '1' after 1810 ns, '0' after 1820 ns;	

	sim_end_process: process
	begin
		wait for 2000 ns;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
	end process sim_end_process;

end architecture behav;