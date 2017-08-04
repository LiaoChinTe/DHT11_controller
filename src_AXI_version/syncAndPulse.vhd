library ieee;
use ieee.std_logic_1164.all;

entity syncAndPulse is
    port( 
	clk: in std_ulogic;
	data_in: in std_ulogic;
	data_pulse: out std_ulogic
    );
end entity syncAndPulse;

architecture arc of syncAndPulse is
signal dp : std_ulogic_vector(2 downto 0);
begin

process(clk)
begin
	if rising_edge(clk) then
		dp <= data_in & dp(2 downto 1);
	end if;
end process;
data_pulse <= dp(1) xor dp(0);
end architecture arc;