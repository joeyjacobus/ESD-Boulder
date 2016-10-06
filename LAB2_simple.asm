*
* Lab 2 simple test program for testing EPROM fetches
* 


	ORG	$0000

Start AJMP CBIT

	ORG $0040
CBIT 
	NOP
	CPL P1.3
	NOP
	AJMP Start
