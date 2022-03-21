TITLE Question E
COMMENT !
This program takes a declared string and prints it backwards

public class questionE {
	// Global Variables
	private static String originalStr = "This is the original string";
	private static int i;
	private static int lenStr = originalStr.length();
	
	public static void main(String[] args) {
		// Output string normally
		System.out.println(originalStr);
		
		// Output string backwards
		for (i = lenStr - 1; i >= 0; i--) System.out.print(originalStr.charAt(i));
	}
}
end comment !

; Standard Declarations
INCLUDE Irvine32.inc

; Data Section
.data
source BYTE "This is the original string",0										; source array with string
target BYTE SIZEOF source DUP('*')											    ; target array using dup and sizeof

; Code Section
.code
main PROC
	; Print the original string
	mov edx, OFFSET source											    ; move into edx the offset of the string
	call WriteString													; write the string
	call Crlf															; line feed
	
	mov ecx, LENGTHOF source - 1									    ; put the length of source into ecx
	mov esi, OFFSET source											    ; set esi to offset of source

	; This loop pushes things onto the stack from the source array
	L1:
		mov al, [esi]										            ; move value in source at 0 into eax
		push eax													    ; push eax onto the stack
		add esi, TYPE source										    ; increment esi by type of source
		loop L1														    ; call loop

	mov ecx, LENGTHOF source - 1									    ; put the length of source into ecx
	mov esi, OFFSET target                                              ; set esi to offset of target

	; L2 moves from the stack into register we can read
	L2:
		pop eax														    ; pop eax off the stack
		mov [esi], al											        ; move into our target string the value in al
		mov dl, al													    ; move to dl the char in al
		add esi, TYPE target 										    ; increment esi by type of target
		loop L2														    ; call loop
	
	mov BYTE PTR [esi], 0
	mov edx, OFFSET target

	call WriteString
	call Crlf														  ; line feed
	exit
main ENDP
END main