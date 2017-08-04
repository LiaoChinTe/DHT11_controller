library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all;



entity timeoutsim is
end entity timeoutsim;

architecture sim of timeoutsim is

	signal clk:        std_ulogic;
	signal sresetn:    std_ulogic;
	signal cnt_out:    std_ulogic_vector(1 downto 0);

begin


        dut: entity work.timeout(arc)
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
		wait for 500 us;
		sresetn <= '0';
		wait for 20 ns;
		sresetn <= '1';
		wait;
	wait;
        end process;


end architecture sim;
