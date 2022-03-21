TITLE Question A

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data
msg1 BYTE "Please enter a low number: ",0									; first statement
msg2 BYTE "Please enter a high number: ",0									; second statement
msg3 BYTE "Random numbers in range: ",0									    ; third statement
spaceStr BYTE " ",0															; an empty space as a string

; Code Section
.code 
main PROC	
	mov edx, OFFSET msg1													; move into edx the offset of msg1
	call WriteString														; write the string
	call ReadInt															; read in a signed integer
	mov ebx, eax															; move into ebx the int in eax, low stores in ebx

	mov edx, OFFSET msg2													; move into edx the offset of msg2
	call WriteString														; write the string
	call ReadInt															; read in a signed integer
												
	mov edx, OFFSET msg3													; move into edx the offset of msg3
	call WriteString														; write the string

	call BetterRandomRange													; call the randomNum procedure
	exit
main ENDP


BetterRandomRange PROC
; ------------------------------------------------
; This is a procedure that will use a low and high
; specified by the user and return a random number
; in the range.
; x = (int)(Math.random * (high - low + 1)) + low
; ------------------------------------------------ 
	mov ecx, 10															        ; move to ecx 10 to loop 10 times
	call Randomize																; set the seed
	L1:
		push eax																; preserve original value of eax and push onto the stack
		push ebx																; preserve original value of ebx and push onto the stack

		sub eax, ebx															; sub from eax(high), ebx(low)
		inc eax																	; increment eax (+1)
		call RandomRange													    ; RandomRange function
		add eax, ebx															; adds ebx to eax 
		call WriteInt															; write the value in eax
		
		mov edx, OFFSET spaceStr												; move into edx the offset of the space string
		call WriteString														; write the string in edx

		pop ebx																	; pop value off the stack
		pop eax																	; pop value off the stack
	loop L1																		; call loop
	
	call Crlf																	; line feed
	ret 
BetterRandomRange ENDP
END main