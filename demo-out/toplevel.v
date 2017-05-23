////////////////////////////////////////////////////////////////////////////////
//
// Filename:	../demo-out/toplevel.v
//
// Project:	VideoZip, a ZipCPU SoC supporting video functionality
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	./autofpga ./autofpga -o ../demo-out -I ../auto-data global.txt clock.txt bkram.txt flash.txt zipmaster.txt wbubus.txt dlyarbiter.txt gps.txt icape.txt mdio.txt spio.txt wboledbw.txt rtcdate.txt hdmi.txt clkcounter.txt gpio.txt pwrcount.txt wbpmic.txt version.txt buserr.txt pic.txt rtcgps.txt wbmouse.txt sdspi.txt
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017, Gisselquist Technology, LLC
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none


//
// Here we declare our toplevel.v (toplevel) design module.
// All design logic must take place beneath this top level.
//
// The port declarations just copy data from the @TOP.PORTLIST
// key, or equivalently from the @MAIN.PORTLIST key if
// @TOP.PORTLIST is absent.  For those peripherals that don't need
// any top level logic, the @MAIN.PORTLIST should be sufficent,
// so the @TOP.PORTLIST key may be left undefined.
//
module	toplevel(i_clk,
		// SD Card
		o_sd_sck, io_sd_cmd, io_sd, i_sd_cs, i_sd_wp,
		// The PMic3 microphone wires
		o_mic_csn, o_mic_sck, i_mic_din,
		// GPIO wires
		io_hdmi_in_cec,
		o_hdmi_in_hpa,	// Hotplug assert
		o_hdmi_in_txen,
		io_hdmi_out_cec,
		i_hdmi_out_hpd_n, // Hotplug detect
		o_sd_reset, i_sd_cd,
		i_gps_3df,
		// The PS/2 Mouse
		io_ps2_clk, io_ps2_data,
		// HDMI input EDID I2C ports
		io_hdmi_in_scl, io_hdmi_in_sda,
		// The GPS 1PPS signal port
		i_gps_pps,
		// HDMI input clock, and then data
		i_hdmi_in_clk_n, i_hdmi_in_clk_p,
		i_hdmi_in_p, i_hdmi_in_n,
		// Top level Quad-SPI I/O ports
		o_qspi_cs_n, io_qspi_dat,
		// UART/host to wishbone interface
		i_host_uart_rx, o_host_uart_tx,
		// A reset wire for the ZipCPU
		i_cpu_resetn,
		// OLED control interface (roughly SPI)
		o_oled_sck, o_oled_mosi, o_oled_dcn,
		o_oled_reset_n, o_oled_panel_en, o_oled_logic_en,
		// HDMI output clock
		o_hdmi_out_clk_n, o_hdmi_out_clk_p,
		// HDMI output pixels
		o_hdmi_out_p, o_hdmi_out_n,
		// The GPS-UART
		i_gpsu_rx, o_gpsu_tx,
		// Toplevel ethernet MDIO ports
		o_eth_mdclk, io_eth_mdio,
		// SPIO interface
		i_sw, i_btnc, i_btnd, i_btnl, i_btnr, i_btnu, o_led,
		// HDMI output EDID I2C ports
		io_hdmi_out_scl, io_hdmi_out_sda);
	//
	// Declaring our input and output ports.  We listed these above,
	// now we are declaring them here.
	//
	// These declarations just copy data from the @TOP.IODECLS key,
	// or from the @MAIN.IODECL key if @TOP.IODECL is absent.  For
	// those peripherals that don't do anything at the top level,
	// the @MAIN.IODECL key should be sufficient, so the @TOP.IODECL
	// key may be left undefined.
	//
	input	wire		i_clk;
	// SD Card
	output	wire		o_sd_sck;
	inout	wire		io_sd_cmd;
	inout	wire	[3:0]	io_sd;
	input	wire		i_sd_cs;
	input	wire		i_sd_wp;
	output	wire		o_mic_csn, o_mic_sck;
	input	wire		i_mic_din;
	// GPIO wires
	inout	wire	io_hdmi_in_cec;
	output	wire	o_hdmi_in_hpa;
	output	wire	o_hdmi_in_txen;
	inout	wire	io_hdmi_out_cec;
	input	wire	i_hdmi_out_hpd_n;
	input	wire	i_sd_cd;
	output	wire	o_sd_reset;
	input	wire	i_gps_3df;
	inout	wire	io_ps2_clk, io_ps2_data;
	// HDMI input EDID I2C ports
	inout	wire	io_hdmi_in_scl, io_hdmi_in_sda;
	//The GPS Clock
	input	wire		i_gps_pps;
	// HDMI input clock
	input	wire	i_hdmi_in_clk_n, i_hdmi_in_clk_p;
	input	[2:0]	i_hdmi_in_p, i_hdmi_in_n;
	// Quad SPI flash
	output	wire		o_qspi_cs_n;
	inout	wire	[3:0]	io_qspi_dat;
	// UART/host to wishbone interface
	input	wire		i_host_uart_rx;
	output	wire		o_host_uart_tx;
	// A reset wire for the ZipCPU
	input	wire		i_cpu_resetn;
	// OLEDBW interface
	output	wire		o_oled_sck, o_oled_mosi,
				o_oled_dcn, o_oled_reset_n, o_oled_panel_en,
				o_oled_logic_en;
	// HDMI output clock
	output	wire	o_hdmi_out_clk_n, o_hdmi_out_clk_p;
	// HDMI output pixels
	output	[2:0]	o_hdmi_out_p, o_hdmi_out_n;
	input	wire		i_gpsu_rx;
	output	wire		o_gpsu_tx;
	// Ethernet control (MDIO)
	output	wire		o_eth_mdclk, io_eth_mdio;
	// SPIO interface
	input	wire	[7:0]	i_sw;
	input	wire		i_btnc, i_btnd, i_btnl, i_btnr, i_btnu;
	output	wire	[7:0]	o_led;
	// HDMI output EDID I2C ports
	inout	wire	io_hdmi_out_scl, io_hdmi_out_sda;


	//
	// Declaring component data, internal wires and registers
	//
	// These declarations just copy data from the @TOP.DEFNS key
	// within the component data files.
	//
	wire		w_sd_cmd;
	wire	[3:0]	w_sd_data;
	// GPIO declarations.  The two wire busses are just virtual lists of
	// input (or output) ports.
	wire	[15:0]	i_gpio, o_gpio;
	wire		w_hdmi_out_en;
	wire		w_hdmi_bypass_sda;
	wire		w_hdmi_bypass_scl;
	wire	[1:0]	w_ps2;
	// HDMI command I2C wires, to support the EDID protocol
	// These are used to determine if the bus wires are to be set to zero
	// or not
	wire		w_hdmi_in_scl, w_hdmi_in_sda;
	wire		w_hdmi_in_logic_clk, w_hdmi_in_hsclk,
			w_hdmi_in_clk_no_buf, w_hdmi_in_clk_no_delay,
			w_hdmi_in_clk_raw;
	wire	[1:0]	w_hdmi_in_hsclk_pn;
	wire	[9:0]	w_hdmi_in_red, w_hdmi_in_green, w_hdmi_in_blue;
	// HDMI input (sink) delay definition(s)
	wire	[4:0]	w_hdmi_in_delay, w_hdmi_in_actual_delay_r,
			w_hdmi_in_actual_delay_g, w_hdmi_in_actual_delay_b;
	//
	wire	s_clk_200mhz, s_clk_200mhz_unbuffered,
		sysclk_locked, sysclk_feedback;
	wire		w_qspi_sck, w_qspi_cs_n;
	wire	[1:0]	qspi_bmod;
	wire	[3:0]	qspi_dat;
	//
	//
	// UART interface
	//
	//
	localparam [23:0] BUSUART = 24'h64;	// 1000000 baud
	wire	[7:0]	rx_data, tx_data;
	wire		rx_break, rx_parity_err, rx_frame_err, rx_stb;
	wire		tx_stb, tx_busy;

	wire	w_ck_uart, w_uart_tx;
	wire		s_clk, s_reset;
	wire		w_hdmi_out_hsclk, w_hdmi_out_logic_clk;
	wire	[9:0]	w_hdmi_out_r, w_hdmi_out_g, w_hdmi_out_b;
	// Ethernet control (MDIO)
	wire		w_mdio, w_mdwe;
	// HDMI command I2C wires, to support the EDID protocol
	// These are used to determine if the bus wires are to be set to zero
	// or not
	wire		w_hdmi_out_scl, w_hdmi_out_sda;


	//
	// Time to call the main module within main.v.  Remember, the purpose
	// of the main.v module is to contain all of our portable logic.
	// Things that are Xilinx (or even Altera) specific, or for that
	// matter anything that requires something other than on-off logic,
	// such as the high impedence states required by many wires, is
	// kept in this (toplevel.v) module.  Everything else goes in
	// main.v.
	//
	// We automatically place s_clk, and s_reset here.  You may need
	// to define those above.  (You did, didn't you?)  Other
	// component descriptions come from the keys @TOP.MAIN (if it
	// exists), or @MAIN.PORTLIST if it does not.
	//

	main	thedesign(s_clk, s_reset,
		// SD Card
		o_sd_sck, w_sd_cmd, w_sd_data, io_sd_cmd, io_sd, i_sd_cs,
		// The PMic3 microphone wires
		o_mic_csn, o_mic_sck, i_mic_din,
		// GPIO wires
		i_gpio, o_gpio,
		// The PS/2 Mouse
		{ io_ps2_clk, io_ps2_data }, w_ps2,
	io_hdmi_in_scl, io_hdmi_in_sda, w_hdmi_in_scl, w_hdmi_in_sda,
		// The GPS 1PPS signal port
		i_gps_pps,
		// HDMI input clock
		w_hdmi_in_logic_clk,
		w_hdmi_in_red, w_hdmi_in_green, w_hdmi_in_blue,
		w_hdmi_in_hsclk, s_clk_200mhz,
		// HDMI input (sink) delay)
		w_hdmi_in_actual_delay_r, w_hdmi_in_actual_delay_g,
		w_hdmi_in_actual_delay_b, w_hdmi_in_delay,
		// Quad SPI flash
		w_qspi_cs_n, w_qspi_sck, qspi_dat, io_qspi_dat, qspi_bmod,
		// External USB-UART bus control
		rx_stb, rx_data, tx_stb, tx_data, tx_busy,
		// Reset wire for the ZipCPU
		(!i_cpu_resetn),
		// OLED control interface (roughly SPI)
		o_oled_sck, o_oled_mosi, o_oled_dcn,
		o_oled_reset_n, o_oled_panel_en, o_oled_logic_en,
		// HDMI output ports
		w_hdmi_out_logic_clk,
		// HDMI output pixels, set within the main module
		w_hdmi_out_r, w_hdmi_out_g, w_hdmi_out_b,
		// The GPS-UART
		i_gpsu_rx, o_gpsu_tx,
		o_eth_mdclk, w_mdio, w_mdwe, io_eth_mdio,
		// SPIO interface
		i_sw, i_btnc, i_btnd, i_btnl, i_btnr, i_btnu, o_led,
		// EDID port for the HDMI source
		io_hdmi_out_scl, io_hdmi_out_sda, w_hdmi_out_scl, w_hdmi_out_sda);


	//
	// Our final section to the toplevel is used to provide all of
	// that special logic that couldnt fit in main.  This logic is
	// given by the @TOP.INSERT tag in our data files.
	//


	//
	//
	// Wires for setting up the SD Card Controller
	//
	//
	assign io_sd_cmd = w_sd_cmd ? 1'bz:1'b0;
	assign io_sd[0] = w_sd_data[0]? 1'bz:1'b0;
	assign io_sd[1] = w_sd_data[1]? 1'bz:1'b0;
	assign io_sd[2] = w_sd_data[2]? 1'bz:1'b0;
	assign io_sd[3] = w_sd_data[3]? 1'bz:1'b0;

	assign	i_gpio = { 11'h0,
			sysclk_locked, i_gps_3df,
			!i_hdmi_out_hpd_n, i_sd_cd,
			io_hdmi_out_cec, io_hdmi_in_cec };
	assign	io_hdmi_in_cec  = o_gpio[0] ? 1'bz : 1'b0;
	assign	io_hdmi_out_cec = o_gpio[1] ? 1'bz : 1'b0;
	assign	w_hdmi_bypass_scl=o_gpio[2];
	assign	w_hdmi_bypass_sda=o_gpio[3];
	assign	o_hdmi_in_txen  = o_gpio[4];
	assign	o_hdmi_in_hpa   = o_gpio[5];	// Hotplug assert
	assign	o_sd_reset      = o_gpio[6];
	assign	w_hdmi_out_en   = o_gpio[7];

	// WB-Mouse
	//
	// Adjustments necessary to turn the PS/2 logic to pull-up logic,
	// with a high impedence state if not used.
	assign	io_ps2_clk  = (w_ps2[1])? 1'bz:1'b0;
	assign	io_ps2_data = (w_ps2[0])? 1'bz:1'b0;

	// The EDID I2C port for the HDMI source port
	//
	// We need to make certain we only force the pin to a zero (drain)
	// when trying to do so.  Otherwise we let it float (back) high.
	assign	io_hdmi_in_scl = (w_hdmi_in_scl) ? 1'bz : 1'b0;
	assign	io_hdmi_in_sda = (w_hdmi_in_sda) ? 1'bz : 1'b0;


	// First, let's get our clock up and running
	// 1. Convert from differential to single
	IBUFDS	hdmi_in_clk_ibuf(
			.I(i_hdmi_in_clk_p), .IB(i_hdmi_in_clk_n),
			.O(w_hdmi_in_clk_raw));

	BUFG	rawckbuf(.I(w_hdmi_in_clk_raw), .O(w_hdmi_in_clk_no_buf));

	

	// 3. Use that signal to generate a clock
	xhdmiiclk xhclkin(s_clk, w_hdmi_in_clk_no_buf, o_hdmi_in_txen,
			w_hdmi_in_hsclk_pn, w_hdmi_in_logic_clk);

	// 4. Use the (non-inverted) clock as needed as w_hdmi_in_hsclk
	assign	w_hdmi_in_hsclk = w_hdmi_in_hsclk_pn[1]; // P


	xhdmiin xhin_r(w_hdmi_in_logic_clk, w_hdmi_in_hsclk_pn,
		o_hdmi_in_txen,
		w_hdmi_in_delay, w_hdmi_in_actual_delay_r,
		{ i_hdmi_in_p[2], i_hdmi_in_n[2] }, w_hdmi_in_red);
	xhdmiin	xhin_g(w_hdmi_in_logic_clk, w_hdmi_in_hsclk_pn,
		o_hdmi_in_txen,
		w_hdmi_in_delay, w_hdmi_in_actual_delay_g,
		{ i_hdmi_in_p[1], i_hdmi_in_n[1] }, w_hdmi_in_green);
	xhdmiin xhin_b(w_hdmi_in_logic_clk, w_hdmi_in_hsclk_pn,
		o_hdmi_in_txen,
		w_hdmi_in_delay, w_hdmi_in_actual_delay_b,
		{ i_hdmi_in_p[0], i_hdmi_in_n[0] }, w_hdmi_in_blue);

	// Xilinx requires an IDELAYCTRL to be added any time the IDELAY
	// element is included in the design.  Strangely, this doesn't need
	// to be conencted to the IDELAY in any fashion, it just needs to be
	// provided with a clock.
	//
	// I should associate this delay with a delay group --- just haven't
	// done that yet.
	wire	delay_reset;
	assign	delay_reset = 1'b0;
	/*
	always @(posedge s_clk)
		delay_reset <= !sys_clk_locked;
	*/
	IDELAYCTRL dlyctrl(.REFCLK(s_clk_200mhz), .RDY(), .RST(delay_reset));

	// But ... the delay controller requires a 200 MHz reference clock,
	// so ... let's create one
	PLLE2_BASE #(
		.CLKFBOUT_MULT(8),
		.CLKFBOUT_PHASE(0.0),
		.CLKIN1_PERIOD(10),
		.CLKOUT0_DIVIDE(4)) gen_sysclk(
			.CLKIN1(s_clk),
			.CLKOUT0(s_clk_200mhz_unbuffered),
			.PWRDWN(1'b0), .RST(1'b0),
			.CLKFBOUT(sysclk_feedback),
			.CLKFBIN(sysclk_feedback),
			.LOCKED(sysclk_locked));

	BUFG	sysbuf(.I(s_clk_200mhz_unbuffered), .O(s_clk_200mhz));



	//
	//
	// Wires for setting up the QSPI flash wishbone peripheral
	//
	//
	// QSPI)BMOD, Quad SPI bus mode, Bus modes are:
	//	0?	Normal serial mode, one bit in one bit out
	//	10	Quad SPI mode, going out
	//	11	Quad SPI mode coming from the device (read mode)
	assign io_qspi_dat = (~qspi_bmod[1])?({2'b11,1'bz,qspi_dat[0]})
				:((qspi_bmod[0])?(4'bzzzz):(qspi_dat[3:0]));
	assign	o_qspi_cs_n = w_qspi_cs_n;

	// The following primitive is necessary in many designs order to gain
	// access to the o_qspi_sck pin.  It's not necessary on the Arty,
	// simply because they provide two pins that can drive the QSPI
	// clock pin.
	wire	[3:0]	su_nc;	// Startup primitive, no connect
	STARTUPE2 #(
		// Leave PROG_USR false to avoid activating the program
		// event security feature.  Notes state that such a feature
		// requires encrypted bitstreams.
		.PROG_USR("FALSE"),
		// Sets the configuration clock frequency (in ns) for
		// simulation.
		.SIM_CCLK_FREQ(0.0)
	) STARTUPE2_inst (
	// CFGCLK, 1'b output: Configuration main clock output -- no connect
	.CFGCLK(su_nc[0]),
	// CFGMCLK, 1'b output: Configuration internal oscillator clock output
	.CFGMCLK(su_nc[1]),
	// EOS, 1'b output: Active high output indicating the End Of Startup.
	.EOS(su_nc[2]),
	// PREQ, 1'b output: PROGRAM request to fabric output
	//	Only enabled if PROG_USR is set.  This lets the fabric know
	//	that a request has been made (either JTAG or pin pulled low)
	//	to program the device
	.PREQ(su_nc[3]),
	// CLK, 1'b input: User start-up clock input
	.CLK(1'b0),
	// GSR, 1'b input: Global Set/Reset input
	.GSR(1'b0),
	// GTS, 1'b input: Global 3-state input
	.GTS(1'b0),
	// KEYCLEARB, 1'b input: Clear AES Decrypter Key input from BBRAM
	.KEYCLEARB(1'b0),
	// PACK, 1-bit input: PROGRAM acknowledge input
	//	This pin is only enabled if PROG_USR is set.  This allows the
	//	FPGA to acknowledge a request for reprogram to allow the FPGA
	//	to get itself into a reprogrammable state first.
	.PACK(1'b0),
	// USRCLKO, 1-bit input: User CCLK input -- This is why I am using this
	// module at all.
	.USRCCLKO(w_qspi_sck),
	// USRCCLKTS, 1'b input: User CCLK 3-state enable input
	//	An active high here places the clock into a high impedence
	//	state.  Since we wish to use the clock as an active output
	//	always, we drive this pin low.
	.USRCCLKTS(1'b0),
	// USRDONEO, 1'b input: User DONE pin output control
	//	Set this to "high" to make sure that the DONE LED pin is
	//	high.
	.USRDONEO(1'b1),
	// USRDONETS, 1'b input: User DONE 3-state enable output
	//	This enables the FPGA DONE pin to be active.  Setting this
	//	active high sets the DONE pin to high impedence, setting it
	//	low allows the output of this pin to be as stated above.
	.USRDONETS(1'b1)
	);


	// The Host USB interface, to be used by the WB-UART bus
	rxuartlite	#(BUSUART) rcv(s_clk, i_host_uart_rx,
				rx_stb, rx_data);
	txuartlite	#(BUSUART) txv(s_clk,
				tx_stb, tx_data, o_host_uart_tx, tx_busy);


	assign	s_clk = i_clk;
	assign	s_reset = 1'b0; // This design requires local, not global resets

	assign	w_hdmi_out_hsclk     = w_hdmi_in_hsclk;
	assign	w_hdmi_out_logic_clk = w_hdmi_in_logic_clk;

	xhdmiout ohdmick(w_hdmi_out_logic_clk, w_hdmi_out_hsclk, w_hdmi_out_en,
			10'h3e0,
			{ o_hdmi_out_clk_p, o_hdmi_out_clk_n });
	xhdmiout ohdmir(w_hdmi_out_logic_clk, w_hdmi_out_hsclk, w_hdmi_out_en,
			w_hdmi_out_r,
			{ o_hdmi_out_p[2], o_hdmi_out_n[2] });
	xhdmiout ohdmig(w_hdmi_out_logic_clk, w_hdmi_out_hsclk, w_hdmi_out_en,
			w_hdmi_out_g,
			{ o_hdmi_out_p[1], o_hdmi_out_n[1] });
	xhdmiout ohdmib(w_hdmi_out_logic_clk, w_hdmi_out_hsclk, w_hdmi_out_en,
			w_hdmi_out_b,
			{ o_hdmi_out_p[0], o_hdmi_out_n[0] });

	assign	io_eth_mdio = (w_mdwe)?w_mdio : 1'bz;

	// The EDID I2C port for the HDMI source port
	//
	// We need to make certain we only force the pin to a zero (drain)
	// when trying to do so.  Otherwise we let it float (back) high.
	assign	io_hdmi_out_scl = ((w_hdmi_bypass_scl)&&(w_hdmi_out_scl)) ? 1'bz : 1'b0;
	assign	io_hdmi_out_sda = ((w_hdmi_bypass_sda)&&(w_hdmi_out_sda)) ? 1'bz : 1'b0;



endmodule // end of toplevel.v module definition
