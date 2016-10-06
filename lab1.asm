*
* EMILY Lab 1 Joey Jacobus
* 
* This program shall calculate the following equation using integer division: Z = ((X+2)/Y)*4
* In this assignment, X, Y, and Z are unsigned 8-bit values.
* Example: If X=0x1C and Y=0x07, then Z=0x10. (28+2 = 30 and 30 div 7 = 4 and 4*4 = 16) 
*
* Preconditions:
*  Accumulator contains the dividend X.
*  B register contains the divisor Y. 
* Post Conditions:
*	Internal data memory (IRAM) location 0x20 contains the value of (X+2)
* 	IRAM location 0x21 contains the 8-bit quotient of (X+2)/Y (in hexadecimal)
* 	IRAM location 0x22 contains the 8-bit remainder of (X+2)/Y (in hexadecimal)
*	IRAM location 0x23 contains the 8-bit result Z (in hexadecimal)
* 	IRAM location 0x30 contains the error code. 
* Other requirements:
*	This program must implement an algorithm that does not use the 8051 divide (DIV) or
* multiply (MUL) instructions.
* Use an 8051 shift/rotate instruction to implement the multiplication.
* The program must start at address 0000h.
* When the calculation is complete, the program jumps to a label named 'ENDLOOP' and
* enters an infinite loop.
* Error handling:
* If no error occurs during program execution, the program shall write a ‘0x00 into the error
*	code in internal memory.
* If the calculation exceeds an 8-bit value when adding, then the program shall write a ‘0x01’
*	into the error code in internal memory and then immediately jump to ‘ENDLOOP’ without
*	performing any calculations
* If the divisor is 0, then the program shall write a ‘0x02’ into the error code in internal
*	memory and then immediately jump to ‘ENDLOOP’ without performing any calculations.
* If the calculation exceeds an 8-bit value when multiplying, then the program shall leave the
*	least significant 8 bits of the result in Z and shall write a ‘0x03’ into the error code in internal
*	memory


	ORG	$0000
BEGIN	
	*Check if Y == 0
	MOV R0,B
	CJNE R0,#0H,DO_ADD
	AJMP ZERO

DO_ADD
	ADD A,#2 			(x+2)
	MOV R0,#20H
	MOV [R0],A 			Store X+2 at 0x20

	* Check for overflow
	JNC	DIVIDE		Jump if carry==0
	AJMP OVERFLOW   Jump to error

*Divide A / B     A = X+2  B = Y 
DIVIDE
	MOV R0,#0
DIV_LOOP 
	MOV R1,A 	*Store possible remainder in R1
	SUBB A,B
	INC R0
	JZ DIV_EVENLY	
	JNC DIV_LOOP
	DEC R0
	AJMP DIV_DONE

DIV_EVENLY
	MOV R1,#0 	*Set remainder to zero if evenly divided

DIV_DONE
	MOV A,R0
	MOV B,R1

	* Write result of divide and remainder to 0x21 and 0x22 respectively
	MOV R0,#21H
	MOV R1,#22H
	MOV [R0],A
	MOV [R1],B

*Multiply  by 4 and check for overflow
	
	CLR C
	RLC A
	JNC ROTATE

	*Overflow  occurred on first shift
	MOV R0,#30H
	MOV [R0],#3H
	AJMP RESULT
ROTATE
	CLR C
	RLC A
	JNC NO_ERROR 

	* Over flow occurred on second shift
	MOV R0,#30H
	MOV [R0],#3H
	AJMP RESULT

NO_ERROR
	MOV R0,#30H
	MOV [R0],#0H

* Put the result in memory 0x23
RESULT
	MOV R0,#23H
	MOV [R0],A

	AJMP ENDLOOP

OVERFLOW
	MOV R0,#30H
	MOV [R0],#1H
	AJMP ENDLOOP

ZERO
	*ERROR Divide by Zero
	MOV R0,#30H
	MOV [R0],#2H
ENDLOOP
	AJMP ENDLOOP
