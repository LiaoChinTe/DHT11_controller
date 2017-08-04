library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all;



entity timer_sim is
end entity timer_sim;

architecture sim of timer_sim is

	signal clk:        std_ulogic;
	signal sresetn:    std_ulogic;
	signal cnt_out:    std_ulogic_vector(1 downto 0);

begin


        dut: entity work.timer(arc)
		generic map(freq => 50)
		port map(
			clk     	=> clk,
			sresetn      	=> sresetn,
			cnt_out 	=> cnt_out
		);

       process
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process;
        

        process
	begin
                sresetn <= '0'; -- assert reset low
		wait for 37 ns;
                sresetn <= '1';
		wait for 1102 ms;
		sresetn <= '0';
		wait for 200 ns;
		sresetn <= '1';
		wait;
	wait;
        end process;


end architecture sim;
