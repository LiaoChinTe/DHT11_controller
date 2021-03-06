-- AXI4 lite wrapper around the DHT11 controller dht11_ctrl(rtl). It contains two 32-bits read-only registers:
--
-- Address                Name    Description
-- 0x00000000-0x00000003  DATA    read-only, 32-bits, data register
-- 0x00000004-0x00000007  STATUS  read-only, 32-bits, status register
-- 0x00000008-...         -       unmapped
--
-- Writing to DATA or STATUS shall be answered with a SLVERR response. Reading or writing to the unmapped address space [0x00000008,...] shall be answered with a DECERR response.
--
-- The reset value of DATA is 0xffffffff.
-- DATA(31 downto 16) = last sensed humidity level, Most Significant Bit: DATA(31).
-- DATA(15 downto 0) = last sensed temperature, MSB: DATA(15).
--
-- The reset value of STATUS is 0x00000000.
-- STATUS = (2 => PE, 1 => B, 0 => CE, others => '0'), where PE, B and CE are the protocol error, busy and checksum error flags, respectively.
--
-- After the reset has been de-asserted, the wrapper waits for 1 second and sends the first start command to the controller. Then, it waits for one more second, samples DO(39 downto 8) (the sensed values) in DATA, samples the PE and CE flags in STATUS, and sends a new start command to the controller. And so on every second, until the reset is asserted. When the reset is de-asserted, every rising edge of the clock, the B output of the DHT11 controller is sampled in the B flag of STATUS.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.axi_pkg.all;

entity dht11_axi is
	generic(
		freq:       positive range 1 to 1000 -- Clock frequency (MHz)
	);
	port(
		aclk:           in  std_ulogic;  -- Clock
		aresetn:        in  std_ulogic;  -- Synchronous, active low, reset
		
		--------------------------------
		-- AXI lite slave port s0_axi --
		--------------------------------
		-- Inputs (master to slave) --
		------------------------------
		-- Read address channel
		s0_axi_araddr:  in  std_ulogic_vector(29 downto 0);
		s0_axi_arprot:  in  std_ulogic_vector(2 downto 0);--nc
		s0_axi_arvalid: in  std_ulogic;
		-- Read data channel
		s0_axi_rready:  in  std_ulogic;
		-- Write address channel
		s0_axi_awaddr:  in  std_ulogic_vector(29 downto 0);
		s0_axi_awprot:  in  std_ulogic_vector(2 downto 0);--nc
		s0_axi_awvalid: in  std_ulogic;
		-- Write data channel
		s0_axi_wdata:   in  std_ulogic_vector(31 downto 0); --nc
		s0_axi_wstrb:   in  std_ulogic_vector(3 downto 0); --nc
		s0_axi_wvalid:  in  std_ulogic;
		-- Write response channel
		s0_axi_bready:  in  std_ulogic;
		-------------------------------
		-- Outputs (slave to master) --
		-------------------------------
		-- Read address channel
		s0_axi_arready: out std_ulogic;
		-- Read data channel
		s0_axi_rdata:   out std_ulogic_vector(31 downto 0);
		s0_axi_rresp:   out std_ulogic_vector(1 downto 0);
		s0_axi_rvalid:  out std_ulogic;
		-- Write address channel
		s0_axi_awready: out std_ulogic;
		-- Write data channel
		s0_axi_wready:  out std_ulogic;
		-- Write response channel
		s0_axi_bresp:   out std_ulogic_vector(1 downto 0);
		s0_axi_bvalid:  out std_ulogic;

		data_in:        in  std_ulogic;
		data_drv:       out std_ulogic
  );
end entity dht11_axi;

architecture rtl of dht11_axi is
	signal start, pe, b, CE, addr_read_le, addr_write_le, statusN_data:  std_ulogic;
	signal do:     std_ulogic_vector(39 downto 0);
	signal data, status, tmp_status:   std_ulogic_vector(31 downto 0);
	signal writeAddr, readAddr:   std_ulogic_vector(29 downto 0);
begin
tmp_status <= (2 => PE, 1 => B, 0 => CE, others => '0');
	ctrl: entity work.dht11_ctrl(rtl)
		generic map( freq => freq)
		port map( clk => aclk, srstn => aresetn, start => start, data_in => data_in,
			data_drv => data_drv, pe => pe, b => b, do => do);
	check: entity work.checksum(arc)
		port map( data_in => do(39 downto 8), cksum => do(7 downto 0),
				ce_error => CE);
	dataReg: entity work.regNbit1rst(arc)
		port map( CLK => aclk, RSTN => aresetn,
				LE => '1', A => do(39 downto 8), B => data);
				-- LE should be active only when a new DO is available
				-- but to simplify, here LE is always active (DO always sampled)
	statusReg: entity work.regNbit0rst(arc)
		port map( CLK => aclk, RSTN => aresetn,
				LE => '1', A => tmp_status, B => status);
				-- LE should be active only when a tmp_status changes
				-- but to simplify, here LE is always active
	addressWriteReg: entity work.regNbit0rst(arc)
		generic map( N => 30)
		port map( CLK => aclk, RSTN => aresetn,
				LE => addr_write_le, A => s0_axi_awaddr, B => writeAddr);
	addressReadReg: entity work.regNbit0rst(arc)
		generic map( N => 30)
		port map( CLK => aclk, RSTN => aresetn,
				LE => addr_read_le, A => s0_axi_araddr, B => readAddr);
	fsm_axi_write: entity work.fsm_axi_mts(arc)
		port map( aclk, aresetn, writeAddr, s0_axi_bready, s0_axi_wvalid, s0_axi_awvalid,
			s0_axi_wready, s0_axi_awready, s0_axi_bvalid, s0_axi_bresp, addr_write_le);
	fsm_axi_read: entity work.fsm_axi_stm(arc)
		port map( aclk, aresetn, readAddr, s0_axi_rready, s0_axi_arvalid,
			s0_axi_arready, s0_axi_rvalid, s0_axi_rresp, statusN_data, addr_read_le);
	mux2to1_Nbit: entity work.mux2to1_Nbit(arc)
		port map( status, data, statusN_data, s0_axi_rdata);
	cnt1s: entity work.timerN(arc)
		generic map( freq => freq)
		port map( aclk, aresetn, start);
end architecture rtl;
