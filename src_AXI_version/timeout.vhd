library ieee; -- to use ieee.std_logic_1164 package
use ieee.std_logic_1164.all; -- to use std_ulogic and std_ulogic_vector types
use work.constants_pkg.all;

entity timeout is
	generic(
		freq:    positive range 1 to 1000);
	port(
		clk:      in  std_ulogic;
		sresetn:  in  std_ulogic;
		pulsed_rst:  in  std_ulogic;
		cnt_out:   out std_ulogic_vector(1 downto 0));
end entity timeout;

architecture arc of timeout is
	signal cnt1: natural range 0 to freq - 1; --actual num of clk received, when 0 -> 1us passed
	signal tick: std_ulogic; -- one pulse for each us
	signal counter: natural range 0 to dht11_88us; -- actual num of us don't have to be more than 88
	

begin
tick_gen: process(clk)
	begin
		if rising_edge(clk) then
			tick <= '0';
			if (sresetn = '0' or pulsed_rst = '1')then
				cnt1 <= freq - 1;
			elsif cnt1 = 0 then
				cnt1 <= freq - 1;
				tick <= '1';
			else
				cnt1 <= cnt1 - 1;
			end if;
		end if;
	end process;

counting_us: process(clk)
	begin
		if rising_edge(clk) then
			if (sresetn = '0' or pulsed_rst = '1') then
				counter <= 0;
			elsif tick = '1' then
				if (counter < dht11_88us) then
					counter <= counter+1;
				end if;
			end if;
		end if;
	end process;

out_gen: process(counter)
	begin
	    	if counter >= 0 and counter < dht11_44us then
			cnt_out <= "00";
		elsif counter >= dht11_44us and counter < dht11_77us then
			cnt_out <= "01";
		elsif counter >= dht11_77us and counter < dht11_88us then
			cnt_out <= "10";
		else
			cnt_out <= "11";
		end if;
	end process;
end architecture arc;
