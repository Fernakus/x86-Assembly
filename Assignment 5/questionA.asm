TITLE questionA

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data 
inputMsg BYTE "Please enter the name of the file: ",0																			; a statement telling the user to enter a number
countOfMsg BYTE "Count of: ",0																									; a string used for output
equalSignMsg BYTE " = ",0																										; a string used for output
errorMsg BYTE "File not found!!",0																								; a string stating the file was not found
commaStr BYTE "'",0																												; a string used for outputting

numCount BYTE 10 DUP(?)																											; our number count array
charCount BYTE 26 DUP(?)																										; our charsCount array
buffer BYTE 100 DUP(?)																											; our buffer array
nameOfFile BYTE 30 DUP(?)																										; our nameOfFile array

numsToComp BYTE 048, 049, 050, 051, 052, 053, 054, 055, 056, 057																; numbers to compare to in ascii, nums as DWORDS 0d-9d not working?
charsToComp BYTE 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',0		; characters to compare too as lowercase

; Code Section
.code
main PROC

start:
	mov edx, OFFSET inputMsg									; move to edx our input message
	call WriteString											; write the string
	
	mov edx, OFFSET nameOfFile									; move the offset of the nameOfFile variable into edx
	mov ecx, LENGTHOF nameOfFile								; move into ecx the SIZEOF nameOfFile (number of bytes in nameOfFile var)
	call ReadString												; read in the users input

	mov edx, OFFSET nameOfFile									; move into edx the offset of the nameOfFile variable
	call OpenInputFile											; open up this file
	cmp eax, INVALID_HANDLE_VALUE								; compare filehanlde in eax to INVALID_HANDLE_VALUE
	jne continue												; if the file loads (not equal to zero) we can simply jump to the continue label

	mov edx, OFFSET errorMsg									; move into edx the offset of the errorMsg
	call WriteString											; write the string
	call Crlf													; line feed
	call Crlf													; line feed
	jmp start													; jumps back to the start (loops until they enter in the proper filename)

continue:		
	mov edx, OFFSET buffer										; move to edx the OFFSET of buffer
	mov ecx, LENGTHOF buffer									; move into ecx the LENGTHOF the buffer
	Call ReadFromFile											; call the ReadFromFile irvine proc
	call ProcessInputFile										; call the ProcessInputFile procedure which processes the file specifed by the user

	mov edx, OFFSET nameOfFile									; move the offset of nameOfFile int edx
	call WriteString											; write the string
	call Crlf													; line feed
	
	mov ecx, LENGTHOF numCount									; move into ecx the lengthof numCount
	mov esi, 0													; move into esi a 0
	call PrintResults											; call the PrintResults procedure which prints out our results from the ProcessInputFile procedure
	call Crlf													; line feed

	exit
main ENDP

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
isLetter PROC USES eax
; ------------------------------------------------
; Determines whether the character in AL is a
; valid decimal digit. 
; Receives: AL = char
; Returns: ZF = 1, AL = to valid letter
; Returns ZF = 0, AL = to invalid letter
; ------------------------------------------------
	OR al, 00100000b										; clears the fifth bit

	cmp al, 'a'												; compare 'a' to al
	jb done													; if al < 'a' jump to done

	cmp al, 'z'												; compare 'z' to al
	jg done													; if al > 'z' jump to done

	test ax, 0												; if both conditions fail we hit this which sets ZF = 1 (valid letter)
done:
	ret
isLetter ENDP

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ProcessInputFile PROC
; ------------------------------------------------
; Processes an input file, filename is specified
; by the user
; Receives: an opened file
; Returns: the amount of chars and numbers in the 
;		   file
; ------------------------------------------------
	mov ecx, LENGTHOF buffer								; put the number of bytes read into ecx
	mov edx, OFFSET buffer									; move the offset of buffer into edx
	
L1:
	push ecx												; preserve our ecx 

	; ------ Here we will be checking for new line characters ------

	mov al, [edx]											; move a char from edx into al
	cmp al, 0ah												; 0ah is the new line character, check for it
	je loopL1												; if the above comparison is equal we will jump to loopL1 label

	OR al, 00100000b										; clears the fifth bit aka puts it to lowercase
	call isLetter											; since we now know we have either a letter or a number in al, call the isLetter procedure
	jz aLetter												; if ZF is set then we jump to the aLetter label because we know that the byte is a letter

	mov ecx, LENGTHOF numsToComp							; move into ecx the lengthof numsToComp array			
	mov esi, 0												; move into esi a zero, will be used for indexed addressing of arrays
NumberLoop:
	cmp al, numsToComp[esi]									; compare to al the first number in the numsToComp array
	jne invalidMatch										; if the value in al and the value in numsToComp array are not equal we need to loop again

	add numCount[esi], 1									; add in our numCount array at index [esi] a 1 if we have a match
	jmp loopL1												; jump to the loopL1 label if we have a match, end this loop

	invalidMatch:
	add esi, TYPE numsToComp								; increment esi
Loop NumberLoop


aLetter:
	mov ecx, LENGTHOF charsToComp							; move into ecx the lengthof charsToComp array			
	mov esi, 0												; move into esi a zero, will be used for indexed addressing of arrays
CharLoop:
	cmp al, charsToComp[esi]								; compare the letter in al to the charsToComp array at esi index
	jne noMatch												; if not equal then jump to the noMatch label

	add charCount[esi], 1									; add to the charCount array at [esi] 1
	jmp loopL1												; jump to the loopL1 label if we have a match, end this loop

	noMatch:
	add esi, TYPE charsToComp								; increment esi
Loop CharLoop

loopL1:												
	add edx, TYPE buffer									; add to edx the type of buffer (increments it by a byte)
	pop ecx													; restore ecx
Loop L1

done:
	ret
ProcessInputFile ENDP

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PrintResults PROC USES ecx esi
; ------------------------------------------------
; Prints the results from after processing the 
; input file.
; Receives: the results from the ProcessInputFile
;			procedure
; Returns: prints out the results from the 
;          ProcessInputFile procedure
; ------------------------------------------------

PrintNums:													 
	mov edx, OFFSET countOfMsg								; move the offset of countOfMsg into edx
	call WriteString										; write the string

	mov edx, OFFSET commaStr								; move the offset of commaStr into edx
	call WriteString										; write the string

	mov al, numsToComp[esi]									; mov into al our numsToComp[esi] 
	call WriteChar											; write the char

	mov edx, OFFSET commaStr								; move the offset of the commaStr into edx
	call WriteString										; write the string

	mov edx, OFFSET equalSignMsg							; move the offset of equalSignMsg into edx
	call WriteString										; write the string
		
	mov al, numCount[esi]									; move into al the numCount[esi] value
	call WriteDec											; write the value

	add esi, TYPE numCount									; increment esi
	call Crlf												; line feed
Loop PrintNums

	mov ecx, LENGTHOF charCount								; move into ecx the lengthof charCount
	mov esi, 0												; move into esi a 0
PrintChars:
	mov edx, OFFSET countOfMsg								; move the offset of countOfMsg into edx
	call WriteString										; write the string

	mov edx, OFFSET commaStr								; move the offset of commaStr into edx
	call WriteString										; write the string

	mov al, charsToComp[esi]								; move into al charsToComp[esi] value
	AND al, 11011111b										; change value in AL to uppercase
	call WriteChar											; write the char

	mov edx, OFFSET commaStr								; move into edx our comma str
	call WriteString										; write the string

	mov edx, OFFSET equalSignMsg							; move into edx the offset of the equalSignMsg string
	call WriteString										; write the string

	mov al, charCount[esi]									; mov into al the charCount[esi] value
	call WriteDec											; write the value

	add esi, TYPE charCount									; increment esi
	call Crlf												; line feed
Loop PrintChars
	ret
PrintResults ENDP
END main