////////////////////////////////////////////////////////////////////////////////
//
// Filename:	../demo-out/board.h
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
#ifndef	BOARD_H
#define	BOARD_H

// And, so that we can know what is and isn't defined
// from within our main.v file, let's include:
#include <design.h>

#include <design.h>
#include <cpudefs.h>
#ifdef	INCLUDE_ZIPCPU
#ifdef INCLUDE_DMA_CONTROLLER
#define	_HAVE_ZIPSYS_DMA
#endif	// INCLUDE_DMA_CONTROLLER
#ifdef INCLUDE_ACCOUNTING_COUNTERS
#define	_HAVE_ZIPSYS_PERFORMANCE_COUNTERS
#endif	// INCLUDE_ACCOUNTING_COUNTERS
#endif // INCLUDE_ZIPCPU


#define	SDSPI_SETAUX	0x0ff
#define	SDSPI_READAUX	0x0bf
#define	SDSPI_CMD		0x040
#define	SDSPI_ACMD		(0x040+55) // CMD55
#define	SDSPI_FIFO_OP	0x0800	// Read only
#define	SDSPI_WRITEOP	0x0c00	// Write to the FIFO
#define	SDSPI_ALTFIFO	0x1000
#define	SDSPI_BUSY		0x4000
#define	SDSPI_ERROR	0x8000
#define	SDSPI_CLEARERR	0x8000
#define	SDSPI_READ_SECTOR	((SDSPI_CMD|SDSPI_CLEARERR|SDSPI_FIFO_OP)+17)
#define	SDSPI_WRITE_SECTOR	((SDSPI_CMD|SDSPI_CLEARERR|SDSPI_WRITEOP)+24)

typedef	struct SDSPI_S {
	unsigned	sd_ctrl, sd_data, sd_fifo[2];
} SDSPI;


typedef	struct	RTCLIGHT_S	{
	unsigned	r_clock, r_stopwatch, r_timer, r_alarm;
} RTCLIGHT;


#define WBMIC_ENABLE	0
#define WBMIC_DISABLE	(1<<20)
#define WBMIC_NONEMPTY	0
#define WBMIC_HALFINT	(1<<22)
#define WBMIC_RESET	(1<<24)

typedef struct  WBMIC_S {
	unsigned	m_data;
	unsigned	m_setup;
} WBMIC;


//
// GPIO input wires
//
#define	GPIO_HDMI_IN_CEC	0x000010000
#define	GPIO_HDMI_OUT_CEC	0x000020000
#define	GPIO_SD_DETECTED	0x000040000
#define	GPIO_HDMI_OUT_DETECT	0x000080000
#define	GPIO_GPS_3DF		0x000100000
#define	GPIO_SYSCLK_LOCKED	0x000200000
//
// GPIO output wires
//
#define	GPIO_SET(WIRE)	(((WIRE)<<16)|(WIRE))
#define	GPIO_CLR(WIRE)	 ((WIRE)<<16)
//
#define	GPIO_HDMI_IN_CEC_SET	0x000010001
#define	GPIO_HDMI_IN_CEC_CLR	0x000010000
#define	GPIO_HDMI_OUT_CEC_SET	0x000020002
#define	GPIO_HDMI_OUT_CEC_CLR	0x000020000
#define	GPIO_EDID_SCL		0x000000004
#define	GPIO_EDID_SDA		0x000000008
//
#define	GPIO_HDMI_IN_ENB	0x000000010
#define	GPIO_HDMI_IN_HPA	0x000000020
#define	GPIO_SD_RESET		0x000000040
#define	GPIO_HDMI_OUT_EN	0x000000080
//
#define	GPIO_EDID_SCL_SET	GPIO_SET(GPIO_EDID_SCL)
#define	GPIO_EDID_SCL_CLR	GPIO_CLR(GPIO_EDID_SCL)
#define	GPIO_EDID_SDA_SET	GPIO_SET(GPIO_EDID_SDA)
#define	GPIO_EDID_SDA_CLR	GPIO_CLR(GPIO_EDID_SDA)
#define	GPIO_HDMI_IN_ENB_SET	GPIO_SET(GPIO_HDMI_IN_ENB)
#define	GPIO_HDMI_IN_ENB_CLR	GPIO_CLR(GPIO_HDMI_IN_ENB)
#define	GPIO_HDMI_IN_HPA_SET	GPIO_SET(GPIO_HDMI_IN_HPA)
#define	GPIO_HDMI_IN_HPA_CLR	GPIO_CLR(GPIO_HDMI_IN_HPA)
#define	GPIO_SD_RESET_SET	GPIO_SET(GPIO_SD_RESET)
#define	GPIO_SD_RESET_CLR	GPIO_CLR(GPIO_SD_RESET)
#define	GPIO_HDMI_OUT_EN_SET	GPIO_SET(GPIO_HDMI_OUT_EN)
#define	GPIO_HDMI_OUT_EN_CLR	GPIO_CLR(GPIO_HDMI_OUT_EN)



typedef	struct	EDID_SRC_S {
	unsigned	o_cmd;
	unsigned	o_spd;
	unsigned	o_ignored[64-2];
	unsigned	o_data[64];
} EDID_SRC;

#define	READ_EDID(START,LN)	((0xa1<<16)|(((START)&0x0ff)<<8)|((LN)&0x0ff))
#define	EDID_SRC_BUSY	0x80000000
#define	EDID_SRC_ERR	0x40000000



typedef struct FLASHCTL_S {
	unsigned	f_ereg, f_config, f_status, f_id;
} FLASHCTL;


// Definitions to interact with the OLED device
#define	OLED_LOGICEN		0x0010001
#define	OLED_LOGICEN_OFF	0x0010000
#define	OLED_IOPWR		OLED_PMODEN
#define	OLED_DPWREN		0x0020002 // Was VCC
#define	OLED_DPWR_DISABLE	0x0020000
#define	OLED_RESET		0x0040000
#define	OLED_RESET_CLR		0x0040004
#define	OLED_FULLPOWER		(OLED_PMODEN|OLED_VCCEN|OLED_RESET_CLR)
#define	OLED_POWER_DOWN		(OLED_PMODEN_OFF|OLED_VCCEN|OLED_RESET_CLR)
#define	OLED_BUSY(dev)		(dev.o_ctrl & 1)
#define	OLED_DISPLAYON		0x0af	// To be sent over the control channel
typedef	struct OLEDBW_S {
	unsigned	o_ctrl, o_a, o_b, o_data;
} OLEDBW;



typedef	struct	GPSTRACKER_S	{
	unsigned	g_alpha, g_beta, g_gamma, g_step;
} GPSTRACKER;


// Mouse definitions
typedef struct  WBMOUSE_S {
	unsigned	m_bus, m_raw, m_screen, m_size;
} WBMOUSE;


#ifndef	WBSCOPE_H
#define	WBSCOPE_H

#define	WBSCOPE_NO_RESET	0x800000000
#define	WBSCOPE_TRIGGER		(WBSCOPE_NO_RESET|0x08000000)
#define	WBSCOPE_MANUAL		(WBSCOPE_TRIGGER)
#define	WBSCOPE_DISABLE		0x04000000

typedef struct WBSCOPE_S {
	unsigned s_ctrl, s_data;
} WBSCOPE;
#endif


typedef	struct	HDMI_IN_S {
	unsigned	hin_frame_addr;
	unsigned	hin_origin,
			hin_maxsz,
			hin_unused;
	unsigned	hin_ctrl, hin_manual, hin_syncdata, hin_quality;
	unsigned	hin_pixclk;
	unsigned	hin_reserved[3];
	short		hin_htotal, hin_ncols,
			hin_vtotal, hin_nrows;
	short		hin_hsstart, hin_ssend,
			hin_vsstart, hin_vssend;
} HDMI_IN;


#define	CLKFREQHZ	100000000


#define	SYSPIC(A)	(1<<(A))


// Offsets for the ICAPE2 interface
#define	CFG_CRC		0
#define	CFG_FAR		1
#define	CFG_FDRI	2
#define	CFG_FDRO	3
#define	CFG_CMD		4
#define	CFG_CTL0	5
#define	CFG_MASK	6
#define	CFG_STAT	7
#define	CFG_LOUT	8
#define	CFG_COR0	9
#define	CFG_MFWR	10
#define	CFG_CBC		11
#define	CFG_IDCODE	12
#define	CFG_AXSS	13
#define	CFG_COR1	14
#define	CFG_WBSTAR	16
#define	CFG_TIMER	17
#define	CFG_BOOTSTS	22
#define	CFG_CTL1	24
#define	CFG_BSPI	31


#define	ALTPIC(A)	(1<<(A))


#ifndef	WBUART_H
#define	WBUART_H

#define UART_PARITY_NONE        0
#define UART_HWFLOW_OFF         0x40000000
#define UART_PARITY_ODD         0x04000000
#define UART_PARITY_EVEN        0x05000000
#define UART_PARITY_SPACE       0x06000000
#define UART_PARITY_MARK        0x07000000
#define UART_STOP_ONEBIT        0
#define UART_STOP_TWOBITS       0x08000000
#define UART_DATA_8BITS         0
#define UART_DATA_7BITS         0x10000000
#define UART_DATA_6BITS         0x20000000
#define UART_DATA_5BITS         0x30000000
#define UART_RX_BREAK           0x0800
#define UART_RX_FRAMEERR        0x0400
#define UART_RX_PARITYERR       0x0200
#define UART_RX_NOTREADY        0x0100
#define UART_RX_ERR             (-256)
#define UART_TX_BUSY            0x0100
#define UART_TX_BREAK           0x0200

typedef struct  WBUART_S {
	unsigned	u_setup;
	unsigned	u_fifo;
	unsigned	u_rx, u_tx;
} WBUART;

#endif	// WBUART_H



typedef	struct	GPSTB_S	{
	unsigned	tb_maxcount, tb_jump;
	unsigned long	tb_err, tb_count, tb_step;
} GPSTB;


//
// The Ethernet MDIO interface
//
#define MDIO_BMCR	0x00
#define MDIO_BMSR	0x01
#define MDIO_PHYIDR1	0x02
#define MDIO_PHYIDR2	0x03
#define MDIO_ANAR	0x04
#define MDIO_ANLPAR	0x05
#define MDIO_ANLPARNP	0x05	// Duplicate register address
#define MDIO_ANER	0x06
#define MDIO_ANNPTR	0x07
#define MDIO_PHYSTS	0x10
#define MDIO_FCSCR	0x14
#define MDIO_RECR	0x15
#define MDIO_PCSR	0x16
#define MDIO_RBR	0x17
#define MDIO_LEDCR	0x18
#define MDIO_PHYCR	0x19
#define MDIO_BTSCR	0x1a
#define MDIO_CDCTRL	0x1b
#define MDIO_EDCR	0x1d

typedef struct ENETMDIO_S {
	unsigned	e_v[32];
} ENETMDIO;



#define	SPIO_BTNC	0x01000
#define	SPIO_BTND	0x00800
#define	SPIO_BTNL	0x00400
#define	SPIO_BTNR	0x00200
#define	SPIO_BTNU	0x00100


#ifdef	SDSPI_ACCESS
#define	_BOARD_HAS_SDSPI
static volatile SDSPI *const _sdcard = ((SDSPI *)7340032);
#endif	// SDSPI_ACCESS
#ifdef	RTC_ACCESS
#define	_BOARD_HAS_RTCLIGHT
static volatile RTCLIGHT *const _rtc = ((RTCLIGHT *)11534432);
#endif	// RTC_ACCESS
#define	_BOARD_HAS_VERSION
#ifdef	MICROPHONE_ACCESS
#define	_BOARD_HAS_WBMIC
static volatile WBMIC *const _wbmic = ((WBMIC *)1048576);
#endif	// MICROPHONE_ACCESS
#ifdef	GPIO_ACCESS
#define	_BOARD_HAS_GPIO
static volatile unsigned *const _gpio = ((unsigned *)8388628);
#endif	// GPIO_ACCESS
#ifdef	HDMI_OUT_EDID_ACCESS
#define	_BOARD_HAS_HDMI_SRC_EDID
static volatile EDID_SRC *const _edout = ((EDID_SRC *)11534848);
#endif	// HDMI_OUT_EDID_ACCESS
#ifdef	BKRAM_ACCESS
#define	_BOARD_HAS_BKRAM
extern char	_bkram[0x00100000];
#endif	// BKRAM_ACCESS
#ifdef	FLASH_ACCESS
#define	_BOARD_HAS_FLASH
extern char _flash[0x01000000];
#endif	// FLASH_ACCESS
#ifdef	OLEDBW_ACCESS
#define	_BOARD_HAS_OLEDBW
static volatile OLEDBW *const _oledbw = ((OLEDBW *)11534400);
#endif	// OLEDBW_ACCESS
#ifdef	MOUSE_ACCESS
#define	_BOARD_HAS_WBMOUSE
static volatile WBMOUSE *const _mouse = ((WBMOUSE *)11534368);
#endif	// MOUSE_ACCESS
#ifdef	HDMI_IN_EDID_ACCESS
#define	_BOARD_HAS_HDMI_IN_EDID
static volatile unsigned *const _edin = ((unsigned *)11534592);
#endif	// HDMI_IN_EDID_ACCESS
#ifdef	SDSPI_SCOPE
#define	_BOARD_HAS_SDSPI_SCOPE
static volatile WBSCOPE *const _scope_sdcard = ((WBSCOPE *)4194304);
#endif	// SDSPI_SCOPE
#ifdef	HDMIIN_ACCESS
#define	_BOARD_HAS_HDMI_IN
static volatile HDMI_IN *const _hin = ((HDMI_IN *)11534528);
#endif	// HDMIIN_ACCESS
#ifdef	RTCDATE_ACCESS
#define	_BOARD_HAS_RTCDATE
static volatile unsigned *const _date = ((unsigned *)8388624);
#endif	// RTCDATE_ACCESS
#ifdef	CFG_ACCESS
#define	_BOARD_HAS_ICAPTETWO
static volatile unsigned *const _icape = ((unsigned *)9437184);
#endif	// CFG_ACCESS
#define	_BOARD_HAS_BUSERR
static volatile unsigned *const _buserr = ((unsigned *)8388608);
#ifdef	BUSPIC_ACCESS
#define	_BOARD_HAS_BUSPIC
static volatile unsigned *const _buspic = ((unsigned *)8388612);
#endif	// BUSPIC_ACCESS
#ifdef	GPSUART_ACCESS
#define	_BOARD_HAS_GPS_UART
static volatile WBUART *const gpsu = ((WBUART *)6291456);
#endif	// GPSUART_ACCESS
#ifdef	NETCTRL_ACCESS
#define	_BOARD_HAS_NETMDIO
static volatile ENETMDIO *const _mdio = ((ENETMDIO *)10485760);
#endif	// NETCTRL_ACCESS
#ifdef	SPIO_ACCESS
#define	_BOARD_HAS_SPIO
static volatile unsigned *const _spio = ((unsigned *)8388640);
#endif	// SPIO_ACCESS
//
// Interrupt assignments (3 PICs)
//
// PIC: syspic
#define	SYSPIC_DMAC	SYSPIC(0)
#define	SYSPIC_JIFFIES	SYSPIC(1)
#define	SYSPIC_TMC	SYSPIC(2)
#define	SYSPIC_TMB	SYSPIC(3)
#define	SYSPIC_TMA	SYSPIC(4)
#define	SYSPIC_ALT	SYSPIC(5)
#define	SYSPIC_BUS	SYSPIC(6)
#define	SYSPIC_SDCARD	SYSPIC(7)
#define	SYSPIC_MIC	SYSPIC(8)
#define	SYSPIC_EDID	SYSPIC(9)
#define	SYSPIC_OLED	SYSPIC(10)
#define	SYSPIC_PPS	SYSPIC(11)
#define	SYSPIC_MOUSE	SYSPIC(12)
// PIC: altpic
#define	ALTPIC_UIC	ALTPIC(0)
#define	ALTPIC_UOC	ALTPIC(1)
#define	ALTPIC_UPC	ALTPIC(2)
#define	ALTPIC_UTC	ALTPIC(3)
#define	ALTPIC_MIC	ALTPIC(4)
#define	ALTPIC_MOC	ALTPIC(5)
#define	ALTPIC_MPC	ALTPIC(6)
#define	ALTPIC_MTC	ALTPIC(7)
#define	ALTPIC_RTC	ALTPIC(8)
#define	ALTPIC_GPIO	ALTPIC(9)
#define	ALTPIC_GPSRX	ALTPIC(10)
// PIC: buspic
#define	BUSPIC_SDCARD	BUSPIC(0)
#define	BUSPIC_SCOPE	BUSPIC(1)
#define	BUSPIC_FLASH	BUSPIC(2)
#define	BUSPIC_HINSCOPE	BUSPIC(3)
#define	BUSPIC_MOUSE	BUSPIC(4)
#define	BUSPIC_SPIO	BUSPIC(5)
#endif	// BOARD_H
