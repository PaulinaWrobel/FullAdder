library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL; 
use IEEE.std_logic_textio.all;
use std.textio.all;

entity serialAdderTB is
end entity serialAdderTB;

architecture behav of serialAdderTB is
    signal A_i: std_logic_vector(3 downto 0);
    signal B_i: std_logic_vector(3 downto 0);
    signal start_i: std_logic:='0';
    signal stop_o: std_logic;
    signal clk_i: std_logic:='0';
    signal outputs_o: std_logic_vector(4 downto 0);
	signal sum_ref: std_logic_vector(4 downto 0); 
	signal write_enable: std_logic;
	signal correct: string(1 to 2);

begin
	UUT: entity work.serialAdder
	port map(
		start=>start_i,
		clk=>clk_i,
		IN_A =>A_i,
		IN_B=>B_i,
		leds=>outputs_o,
		stop=>stop_o 
	);

	clk_process: process
  	begin
    	wait for 50 ns;    
    	clk_i <= not clk_i;
  	end process clk_process;

	start_process: process
	begin
		start_i <= '1', '0' after 50 ns;
		wait for 800 ns;
	end process start_process;

  	read_file: process (start_i)
		file file_inputs: text open read_mode is "testbench_table.txt";
		variable line_inputs: line;
		variable A_f, B_f, sum_f: std_logic_vector(3 downto 0);
		variable carry_f: std_logic;
	begin
		if start_i='1' and start_i'event then
			if endfile(file_inputs) then
				assert false
					report "End of file "
					severity Failure;
			else
				if now = 0 ns then
					readline(file_inputs, line_inputs);
				end if;
	        	readline(file_inputs, line_inputs);
				hread(line_inputs, A_f);
				hread(line_inputs, B_f);
				hread(line_inputs, sum_f);
				read(line_inputs, carry_f);
				A_i <= A_f;
				B_i <= B_f;
				sum_ref <= carry_f & sum_f;
			end if;
		end if;
    end process read_file;

	response: process (write_enable)
	begin
		if write_enable='1' and write_enable'event then
			assert outputs_o=sum_ref
				report "Sum from file " & to_string(to_integer(unsigned(A_i))) & " + " & to_string(to_integer(unsigned(B_i)))
					& " = " & to_string(to_integer(unsigned(sum_ref)))
					& " is not correct. UUT output is " & to_string(to_integer(unsigned(outputs_o))) 
				severity Warning;
		end if;
	end process response;

	correct <= "OK" when outputs_o=sum_ref else
				"NO";

	write_enable <= stop_o after 20 ns;

	write_file: process (write_enable)
		file file_results: text open write_mode is "testbench_results.txt";
		variable line_results: line;
		constant space_char: character := ' ';
		constant sep_char: character := '|';
	begin
		if now = 0 ns then
			write(line_results, string'("Time"), right, 10);
			write(line_results, space_char);
			write(line_results, sep_char);
        	write(line_results, string'("hexA"), right, 5);
        	write(line_results, string'("hexB"), right, 5);
        	write(line_results, string'("hexSUM"), right, 7);
        	write(line_results, string'("hexREF"), right, 7);
			write(line_results, space_char);
			write(line_results, sep_char);
        	write(line_results, string'("decA"), right, 5);
        	write(line_results, string'("decB"), right, 5);
        	write(line_results, string'("decSUM"), right, 7);
        	write(line_results, string'("decREF"), right, 7);
			write(line_results, space_char);
			write(line_results, sep_char);
			write(line_results, space_char);
        	write(line_results, string'("CORRECT"), right, 7);
        	writeline(file_results, line_results);
		elsif write_enable='1' and write_enable'event then
			write(line_results, now, right, 10);
			write(line_results, space_char);
			write(line_results, sep_char);
        	hwrite(line_results, A_i, right, 5);
			hwrite(line_results, B_i, right, 5);
			hwrite(line_results, outputs_o, right, 6);
			hwrite(line_results, sum_ref, right, 6);
			write(line_results, space_char);
			write(line_results, sep_char);
			write(line_results, to_integer(unsigned(A_i)), right, 5);
			write(line_results, to_integer(unsigned(B_i)), right, 5);
			write(line_results, to_integer(unsigned(outputs_o)), right, 7);
			write(line_results, to_integer(unsigned(sum_ref)), right, 7);
			write(line_results, space_char);
			write(line_results, sep_char);
			write(line_results, space_char);
			write(line_results, correct, right, 7);
        	writeline(file_results, line_results);
		end if;
	end process write_file;

	
	sim_end_process: process
	begin
		wait for 1000000 ns;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
	end process sim_end_process;

end architecture behav;
