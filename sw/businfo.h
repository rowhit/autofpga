////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	businfo.h
//
// Project:	AutoFPGA, a utility for composing FPGA designs from peripherals
//
// Purpose:	
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
#ifndef	BUSINFO_H
#define	BUSINFO_H

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <algorithm>

#include "parser.h"
#include "mapdhash.h"
#include "plist.h"
#include "clockinfo.h"

class	BUSINFO {
protected:
	bool	m_addresses_assigned;
	int	m_data_width, m_address_width;
public:
	PLISTP    m_plist, m_slist, m_dlist;
	STRINGP   m_name, m_prefix, m_type;
	CLOCKINFO *m_clock; // , *m_bhash;
	int	m_nullsz;
	int	m_num_single, m_num_double, m_num_total;
	bool	m_has_slist, m_has_dlist;
	MAPDHASH	*m_hash;

	BUSINFO(void) { // MAPDHASH *hash)
		// m_bhash  = hash;
		m_plist  = NULL;
		m_slist  = NULL;
		m_dlist  = NULL;
		m_name   = NULL;
		m_prefix = NULL;
		m_type   = NULL;
		m_clock  = NULL;
		m_hash   = NULL;
		m_nullsz = 0;
		m_data_width = 0;
		m_addresses_assigned = false;
		m_address_width = 0;
		m_num_single = 0;
		m_num_double = 0;
		m_num_total  = 0;
	}

	bool	get_base_address(MAPDHASH *phash, unsigned &base);
	void	assign_addresses(void);
	int	address_width(void);
	int	data_width(void);
	void	add(void);
	PERIPH *add(PERIPHP p);
	PERIPH *add(MAPDHASH *phash);
	PLIST	*create_sio(void);
	PLIST	*create_dio(void);

	void	post_countsio(void);
	void	countsio(MAPDHASH *phash);

	bool	need_translator(BUSINFO *b);
	void	writeout_slave_defn_v(FILE *fp, const char *name, const char *errwire = NULL, const char *btyp="");
	void	writeout_bus_slave_defns_v(FILE *fp);
	void	writeout_bus_master_defns_v(FILE *fp);
	void	writeout_bus_defns_v(FILE *fp);
	void	writeout_bus_select_v(FILE *fp);
	void	writeout_bus_logic_v(FILE *fp);

	void	writeout_no_slave_v(FILE *fp, STRINGP prefix);
	void	writeout_no_master_v(FILE *fp);
	bool	ismember_of(MAPDHASH *phash);

	PERIPHP operator[](unsigned i);
	unsigned size(void);
	void	init(MAPDHASH *phash, MAPDHASH *bp);
	void	integrity_check(void);
};

class	BUSLIST : public std::vector<BUSINFO *>	{
public:
	BUSINFO *find_bus(STRINGP name);
	BUSINFO *find_bus(MAPDHASH *hash);
	unsigned	get_base_address(MAPDHASH *phash);
	void	addperipheral(MAPDHASH *phash);
	void	addperipheral(MAPT &map);

	void	adddefault(MAPDHASH &master, STRINGP defname);

	BUSINFO *addbus_aux(MAPDHASH *phash, STRINGP pname, MAPDHASH *bp);
	void	addbus(MAPDHASH *phash);
	void	addbus(MAPT &map);
	void	countsio(MAPDHASH *phash);
	void	countsio(MAPT &map);
	BUSINFO *find_bus_of_peripheral(MAPDHASH *phash);
};

extern	void	build_bus_list(MAPDHASH &master);
extern	BUSINFO *find_bus_of_peripheral(MAPDHASH *phash);
extern	BUSINFO *find_bus(MAPDHASH *hash);
extern	BUSINFO *find_bus(STRINGP name);
extern	bool	need_translator(BUSINFO *a, BUSINFO *b);
extern	void	writeout_bus_defns_v(FILE *fp);
extern	void	writeout_bus_select_v(FILE *fp);
extern	void	writeout_bus_logic_v(FILE *fp);

#endif	// BUSINFO_H
