library ieee;
use ieee.std_logic_1164.all;

entity shiftReg is
    port( 
	clk: in std_ulogic;
   sresetn: in std_ulogic;
	data_in: in std_ulogic;
	SE: in std_ulogic;
	change_out: in std_ulogic;
	data_out: out std_ulogic_vector(39 downto 8);
	checksum_out: out std_ulogic_vector(7 downto 0)
    );
end entity shiftReg;

architecture arc of shiftReg is
signal reg: std_ulogic_vector(39 downto 0);

begin
process(clk)
	begin
		if rising_edge(clk) then
			if sresetn = '0' then -- synchronous, active low, reset
				reg <= (others => '0'); -- aggregate notation
				data_out <= (others => '0');
				checksum_out <= (others => '0');
			elsif change_out = '1'  then
				data_out <= reg(39 downto 8);
				checksum_out <= reg(7 downto 0);
			elsif SE = '1'  then
				reg <=  reg(38 downto 0) & data_in  ; -- use concatenation and bit-slicing
			end if;
		end if;
	end process;

end architecture arc;




