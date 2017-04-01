


//
// TO BE PLACED INTO main.v
//
`default_nettype	none
//
//
// Here is a list of defines which may be used, post auto-design
// (not post-build), to turn particular peripherals (and bus masters)
// on and off.  In particular, to turn off support for a particular
// design component, just comment out its respective define below
//
// These lines are taken from the respective @ACCESS tags for each of our
// components.  If a component doesn't have an @ACCESS tag, it will not
// be listed here.
//
// First, the access fields for any bus masters
// And then for the peripherals
`define	GPS_CLOCK
`define	BLKRAM_ACCESS
`define	ETHERNET_ACCESS
`define	CONSOLE_ACCESS
`define	FLASH_ACCESS
`define	CFG_ACCESS
`define	NETCTRL_ACCESS
`define	SDSPI_ACCESS
`define	FLASH_ACCESS
`define	MOUSE_ACCESS
`define	GPSUART_ACCESS
`define	OLEDRGB_ACCESS
`define	GPIO_ACCESS
//
//
// Finally, we define our main module itself.  We start with the list of
// I/O ports, or wires, passed into (or out of) the main function.
//
// These fields are copied verbatim from the respective I/O port lists,
// from the fields given by @MAIN.PORTLIST
//
module	main(i_clk, i_reset,
		// The GPS 1PPS signal port
		i_gps_pps,
		// Ethernet control (packets) lines
		o_net_reset_n, i_net_rx_clk, i_net_col, i_net_crs, i_net_dv,
			i_net_rxd, i_net_rxerr,
		i_net_tx_clk, o_net_tx_en, o_net_txd,
		// The UART console
		i_aux_rx, o_aux_tx, i_aux_cts_n, o_aux_rts_n,
		// The ethernet MDIO wires
		o_mdclk, o_mdio, o_mdwe, i_mdio,
		// The SD-Card wires
		o_sd_sck, o_sd_cmd, o_sd_data, i_sd_cmd, i_sd_data, i_sd_detect,
		// The QSPI Flash
		o_qspi_cs_n, o_qspi_sck, o_qspi_dat, i_qspi_dat, o_qspi_mod,
		// The PS/2 Mouse
		i_ps2, o_ps2,
		// The GPS-UART
		i_gps_rx, o_gps_tx,
	// OLED control interface (roughly SPI)
	o_oled_sck, o_oled_cs_n, o_oled_mosi, o_oled_dcn,
	o_oled_reset_n, o_oled_vccen, o_oled_pmoden);
//
////////////////////////////////////////
/// PARAMETER SUPPORT BELONGS HERE
/// (it hasn't been written yet
////////////////////////////////////////
//
//
// The next step is to declare all of the various ports that were just
// listed above.  
//
// The following declarations are taken from the values of the various
// @MAIN.IODECLS keys.
//
	input			i_clk, i_reset;
	//The GPS Clock
	input			i_gps_pps;
	// Ethernet control (MDIO)
	output	wire		o_mdclk, o_mdio, o_mdwe;
	input			i_mdio;
	// SD-Card declarations
	output	wire		o_sd_sck, o_sd_cmd;
	output	wire	[3:0]	o_sd_data;
	input			i_sd_cmd;
	input		[3:0]	i_sd_data;
	input			i_sd_detect;
	input			i_gps_rx;
	output	wire		o_gps_tx;
	// OLEDRGB interface
	output	wire		o_oled_sck, o_oled_cs_n, o_oled_mosi,
				o_oled_dcn, o_oled_reset_n, o_oled_vccen,
				o_oled_pmoden;


	//
	// Declaring wishbone master bus data
	//
	wire		wb_cyc, wb_stb, wb_we, wb_stall, wb_ack, wb_err;
	wire	[31:0]	wb_data, wb_idata, wb_addr;
	wire	[3:0]	wb_sel;
	wire	sio_sel, dio_sel;
	reg	sio_ack, dio_ack;
	reg	[31:0]	sio_data, dio_data;



////////////////////////////////////////
/// BUS MASTER declarations belong here
////////////////////////////////////////


	//
	// Declaring Peripheral data, internal wires and registers
	//
	// These declarations come from the various components values
	// given under the @MAIN.DEFNS key.
	//
	// wires are also declared for any interrupts defined by the
	// @INTERRUPT key
	//
	wire	gps_pps, ck_pps, gps_led, gps_locked;
	wire	[63:0]	gps_now, gps_err, gps_step;
	wire	[1:0]	gps_dbg_tick;
	wire	enet_rx_int;
	wire	enet_tx_int;
	wire	uartrx_int, uarttx_int, uartrxf_int, uarttxf_int;
	wire	uartrx_int;
	wire	uarttx_int;
	wire	uartrxf_int;
	wire	uarttxf_int;
	wire	sdcard_int;
	wire	flash_interrupt;
	reg	[31:0]	pwrcount_data;
	// scrn_mouse is a 32-bit field containing 16-bits of x-position and
	// 16-bits of y position, limited to the size of the screen.
	wire	[31:0]	scrn_mouse;
	wire	mous_interrupt;
	wire	gpsurx_int;
	wire	gpsutx_int;
	wire	gpsurxf_int;
	wire	gpsutxf_int;
	wire	oled_int;

	// Declare those signals necessary to build the bus, and detect
	// bus errors upon it.
	//
	wire	none_sel;
	reg	many_sel, many_ack;
	reg	[31:0]	r_bus_err;

	//
	// Wishbone slave wire declarations
	//
	// These are given for every configuration file with a @PTYPE
	// tag, and the names are given by the @PREFIX tag.
	//

	wire	gck_ack, gck_stall, gck_sel;
	wire	[31:0]	gck_data;

	wire	version_ack, version_stall, version_sel;
	wire	[31:0]	version_data;

	wire	gtb_ack, gtb_stall, gtb_sel;
	wire	[31:0]	gtb_data;

	wire	mem_ack, mem_stall, mem_sel;
	wire	[31:0]	mem_data;

	wire	netp_ack, netp_stall, netp_sel;
	wire	[31:0]	netp_data;

	wire	clkhdmiin_ack, clkhdmiin_stall, clkhdmiin_sel;
	wire	[31:0]	clkhdmiin_data;

	wire	uart_ack, uart_stall, uart_sel;
	wire	[31:0]	uart_data;

	wire	flctl_ack, flctl_stall, flctl_sel;
	wire	[31:0]	flctl_data;

	wire	cfg_ack, cfg_stall, cfg_sel;
	wire	[31:0]	cfg_data;

	wire	netb_ack, netb_stall, netb_sel;
	wire	[31:0]	netb_data;

	wire	mdio_ack, mdio_stall, mdio_sel;
	wire	[31:0]	mdio_data;

	wire	sdcard_ack, sdcard_stall, sdcard_sel;
	wire	[31:0]	sdcard_data;

	wire	clkhdmiout_ack, clkhdmiout_stall, clkhdmiout_sel;
	wire	[31:0]	clkhdmiout_data;

	wire	flash_ack, flash_stall, flash_sel;
	wire	[31:0]	flash_data;

	wire	pwrcount_ack, pwrcount_stall, pwrcount_sel;
	wire	[31:0]	pwrcount_data;

	wire	mous_ack, mous_stall, mous_sel;
	wire	[31:0]	mous_data;

	wire	gpsu_ack, gpsu_stall, gpsu_sel;
	wire	[31:0]	gpsu_data;

	wire	oled_ack, oled_stall, oled_sel;
	wire	[31:0]	oled_data;

	wire	gpio_ack, gpio_stall, gpio_sel;
	wire	[31:0]	gpio_data;

	wire	buserr_ack, buserr_stall, buserr_sel;
	wire	[31:0]	buserr_data;


	// Wishbone peripheral address decoding
	// This particular address decoder decodes addresses for all
	// peripherals (components with a @PTYPE tag), based upon their
	// NADDR (number of addresses required) tag
	//

	assign	      buserr_sel = (sio_sel)&&(wb_addr[2:0] ==  3'b0_00);
	assign	   clkhdmiin_sel = (sio_sel)&&(wb_addr[2:0] ==  3'b0_01);
	assign	  clkhdmiout_sel = (sio_sel)&&(wb_addr[2:0] ==  3'b0_10);
	assign	        gpio_sel = (sio_sel)&&(wb_addr[2:0] ==  3'b0_11);
	assign	    pwrcount_sel = (sio_sel)&&(wb_addr[2:0] ==  3'b1_00);
	assign	     version_sel = (sio_sel)&&(wb_addr[2:0] ==  3'b1_01);
	assign	   gck_sel = (dio_sel)&&(wb_addr[29: 5] ==  4'b0000_);
	assign	  gpsu_sel = (dio_sel)&&(wb_addr[29: 5] ==  4'b0001_);
	assign	  mous_sel = (dio_sel)&&(wb_addr[29: 5] ==  4'b0010_);
	assign	  oled_sel = (dio_sel)&&(wb_addr[29: 5] ==  4'b0011_);
	assign	sdcard_sel = (dio_sel)&&(wb_addr[29: 5] ==  4'b0100_);
	assign	  uart_sel = (dio_sel)&&(wb_addr[29: 5] ==  4'b0101_);
	assign	   gtb_sel = (dio_sel)&&(wb_addr[29: 5] ==  3'b011);
	assign	  netp_sel = (dio_sel)&&(wb_addr[29: 5] ==  3'b100);
	assign	   sio_sel = (wb_addr[29: 3] == 27'b0000_0000_0000_0000_0000_0100_000;
	assign	   dio_sel = (wb_addr[29: 6] == 24'b0000_0000_0000_0000_0000_0101_;
	assign	 flctl_sel = (wb_addr[29: 2] == 28'b0000_0000_0000_0000_0000_0110_0000_);
	assign	   cfg_sel = (wb_addr[29: 5] == 25'b0000_0000_0000_0000_0000_0110_1);
	assign	  mdio_sel = (wb_addr[29: 5] == 25'b0000_0000_0000_0000_0000_0111_0);
	assign	  netb_sel = (wb_addr[29:12] == 18'b0000_0000_0000_0000_01);
	assign	   mem_sel = (wb_addr[29:19] == 11'b0000_0000_001);
	assign	 flash_sel = (wb_addr[29:24] ==  6'b0000_01);
	assign	none_sel = (wb_stb)&&({ flash, mem, netb, mdio, cfg, flctl, dio_sel, sio_sel} == 0);
	//
	// many_sel
	//
	// This should *never* be true .... unless the address decoding logic
	// is somehow broken.  Given that a computer is generating the
	// addresses, that should never happen.  However, since it has
	// happened to me before (without the computer), I test/check for it
	// here.
	//
	// Devices are placed here as a natural result of the address
	// decoding logic.  Thus, any device with a sel_ line will be
	// tested here.
	//
	always @(*)
	begin
		many_sel <= (wb_stb);
		case({flash, mem, netb, mdio, cfg, flctl, dio_sel, sio_sel})
			20'h0: many_sel <= 1'b0;
			20'b10000000: many_sel <= 1'b0;
			20'b01000000: many_sel <= 1'b0;
			20'b00100000: many_sel <= 1'b0;
			20'b00010000: many_sel <= 1'b0;
			20'b00001000: many_sel <= 1'b0;
			20'b00000100: many_sel <= 1'b0;
			20'b00000010: many_sel <= 1'b0;
			20'b00000001: many_sel <= 1'b0;
		endcase
	end
//
// many_ack
//
// It is also a violation of the bus protocol to produce multiply
// acks at once and on the same clock.  In that case, the bus
// can't decide which result to return.  Worse, if someone is waiting
// for a return value, that value will never come since another ack
// masked it.
//
// The other error that isn't tested for here, no would I necessarily
// know how to test for it, is when peripherals return values out of
// order.  Instead, I propose keeping that from happening by
// guaranteeing, in software, that two peripherals are not accessed
// immediately one after the other.
//
	always @(posedge i_clk)
	begin
		many_ack <= (wb_cyc);
		case({flash, mem, netb, mdio, cfg, flctl, dio_ack, sio_ack})
			8'h0: many_ack <= 1'b0;
			8'b10000000: many_ack <= 1'b0;
			8'b01000000: many_ack <= 1'b0;
			8'b00100000: many_ack <= 1'b0;
			8'b00010000: many_ack <= 1'b0;
			8'b00001000: many_ack <= 1'b0;
			8'b00000100: many_ack <= 1'b0;
			8'b00000010: many_ack <= 1'b0;
			8'b00000001: many_ack <= 1'b0;
		endcase
	end
	//
	// wb_ack
	//
	// The returning wishbone ack is equal to the OR of every component that
	// might possibly produce an acknowledgement, gated by the CYC line.  To
	// add new components, OR their acknowledgements in here.
	//
	// To return an ack here, a component must have a @PTYPE.  Acks from
	// any @PTYPE SINGLE and DOUBLE components have been collected
	// together into sio_ack and dio_ack respectively, which will appear.
	// ahead of any other device acks.
	//
	always @(posedge i_clk)
		sio_ack <= (wb_sel)&&(sio_sel);
	always @(posedge i_clk)
		pre_dio_ack <= (wb_sel)&&(dio_sel);
	always @(posedge i_clk)
		dio_ack <= pre_dio_ack;
	assign	wb_ack = (wb_cyc)&&(|{flash, mem, netb, mdio, cfg, flctl, dio_ack, sio_ack});


	//
	// wb_stall
	//
	// The returning wishbone stall line really depends upon what device
	// is requested.  Thus, if a particular device is selected, we return 
	// the stall line for that device.
	//
	// Stall lines come from any component with a @PTYPE key and a
	// @NADDR > 0.  Since those components of @PTYPE SINGLE or DOUBLE
	// are not allowed to stall, they have been removed from this list
	// here for simplicity.
	//
	assign	wb_stall = 
		  (wb_stb)&&( flctl_sel)&&( flctl_stall)
		||(wb_stb)&&(   cfg_sel)&&(   cfg_stall)
		||(wb_stb)&&(  mdio_sel)&&(  mdio_stall)
		||(wb_stb)&&(  netb_sel)&&(  netb_stall)
		||(wb_stb)&&(   mem_sel)&&(   mem_stall)
		||(wb_stb)&&( flash_sel)&&( flash_stall);


	//
	// wb_err
	//
	// This is the bus error signal.  It should never be true, but practice
	// teaches us otherwise.  Here, we allow for three basic errors:
	//
	// 1. STB is true, but no devices are selected
	//
	//	This is the null pointer reference bug.  If you try to access
	//	something on the bus, at an address with no mapping, the bus
	//	should produce an error--such as if you try to access something
	//	at zero.
	//
	// 2. STB is true, and more than one device is selected
	//
	//	(This can be turned off, if you design this file well.  For
	//	this line to be true means you have a design flaw.)
	//
	// 3. If more than one ACK is every true at any given time.
	//
	//	This is a bug of bus usage, combined with a subtle flaw in the
	//	WB pipeline definition.  You can issue bus requests, one per
	//	clock, and if you cross device boundaries with your requests,
	//	you may have things come back out of order (not detected here)
	//	or colliding on return (detected here).  The solution to this
	//	problem is to make certain that any burst request does not cross
	//	device boundaries.  This is a requirement of whoever (or
	//	whatever) drives the bus.
	//
	assign	wb_err = ((wb_stb)&&(none_sel || many_sel))
				|| ((wb_cyc)&&(many_ack));

	always @(posedge i_clk)
		if (wb_err)
			r_bus_err <= wb_addr;

	//Now we turn to defining all of the parts and pieces of what
	// each of the various peripherals does, and what logic it needs.
	//
	// This information comes from the @MAIN.INSERT and @MAIN.ALT tags.
	// If an @ACCESS tag is available, an ifdef is created to handle
	// having the access and not.  If the @ACCESS tag is `defined above
	// then the @MAIN.INSERT code is executed.  If not, the @MAIN.ALT
	// code is exeucted, together with any other cleanup settings that
	// might need to take place--such as returning zeros to the bus,
	// or making sure all of the various interrupt wires are set to
	// zero if the component is not included.
	//
`ifdef	GPS_CLOCK
	gpsclock #(.DEFAULT_STEP(GPSCLOCK_DEFAULT_STEP))
		ppsck(i_clk, 1'b0, gps_pps, ck_pps, gps_led,
			(wb_stb)&&(gck_sel), wb_we, wb_addr[1:0], wb_data,
				gck_ack, gck_stall, gck_data,
			gps_tracking, gps_now, gps_step, gps_err, gps_locked);
`else	// GPS_CLOCK
	wire	[31:0]	pre_step;
	assign	pre_step = { 16'h00, (({GPSCLOCK_DEFAULT_STEP[27:0],20'h00})
				>>GPSCLOCK_DEFAULT_STEP[31:28]) };
	always @(posedge i_clk)
		{ ck_pps, gps_step[31:0] } <= gps_step + pre_step;
	assign	gck_stall  = 1'b0;
	assign	gps_now    = 64'h0;
	assign	gps_err    = 64'h0;
	assign	gps_step   = 64'h0;
	assign	gps_led    = 1'b0;
	assign	gps_locked = 1'b0;


	reg	r_gck_ack;
	always @(posedge i_clk)
		r_gck_ack <= (wb_stb)&&(gck_sel);

	assign	gck_ack   = r_gck_ack;
	assign	gck_stall = 1'b0;
	assign	gck_data  = 32'h0;

`endif	// GPS_CLOCK

	assign	version_data = `DATESTAMP;
`ifdef	GPS_CLOCK

	gpsclock_tb
		ppsck(i_clk, ck_pps, tb_pps,
			(wb_stb)&&(gtb_sel), wb_we, wb_addr[2:0], wb_data,
				gtb_ack, gtb_stall, gtb_data,
			gps_err, gps_now, gps_step);

`ifdef	GPSTB
	assign	gps_pps = tb_pps;
`else
	assign	gps_pps = i_gps_pps;
`endif

`endif

`ifdef	BLKRAM_ACCESS
	memdev #(.LGMEMSZ(20), .EXTRACLOCK(0))
		blkram(i_clk,
			(wb_cyc), (wb_stb)&&(mem_sel), wb_we,
				wb_addr[17:0], wb_data, wb_sel,
				mem_ack, mem_stall, mem_data);

	reg	r_mem_ack;
	always @(posedge i_clk)
		r_mem_ack <= (wb_stb)&&(mem_sel);

	assign	mem_ack   = r_mem_ack;
	assign	mem_stall = 1'b0;
	assign	mem_data  = 32'h0;

`endif	// BLKRAM_ACCESS

`ifdef	ETHERNET_ACCESS
	enetpackets	#(12)
		netctrl(i_clk, i_rst, wb_cyc,(wb_stb)&&((netp_sel)||(netb_sel)),
			wb_we, { (netb_sel), wb_addr[10:0] }, wb_data, wb_sel,
				netp_ack, netp_stall, netp_data,
			o_net_reset_n,
			i_net_rx_clk, i_net_col, i_net_crs, i_net_dv, i_net_rxd,
				i_net_rxerr,
			i_net_tx_clk, o_net_tx_en, o_net_txd,
			enet_rx_int, enet_tx_int);

	reg	r_netp_ack;
	always @(posedge i_clk)
		r_netp_ack <= (wb_stb)&&(netp_sel);

	assign	netp_ack   = r_netp_ack;
	assign	netp_stall = 1'b0;
	assign	netp_data  = 32'h0;

	assign	enet_rx_int = 1'b0;
	assign	enet_tx_int = 1'b0;
`endif	// ETHERNET_ACCESS

	clkcounter clkhmdiin(i_clk, ck_pps, i_hdmi_in_clk,
 			clkhdmiin_data);
`ifdef	CONSOLE_ACCESS
	wbuart #(.DEFAULT_STEP(GPSCLOCK_DEFAULT_STEP))
 		console(i_clk, 1'b0,
 			(wb_stb)&&(uart_sel), wb_we, wb_addr[1:0], wb_data,
 			uart_ack, uart_stall, uart_data,
 			i_aux_rx, o_aux_tx, i_aux_cts_n, o_aux_rts_n,
			uartrx_int, uarttx_int, uartrxf_int, uarttxf_int);
`else	// CONSOLE_ACCESS
	assign	o_uart_tx    = 1'b1;
	assign	o_uart_rts_n = 1'b0;

	reg	r_uart_ack;
	always @(posedge i_clk)
		r_uart_ack <= (wb_stb)&&(uart_sel);

	assign	uart_ack   = r_uart_ack;
	assign	uart_stall = 1'b0;
	assign	uart_data  = 32'h0;

	assign	uartrx_int = 1'b0;
	assign	uarttx_int = 1'b0;
	assign	uartrxf_int = 1'b0;
	assign	uarttxf_int = 1'b0;
`endif	// CONSOLE_ACCESS

`ifdef	CFG_ACCESS
	wire[31:0]	cfg_debug;
`ifdef	VERILATOR
	reg	r_cfg_ack;
	always @(posedge i_clk)
		r_cfg_ack <= (wb_stb)&&(cfg_sel);
	assign	cfg_stall = 1'b0;
	assign	cfg_data  = 32'h00;
`else
	wbicapetwo #(ICAPE_LGDIV)
		cfgport(i_clk, wb_cyc, (wb_stb)&&(cfg_sel), wb_we,
			wb_addr[4:0], wb_data,
			cfg_ack, cfg_stall, cfg_data);
`endif

	reg	r_cfg_ack;
	always @(posedge i_clk)
		r_cfg_ack <= (wb_stb)&&(cfg_sel);

	assign	cfg_ack   = r_cfg_ack;
	assign	cfg_stall = 1'b0;
	assign	cfg_data  = 32'h0;

`endif	// CFG_ACCESS

`ifndef	ETHERNET_ACCESS
	// Ethernet packet memory declaration
	//
	// The only time this needs to be defined is when the ethernet module
	// itself isnt defined.  Otherwise, the access is accomplished by the
	// ethernet module

	memdev #(13)
		enet_buffers(i_clk,
			(wb_cyc), (wb_stb)&&(netb_sel),(wb_we)&&(wb_addr[11]),
				wb_addr[11:0], wb_data, wb_sel
				netb_ack, netb_stall, netb_data);

`else

	assign	netb_ack   = 1'b0;
	assign	netb_stall = 1'b0;

`endif

`ifdef	NETCTRL_ACCESS
	wire[31:0]	mdio_debug;
	enetctrl #(2)
		mdio(i_clk, i_rst, wb_cyc, (wb_stb)&&(mdio_sel), wb_we,
				wb_addr[4:0], wb_data[15:0],
			mdio_ack, mdio_stall, mdio_data,
			o_mdclk, o_mdio, i_mdio, o_mdwe);;
static	const	char	*alt_insert = ""
	assign	o_mdclk = 1'b1;
	assign	o_mdio  = 1'b1;
	assign	o_mdwe  = 1'b0;;

	reg	r_mdio_ack;
	always @(posedge i_clk)
		r_mdio_ack <= (wb_stb)&&(mdio_sel);

	assign	mdio_ack   = r_mdio_ack;
	assign	mdio_stall = 1'b0;
	assign	mdio_data  = 32'h0;

`endif	// NETCTRL_ACCESS

`ifdef	SDSPI_ACCESS
	wire[31:0]	sd_debug;
	// SPI mapping
	wire	w_sd_cs_n, w_sd_mosi, w_s_miso;

	sdspi	sdctrl(i_clk,
		wb_cyc, (wb_stb)&&(sdcard_sel), wb_we,
			wb_addr[1:0], wb_data,
			sdcard_ack, sdcard_stall, sdcard_data,
		w_sd_cs_n, o_sd_sck, w_sd_mosi, w_sd_miso,
		sdcard_int, 1\'b1, sd_dbg);

	assign	w_sd_miso = i_sd_data[0];
	assign	o_sd_data = { w_sd_cs_n, 3\'b111 };
	assign	o_sd_cmd  = w_sd_mosi;
`else	// SDSPI_ACCESS
	assign	o_sd_sck   = 1\'b1;
	assign	o_sd_cmd   = 1\'b1;
	assign	o_sd_data  = 4\'hf;
	assign	sdcard_int = 1'b0

	reg	r_sdcard_ack;
	always @(posedge i_clk)
		r_sdcard_ack <= (wb_stb)&&(sdcard_sel);

	assign	sdcard_ack   = r_sdcard_ack;
	assign	sdcard_stall = 1'b0;
	assign	sdcard_data  = 32'h0;

	assign	sdcard_int = 1'b0;
`endif	// SDSPI_ACCESS

	clkcounter clkhmdiout(i_clk, ck_pps, i_hdmi_out_clk, clkhdmiin_data);
`ifdef	FLASH_ACCESS
	wbqspiflash #(24)
		flashmem(i_clk,
			(wb_cyc), (wb_stb)&&(flash_sel), (wb_stb)&&(flctl_sel),wb_we,
			wb_addr[23:0], wb_data,
			flash_ack, flash_stall, flash_data,
			o_qspi_sck, o_qspi_cs_n, o_qspi_dat, i_qspi_dat,
			flash_interrupt)
`else	// FLASH_ACCESS
	assign	o_qspi_sck  = 1\'b1;
	assign	o_qspi_cs_n = 1\'b1;
	assign	o_qspi_mod  = 2\'b01;
	assign	o_qspi_dat  = 4\'b1111;

	reg	r_flash_ack;
	always @(posedge i_clk)
		r_flash_ack <= (wb_stb)&&(flash_sel);

	assign	flash_ack   = r_flash_ack;
	assign	flash_stall = 1'b0;
	assign	flash_data  = 32'h0;

	assign	flash_interrupt = 1'b0;
`endif	// FLASH_ACCESS

	initial	pwrcount_data = 32'h0;
	always @(posedge i_clk)
	if (pwrcount_data[31])
		pwrcount_data[30:0] <= pwrcount_data[30:0] + 1'b1;
	else
		pwrcount_data[31:0] <= pwrcount_data[31:0] + 1'b1;
`ifdef	MOUSE_ACCESS
	wbmouse themouse(i_clk,
		(wb_cyc), (wb_stb)&&(mous_sel), wb_we, wb_addr[1:0], wb_data,
			mous_ack, mous_stall, mous_data,
		i_ps2, o_ps2,
		scrn_mouse, mous_interrupt);
`else	// MOUSE_ACCESS
	// If there is no mouse, declare mouse types of things to be .. absent
	assign	scrn_mouse     = 32'h00;
	assign	mous_interrupt = 1'b0;
	assign	o_ps2          = 2'b11;

	reg	r_mous_ack;
	always @(posedge i_clk)
		r_mous_ack <= (wb_stb)&&(mous_sel);

	assign	mous_ack   = r_mous_ack;
	assign	mous_stall = 1'b0;
	assign	mous_data  = 32'h0;

	assign	mous_interrupt = 1'b0;
`endif	// MOUSE_ACCESS

`ifdef	GPSUART_ACCESS
	wbuart #(.DEFAULT_STEP(GPSCLOCK_DEFAULT_STEP))
		gpsuart(i_clk, 1'b0,
			(wb_stb)&&(gpsu_sel), wb_we, wb_addr[1:0], wb_data,
				gpsu_ack, gpsu_stall, gpsu_data,
			i_aux_rx, o_aux_tx, i_aux_cts_n, o_aux_rts_n,
			gpsurx_int, gpsutx_int, gpsurxf_int, gpsutxf_int);
`else	// GPSUART_ACCESS
	assign	o_gps_tx = 1'b1;
	assign	o_gpsurx_int = 1'b0;
	assign	o_gpsutx_int = 1'b0;
	assign	o_gpsurxf_int = 1'b0;
	assign	o_gpsutxf_int = 1'b0;


	reg	r_gpsu_ack;
	always @(posedge i_clk)
		r_gpsu_ack <= (wb_stb)&&(gpsu_sel);

	assign	gpsu_ack   = r_gpsu_ack;
	assign	gpsu_stall = 1'b0;
	assign	gpsu_data  = 32'h0;

	assign	gpsurx_int = 1'b0;
	assign	gpsutx_int = 1'b0;
	assign	gpsurxf_int = 1'b0;
	assign	gpsutxf_int = 1'b0;
`endif	// GPSUART_ACCESS

`ifdef	OLEDRGB_ACCESS
	wboled #(.CBITS(4)) oledctrl(i_clk,
		(wb_cyc), (wb_stb)&&(oled_sel), wb_we,
				wb_addr[1:0], wb_data,
			oled_ack, oled_stall, oled_data,
		o_oled_sck, o_oled_cs_n, o_oled_mosi, o_oled_dcn,
		{ o_oled_reset_n, o_oled_vccen, o_oled_pmoden },
		oled_int);
`else	// OLEDRGB_ACCESS
	assign	o_oled_cs_n    = 1'b1;
	assign	o_oled_sck     = 1'b1;
	assign	o_oled_mosi    = 1'b1;
	assign	o_oled_dcn     = 1'b1;
	assign	o_oled_reset_n = 1'b0;
	assign	o_oled_vccen   = 1'b0;
	assign	o_oled_pmoden  = 1'b0;


	reg	r_oled_ack;
	always @(posedge i_clk)
		r_oled_ack <= (wb_stb)&&(oled_sel);

	assign	oled_ack   = r_oled_ack;
	assign	oled_stall = 1'b0;
	assign	oled_data  = 32'h0;

	assign	oled_int = 1'b0;
`endif	// OLEDRGB_ACCESS

`ifdef	GPIO_ACCESS
	//
	// GPIO
	//
	// Not used (yet), but this interface should allow us to control up to
	// 16 GPIO inputs, and another 16 GPIO outputs.  The interrupt trips
	// when any of the inputs changes.  (Sorry, which input isn't (yet)
	// selectable.)
	//
	wire	[31:0]	gpio_data;
	wbgpio	#(NGPI, NGPO)
		gpioi(i_clk, 1'b1, (wb_stb)&&(gpio_sel), 1'b1,
			w_wb_data, gpio_data, i_gpio, o_gpio, gpio_int);

	reg	r_gpio_ack;
	always @(posedge i_clk)
		r_gpio_ack <= (wb_stb)&&(gpio_sel);

	assign	gpio_ack   = r_gpio_ack;
	assign	gpio_stall = 1'b0;
	assign	gpio_data  = 32'h0;

`endif	// GPIO_ACCESS

	assign	buserr_data = r_bus_err;
	//
	// Finally, determine what the response is from the wishbone
	// bus
	//
	//
	//
	// wb_idata
	//
	// This is the data returned on the bus.  Here, we select between a
	// series of bus sources to select what data to return.  The basic
	// logic is simply this: the data we return is the data for which the
	// ACK line is high.
	//
	// The last item on the list is chosen by default if no other ACK's are
	// true.  Although we might choose to return zeros in that case, by
	// returning something we can skimp a touch on the logic.
	//
	// Any peripheral component with a @PTYPE value will be listed
	// here.
	//
	always @(posedge i_clk)
	casez({ buserr_sel, clkhdmiin_sel, clkhdmiout_sel, gpio_sel, pwrcount_sel, version_sel })
		 6'b1?????: sio_data <= buserr_data;
;
		 6'b01????: sio_data <= clkhdmiin_data;
;
		 6'b001???: sio_data <= clkhdmiout_data;
;
		 6'b0001??: sio_data <= gpio_data;
;
		 6'b00001?: sio_data <= pwrcount_data;
;
		 6'b000001: sio_data <= version_data;
;
	default: sio_data <= 32'h0;
	always @(posedge i_clk)
	casez({ gck_ack, gpsu_ack, mous_ack, oled_ack, sdcard_ack, uart_ack, gtb_ack, netp_ack })
		 8'b1???????: dio_data <= gck_data;
;
		 8'b01??????: dio_data <= gpsu_data;
;
		 8'b001?????: dio_data <= mous_data;
;
		 8'b0001????: dio_data <= oled_data;
;
		 8'b00001???: dio_data <= sdcard_data;
;
		 8'b000001??: dio_data <= uart_data;
;
		 8'b0000001?: dio_data <= gtb_data;
;
		 8'b00000001: dio_data <= netp_data;
;
	default: dio_data <= 32'h0;
	always @(*)
		casez({ flash, mem, netb, mdio, cfg, flctl, dio_ack, sio_ack })
			8'b1???????: wb_idata <= flctl_data;
			8'b01??????: wb_idata <= cfg_data;
			8'b001?????: wb_idata <= mdio_data;
			8'b0001????: wb_idata <= netb_data;
			8'b00001???: wb_idata <= mem_data;
			8'b000001??: wb_idata <= flash_data;
			8'b0000001?: wb_idata <= dio_data;
			8'b00000001: wb_idata <= dio_data;
		endcase
	end


endmodule; // main.v
