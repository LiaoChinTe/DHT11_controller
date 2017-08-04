library IEEE;
use IEEE.std_logic_1164.all;

entity selector is
    port( data_in: std_ulogic_vector(31 downto 0);
	sw: in std_ulogic_vector(2 downto 0); --sw 0,1,2
	data_out: out std_ulogic_vector(3 downto 0));
end entity selector;

architecture arc of selector is
begin
process(sw, data_in)
begin
	case sw is
		when "011"  => data_out <= data_in(31 downto 28);
		when "010" => data_out <= data_in(27 downto 24);
		when "001" => data_out <= data_in(23 downto 20);
		when "000" => data_out <= data_in(19 downto 16);
		when "111" => data_out <= data_in(15 downto 12);
		when "110" => data_out <= data_in(11 downto 8);
		when "101" => data_out <= data_in(7 downto 4);
		when others => data_out <= data_in(3 downto 0);
	end case;
end process;
end arc;
