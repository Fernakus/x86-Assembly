TITLE Question B

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data
arraySB SBYTE 10 DUP(100)														; SBYTE array size 10, intialized with 100s													
lowVal SDWORD -50																; signed dword low
highVal SDWORD +75															    ; signed dword high

spaceStr BYTE "  ", 0															; double space string
openBracStr BYTE "{", 0															; opening bracket string
closeBracStr BYTE "}", 0														; closing bracket string
totalStatementStr BYTE "The total of the array is: ",0							; total statement string

; Code Section
.code 
main PROC	
	mov esi, OFFSET arraySB													    ; move to esi offset of arraysb
	mov ecx, LENGTHOF arraySB													; set our loop count to the length of arraysb
	mov ebx, TYPE arraySB														; set ecx to the length of arraySB

	call printArray																; print our original array with printArray procedure
	call Randomize																; set the seed
	call BetterRandomRange														; call the BetterRandomRange procedure
	call printArray																; print our new array with the random bytes in it 

	mov edx, OFFSET totalStatementStr											; move the offset of the totalStatementStr to edx
	call WriteString															; write the string
	call sumArray																; call the sumArray method which sums the array and stores it in the eax register
	call WriteInt																; write the value in eax which should be the returned value from sumArray call
	
	call Crlf																	; line feed
	exit
main ENDP
																	
BetterRandomRange PROC USES ecx esi
; ------------------------------------------------
; This is a procedure that will use a low and high
; and return a random number in the range.
; x = (int)(Math.random * (high - low + 1)) + low
; ------------------------------------------------ 
	mov eax, 0																	; set eax as 0 to begin
	L1:
		push eax																; preserve original value of eax as 0 and push onto the stack
		
		mov eax, highVal														; move into eax our high val
		sub eax, lowVal															; subtract from eax our low value  (high - low)
		inc eax																    ; increment eax (+1) (high - low) + 1
		
		call RandomRange													    ; RandomRange function (Math.random)
		add eax, lowVal															; adds low value to eax (Math.random * (high - low + 1) + low)
		
		mov [esi], al												            ; move into esi (our array) the number in al
		add esi, ebx															; add to esi out value in ebx which is TYPE arraySB, increments esi to next value
		
		pop eax																	; pop value off the stack
	loop L1																		; call loop
	ret 
BetterRandomRange ENDP

printArray PROC USES ecx esi
; ------------------------------------------------
; This is a procedure that will use print all of 
; the values in an array 
; ------------------------------------------------ 
	mov edx, OFFSET openBracStr													; move the offset of the openBracStr to edx
	call WriteString															; write the string
	sub ecx, 1																	; subtract 1 from count, only want to run 9 times for formatting
	mov eax, 0																	; set eax as 0 to begin

	L2:
		push eax																; push eax(0) onto the stack
		movsx eax, BYTE PTR [esi]												; move into eax the value in esi
		call WriteInt															; write the int
		add esi, ebx													        ; add to esi ebx which is TYPE arraySB so it increments esi 

		mov edx, OFFSET spaceStr												; move to edx offset of the spaceStr
		call WriteString														; write the string
		pop eax																	; pop eax off the stack
	loop L2																		; call the loop
	
	push eax																	; push eax onto the stack
	movsx eax,  BYTE PTR [esi]													; move to eax the last number in esi
	call WriteInt																; write the int
	mov edx, OFFSET closeBracStr												; move to edx the closeBracStr
	call WriteString															; write the string
	pop eax																		; pop eax off the stack

	call Crlf																	; line feed
	ret 
printArray ENDP

sumArray PROC USES ecx esi
; ------------------------------------------------
; This is a procedure that will sum an array
; ------------------------------------------------ 	
	L3:
		push ebx																; push ebx onto the stack (ebx holds TYPE arraySB)
		movsx ebx, BYTE PTR [esi]												; move into ebx the value in [esi] and pad
		add eax, ebx													        ; add value at [esi] to eax
		
		pop ebx																	; pop ebx off the stack
		add esi, ebx													        ; add to esi ebx which is TYPE arraySB so it increments esi 
	loop L3																		; call the loop
	ret 
sumArray ENDP
END main