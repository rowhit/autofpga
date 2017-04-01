


// TO BE PLACED INTO regdefs.cpp
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <ctype.h>
#include "regdefs.h"

const	REGNAME	raw_bregs[] = {
	{ R_QSPI_EREG   ,	"QSPIE"     	},
	{ R_QSPI_SREG   ,	"QSPIC"     	},
	{ R_QSPI_SREG   ,	"QSPIS"     	},
	{ R_QSPI_IDREG  ,	"QSPII"     	},
	{ R_CFG_CRC     ,	"FPGACRC"   	},
	{ R_CFG_FAR     ,	"FPGAFAR"   	},
	{ R_CFG_FDRI    ,	"FPGAFDRI"  	},
	{ R_CFG_FDRO    ,	"FPGAFDRO"  	},
	{ R_CFG_CMD     ,	"FPGACMD"   	},
	{ R_CFG_CTL0    ,	"FPGACTL0"  	},
	{ R_CFG_MASK    ,	"FPGAMASK"  	},
	{ R_CFG_STAT    ,	"FPGASTAT"  	},
	{ R_CFG_LOUT    ,	"FPGALOUT"  	},
	{ R_CFG_COR0    ,	"FPGACOR0"  	},
	{ R_CFG_MFWR    ,	"FPGAMFWR"  	},
	{ R_CFG_CBC     ,	"FPGACBC"   	},
	{ R_CFG_IDCODE  ,	"FPGAIDCODE"	},
	{ R_CFG_AXSS    ,	"FPGAAXSS"  	},
	{ R_CFG_COR1    ,	"FPGACOR1"  	},
	{ R_CFG_WBSTAR  ,	"WBSTAR"    	},
	{ R_CFG_TIMER   ,	"CFGTIMER"  	},
	{ R_CFG_BOOTSTS ,	"BOOTSTS"   	},
	{ R_CFG_CTL1    ,	"FPGACTL1"  	},
	{ R_CFG_BSPI    ,	"FPGABSPI"  	},
	{ R_MDIO_BMCR   ,	"BMCR"      	},
	{ R_MDIO_BMSR   ,	"BMSR"      	},
	{ R_MDIO_PHYIDR1,	"PHYIDR1"   	},
	{ R_MDIO_PHYIDR2,	"PHYIDR2"   	},
	{ R_MDIO_ANAR   ,	"ANAR"      	},
	{ R_MDIO_ANLPAR ,	"ANLPAR"    	},
	{ R_MDIO_ANER   ,	"ANER"      	},
	{ R_MDIO_ANNPTR ,	"ANNPTR"    	},
	{ R_MDIO_PHYSTS ,	"PHYSYTS"   	},
	{ R_MDIO_FCSCR  ,	"FCSCR"     	},
	{ R_MDIO_RECR   ,	"RECR"      	},
	{ R_MDIO_PCSR   ,	"PCSR"      	},
	{ R_MDIO_RBR    ,	"RBR"       	},
	{ R_MDIO_LEDCR  ,	"LEDCR"     	},
	{ R_MDIO_PHYCR  ,	"PHYCR"     	},
	{ R_MDIO_BTSCR  ,	"BTSCR"     	},
	{ R_MDIO_CDCTRL ,	"CDCTRL"    	},
	{ R_MDIO_EDCR   ,	"EDCR"      	},
	{ R_NET_RXBUF   ,	"NETRXB"    	},
	{ R_NET_TXBUF   ,	"NETTXB"    	},
	{ BKRAM         ,	"RAM"       	},
	{ FLASHMEM      ,	"FLASH"     	}
};

#define	RAW_NREGS	(sizeof(raw_bregs)/sizeof(bregs[0]))

const	REGNAME	*bregs = raw_bregs;
unsigned	addrdecode(const char *v) {
	if (isalpha(v[0])) {
		for(int i=0; i<NREGS; i++)
			if (strcasecmp(v, bregs[i].m_name)==0)
				return bregs[i].m_addr;
		fprintf(stderr, "Unknown register: %s\n", v);
		exit(-2);
	} else
		return strtoul(v, NULL, 0); 
}

const	char *addrname(const unsigned v) {
	for(int i=0; i<NREGS; i++)
		if (bregs[i].m_addr == v)
			return bregs[i].m_name;
	return NULL;
}
