;
; Sample ASM program for EMILY SFR emulation
; Invert bits of all SFR's written
;
; Assemble with: ASM sfrdemo1;
; Link     with: VAL/sys sfrdemo1,sfrdemo1.sfr;
; Run      with: EMILY52 s=sfrdemo1.sfr
;
CSEG	SEGMENT BYTE PUBLIC 'CODE'
	ASSUME CS:CSEG, DS:CSEG, SS:CSEG
begin:	ORG	0h
; Read function is at offset 0000
	JMP	read
	ORG	5h
; Write function is at offset 0005
	JMP	write
	ORG	0ah
; Initialize function is at offset 000A
init:	MOV	eseg,AX			; Save EMILY segment
	MOV	output,DI		; Save EMILY output
	DB	0CBh			; RETF
; Read contents of SFR
read:	MOV	BX,AX			; Get address into index
	MOV	AL,sfrs[BX]		; Read content of SFR
	PUSH	AX			; Save result
	MOV	AL,'R'			; Indicate READ
	CALL	debug			; Output
	POP	AX			; Restore result
	DB	0CBh			; RETF
; Write to SFR but invert bits
write:	NOT	AL			; Invert bits of data value
	MOV	sfrs[BX],AL		; Write to SFR
	MOV	AL,'W'			; Indicate write
	CALL	debug			; Output
	DB	0CBh			; RETF
; Write character in AL to emily debug window
debug:	PUSH	eseg			; Save output segment
	PUSH	output			; Save output offset
	DB	0CBh			; RETF
; Table to hold SFR values by direct address
eseg	DW	0			; EMILY segment
output	DW	0			; Output function
sfrs	DB	256 dup(0)
;
CSEG	ENDS
	END	begin
*DEMO installed August 24, 2016 (Not to be used after 30 days).
