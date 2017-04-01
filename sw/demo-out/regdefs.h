


// TO BE PLACED INTO regdefs.h
#ifndef	REGDEFS_H
#define	REGDEFS_H


// FLASH erase/program configuration registers
#define	R_QSPI_EREG   	0x00000600	// wbregs names: QSPIE
#define	R_QSPI_SREG   	0x00000604	// wbregs names: QSPIC
#define	R_QSPI_SREG   	0x00000608	// wbregs names: QSPIS
#define	R_QSPI_IDREG  	0x0000060c	// wbregs names: QSPII
// FPGA CONFIG REGISTERS: 0x4e0-0x4ff
#define	R_CFG_CRC     	0x00000680	// wbregs names: FPGACRC
#define	R_CFG_FAR     	0x00000684	// wbregs names: FPGAFAR
#define	R_CFG_FDRI    	0x00000688	// wbregs names: FPGAFDRI
#define	R_CFG_FDRO    	0x0000068c	// wbregs names: FPGAFDRO
#define	R_CFG_CMD     	0x00000690	// wbregs names: FPGACMD
#define	R_CFG_CTL0    	0x00000694	// wbregs names: FPGACTL0
#define	R_CFG_MASK    	0x00000698	// wbregs names: FPGAMASK
#define	R_CFG_STAT    	0x0000069c	// wbregs names: FPGASTAT
#define	R_CFG_LOUT    	0x000006a0	// wbregs names: FPGALOUT
#define	R_CFG_COR0    	0x000006a4	// wbregs names: FPGACOR0
#define	R_CFG_MFWR    	0x000006a8	// wbregs names: FPGAMFWR
#define	R_CFG_CBC     	0x000006ac	// wbregs names: FPGACBC
#define	R_CFG_IDCODE  	0x000006b0	// wbregs names: FPGAIDCODE
#define	R_CFG_AXSS    	0x000006b4	// wbregs names: FPGAAXSS
#define	R_CFG_COR1    	0x000006b8	// wbregs names: FPGACOR1
#define	R_CFG_WBSTAR  	0x000006c0	// wbregs names: WBSTAR
#define	R_CFG_TIMER   	0x000006c4	// wbregs names: CFGTIMER
#define	R_CFG_BOOTSTS 	0x000006d8	// wbregs names: BOOTSTS
#define	R_CFG_CTL1    	0x000006e0	// wbregs names: FPGACTL1
#define	R_CFG_BSPI    	0x000006fc	// wbregs names: FPGABSPI
// Ethernet configuration (MDIO) port
#define	R_MDIO_BMCR   	0x00000700	// wbregs names: BMCR
#define	R_MDIO_BMSR   	0x00000704	// wbregs names: BMSR
#define	R_MDIO_PHYIDR1	0x00000708	// wbregs names: PHYIDR1
#define	R_MDIO_PHYIDR2	0x0000070c	// wbregs names: PHYIDR2
#define	R_MDIO_ANAR   	0x00000710	// wbregs names: ANAR
#define	R_MDIO_ANLPAR 	0x00000714	// wbregs names: ANLPAR
#define	R_MDIO_ANER   	0x00000718	// wbregs names: ANER
#define	R_MDIO_ANNPTR 	0x0000071c	// wbregs names: ANNPTR
#define	R_MDIO_PHYSTS 	0x00000740	// wbregs names: PHYSYTS
#define	R_MDIO_FCSCR  	0x00000750	// wbregs names: FCSCR
#define	R_MDIO_RECR   	0x00000754	// wbregs names: RECR
#define	R_MDIO_PCSR   	0x00000758	// wbregs names: PCSR
#define	R_MDIO_RBR    	0x0000075c	// wbregs names: RBR
#define	R_MDIO_LEDCR  	0x00000760	// wbregs names: LEDCR
#define	R_MDIO_PHYCR  	0x00000764	// wbregs names: PHYCR
#define	R_MDIO_BTSCR  	0x00000768	// wbregs names: BTSCR
#define	R_MDIO_CDCTRL 	0x0000076c	// wbregs names: CDCTRL
#define	R_MDIO_EDCR   	0x00000774	// wbregs names: EDCR
#define	R_NET_RXBUF   	0x00004000	// wbregs names: NETRXB
#define	R_NET_TXBUF   	0x00006000	// wbregs names: NETTXB
#define	BKRAM         	0x00200000	// wbregs names: RAM
#define	FLASHMEM      	0x04000000	// wbregs names: FLASH


// Definitions for the bus masters
// And then from the peripherals
#define	SZPAGEB		256
#define	PGLENB		256
#define	SZPAGEW		64
#define	PGLENW		64
#define	NPAGES		256
#define	SECTORSZB	(NPAGES * SZPAGEB)	// In bytes, not words!!
#define	SECTORSZW	(NPAGES * SZPAGEW)	// In words
#define	NSECTORS	64
#define	SECTOROF(A)	((A) & (-1<<16))
#define	SUBSECTOROF(A)	((A) & (-1<<12))
#define	PAGEOF(A)	((A) & (-1<<8))

// End of definitions from REGS.INSERT.H


typedef	struct {
	unsigned	m_addr;
	const char	*m_name;
} REGNAME;

extern	const	REGNAME	*bregs;
extern	const	int	NREGS;
// #define	NREGS	(sizeof(bregs)/sizeof(bregs[0]))

extern	unsigned	addrdecode(const char *v);
extern	const	char *addrname(const unsigned v);

#endif	// REGDEFS_H
