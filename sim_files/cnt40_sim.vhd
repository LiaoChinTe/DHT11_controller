library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all; -- to use std_ulogic and std_ulogic_vector types

entity CNT40_sim is
end entity CNT40_sim;

architecture sim of CNT40_sim is

	signal clk:            std_ulogic;
	signal count:          std_ulogic;
	signal resetn:          std_ulogic;
	signal cnt_end:            std_ulogic;

begin


        dut: entity work.CNT40(arc)
		port map(
			clk     	=> clk,
			count 	        => count,
			resetn      	=> resetn,
			cnt_end         => cnt_end
		);

       process
	begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process;
        

        process
	begin
		resetn <= '0'; -- assert reset low
		count <= '0';
		wait for 17 ns;
                resetn <= '1';
		wait for 10 ns;
                count <= '1';
		wait for 10 ns;
                count <= '0';
		wait for 30 ns;
                count <= '1';
		wait for 380 ns;
                count <= '0';
		wait for 30 ns;
                count <= '1';
		wait for 30 ns;
                resetn <= '0';
		wait for 10 ns;
                resetn <= '1';
		wait for 430 ns;
                count <= '0';
		wait for 30 ns;
	wait;
        end process;
end architecture sim;