library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all;



entity timeout_sim is
end entity timeout_sim;

architecture sim of timeout_sim is

	signal clk, pulsed_rst, sresetn: std_ulogic;
	signal cnt_out:    std_ulogic_vector(1 downto 0);

begin


        dut: entity work.timeout(arc)
		generic map(freq => 50)
		port map(
			clk     	=> clk,
			sresetn      	=> sresetn,
			cnt_out 	=> cnt_out,
			pulsed_rst	=> pulsed_rst
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
		pulsed_rst <= '0';
		wait for 37 ns;
                sresetn <= '1';
		wait for 106 us;
		pulsed_rst <= '1';
		wait for 20 ns;
		pulsed_rst <= '0';
		wait;
	wait;
        end process;


end architecture sim;
