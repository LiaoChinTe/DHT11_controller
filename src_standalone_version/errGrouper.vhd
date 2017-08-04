library IEEE;
use IEEE.std_logic_1164.all;

entity errGrouper is
    port( 
	checksum: in std_ulogic;
	busybit: in std_ulogic;
	SW0: in std_ulogic;
	protocol_error: in std_ulogic;
	out_error: out std_ulogic_vector(3 downto 0)
    );
end entity errGrouper;

architecture arc of errGrouper is
begin
	out_error <= protocol_error & SW0 & busybit & checksum;
end arc;
