library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package constants_pkg is
-- Delays in numbers of microseconds
	constant dht11_1_1s: natural := 1100000; -- 1.1 s
	constant dht11_20ms: natural := 19800; --20ms
	constant dht11_50us: natural := 100; --100us
	constant dht11_88us: natural := 87; --88us because 1 count delay
	constant dht11_77us: natural := 76; --77us
	constant dht11_44us: natural := 43; --44us
-- Delays in time
	constant dht11_1_1s_t: time := dht11_1_1s * 1 us;
	constant dht11_20ms_t: time := dht11_20ms * 1 us;
end package constants_pkg;
