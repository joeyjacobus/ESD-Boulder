*
* EMILY test program: Step through & increment local memory
*
	ORG	$0800
BEGIN	MOV	R0,#0		Begin at bottom of internal RAM
	CLR	A		Zero initial value
LOOP1	MOV	[R0],A		Write to internal RAM
	INC	A		Advance value
	INC	R0		Advance register
	SJMP	LOOP1		And continue
*DEMO installed August 24, 2016 (Not to be used after 30 days).
