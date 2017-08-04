-- DTH11 controller wrapper, standalone version

library ieee;
use ieee.std_logic_1164.all;

entity dht11_sa is
	generic(
		freq:    positive range 1 to 1000 -- Clock frequency (MHz)
	);
	port(
		clk:      in  std_ulogic;
		rst:      in  std_ulogic; -- Active high synchronous reset
		-- should we consider rst as coming from a button?
		btn:      in  std_ulogic;
		sw:       in  std_ulogic_vector(3 downto 0); -- Slide switches
		data_in:  in  std_ulogic;
		data_drv: out std_ulogic;
		led:      out std_ulogic_vector(3 downto 0) -- LEDs
	);
end entity dht11_sa;

architecture rtl of dht11_sa is
	signal rstn, srstn, start, pe, b, cks_out: std_ulogic;
	signal do: std_ulogic_vector(39 downto 0);
	signal selector_out, error_out: std_ulogic_vector(3 downto 0);

begin
	rstn <= not rst;

	debStart: entity work.debouncer(rtl)
		port map (clk => clk, srstn => srstn, d => btn, q => open,
				r => start, f => open, a => open);
	debRst: entity work.debouncer(rtl)
		port map (clk => clk, srstn => '1', d => rstn, q => srstn,
				r => open, f => open, a => open);
	ctrl: entity work.dht11_ctrl(rtl)
		generic map (freq => freq)
		port map(clk => clk,	srstn => srstn, start => start, data_in => data_in,
				data_drv => data_drv, pe => pe, b => b, do => do);
	sel: entity work.selector(arc)
		port map(data_in => do(39 downto 8), sw => sw(2 downto 0),
				data_out => selector_out);
	check: entity work.checksum(arc)
		port map(data_in => do(39 downto 8), cksum => do(7 downto 0),
				ce_error => cks_out);
	err: entity work.errGrouper(arc)
		port map(checksum => cks_out, busybit => b, SW0 => sw(0),
				protocol_error => pe, out_error => error_out);
	mux: entity work.mux2x1(arc)
		port map(sensor_data => selector_out, error_data => error_out,
				SW3 => sw(3), leds => led);

end architecture rtl;
