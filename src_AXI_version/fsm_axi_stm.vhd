LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY fsm_axi_stm IS
	PORT (
		clk: 			IN std_ulogic;
		srstn: 			IN std_ulogic;
		ADDR : in std_ulogic_vector(29 downto 0);
		RREADY: 		in std_ulogic;
		ARVALID:		in std_ulogic;
		
		ARREADY:		OUT std_ulogic;
		RVALID:			OUT std_ulogic;
		RRESP: 			OUT std_ulogic_vector(1 downto 0);
		data_statusN: out std_ulogic;
		addr_le: out std_ulogic);
END fsm_axi_stm;

ARCHITECTURE arc OF fsm_axi_stm IS
type states is (RST, IDLE, readDATA, readSTATUS, DECERR);
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
					if to_integer(unsigned(ADDR)) < 4 then
						state <= readDATA;
					elsif to_integer(unsigned(ADDR)) < 8 then
						state <= readSTATUS;
					else
						state <= DECERR;
					end if;
				when DECERR =>
					if RREADY = '1' then
						state <= RST;
					end if;
				when readDATA=>
					if RREADY = '1' then
						state <= RST;
					end if;
				when readSTATUS=>
					if RREADY = '1' then
						state <= RST;
					end if;
				when others => -- rst
					if ARVALID = '1' then
						state <= IDLE;
					end if;
			end case;
		end if;
	end if;
 end process;

fsm_output: process(state)
begin
ARREADY <= '0'; RVALID <= '0'; RRESP <= "00";
data_statusN <= '0'; addr_le <= '0';
	case (state) is
		when RST =>
			addr_le <= '1';
		when DECERR =>
			RVALID <= '1';
			RRESP <= "11";
		when readDATA =>
			RVALID <= '1';
			data_statusN <= '1';
		when readSTATUS =>
			RVALID <= '1';
		when others => -- idle
			ARREADY <= '1';
	end case;
end process;

END arc;
