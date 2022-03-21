TITLE Question A

COMMENT ! 
This program performs 3 different function solutions, they are as follows:
EQN1 = (P+R) - (Q+S) + T
EQN2 = T + (P-R) - (S+Q)
EQN3 = (S+Q) + (T-P) - R

unsigned ints:(P,R,T)
signed ints:(Q,S)

import java.util.Scanner;
public class questionA {
public class questionA {
	// Global Variables
	// Unsigned Ints
	private static int P;
	private static int R;
	private static int T;
							// ALL VARS ARE DWORDS = 4 bytes = 32-bits
	// Signed Ints
	private static int Q;
	private static int S;
	
	// Scanner
	private static Scanner in = new Scanner(System.in);
	
	// Main
	public static void main(String[] args) {
		// Collect Number
		System.out.print("Enter an unsigned value for P: "); // ReadDec
		P = in.nextInt();
		
		// Collect Number
		System.out.print("Enter an unsigned value for R: "); // ReadDec
		R = in.nextInt();
		
		// Collect Number
		System.out.print("Enter an unsigned value for T: "); // ReadDec
		T = in.nextInt();
		
		// Collect Number
		System.out.print("Enter a signed value for Q: "); // ReadInt
		Q = in.nextInt();
		
		// Collect Number
		System.out.print("Enter a signed value for S: "); // ReadInt
    	S = in.nextInt();
		
		// Perform math and output
		System.out.println("...");
		System.out.println("(P + R) - (Q + S) + T : " + ((P + R) - (Q + S) + T));
        System.out.println("T + (P - R) - (S + Q) : " + (T + (P - R) - (S + Q)));
        System.out.println("(S + Q) + (T - P) - R : " + ((S + Q) + (T - P) - R));
		
	}
 } 
end comment !

; Standard Declaration
INCLUDE Irvine32.inc

; Data Section
.data
func1 BYTE "(P+R) - (Q+S) + T : ",0							; function 1 as a string
func2 BYTE "T + (P-R) - (S+Q) : ",0							; function 2 as a string
func3 BYTE "(S+Q) + (T-P) - R : ",0							; function 3 as a string

solutionHeader BYTE "------- Solutions -------",0			; a heading used to make the output look nice

promptP BYTE "Enter an unsigned value for P: ",0			; string prompt asking to enter an unsigned value for P
promptR BYTE "Enter an unsigned value for R: ",0			; string prompt asking to enter an unsigned value for R
promptT BYTE "Enter an unsigned value for T: ",0			; string prompt asking to enter an unsigned value for T

promptQ BYTE "Enter a signed value for Q: ",0			    ; string prompt asking to enter a signed value for Q
promptS BYTE "Enter a signed value for S: ",0			    ; string prompt asking to enter a signed value for S

P DWORD ?													; variable for P, unsigned dword
R DWORD ?													; variable for R, unsigned dword
T DWORD ?													; variable for T, unsigned dword
Q SDWORD ?													; variable for Q, signed dword
S SDWORD ?													; variable for S, signed dword

; Code Section
.code
main PROC
	; This block of code asks the user to 
	; input values, both signed and unsigned
	; and then it stores the values in their variables

	mov edx, OFFSET promptP			; move prompt offset to edx
	call WriteString			    ; write the prompt
	call ReadDec			        ; store the value in eax 
	mov P, eax						; store eax value in variable P

	mov edx, OFFSET promptR			; move prompt offset to edx
	call WriteString			    ; write the prompt
	call ReadDec			        ; store the value in eax 
	mov R, eax						; store eax value in variable R

	mov edx, OFFSET promptT			; move prompt offset to edx
	call WriteString			    ; write the prompt
	call ReadDec			        ; store the value in eax 
	mov T, eax						; store eax value in variable T

	mov edx, OFFSET promptQ			; move prompt offset to edx
	call WriteString			    ; write the prompt
	call ReadInt			        ; store the value in eax 
	mov Q, eax						; store eax value in variable Q

	mov edx, OFFSET promptS			; move prompt offset to edx
	call WriteString			    ; write the prompt
	call ReadInt			        ; store the value in eax 
	mov S, eax						; store eax value in variable S

	; Output
	call Crlf						; line feed
	mov edx, OFFSET solutionHeader	; move offset of solutionHeader to edx
	call WriteString				; write the string
	call Crlf						; line feed
	
	; Output for func1
	mov edx, OFFSET func1			; move offset of func1 to edx
	call WriteString				; write the string

	mov eax, P						; move P to eax
	add eax, R						; add R to eax
	mov ebx, Q						; move Q to eax
	add ebx, S						; add S to ebx
	sub eax, ebx					; subtract ebx from eax
	add eax, T						; add T to eax
	call WriteInt					; write the result in eax
	call Crlf						; line feed

	; Output for func2
	mov edx, OFFSET func2			; move offset of func2 to edx
	call WriteString				; write the string
	
	mov eax, P						; move P to eax
	sub eax, R						; subtract R from eax
	mov ebx, S						; move S to ebx
	add ebx, Q						; add Q to ebx
	sub eax, ebx					; subtract ebx from eax
	add eax, T						; add T to eax
	call WriteInt					; write the result in eax
	call Crlf						; line feed

	; Output for func3				
	mov edx, OFFSET func3			; move offset of func3 to edx
	call WriteString				; write the string
	
	mov eax, S						; move S to eax
	add eax, Q						; add Q to eax
	mov ebx, T						; move T to ebx
	sub ebx, P						; subtract P from ebx
	add eax, ebx					; add eax and ebx
	sub eax, R						; subtract R from eax
	call WriteInt					; write the result in eax
	call Crlf						; line feed

	exit
main ENDP
END main