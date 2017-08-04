library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all; -- to use std_ulogic and std_ulogic_vector types

entity CNT2 is
    port(
        clk:      in  std_ulogic;
        count:    in  std_ulogic;
        resetn:    in  std_ulogic;
        Ovf:      out std_ulogic
    );
end entity CNT2;

architecture arc of CNT2 is
    signal tmp: std_ulogic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then -- synchronous, active low, reset
                tmp <= '0';
	        Ovf <= '0';
            elsif count = '1' then
		if tmp = '1' then  --overflow case
	                tmp <= '0';
	                Ovf <= '1';
		else                 --tmp 1, input 0,
	                tmp <= '1';
	                Ovf <= '0';
		end if;
	    else
			Ovf <= '0';
            end if;
        end if;
    end process;
end architecture arc;
