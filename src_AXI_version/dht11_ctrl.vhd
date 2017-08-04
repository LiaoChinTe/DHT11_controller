-- DTH11 controller

library ieee;
use ieee.std_logic_1164.all;

-- Read data (do) format:
-- do(39 downto 24): relative humidity (do(39) = MSB)
-- do(23 downto 8):  temperature (do(23) = MSB)
-- do(7 downto 0):   check-sum = (do(39 downto 32)+do(31 downto 24)+do(23 downto 16)+do(15 downto 8)) mod 256
entity dht11_ctrl is
	generic(
		freq:    positive range 1 to 1000 -- Clock frequency (MHz)
	);
	port(
		clk:      in  std_ulogic;
		srstn:    in  std_ulogic; -- Active low synchronous reset
		start:    in  std_ulogic;
		data_in:  in  std_ulogic;
		data_drv: out std_ulogic;
		pe:       out std_ulogic; -- Protocol error
		b:        out std_ulogic; -- Busy
		do:       out std_ulogic_vector(39 downto 0) -- Read data
	);
end entity dht11_ctrl;

architecture rtl of dht11_ctrl is
	signal syncAndPulse_out, CNT2_RSTn, cnt2_ovf, cnt40_increment, CNT40_RSTn,
		cnt40_output, SR_RSTn, DATA_to_SR, SE, update_out_sr, Timeout_RSTn,
		Timer_RSTn, new_PE, LE_PE: std_ulogic;
	signal Timeout_output, Timer_output: std_ulogic_vector(1 downto 0);

begin
	cnt2:entity work.cnt2(arc)
		port map (clk => clk, count => syncAndPulse_out,
			resetn => CNT2_RSTn, ovf => cnt2_ovf);
	cnt40:entity work.cnt40(arc)
		port map (clk => clk, count => cnt40_increment,
			resetn => CNT40_RSTn, cnt_end => cnt40_output);
	shiftReg:entity work.shiftReg(arc)
		port map (clk => clk, sresetn => SR_RSTn, data_in => DATA_to_SR,
			SE => SE, change_out => update_out_sr, data_out => do(39 downto 8),
			checksum_out => do(7 downto 0));
	timeout:entity work.timeout(arc)
		generic map (freq => freq)
		port map (clk => clk, sresetn => Timeout_RSTn,
			pulsed_rst => syncAndPulse_out, cnt_out => Timeout_output);
	timer:entity work.timer(arc)
		generic map (freq => freq)
		port map (clk => clk, sresetn => Timer_RSTn, cnt_out => Timer_output);
	syncAndPulse:entity work.syncAndPulse(arc)
		port map (clk => clk, data_in => data_in, data_pulse => syncAndPulse_out);
	pe_register:entity work.pe_register(arc)
		port map (clk => clk, new_PE => new_PE, LE => LE_PE, pe => pe);
	fsm:entity work.fsm(arc)
		port map (clk => clk, srstn => srstn, START => start,
				Timeout_output => Timeout_output, Timer_output => Timer_output,
				cnt2_ovf => cnt2_ovf, cnt40_output => cnt40_output,
				DATA_to_SR => DATA_to_SR, SE => SE, update_out_sr => update_out_sr,
				DDRV => data_drv, busybit => b, cnt40_increment => cnt40_increment,
				Timer_RSTn => Timer_RSTn, Timeout_RSTn => Timeout_RSTn,
				CNT2_RSTn => CNT2_RSTn, CNT40_RSTn => CNT40_RSTn,
				SR_RSTn => SR_RSTn, new_PE => new_PE, LE_PE => LE_PE);
end architecture rtl;
