TITLE questionA

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data
array SWORD 10 DUP(-100)														; original array declared to size 10 with -100 values in it

choice1 BYTE "1. Populate the array with random numbers",0						; a choice in the menu
choice2 BYTE "2. Mutliply the array with a user provided multiplier",0			; a choice in the menu
choice3 BYTE "3. Divide the array with a user provided divisor",0				; a choice in the menu
choice4 BYTE "4. Print the array",0												; a choice in the menu
choice0 BYTE "0. Exit",0														; a choice in the menu

string BYTE "-------------------------------------------------------",0			; a string used for outputting
openBrac BYTE "[", 0															; a string used for outputting
closeBrac BYTE "]",0															; a string used for outputting
commaStr BYTE ", ",0															; a string used for outputting

enterChoice BYTE "Enter a choice: ",0											; enter a choice
enterNum BYTE "Enter a number: ",0												; enter a number
errorMsg BYTE "Invalid choice!",0												; invalid choice msg
goodbyeMsg BYTE "Goodbye!!",0													; goodbye message

popArrayMsg BYTE "Populated array with randoms...",0							; populate array message
mulArrayMsg BYTE "Multiplying array elements...",0									; multiply array message
divArrayMsg BYTE "Dividing array elements...",0									; divide array message
printArrayMsg BYTE "Printing array...",0										; printing array message

arrayStackParam DWORD ?
multiplierParam DWORD ?

;printArray PROTO, array:DWORD

; Code Section
.code 
main PROC
	call Randomize																; sets the seed

Begin:
	mov edx, OFFSET string														; move the offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET choice1														; move the offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET choice2														; move the offset into string
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET choice3														; move the offset into string
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET choice4														; move the offset into string
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET choice0														; move the offset into string
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET string														; move the offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov edx, OFFSET enterChoice													; move the offset into edx
	call WriteString															; write the string
	call ReadDec																; reads in the choice the user enters

	; ----------------- Our switch statement -----------------
	cmp eax, 1																	; case "1"
	je Ch1																		; jumps if equal, to label Ch1 which populates array

	cmp eax, 2																	; case "2"
	je Ch2																		; jumps if equal, to label Ch2 which multiplies array

	cmp eax, 3																	; case "3"
	je Ch3																		; jumps if equal, to label Ch3 which divides array 

	cmp eax, 4																	; case "4"
	je Ch4																		; jumps if equal, to label Ch4 which prints the array

	cmp eax, 0																	; case "0"
	je Done																		; jumps if equal, to label Done which breaks the loop


	; default:
	mov edx, OFFSET errorMsg													; move the offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed
	call Crlf																	; line feed
	jmp Begin																	; jump to the Begin label, continues to loop

; -------- Choice Labels Below ------
Ch1:
	mov edx, OFFSET popArrayMsg													; move string offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov esi, OFFSET array														; move the offset of array into esi
	push esi																	; push esi onto the stack

	mov ecx, LENGTHOF array														; move into ecx the LENGTHOF the array
	push ecx																	; push ecx onto the stack

	call populateArray															; call the populateArray procedure
	jmp Begin																	; jump to the Begin label, continues to loop
Ch2:
	mov edx, OFFSET enterNum													; move the offset into edx
	call WriteString															; write the string
	call ReadInt																; read in the signed number the user gives

	mov edx, OFFSET mulArrayMsg													; move string offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov arrayStackParam, OFFSET array											; move the offset of array into the named stack parameter
	mov multiplierParam, eax													; move the multiplier value in eax into the named parameter

	push arrayStackParam														; push esi onto the stack
	push multiplierParam														; push eax onto the stack which contains our multiplier value 

	call multiplyArray															; call the multiplyArray procedure
	jmp Begin																	; jump to the Begin label, continues to loop
Ch3:
	mov edx, OFFSET enterNum													; move the offset into edx
	call WriteString															; write the string
	call ReadInt																; read in the signed number the user gives

	mov edx, OFFSET divArrayMsg													; move string offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov esi, OFFSET array														; move into esi the offset of the array
	mov ecx, LENGTHOF array														; move into ecx the lengthof the array

aLoop:
	push eax																	; push eax onto the stack, contains dividend
	push [esi]																	; push esi onto the stack, contains offset of array

	call divideArray															; call the divideArray procedure

	mov [esi], ax																; move into esi the value returned in eax
	add esi, TYPE WORD															; increment esi

	pop [esi]																	; push eax onto the stack, contains dividend
	pop eax																		; push esi onto the stack, contains offset of array														
loop aLoop
	jmp Begin																	; jump to the Begin label, continues to loop
Ch4:	
	mov edx, OFFSET printArrayMsg												; move string offset into edx
	call WriteString															; write the string
	call Crlf																	; line feed

	mov esi, OFFSET array
	;INVOKE printArray, esi
	call printArray																; call the printArray procedure
	call Crlf																	; line feed
	jmp Begin																	; jump to the Begin label, continues to loop
Done:
	mov edx, OFFSET goodbyeMsg													; move into edx the offset of the goodbyeMsg string
	call WriteString															; write the string
	call Crlf																	; line feed
	exit
main ENDP


; ALL PROCEDURES ARE BELOW IN ORDER FROM:
; -------------------------------------------------------------------------------------------------------------------
; 1. Populate array with random numbers
; 2. Multiply the array by a number
; 3. Divide the array by a number
; 4. Print the array
; -------------------------------------------------------------------------------------------------------------------

; ---------------------------------------
; Populates an array with random numbers
; between low = -15000, high = +2500
;
; Receives: array, low, high
; Returns: array with randoms numbers in 
;          range
; ---------------------------------------
populateArray PROC 
	push ebp														; push ebp onto the stack
	mov ebp, esp													; move into ebp esp reg
	pushad															; preserve all regs here

	; Parameters
	mov esi, [ebp+12]												; move into esi the offset of the array which is at [ebp+12]
	mov ecx, [ebp+8]												; move into ecx the LENGTHOF the array which is at [ebp+8]
	
	; Local Vars
	mov DWORD PTR [ebp+16], 2500d									; store high val at [ebp+16]
	mov DWORD PTR [ebp+20], -1500d									; store low val at [ebp+20]

forLoop:		
	mov eax, [ebp+16]												; move into eax the 2500
	mov ebx, [ebp+20]												; move into ebx the -1500

	sub eax, ebx													; high - low
	inc eax															; high - low + 1
	call RandomRange												; Math.random()
	add eax, ebx													;(Math.random() * ((high - low + 1) + low))

	mov [esi], ax													; array[i] = random
	add esi, TYPE array												; increments esi 
loop forLoop
	
	call Crlf														; line feed
	popad															; pop all the regs off the stack
	mov esp, ebp													; move into esp ebp reg
	pop ebp															; pop ebp reg off the stack
	ret
populateArray ENDP

; ---------------------------------------
; Multiplies all the numbers in an array 
; by the number entered by a user
;
; Receives: offset of array, multiplier
; Returns: array with numbers in it 
;          multiplied by the number 
;		   the user entered
; ---------------------------------------
multiplyArray PROC 
	ENTER 0,0														; using enter to push EBP on stack, set EBP to base of StackFrame, reserve space for local vars 
	pushad															; preserve all regs here

	; Parameters
	mov ebx, [ebp+8]												; moves into esi [ebp+8] which is passed in as the multiplier 
	mov esi, [ebp+12]												; move into ebx [ebp+12] which was passed the in as offset of array 
	mov ecx, 10														; set ecx to the LENGTHOF array

forLoop1:	
	mov ax, [esi]													; move into eax the first value in the array
	imul ebx														; multiply eax by ebx (ebx contains multiplier value)
	jc Do															; if carry is set, upper half contains product

	mov [esi], ax													; move into eso the product in ax
	add esi, TYPE WORD												; increment esi
	jmp Continue

Do:
	mov [esi], dx													; move the array the product which is in dx value is in
	add esi, TYPE WORD												; increment esi

Continue:
loop forLoop1
	
	call Crlf														; line feed
	popad															; pop all the regs off the stack
	LEAVE															; leave
	ret
multiplyArray ENDP

; ---------------------------------------
; Divides all the numbers in an array 
; by the number entered by a user
;
; Receives: array, number
; Returns: array with numbers in it 
;          divided by the number the user
;		    entered
; ---------------------------------------
divideArray PROC  
	push ebp
	mov ebp, esp

	; Parameters
	mov ebx, [ebp+8]												; moves into esi [ebp+8] which is passed in as the divider 
	mov edi, [ebp+12]												; move into ebx [ebp+12] which was passed the in as a value in the array

	mov eax, edi													; move into eax the first value in the array

	idiv ebx														; divide eax by ebx (ebx contains multiplier value)
	jo Do															; if carry is set, upper half contains product
	jmp Continue

Do:
	mov eax, edx													; move the array the product which is in dx value is in

Continue:
	call Crlf														; line feed	
	mov esp, ebp
	pop ebp
	ret
divideArray ENDP

; ---------------------------------------
; Prints out an array passed to the 
; procedure
;
; Receives: array, number
; Returns: void
; ---------------------------------------
printArray PROC USES eax ebx ecx esi

mov edx, OFFSET openBrac											; move the offset into edx
call WriteString													; write the string
dec ecx																; decrement ecx by 1

forLoop3:		
	movsx eax, WORD PTR [esi]									    ; move into eax and sign extend the value in esi
	call WriteInt													; write the number

	mov edx, OFFSET commaStr										; move into edx the offset of the commaStr
	call WriteString												; write the string

	add esi, TYPE array												; increment esi
loop forLoop3

	movsx eax, WORD PTR [esi]									    ; move into eax and sign extend the value in esi
	call WriteInt													; write the number

	mov edx, OFFSET closeBrac										; move into edx the offset of the closeBrac
	call WriteString												; write the string
	call Crlf														; line feed
	ret
printArray ENDP
END main