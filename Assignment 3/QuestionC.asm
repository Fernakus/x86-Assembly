TITLE Question C
COMMENT !
This program solves the algorithm required to
determine the solution to F[n] = 2 * F[n - 1] + F[i - 5]

public class questionC {
	// Global Variables
	private static int i;
	private static int[] F = new int[30];
							
	// Main
	public static void main(String[] args) {
		// Add Elements to the array
		F[0] = 0;
		F[1] = 2;
		F[2] = 1;
		F[3] = 4;
		F[4] = 2;

		// Do fib sequence
		for (i = 5; i < 30; i++) F[i] = F[i - 1] + F[i - 1] + F[i - 5];

		// For loop to output
		for (i = 0; i < F.length; i++) System.out.print(F[i] + ", ");	
	}
}
end comment !


; Standard Declarations
INCLUDE Irvine32.inc

; Data Section
.data
array DWORD 0, 2, 1, 4, 2, 25 DUP(?)																	    ; declare an array of 30 elements initilaized to 0
commaStr BYTE ", ", 0																						; used for formatting the output
statementStr BYTE "The solution for the first 30 values of the equation are: ",0							; used for output
equationStr BYTE "F(n) = 2 * F(n-1) + F(n-5) = ",0														    ; used for output

; Code Section
.code
main PROC
	; Output 
	mov edx, OFFSET statementStr						; move statementStr to edx
	call WriteString									; call write string
	call Crlf											; line feed
	mov edx, OFFSET equationStr							; move equationStr to edx
	call WriteString									; call write string

	; Preform formula on array, then add the result 
	; into the array in the next position
	mov ecx, LENGTHOF array	- 5						    ; set our loop count the the length of array - 5, we want to start indexing at 5 so we run 25 times
	mov esi, OFFSET array				                ; start at the 5th element in the array, dword = 4 bytes, 4 * 5 = move 20 bytes in
	add esi, TYPE array * 5								; add 20 to esi to move to the 5th position in the array

	; Loop
	L1:
		sub esi, TYPE array * 1						    ; simulates F(index - 1), subtract TYPE array * 1, 4 because its a dword array
		mov eax, [esi]									; move the value at the 5th position into eax	
		mov ebx, eax									; move this value into ebx
		add ebx, eax									; add these values together. simulates 2 * F(n-1)
		add esi, TYPE array * 1							; add 4 to esi to move back to the 5th position

		sub esi, TYPE array * 5							; subtract from esi 20 to simulate F(index - 5), 5 * 4 = 20
		mov eax, [esi]									; move the value at esi into eax
		add eax, ebx									; add eax and ebx, simulates 2 * F(n-1) + F(n-5)
		add esi, TYPE array * 5							; add to esi to move to the 6th position in the array, one position over

		mov [esi], eax						            ; move into esi the value in eax
		add esi, TYPE array							    ; add to esi to move to the 6th position in the array, one position over
		loop L1										    ; call loop

	; Prints contents of array
	mov ecx, LENGTHOF array - 1							; move to ecx the length of the array - 1, we wanna run it 29 times
	mov esi, OFFSET array								; move into esi the offset of the array
	L2:
		mov eax, [esi]									; move into eax the value at esi
		call WriteDec									; call write dec
		add esi, TYPE array								; add to esi the type of the array to push to the next value 

		mov edx, OFFSET commaStr						; move to edx the offset of the comma string
		call WriteString								; write the string
		loop L2											; call loop

		mov eax, [esi]									; mov into eax the value at esi which is the last value in the array
		call WriteDec									; call write dec
	
	call Crlf											; line feed
	exit
main ENDP
END main