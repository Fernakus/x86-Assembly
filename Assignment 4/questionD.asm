TITLE Question D

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data
filename BYTE 20 DUP(?)														; name of the file we want to open
buffer BYTE 20 DUP(?)														; our buffer which is size 20
bytesRead BYTE ?
	
msg1 BYTE "Data from file: ",0												; msg1 as a string
msg2 BYTE "Enter in a filename: ",0											; msg2 as a string

; Code Section
.code 
main PROC
	mov ecx, LENGTHOF filename												; determines size of text we will read in
	
	mov edx, OFFSET msg2													; move offset of msg2 into edx
	call WriteString														; write the string

	mov edx, OFFSET filename												; move the offset of filename into edx
	call ReadString															; read the string in
	call OpenInputFile														; opens the input file

	mov edx, OFFSET buffer													; move to edx the offset of buffer
	mov ecx, LENGTHOF buffer												; move into ecx the size of buffer
	call ReadFromFile														; call read from file

	mov ecx, LENGTHOF bytesRead												; move int ecx the lengthof bytesRead
	mov esi, OFFSET buffer													; move into esi the offset of buffer
	mov edx, OFFSET buffer													; move into edx the offset of buffer

	L1:
		push ecx															; preserve ecx
		mov ecx, LENGTHOF buffer											; move into ecx the lengthof buffer

		L2:
			push eax														; preserve eax
			call WriteChar													; write the char

			mov eax, 250													; move to eax 250
			call Delay														; call delay

			add esi, TYPE buffer											; increments esi
			pop eax															; restore eax
		loop L2

		AND eax, eax														; and eax with itself
		JZ done																; if zero flag is set jump to done
		pop ecx																; restore eax
	loop L1																	; call loop
done:
	exit
main ENDP
END main