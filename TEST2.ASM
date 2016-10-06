*
* EMILY test program: Write message to the serial port
*
	ORG	$0800
BEGIN	MOV	DPTR,#MESSAGE	Point to message
WRCHR	CLR	A		Zero ACC
	MOVC	A,[A+DPTR]	Get value from string
	JZ	BEGIN		End of string, repeat
	JNB	SCON.1,*	Wait for TX ready
	MOV	SBUF,A		Write out char
	CLR	SCON.1		Indicte we are sending
	INC	DPTR		Advance pointer
	SJMP	WRCHR		And keep going
MESSAGE	STR	'This is a test of the EMILY serial operation.'
	DB	$0A,$0D,0
*DEMO installed August 24, 2016 (Not to be used after 30 days).
