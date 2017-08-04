library ieee;
use ieee.std_logic_1164.all;

entity checksum_sim is
end entity checksum_sim;

architecture chk_sim of checksum_sim is
	signal data_in:        std_ulogic_vector(31 downto 0);
	signal cksum:        std_ulogic_vector(7 downto 0);
	signal valid:       std_ulogic;
begin
	-- entity instantiation of the Design Under Test
dut: entity work.checksum(arc) port map(data_in,cksum,valid);

	process
	begin
      		data_in <= "11111111110000000000111111000000";
		cksum <= "10001110";
		wait for 10 ns;
		data_in <= "11111111111111111111111111000000";
		cksum <= "10111101";
		wait for 10 ns;
		data_in <= "11111111110000000000000000000000";
		cksum <= "10111110";
		wait for 10 ns;
		data_in <= "11111111110000000000000000000000";
		cksum <= "10111111";
		wait for 10 ns;
		wait;
	end process;

end architecture chk_sim;
