TITLE questionA.asm
; Finds the surface area & volume for a Icosahedron
; By: Matthew Ferlaino
; Date: Nov, 25th
; Student #: 169657520
; Course: C0SC2406

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section -----------------------------------------------------------------------------------------------------------------------------------------------------------------
.data
errorMsg BYTE "Error, no negative lengths allowed!",0					; error message for neg numbers
inputMsg BYTE "Enter in a value for length[0 to exit]: ",0				; input message to take in a length value
goodbyeMsg BYTE "Goodbye!!",0											; goodbye message

saMsg BYTE "The SURFACE AREA of a Icosahedron with length (",0			; message used for formatting output
saMsg1 BYTE ") is: ",0													; message used for formatting output
vMsg BYTE "The VOLUME of a Icosahedron with length (",0					; message used for formatting output
vMsg1 BYTE ") is: ",0													; message used for formatting output

len REAL4 ?																; declare our len as a REAL4 (DWORD Float)
surfaceArea REAL4 ?														; surface area variable as a REAL4 (DWORD Float)
volume REAL4 ?															; volume variable as a REAL4 (DWORD Float)

threeVal REAL4 3.0														; a variable of REAL4 type to be loaded onto the FPU stack, used for formula caluclation
fiveVal REAL4 5.0														; a variable of REAL4 type to be loaded onto the FPU stack, used for formula caluclation
twelveVal REAL4 12.0													; a variable of REAL4 type to be loaded onto the FPU stack, used for formula caluclation

; Code Section -----------------------------------------------------------------------------------------------------------------------------------------------------------------
.code
main PROC
Start:
	FINIT																; initialize the FPU stack

	mov edx, OFFSET inputMsg											; moves offset of string into edx
	call WriteString													; write the string in edx
	call ReadFloat														; read in the decimal value 

	fst len																; store the decimal value into our len variable
	fldz																; loads onto the stack a 0, used for stack comparisons

	; Conditional Processing
	fcomi ST(0), ST(1) 													; compares st(0) and st(1)
	je Done																; jump to done if ST(0) == ST(1) (if var == 0)
	ja NegNum															; jump to NegNum if ST(0) > ST(1) meaning ST(1) is negative

Calculate:
; Calculating Surface Area Here -----------------------------------------------------------------------------------
	call surfaceAreaCalc												; call the surfaceAreaCalc procedure 

	mov edx, OFFSET saMsg												; move into edx our message
	call WriteString													; write the string

	fld len																; load length onto the stack
	call WriteFloat														; write the float 

	mov edx, OFFSET saMsg1												; move into edx our message 
	call WriteString													; write the string

	fstp ST(0)															; pop off ST(0) from the stack 

	call WriteFloat														; write the float at ST(0)

	fstp ST(0)															; pop off ST(0) from the stack
	
	call Crlf															; line feed

; Calculating Volume Here -----------------------------------------------------------------------------------------
	fld len																; load len onto the FPU stack

	call volumeCalc														; call the volumeCalc procedure

	mov edx, OFFSET vMsg												; move into edx our message
	call WriteString													; write the string

	fld len																; load length onto the stack
	call WriteFloat														; write the float 

	mov edx, OFFSET vMsg1												; move into edx our message 
	call WriteString													; write the string

	fstp ST(0)															; pop off ST(0) from the stack which is len we loaded above

	call WriteFloat														; write the float at ST(0)

	fstp ST(0)															; pop off ST(0) from the stack to make the stack empty

	call Crlf															; line feed
	call Crlf															; line feed
	jmp Start															; jump to the start to loop

NegNum:
	mov edx, OFFSET errorMsg											; moves offset of string into edx
	call WriteString													; write the string
	call Crlf															; line feed
	call Crlf															; line feed

	fstp ST(0)															; pop off ST(0) from the stack == 0
	fstp ST(0)															; pop off ST(0) from the stack == length user entered
	jmp Start															; jump to the start to loop
Done:
	mov edx, OFFSET goodbyeMsg											; moves offset of string into edx
	call WriteString													; write the string
	call Crlf															; line feed
	exit
main ENDP


; ------------------------------------------------------------------
surfaceAreaCalc PROC
; This procedure will calculate the  surface area of a Icosahedron
;
; Receives: the FPU stack
; Returns: surface area on the FPU stack at ST(0)
; ------------------------------------------------------------------
	fstp ST(0)															; pop ST(0) off the stack = 0
	fmul ST(0), ST(0)													; multiply ST(0) by itself, ST(0) hold our length, so its equivalent to len^2

	fld threeVal														; load 3.0 onto the the FPU stack ST(0)
	fsqrt																; will square root the top of the stack (3.0)

	fld fiveVal															; load 5.0 onto the FPU stack ST(0)
	fmul ST(0), ST(1)													; multiply ST(0) by ST(1) == 5.0 * SQRT(3.0)

	fstp ST(1)															; pop ST(1) off the stack
	fmul ST(0), ST(1)													; multiply ST(0) by ST(1) == (5.0 * SQRT(3.0)) * len^2

	fstp ST(1)															; pop ST(1) off the 
	ret
surfaceAreaCalc ENDP

; ------------------------------------------------------------------
volumeCalc PROC
; This procedure will calculate the volume of a Icosahedron
;
; Receives: the FPU stack
; Returns: volume on the FPU stack at ST(0)
; ------------------------------------------------------------------
	fldz																; load a zero ST(0)
	fadd ST(0), ST(1)													; add to ST(0) = 0, ST(1) = len 
	fmul ST(0), ST(1)													; multiply ST(0) by ST(1) which == len^2
	fmul ST(0), ST(1)													; multiply ST(0) by ST(1) which == len^3
	
	fstp ST(1)															; pop ST(1) off the stack which contains our len variable
	
	fld threeVal														; load 3.0 at ST(1)
	fld fiveVal															; load 5.0 at ST(0)

	
	fsqrt																; st(0) which is SQRT(5.0)
	fadd ST(0), ST(1)													; adds SQRT(5.0) + 3.0

	fstp ST(1)															; pop ST(1) from the stack, aka remove 3.0 

	fld twelveVal														; loads 12.0 at ST(1)
	fld fiveVal															; loads 5.0 at ST(0)

	fdiv ST(0), ST(1)													; divides 5/12 or ST(0) = 5 / ST(1) = 12.0

	fstp ST(1)															; pop ST(1) from the stack aka remove the 12.0

	; Stack should now contain:
	; ST(0) = result of 5/12
	; ST(1) = result of (3 + SQRT(5))
	; ST(2) = result of len^3

	fmul ST(0), ST(1)													; multiplies ST(0) by ST(1) == (5/12) * (3 + SQRT(5))
	fstp ST(1)															; pop ST(1) which contains result of (3 + SQRT(5))

	fmul ST(0), ST(1)													; mulitplies ST(0) by ST(1) == ((5/12) * (3 + SQRT(5))) * len^2
	fstp ST(1)															; pop ST(1) which contains result of len^2 

	ret
volumeCalc ENDP
END main