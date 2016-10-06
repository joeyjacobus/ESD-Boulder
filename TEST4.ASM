*
* EMILY320 test program - copy memory via dual data pointers
*
	ORG	$0800
*
	MOV	DPS,#0		Start with DTPR #0
	MOV	DPTR,#1000h	Copy from 1000
	INC	DPS		Switch to DPTR #1
	MOV	DPTR,#2000h	Copy to 2000
	MOV	R0,#0		Copy 256 bytes
loop	INC	DPS		Switch to DPTR #0
	MOVX	A,@DPTR		Get a byte from source
	INC	DPTR		Advance to next
	INC	DPS		Switch to DPTR #1
	MOVX	[DPTR],A	Write byte to dest
	INC	DPTR		Advance to next
	DJNZ	R0,loop		Do them all
* All done, halt processing
	SJMP	*		Freeze processing
*DEMO installed August 24, 2016 (Not to be used after 30 days).
