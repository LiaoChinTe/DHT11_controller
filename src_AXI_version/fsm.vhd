LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY fsm IS
	PORT (
		clk: 			IN std_ulogic;
		srstn: 			IN std_ulogic; -- provided by top or push butt1
		START: 		IN std_ulogic; -- output of debouncer for measure RQST

		Timeout_output: 	IN std_ulogic_vector(1 downto 0);
		Timer_output: 		IN std_ulogic_vector(1 downto 0);

		cnt2_ovf: 		IN std_ulogic;   --output of CNT2
		cnt40_output: 		IN std_ulogic;   --output of CNT40

		DATA_to_SR:		OUT std_ulogic; -- data acquired from sensor
		SE:			OUT std_ulogic;  --1 active
		update_out_sr:			OUT std_ulogic;  --update output of ShiftRegister
		DDRV: 			OUT std_ulogic;
		busybit: 		OUT std_ulogic;
		cnt40_increment:		OUT std_ulogic;
		
		new_PE: 		OUT std_ulogic;
		LE_PE: 		OUT std_ulogic;

		Timer_RSTn: 		OUT std_ulogic;  --input of Timer    0 active
		Timeout_RSTn: 		OUT std_ulogic;  --input of Timeout    0 active
		CNT2_RSTn: 		OUT std_ulogic;  --input of CNT2     0 active
		CNT40_RSTn:   		OUT std_ulogic;  --input of CNT40    0 active
		SR_RSTn: 		OUT std_ulogic); --input of ShiftReg 0 active
END fsm;

ARCHITECTURE arc OF fsm IS
type states is (RESET,IDLE,BUSY,measure_RQST,ending_meas_RQST,HANDSHAKE,
		TRANSMISSION,RX_1,RX_0,RX_FIN,Protocol_Error);
signal state: states;

BEGIN
fsm_transition: process(clk)
 begin
	if rising_edge(clk) then
		if srstn = '0' then
			state <= RESET;
		else
			case (state) is
				when RESET =>
					if (srstn = '1') then -- unusefull ...
						state <= BUSY;
					end if;
				when BUSY =>    if (Timer_output = "11") then state <= IDLE; --1.1s
						end if;
				when IDLE =>    if (START ='1') then state <= measure_RQST;
						end if;
				when measure_RQST => 
						if (Timer_output = "10") then --20ms
							state <= ending_meas_RQST;
						end if;
				when ending_meas_RQST => 
						if (cnt2_ovf ='1') then state <= HANDSHAKE;
						else
							if (Timeout_output = "01") then --44us
								state <= Protocol_Error;
							end if;
						end if;
				when HANDSHAKE =>
						if (cnt2_ovf ='1') then state <= TRANSMISSION;
						else
							if (Timeout_output = "11") then -- 88us
								state <= Protocol_Error;
							end if;
						end if;
				when TRANSMISSION =>
						if (cnt2_ovf ='1') then
							if (Timer_output = "01") then --50us
								state <= RX_1;
							else
								state <= RX_0;
							end if;
						else 
							if (Timeout_output = "10") then  --77us
								state <= Protocol_Error;
							end if;
						end if;
				when RX_1 =>
						if (cnt40_output ='1') then 
							state <= RX_FIN;
						else
							if (cnt2_ovf ='1') then
								if (Timer_output = "01") then --50us
									state <= RX_1;
								else
									state <= RX_0;
								end if;
							else 
								if (Timeout_output = "10") then --77us
									state <= Protocol_Error;
								else
									state <= TRANSMISSION;
								end if;
							end if;
						end if;
				when RX_0 => 
						if (cnt40_output ='1') then 
							state <= RX_FIN;
						else
							if (cnt2_ovf ='1') then
								if (Timer_output = "01") then --50us
									state <= RX_1;
								else
									state <= RX_0;
								end if;
							else 
								if (Timeout_output = "10") then --77us
									state <= Protocol_Error;
								else
									state <= TRANSMISSION;
								end if;
							end if;
						end if;
			
				when RX_FIN =>
						state <= IDLE;
				when Protocol_Error =>
						state <= IDLE;
				when others => state <= RESET;
				end case;
		end if;
	end if;
 end process;

fsm_output: process(state)
begin
DATA_to_SR <= '0'; DDRV <= '0'; LE_PE <= '0'; new_PE <= '0';
SE <= '0'; cnt40_increment <= '0'; update_out_sr <= '0';
busybit <= '1'; Timer_RSTn <= '1'; Timeout_RSTn <= '1';
CNT2_RSTn <= '1'; CNT40_RSTn <= '1'; SR_RSTn <= '1';

	case (state) is
		when RESET => 
			Timer_RSTn <= '0'; CNT2_RSTn <= '0'; CNT40_RSTn <= '0';
			SR_RSTn <= '0'; Timeout_RSTn <= '0'; LE_PE <= '1';
		when BUSY=>
		when IDLE=>
				Timer_RSTn <= '0';
				busybit <= '0';
		when measure_RQST =>
				DDRV <= '1';
				CNT2_RSTn <= '0';
				CNT40_RSTn <= '0';
--				SR_RSTn <= '0';
				Timeout_RSTn <= '0';
				LE_PE <= '1';
		when ending_meas_RQST =>
		when HANDSHAKE => 
				Timer_RSTn <= '0';
		when RX_1=>
				SE <= '1';
				DATA_to_SR <= '1'; --count<='1' for a clk cycle
				Timer_RSTn <= '0';
				cnt40_increment <= '1';
		when RX_0=> 
				SE <= '1';
				DATA_to_SR <= '0'; --count<='1' for a clk cycle
				Timer_RSTn <= '0';
				cnt40_increment <= '1';
		when RX_FIN=>
				update_out_sr <= '1';
		when Protocol_Error=>
				LE_PE <= '1';
				new_PE <= '1';
		when others => -- reset
	end case;
end process;

END arc;
