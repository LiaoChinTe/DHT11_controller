library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity checksum is
    port( data_in: in std_ulogic_vector(31 downto 0);
	cksum: in std_ulogic_vector(7 downto 0);
	ce_error: out std_ulogic
    );
end entity checksum;

architecture arc of checksum is
signal temp_int,temp_dec,hum_int,hum_dec,sum: integer;
signal sum_logic: std_ulogic_vector(9 downto 0);
begin
temp_int <= To_integer(Unsigned(data_in(15 downto 8)));
temp_dec <= To_integer(Unsigned(data_in(7 downto 0)));
hum_int <= To_integer(Unsigned(data_in(31 downto 24)));
hum_dec <= To_integer(Unsigned(data_in(23 downto 16)));
sum <= hum_int+hum_dec+temp_int+temp_dec;
sum_logic <= Std_ulogic_vector(To_unsigned(sum,10));
process(cksum,sum_logic)
   begin
	if cksum=sum_logic(7 downto 0) then
		ce_error <= '0';
	else
		ce_error <= '1';
	end if;
end process;
end arc;
