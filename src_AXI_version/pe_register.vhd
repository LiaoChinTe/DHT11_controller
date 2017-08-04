library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all; -- to use std_ulogic and std_ulogic_vector types

entity pe_register is
    port(
        clk:      	in  std_ulogic;
        LE:    		in  std_ulogic; --load enable
        New_PE:    	in  std_ulogic;
        PE:      	out std_ulogic
    );
end entity pe_register;

architecture arc of pe_register is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if LE = '1' then -- synchronous, active high,
                PE <= New_PE;
            end if;
        end if;
    end process;
end architecture arc;
