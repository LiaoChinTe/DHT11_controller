LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY fsm_axi_mts IS
	PORT (
		clk: 			IN std_ulogic;
		srstn: 			IN std_ulogic;
		ADDR : in std_ulogic_vector(29 downto 0);
		BREADY: 		in std_ulogic;
		WVALID: 		in std_ulogic;
		AWVALID: 		in std_ulogic;

		WREADY:			OUT std_ulogic;
		AWREADY:		OUT std_ulogic;
		BVALID:			OUT std_ulogic;
		BRESP: 			OUT std_ulogic_vector(1 downto 0);
		addr_le: out std_ulogic);
END fsm_axi_mts;

ARCHITECTURE arc OF fsm_axi_mts IS
type states is (RST,IDLE,SLVERR,DECERR);
signal state: states;

BEGIN
fsm_transition: process(clk)
 begin
	if rising_edge(clk) then
		if srstn = '0' then
			state <= RST;
		else
			case (state) is
				when IDLE =>
					if to_integer(unsigned(ADDR)) < 8 then
						state <= SLVERR;
					else 
						state <= DECERR;
					end if;
				when SLVERR=>
					if BREADY = '1' then
						state <= RST;
					end if;
				when DECERR =>
					if BREADY = '1' then
						state <= RST;
					end if;
				when others => -- rst
					if WVALID = '1' and AWVALID = '1' then
						state <= IDLE;
					end if;
			end case;
		end if;
	end if;
 end process;

fsm_output: process(state)
begin
WREADY <= '0'; AWREADY <= '0'; addr_le <= '0';
BVALID <= '0'; BRESP <= "11";
	case (state) is
		when RST =>
			addr_le <= '1';
		when SLVERR=>
			BVALID <= '1';
			BRESP <= "10";
		when DECERR =>
			BVALID <= '1';
		when others => --idle
			WREADY <= '1';
			AWREADY <= '1';
	end case;
end process;

END arc;
