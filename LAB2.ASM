*
* EMILY Lab 2 Joey Jacobus
* 
* Uses Timer 0 configured to intterupt at 1.10 HZ (every 0..455seconds)
* Toggles an LED on port 1.3 every execution of the intterupt handler
* Also toggles port 1.4 on at the start of the ISR and off at the end of the ISR 

	ORG	$0000
	LJMP BEGIN

	ORG $000B
	LJMP ISR_Timer0


BEGIN
	* Setup interrupts, gpio output, RD as secondary function
	
	* Configure P3.6 and P3.7 as secondary function /WR and /RD
	CLR P3.6
	SETB P3.6

	CLR P3.7
	SETB P3.7

	MOV TH0,#033H	Load value for 1.10 Hz
	MOV TL0,#03DH 
	MOV TMOD,#01H     16 bit counter no reload

	MOV R0,#0H		R0 counts the number of ISR - need to toggle led every 8 isrs
	MOV R1,#080H 	A is the ISR latch counter
	MOV R2,#00H 	R2 is the main loop latch counter
	MOV DPTR,#0FFFH	Use the DPTR to write to a 16 bit address
	SETB IE.1 		ET0	Enable timer 0 interrupt
	SETB IE.7 		EA Enable global interrupts
	SETB TCON.4     TR0 start timer 0 

MAINLOOP
	INC R1
	MOV A,R1			Can only MOVX from accumulator
	MOVX [DPTR],A		Write debug value to latch
	CJNE R1,#0FFH,MAINLOOP	Check if R1==FF, set back to 0x80
	MOV R1,#080H	
	AJMP MAINLOOP	



* Timer 0 handler - toggle gpio
* Executes approx every 0.056875 seconds - *8 = desired 0.455 second toggle rate
ISR_TIMER0
	SETB P1.4 			Set debug  pin
	INC R2				Increment ISR counter
	MOV A,R2			Can only MOVX from accumulator
	MOVX [DPTR],A			Write debug value to latch
	CJNE R2,#080H,CONT	Check if R2==0x80, set back to 0x0
	MOV R2,#00H			Reset R2

CONT
	INC R0
	CJNE R0,#08H,RELOAD  If R0 != 8, don't toggle. 

* Toggle the LED every 8 ISRs 
LED
	CPL	P1.3 		Toggle LED Output on P1.3
	MOV R0,#0H		Restart ISR counter

* Reload Timer 0 values
RELOAD
	MOV TH0,#033H	Reload the timer value 
	MOV TL0,#03DH
	SETB TCON.4    TR0 start timer 0 


	CLR P1.4        Clear debug pin
	RETI

