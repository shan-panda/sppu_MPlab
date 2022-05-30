; uP- Assigment no-5
; Write a Program to calculate number of -ve ; and +ve elements ; from the array.

section  .data
	array dd	12345678h,87654321h,90ABCDEFh,3A4B5C6Dh,0ABCDEF10h
	
	msg1 db 10,'Total -ve numbers are:'
	msg1len equ $-msg1
	
	msg2 db 10,'Total +ve numbers are:'
	msg2len equ $-msg2

section  .bss
	poscnt resb 1	; resb is pseudo instruction for reserve 
				;the a byte for buffer
	negcnt resb 1

	dispbuff resb 2	;unintialized space

	%macro disp 2			; macro to display msg, 2 is 							;parameter
		mov eax,4			; system call to write
		mov ebx,1			; system call to display
		mov ecx,%1			; system call to pass the ist 							; parameter msg name
		mov edx,%2			; system call to pass the 2nd 							; parameter msg length
		int 80h			; interrupt call to terminate 							; the program
	%endmacro				; end of macro

section  .text


	global  _start
_start: 
		mov esi,array			;move content of array 								;into stack index
		mov ecx,5				;total no.of numbers
	next:	mov eax,dword[esi]		;move first element of 								;stack index into eax 								;register
		bt eax,31				;to check whether given 								;msb is 0 or 1 ( bit Test)
		jc neg_num				;if carry generated -ve 								;number otherwise it is 								;positive

		mov al,[poscnt]			;start given no. is 									;positive  count
		inc al				;for inrementation
		mov [poscnt],al			;for storage

		jmp down

	neg_num:mov al,[negcnt]     	;start given no. is 									;negative  count
		inc al               		;incrementation
		mov [negcnt],al	     		;for storage

	down:	add esi,4             	;add remaining 										;numbers into stack 									;index
		loop next

		disp msg1,msg1len     	;display negative 									;number and length of 								;negative number
		mov bl,[negcnt]       	;move value of 										;negative number into bl 								;register
	
	call hextoascii      			;ASCII Convert
	
		disp msg2,msg2len         	;display positive number 								;and length of positive 								;number
		mov bl,[poscnt]           	; move value of positive 								;number into bl register
	

	call hextoascii          	  	;ASCII Convert
	
		mov eax,1
		mov ebx,0	              	;Exit from program
		int 80h                    ;Interrupt call FOR EXIT

		hextoascii:			; procedure name to 									;convert Hex to ASCII
			mov edi,dispbuff	;move content of Disp 								;Buffer into destination 								;index register
			mov ecx,2			; for +ve number and 									;negative number
	
		again:	
			rol bl,4			;rotate left 4 numbers
			mov dl,bl			;move content of bl 									;register into al register
			and dl,0Fh 		;for Anding(Multiplication 							;purpose)
			add dl,30h			; use for showing given 								;number is Hex number
			cmp dl,39h			;for compare whether given 							;given number gre than or 								;equal to 9
			jle dont_add		;if less than or equal to 								;9 dont add
			add dl,7			;if sum is greter than 								;equal to 9 add 7									;a,b,c,d,e,f)
		dont_add: mov [edi],dl	;move content of dl into 								;value of edi
			loop again

			disp dispbuff,2
			ret
