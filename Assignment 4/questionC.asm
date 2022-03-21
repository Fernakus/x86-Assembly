TITLE Question C

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data
originalStr BYTE "ORIGINAL: ",0									; original string sentence 
upperStr BYTE "UPPERCASE: ",0									; uppercase string sentence															
lowerStr BYTE "LOWERCASE: ",0									; lowercase string sentence
statementStr BYTE "Enter a statement: ",0						; statement string

buffer BYTE 50 DUP(?)											; set a buffer that holds 50 bytes

; Code Section
.code 
main PROC
	mov ecx, LENGTHOF buffer									; specifies the max number of characters
	mov esi, OFFSET buffer										; move the offset of the buffer string into esi
	mov ebx, TYPE buffer										; move the type of buffer into ebx

	mov edx, OFFSET statementStr							    ; move the offset of the statementStr to edx
	call WriteString										    ; write the string
	
	mov edx, OFFSET buffer									    ; move the offset of the buffer into edx
	call ReadString											    ; read in the string the user enters
	mov ecx, eax

	mov edx, OFFSET originalStr									; move to edx the originalStr statement
	call WriteString											; write the string
	
	mov edx, OFFSET buffer										; move to edx the buffer string
	call WriteString											; write the string
	call Crlf													; line feed

	mov edx, OFFSET upperStr									; move to edx the offset of the upperStr 
	call WriteString											; write the string
	
	mov edx, OFFSET buffer									    ; move to edx the offset of the buffer string, will be passed to the PROC
	call ToUpperCase											; call the ToUpperCase procedure
	call WriteString											; write the string in edx
	call Crlf													; line feed

	mov edx, OFFSET lowerStr									; move to edx the offset of the lowerStr
	call WriteString											; write the string
	
	mov edx, OFFSET buffer									    ; move to edx the offset of the buffer string, will be passed to the PROC
	call ToLowerCase											; call the ToLowerCase procedure
	call WriteString											; write the string in edx
	call Crlf													; line feed
	exit
main ENDP
ToUpperCase PROC USES ecx esi
; ------------------------------------------------
; This is a procedure that turns a string to all 
; uppercase chars and then prints the string.
; ------------------------------------------------ 
	L1:
		cmp BYTE PTR [esi], 20h									; compare BYTE PTR [esi] to 20h(20h is space char)
		jbe next												; jump if below or equal to next
		AND BYTE PTR [esi], 11011111b							; clears the 5th bit
	next:														; next label
		add esi, ebx											; increments esi by adding ebx to it which is the type of buffer
	loop L1														; call the loop
	ret 
ToUpperCase ENDP

ToLowerCase PROC USES ecx esi
; ------------------------------------------------
; This is a procedure that turns a string to all 
; lowercase chars and then prints the string.
; ------------------------------------------------ 
	L2:
		OR BYTE PTR [esi], 00100000b							; clears the 5th bit
		add esi, ebx											; increments esi by adding ebx to it which is the type of buffer
	loop L2														; call the loop
	ret 
ToLowerCase ENDP
END main