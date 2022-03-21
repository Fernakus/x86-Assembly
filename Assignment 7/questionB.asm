TITLE questionB.asm
; Takes in 5 values from a user and calculates the following:
; 1. ((A-B) * C) / ((D + C) - E)
; 2. (D+E) / SQRT(A*(B-C))
; 3. SQRT(E*A) / (B/D - C)^2
; By: Matthew Ferlaino
; Date: Nov, 25th
; Student #: 169657520
; Course: C0SC2406

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section -----------------------------------------------------------------------------------------------------------------------------------------------------------------
.data
msgA BYTE "Enter in a value for A: ",0													; string for collecting user input 
msgB BYTE "Enter in a value for B: ",0													; string for collecting user input
msgC BYTE "Enter in a value for C: ",0													; string for collecting user input
msgD BYTE "Enter in a value for D: ",0													; string for collecting user input
msgE BYTE "Enter in a value for E: ",0													; string for collecting user input

valA REAL4 ?																			; variable for A
valB REAL4 ?																			; variable for B
valC REAL4 ?																			; variable for C
valD REAL4 ?																			; variable for D
valE REAL4 ?																			; variable for E
temp REAL4 ?																			; variable for temp

outputA BYTE "((A-B) * C) / ((D+C) - E) = ",0											; output for soln1
outputB BYTE "(D+E) / SQRT(A*(B-C))) = ",0												; output for soln2
outputC BYTE "SQRT(E*A) / (B/D - C)^2) = ",0											; output for soln3

; Code Section -----------------------------------------------------------------------------------------------------------------------------------------------------------------
.code
main PROC
	FINIT																				; initialize the FPU stack

	mov edx, OFFSET msgA																; move msgA offset into edx
	call WriteString																	; write the string
	call ReadFloat																		; read in a float
	fst valA																			; valA = user input --> ST(4)
	fstp ST(0)																			; pop valA

	mov edx, OFFSET msgB																; move msgB offset into edx
	call WriteString																	; write the string
	call ReadFloat																		; read in a float
	fst valB																			; valB = user input --> ST(3)
	fstp ST(0)																			; pop valB

	mov edx, OFFSET msgC																; move msgC offset into edx
	call WriteString																	; write the string
	call ReadFloat																		; read in a float
	fst valC																			; valC = user input --> ST(2)
	fstp ST(0)																			; pop valC

	mov edx, OFFSET msgD																; move msgD offset into edx
	call WriteString																	; write the string
	call ReadFloat																		; read in a float
	fst valD																			; valD = user input --> ST(1)
	fstp ST(0)																			; pop valD

	mov edx, OFFSET msgE																; move msgE offset into edx
	call WriteString																	; write the string
	call ReadFloat																		; read in a float
	fst valE																			; valE = user input --> ST(0)
	fstp ST(0)																			; pop valE

	call Crlf																			; line feed
	; -------- ((A-B) * C) / ((D + C) - E) -------------------------------------------------------------------------------------------
	fld valA																			; ST(0) --> valA
	call equationA																		; calls equationA procedure with ST(0) --> valAs
	
	mov edx, OFFSET outputA																; put the offset of string into edx
	call WriteString																	; write the string
	call WriteFloat																		; write solution from ST(0)

	fstp ST(0)																			; remove ST(0)
	call Crlf																			; line feed
	; -------- (D+E) / SQRT(A*(B-C))) -----------------------------------------------------------------------------------------------
	fld valB																			; ST(0) --> B
	call equationB																		; calls equationB procedure with above elements on the FPU Stack

	mov edx, OFFSET outputB																; put the offset of strng into edx
	call WriteString																	; write the string
	call WriteFloat																		; write solution from ST(0)

	fstp ST(0)																			; remove ST(0)
	fstp ST(0)																			; remove ST(0)

	call Crlf																			; line feed

	; -------- SQRT(E*A) / (B/D - C)^2 -----------------------------------------------------------------------------------------------
	; Pushing all values onto the FPU stack
	fld valC																			; ST(4) --> valC
	fld valD																			; ST(3) --> valD
	fld valB																			; ST(2) --> valB
	fld valA																			; ST(1) --> valA
	fld valE																			; ST(0) --> valE

	call equationC																		; calls equationB procedure with above elements on the FPU Stack

	mov edx, OFFSET outputC																; put the offset of strng into edx
	call WriteString																	; write the string
	call WriteFloat																		; write solution from ST(0)
	call Crlf																			; line feed

	call WriteString																	; write the string
	mov eax, temp
	call WriteInt

	call Crlf																			; line feed
	exit
main ENDP


; ------------------------------------------------------------------
equationA PROC
; Solves ((A-B) * C) / ((D + C) - E)
;
; Receives: FPU stack
; Returns: solution for ((A-B) * C) / ((D + C) - E)
; ------------------------------------------------------------------
	; Solving for (A-B) *C
	fsub valB  																		; ST(0) = A-B
	fmul valC																		; ST(0) = (A-B) * C

	; Solving for (D+C) - E
	fld valD																		; ST(0) = valD
	fadd valC																		; ST(0) = (D+C)
	fsub valE																		; ST(0) = (D+C) - E

	; Solve for full solution
	fdivp ST(1), ST(0)																; ST(0) = ((A-B) * C) / ((D + C) - E)

	ret
equationA ENDP

; ------------------------------------------------------------------
equationB PROC
; Solves (D+E) / SQRT(A*(B-C)))
;
; Receives: FPU Stack
; Returns: solution for (D+E) / SQRT(A*(B-C)))
; ------------------------------------------------------------------
	; Solving for SQRT(A*(B-C))
	fsub valC																		; ST(0) = B - C
	fmul valA																		; ST(0) = (B-C) * A
	fsqrt																			; ST(0) = SQRT(A*(B-C)))

	; Solving for (D+E)
	fld valD																		; ST(0) = valD
	fadd valE																		; ST(0) = D + E

	; Solve for full solution (D+E) / SQRT(A*(B-C)))
	fdiv ST(0), ST(1)																; ST(0) = (D+E) / SQRT(A*(B-C)))
	ret
equationB ENDP

; ------------------------------------------------------------------
equationC PROC
; Solves SQRT(E*A) / (B/D - C)^2)
;
; Receives: FPU Stack
; Returns: solution for SQRT(E*A) / (B/D - C)^2)
; ------------------------------------------------------------------
	; Solving for SQRT(E*A)
	fmul																			; ST(0) --> E*A
	fsqrt																			; ST(0) --> SQRT(E*A)
	fstp temp																		; store SQRT(E*A) in temp and pop ST(0)
	
	; Solving for (B/D - C)^2
	; B, D, C

	fdiv 																			; F(0) = B/D
	fsub ST(0), ST(1)																; F(0) = (B/D) - C
	fstp ST(1)																		; pop off ST(1) = C
	fmul ST(0), ST(0)																; ST(0) =  (B/D - C)^2)

	; Solve for full solution SQRT(E*A) / (B/D - C)^2)
	fld temp																		; load temp at ST(0)
	fdiv ST(0), ST(1)																; ST(0) = SQRT(E*A) / (B/D - C)^2)
	fstp ST(1)																		; pop ST(1) = (B/D - C)^2)
	
	ret
equationC ENDP
END main
