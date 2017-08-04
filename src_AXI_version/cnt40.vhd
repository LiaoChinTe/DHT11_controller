library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all; -- to use std_ulogic and std_ulogic_vector types
--use numeric_std.all;

entity CNT40 is
    port(
        clk:      in  std_ulogic;
        count:    in  std_ulogic;
        resetn:    in  std_ulogic;
        cnt_end:      out std_ulogic
    );
end entity CNT40;

architecture arc of CNT40 is
    signal currVal: natural range 0 to 40;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then -- synchronous, active low, reset
                currVal <= 0;
	        cnt_end <= '0';
            elsif currVal = 39 then
	                cnt_end <= '1';
	    elsif count = '1' then  --40 bit reached when CU controlls again cnt_end
		        currVal <= currVal + 1;
		end if;
        end if;
    end process;
end architecture arc;
