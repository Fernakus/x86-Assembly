TITLE Question D
COMMENT !
This program uses a loop and populates a word array with 10 numbers 10-100. 
The program then uses a loop to populate the items in the wordArray into the dwordArray.
The program then uses another loop to output the items from the dwordArray

public class questionD {
	// Global Variables
	private static short[] wordArray = new short[10]; // short is 2 bytes like a word
	private static int[] dwordArray = new int[10]; // int is 4 bytes like a dword
	private static int i;
	private static int num = 10;

	public static void main(String[] args) {
		// First for loop populates word array with 10 - 100 shorts
		for (i = 0; i < wordArray.length; i++, num += 10) wordArray[i] = (short)num; 

		// Second loop populates the dwordArray with shorts from wordArray
		for (i = 0; i < dwordArray.length; i++) dwordArray[i] = (int)wordArray[i]; 

		// Outputs values in the dwordArray
		for (i = 0; i < dwordArray.length; i++) System.out.print(dwordArray[i] + ", ");
	}
}
end comment !

; Standard Declarations
INCLUDE Irvine32.inc


; Data Section
.data
arrayW WORD 10 DUP(?)
arrayDW DWORD 10 DUP(?)
commaStr BYTE ", ",0


; Code Section
.code
main PROC
	mov ecx, LENGTHOF arrayW				            ; move the length of arrayW into ecx
	mov esi, 0					                        ; move the offset of arrayW into esi
	mov ebx, 0					                        ; move to bx 0 to start
	
	; adds contents into arrayW
	L1:
		add bx, 10				                        ; add 10 to bx
		mov arrayW[esi], bx		                        ; move the value in bx into the arrayW array
		add esi, TYPE arrayW				            ; add 2 to esi to point to next value in array
		loop L1

	mov ecx, LENGTHOF arrayDW				            ; move to ecx the length of arrayDW
	mov esi, 0					                        ; move to esi the entry into arrayDW

	; adds contents from arrayW to arrayDW
	L2:
		movzx eax, arrayW[esi * TYPE WORD]			    ; move value in arrayW to eax
		mov arrayDW[esi * TYPE DWORD], eax			    ; move into arrayDW the corresponding value in arrayW which is in eax
		inc esi				                            ; push ebx to next value in arrayDW
		loop L2								            ; call loop

	mov ecx, LENGTHOF arrayDW - 1			            ; move to ecx the length of arrayDW - 1
	mov esi, 0				                            ; move into esi the entry into arrayDW

	; prints contents from arrayDW
	L3:
		mov eax, arrayDW[esi]			                ; move to eax the first value in arrayDW
		add esi, TYPE arrayDW				            ; push esi to next value in arrayDW
		call WriteDec						            ; write the value in eax to the screen
		mov edx, OFFSET commaStr			            ; move the commStr offset into edx
		call WriteString					            ; call write string
		loop L3								            ; call loop
	
	mov eax, arrayDW[esi]					            ; mov the eax the last value in arrayDW[esi]
	call WriteDec							            ; call write dec

	call Crlf
	exit
main ENDP
END main