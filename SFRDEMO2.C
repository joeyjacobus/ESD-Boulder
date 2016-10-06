/*
 * Demonstration SFR emulation code using Micro-C/PC
 *
 * To compile & run:
 *	 CC sfrdemo2 -fmop      <- Compile to object module SFRDEMO2.OBJ
 *      (For Micro-C/PC versions 3.14 and earlier, use options: -flop)
 *	 SFRL sfrdemo2          <- Link with SFRMCRUN.OBJ to make SFRDEMO2.SFR
 *	 EMILY52 s=sfrdemo2.sfr <- Execute EMILY52 and load SFRDEMO2.SFR
 *
 * You should be careful about using Micro-C library functions which perform
 * system services, as they may affect the host EMILY52 program. As a general
 * rule, limit your use of library functions to a minimum.
 *
 * Note that the stdin, stdout, stderr, ARGC, ARGV, PSP and ENV global 
 * variables normally set by the Micro-C/PC startup code are not available.
 *
 * The sfr_init(), sfr_read(), and sfr_write() functions **MUST** return,
 * DO NOT use exit(), abort() etc. as these will terminate EMILY52!
 *
 * A free version of Micro-C/PC and other tools that you can use to
 * develop SFR emulation code is is available from our web site:
 *		http://www.dunfield.com
 */
#include "emilysfr.h"			/* Required definitions */

/* Holding buffer for SFRs - only addresses 0x80-0xFF are actually used */
unsigned char sfr[256];

show_sfr(unsigned sfr)
{
	int i;
	static unsigned char sfr_addr[] = {				/* SFR addresses */
		0x80, 0x90, 0xa0, 0xb0, 0xb8, 0xa8,
		0x89, 0x88, 0x8c, 0x8a, 0x8d, 0x8b, 0xcd, 0xcc, 0xc8,
		0x98, 0x99, 0x87, 0xcb, 0xca,
		0xe0, 0xf0, 0xd0, 0x81, 0x83, 0x82 };		/* Should never occur */
	static char *sfr_name[] = {						/* SFR names */
		"P0", "P1", "P2", "P3", "IP", "IE",
		"TMOD", "TCON", "TH0", "TL0", "TH1", "TL1", "TH2", "TL2", "T2CON",
		"SCON", "SBUF", "PCON", "RCAP2H", "RCAP2L",
		"A", "B", "PSW", "SP", "DPH", "DPL" };		/* Should never occur */

	/* Lookup SFR name, display if found */
	for(i=0; i < sizeof(sfr_addr); ++i) {
		if(sfr_addr[i] == sfr) {
			eprintf("%s(%02x)", sfr_name[i], sfr);
			return; } }
	eprintf("???(%02x)", sfr);
}

/*
 * Get HEX number from EMILY console
 */
get_hex(unsigned x)
{
	int c;
	unsigned v;

	eputs(" ? ");
	for(;;) {
		eprintf("%02x\b\b", v = x & 255);
		if(!(c = egetc()))		// No console I/O (manual mode)
			return v;
		if(c == 0x1B)			// Abort key
			return v;
		if(c == '\n') {			// Accept data & proceed
			eprintf("\b\b= %02x", v);
			return v; }
		if(c == 0xFF8C) {		// Backspace, delete last digit
			x >>= 4;
			continue; }
		if(isdigit(c))
			c -= '0';
		else if(isxdigit(c))
			c = toupper(c) - ('A'-10);
		else {
			eputc(7);
			continue; }
		x = (x << 4) + c; }
}

/*
 * This function is called only once when the SFR module is loaded.
 * Use it to perform any initialization that you require. There are
 * no parameters passed to this function.
 */
sfr_init()
{
	eprintf("\nSFR emulation: Manual entry");
	sfr[P0] = sfr[P1] = sfr[P2] = sfr[P3] = 0xff;
}

/*
 * This function is called to read an SFR. The single parameter passed
 * is the SFR address (0x80 - 0xFF). A value in the range of 0x00 - 0xFF
 * should be returned as the read value. To indicate that a particular
 * SFR is not implemented, return -1.
 */
sfr_read(unsigned addr)
{
	switch(addr) {			// SFR's to pass on to EMILY
		case SCON :
		case SBUF :
			return -1; }	// Indicate not implemented

	eputs("\nRead  ");
	show_sfr(addr);
	return sfr[addr] = get_hex(sfr[addr]);
}

/*
 * This function is called to write an SFR. The address and value to
 * write are passed. Return 0 on success. To indicate that a particular
 * SFR is not implemented, return a value of -1.
 */
sfr_write(unsigned addr, unsigned value)
{
	switch(addr) {			// SFR's to pass on to EMILY
		case SCON :
		case SBUF :
			return -1; }	// Indicate not implemented

	eputs("\nWrite ");
	show_sfr(addr);
	eprintf(" = %02x", sfr[addr] = value);
	return 0;
}
//DEMO installed August 24, 2016 (Not to be used after 30 days).
