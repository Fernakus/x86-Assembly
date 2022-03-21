TITLE questionB

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data 
userString BYTE 40 DUP(?)							; a string the user enters
inputMsg BYTE "Enter a string: ",0					; inputMsg string

lowRange BYTE 0d									; a lowRange int
highRange BYTE 15d									; a highRange int
foreground BYTE ?									; one generated random number
background BYTE ?									; one generated random number
row BYTE ?			    							; row variable set to ?
col BYTE ? 											; col variable set to ?

; Code Section
.code
main PROC
	mov edx, OFFSET inputMsg						; move the offset of string int edx
	call WriteString								; write the string

	mov ecx, LENGTHOF userString					; move the lengthof the userString var into ecx
	mov edx, OFFSET userString						; move into the offset of the userString
	call ReadString									; read in the string the user enters

	movzx eax, highRange							; move into eax the highRange
	movzx ebx, lowRange								; move into ebx the lowRange
	call BetterRandomRange							; call BetterRandomRange procedure
	mov foreground, al								; move into the foreground var the random number in al

	movzx eax, highRange							; move into eax the highRange
	movzx ebx, lowRange								; move into ebx the lowRange
	call BetterRandomRange							; call BetterRandomRange procedure
	mov background, al								; move into the foreground var the random number in al

	call Clrscr										; clear the screen

	mov ecx, 300									; set to loop 300 times
	call foregroundPart								; call our foregroundPart method

	call backgroundPart								; call our backgroundPart method

	call Crlf										; line feed
	exit
main ENDP

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BetterRandomRange PROC
; ------------------------------------------------
; This is a procedure that will use a low and high
; specified by the user and return a random number
; in the range.
; x = (int)(Math.random * (high - low + 1)) + low
; ------------------------------------------------ 
	call Randomize															; set the seed
	
	sub eax, ebx															; sub from eax(high), ebx(low)
	inc eax																	; increment eax (+1)
	call RandomRange													    ; RandomRange function
	add eax, ebx															; adds ebx to eax 
	
	call Crlf																; line feed
	ret 
BetterRandomRange ENDP

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
foregroundPart PROC USES ecx eax ebx
; ------------------------------------------------
; This is a procedure that will will print the 
; foreground part of the solution. Ends the loop
; when the foreground number is 0
; ------------------------------------------------
	mov BYTE PTR row, 5d							; set row to 5 intially
	mov BYTE PTR col, 5d							; set col to 5 initially

firstLoop:
	cmp foreground, 0d								; if foreground color = 0
	jz done											; jumps to done if ZF is set

	mov dh, row										; move to dh the row
	mov dl, col										; move to dl the col
	call Gotoxy										; call irvine proc

	movzx eax, foreground							; move into eax our lowRange
	movzx ebx, background							; move into ebx our highRange
	add eax, ebx									; combine our random color
	call SetTextColor								; set the color

	mov edx, OFFSET userString						; move the offset of our userString into edx
	call WriteString								; write the string

	inc foreground									; advances foreground

	mov eax, 50										; move in 50 milliseconds
	call Delay										; call delay
Loop firstLoop
done:
	ret 
foregroundPart ENDP
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
backgroundPart PROC USES ecx eax ebx
; ------------------------------------------------
; This is a procedure that will print the 
; background part of the solution. Ends the loop
; when ecx = 0
; ------------------------------------------------
secondLoop:
	dec background									; decrements background color
	inc row											; advacne row value
	cmp row, 25d									; compare row to 25d
	je reset										; jump if equal to reset

	mov dh, row										; move to dh the row
	mov dl, col										; move to dl the col
	call Gotoxy										; call irvine proc

	movzx eax, foreground							; move into eax our lowRange
	movzx ebx, background							; move into ebx our highRange
	add eax, ebx									; combine our random color
	call SetTextColor								; set the color

	mov edx, OFFSET userString						; move the offset of our userString into edx
	call WriteString								; write the string

	mov eax, 50										; move in 50 milliseconds
	call Delay										; call delay

reset:
	mov BYTE PTR row, 5d							; reset row to 5
	inc col											; increment column value
Loop secondLoop										
	ret 
backgroundPart ENDP
END main