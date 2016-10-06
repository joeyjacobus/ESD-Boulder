*
* EMILY test program: Init data memory with value in A
*
* Use the 'C'hange register command to set the initial value in A
*
	ORG	$0800
BEGIN	MOV	DPTR,#0		Begin at zero
	MOV	R2,#0		Low counter
	MOV	R3,#0		High counter
WRMEM	MOVX	[DPTR],A	Write the value
	INC	DPTR		Advance
	DJNZ	R2,WRMEM	Loop 256 times
	DJNZ	R3,WRMEM	LOOP 256*256 times
* Insert the ILLEGAL opcode to halt the simulation
	DB	$A5		Halt emily
*DEMO installed August 24, 2016 (Not to be used after 30 days).
