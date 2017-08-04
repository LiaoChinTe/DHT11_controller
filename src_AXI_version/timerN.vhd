library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all; -- to use std_ulogic and std_ulogic_vector types
use work.constants_pkg.all;

entity timerN is
	generic(
		freq:    positive range 1 to 1000);
	port(
		clk:      in  std_ulogic;
		sresetn:  in  std_ulogic;
		cnt_out:   out std_ulogic);
end entity timerN;

architecture arc of timerN is
	signal cnt1: natural range 0 to freq - 1; --actual num of clk received, when 0 -> 1us passed
	signal tick: std_ulogic; -- one pulse for each us
	signal counter: natural range 0 to dht11_1_1s; -- actual num of us don't have to be more than 88
begin
	process(clk)
	begin
		if rising_edge(clk) then
			tick <= '0';
			if sresetn = '0' then -- synchronous, active low, reset
				cnt1 <= freq - 1;
			elsif cnt1 = 0 then
				cnt1 <= freq - 1;
				tick <= '1';
			else
				cnt1 <= cnt1 - 1;
			end if;
		end if;
	end process;

	process(clk)
	begin
		if rising_edge(clk) then
			if sresetn = '0' then -- synchronous, active low, reset
				counter <= 0;
			elsif tick = '1' then
				if (counter < timerNEnd) then
					counter <= counter+1;
				elsif (counter = timerNEnd) then
					counter <= 1;
				end if;
			end if;
		end if;
	end process;

	process(counter)
	begin
	    	if counter < timerNEnd then --20ms
			cnt_out <= '0';
		else  --1.1s
			cnt_out <= '1';
		end if;
	end process;
end architecture arc;
