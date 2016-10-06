*
* EMILY Lab 3 Joey Jacobus
* 
* Tests output to serial monitor 

	ORG	$0000
	LJMP BEGIN



BEGIN
	* Setup interrupts, gpio output, RD as secondary function

	* VAlue = 256 - ((11.0592 * 10^6)/192)/BAUD
	MOV TH1,#253 		Auto-Reload value for timer 1
	MOV TH0,#253 		Load value into timer 1

	MOV TMOD,#20H    8 bit  auto-reload mode 2

	SETB TCON.6     TR1 start timer 1 
	* SETB PCON.7		We want to double baud rate. 


	* Configure P3.6 and P3.7 as secondary function /WR and /RD
	CLR P3.6
	SETB P3.6

	CLR P3.7
	SETB P3.7

	* Configure Serial port
	MOV SCON,#50H	Mode 1, 8 bit uart with timer 1 baud generator, Receive enable

	MOV R1,#056H	puts 'ascii value for U' in R1
	
	CLR SCON.1		Make sure TI clear to start
	CLR SCON.0 		MAke sure RI clear to start
	* MOV SBUF,R1

GET
	CLR SCON.0 			Clear RI bit
	JNB SCON.0,GET		Wait for receive
	MOV A,SBUF			Move received byte to Accumulator
	
	* START transmitting
	CLR SCON.1			Clear TI bit 

	MOV SBUF,A 			Write the byte back
TX	
	JNB SCON.1,TX		Check if TI is set, if not don't transmit
	AJMP GET


	