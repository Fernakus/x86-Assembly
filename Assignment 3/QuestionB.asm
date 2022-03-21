TITLE Question B
COMMENT !
This program solves the algorithm required to
determine the distance driven(km) in (minkm,maxkm) hours

// Import
import java.util.Scanner;

public class questionB {
	// Global Variables
	// Unsigned Ints 
	private static int avgSpeed, minHrs, maxHrs, i, j, result;		// ALL ARE DWORDS = 4 bytes = 32-bits

	// Scanner
	private static Scanner in = new Scanner(System.in);
	
	// Main
	public static void main(String[] args) {
		// Collect Number
		System.out.print("Please enter your average speed(km/hour): "); // ReadDec
		avgSpeed = in.nextInt();
		
		// Collect Number
		System.out.print("Please enter the minimum number of hours you intend to drive: "); // ReadDec
		minHrs = in.nextInt();
		
		// Collect Number
		System.out.print("Please enter the maximum number of hours you intend to drive: "); // ReadDec
		maxHrs = in.nextInt();
	
		// Perform math and output
		System.out.println();
		System.out.println("Hours		   Distance Driven");
		System.out.println("----------------------------------");
		
		// Use for loop
		for (i = 0; i <= maxHrs - minHrs; i++) {
			for (j = 1; j <= minHrs; j++) result += avgSpeed;
			System.out.println(minHrs + "                        " + result);
			result = 0;
			minHrs++;
			maxHrs++;
		}
	}
}
end comment ! 


; Standard Declarations
INCLUDE Irvine32.inc

; Data Section
.data
speedPrompt BYTE "Please enter your average speed (km/hour): ",0						    ; prompt for avg speed
minhrsPrompt BYTE "Please enter the minimum number of hours you intend to drive: ",0	    ; prompt for min hours
maxhrsPrompt BYTE "Please enter the maximum number of hours you intend to drive: ",0	    ; prompt for max hours

header BYTE  "Hours		Distance Driven",0											        ; output header
header1 BYTE "-------------------------------",0											; output header 2
space BYTE "                     ",0														; output space for formatting

speed DWORD ?																				; speed dword var
minHrs DWORD ?																				; minimum hours dword var
maxHrs DWORD ?																				; maximum hours dword var
count DWORD ?																				; used for our nested loops down below
result DWORD ?																				; temp variable for our result

; Code Section
.code
main PROC
	; Collecting data and assigning to variables section 
	mov edx, OFFSET speedPrompt				; move the prompt to edx
	call WriteString						; call write string
	call ReadDec							; read in the value
	mov speed, eax							; move the value from eax to variable speed

	mov edx, OFFSET minhrsPrompt			; mov the prompt to edx	
	call WriteString						; call write string
	call ReadDec							; read in the value
	mov minHrs, eax							; move the value from eax to variable minHrs

	mov edx, OFFSET maxhrsPrompt			; move the prompt to edx
	call WriteString						; call write string
	call ReadDec							; read in the value
	mov maxHrs, eax							; move the value from eax to variable maxHrs
	call Crlf								; line feed

	; Output
	mov edx, OFFSET header					; move the prompt to edx
	call WriteString						; call write string
	call Crlf								; line feed

	mov edx, OFFSET header1					; move the header to edx
	call WriteString						; call write string
	call Crlf								; line feed

	; Loop
	mov eax, 0								; set eax == 0
	mov ecx, maxHrs							; move maxHrs to ecx
	sub ecx, minHrs							; subtract minHrs from maxHrs in ecx
	add ecx, 1								; add 1 to ecx (maxHrs - minHrs) + 1, tells us how much outer loop runs
	
	outerLoop:
		push ecx							; push ecx onto the stack 
		mov ecx, minHrs						; move minHrs into ecx, setting the num of times innerLoop will run
		
		innerLoop:
			add eax, speed					; add speed to eax 
			loop innerLoop					; loop innerLoop which in effect simulates speed * minHrs
		
		
		; Will actually output 
		; to the screen the desired output
		mov result, eax						; store our number that is in eax into result
		mov eax, minHrs						; move minHrs into eax
		call WriteDec						; write what is in ecx
		
		mov edx, OFFSET space				; move space into edx
		call WriteString					; write the string in edx
		
		mov eax, result						; move our result into eax
		call WriteDec						; write what is in eax
	
		mov eax, 0							; reset eax to 0
		call Crlf							; line feed
		inc minHrs							; increment minHrs so we can repeat process with the next number 
		pop ecx								; pop ecx off the stack
		loop outerLoop						; loop the outerLoop
	exit
main ENDP
END main