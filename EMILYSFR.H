/*
 * Include file for programming EMILY SFR emulation code using the
 * DDS Micro-C/PC compiler.
 *
 * A free version of Micro-C/PC and other tools that you can use to
 * develop SFR emulation code is is available from our web site:
 *		http://www.dunfield.com
 *
 * Copyright 1998-2005 Dave Dunfield
 * All rights reserved.
 */
#define	LINE_SIZE	80		/* Max size of eprintf() output line */

/*
 * Resources available from the SFRMCRUN startup library
 */
int		egetc();				// Read character from EMILY
void	eputc(char c);			// Write character to EMILY
void 	ebreak();				// Set EMILY abort flag
extern unsigned	Eseg;			// EMILY segment
extern unsigned Edata;			// EMILY data table offset

/*
 * Write a string to the EMILY debug window
 */
eputs(char *s)
{
	while(*s)
		eputc(*s++);
}

/*
 * Formatted print to EMILY debug window
 */
register eprintf(args)
	unsigned args;
{
	char buffer[LINE_SIZE+1];
	unsigned l;

	l = _format_(nargs() * 2 + &args, buffer);
	eputs(buffer);
	return l;
}

/*
 * 8051/52 SFR's
 */
#define	P0		0x80
#define	P1		0x90
#define	P2		0xA0
#define	P3		0xB0
#define	IP		0xB8
#define	IE		0xA8
#define	TMOD	0x89
#define	TCON	0x88
#define	TH0		0x8C
#define	TL0		0x8A
#define	TH1		0x8D
#define	TL1		0x8B
#define	TH2		0xCD
#define	TL2		0xCC
#define	T2CON	0xC8
#define	SCON	0x98
#define	SBUF	0x99
#define	PCON	0x87
#define	RCAP2H	0xCB
#define	RCAP2L	0xCA
//DEMO installed August 24, 2016 (Not to be used after 30 days).
