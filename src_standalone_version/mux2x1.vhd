library IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is
    port( 
	sensor_data: in std_ulogic_vector(3 downto 0);
	error_data: in std_ulogic_vector(3 downto 0);
	SW3: in std_ulogic;
	leds: out std_ulogic_vector(3 downto 0)
    );
end entity mux2x1;

architecture arc of mux2x1 is
begin
with SW3 select leds <=
    sensor_data when '1',
    error_data when others;
end arc;
