;MPLab Assignment 05
;Write a switch case driven ALP to perform 64-bit hexadecimal arithmetic operations (+,-,*, /) using suitable macros. Define procedure for each operation.


section .data
	menumsg db 10,'****** Menu ******',
		db 10,'+: Addition'
		db 10,'-: Subtraction'
		db 10,'*: Multiplication'
		db 10,'/: Division'
		db 10,10,'Enter your choice:: '
	menumsg_len: equ $-menumsg

	addmsg db 10,'Welcome to additon',10
	addmsg_len equ $-addmsg
	submsg db 10,'Welcome to subtraction',10
	submsg_len equ $-submsg
	mulmsg db 10,'Welcome to Multiplication',10
	mulmsg_len equ $-mulmsg
	divmsg db 10,'Welcome to Division',10
	divmsg_len equ $-divmsg
	wrchmsg db 10,10,'Wrong CHoice Entered...!',10
	wrchmsg_len equ $-wrchmsg

	no1 dq 0ff05h
	no2 dq 0ffh

	resmsg db 10,'Result is:'
	resmsg_len equ $-resmsg

	qmsg db 10,'Quotient::'
	qmsg_len equ $-qmsg

	rmsg db 10,'Remainder::'
	rmsg_len equ $-rmsg

	nwmsg db 10

	resh dq 0
	resl dq 0

section .bss
	accbuff resb 2
	dispbuff resb 16

%macro  print   2
	mov   eax, 4
	mov   ebx, 1
	mov   ecx, %1
	mov   edx, %2
	int   80h
%endmacro

section .text
	global _start
_start:	print menumsg,menumsg_len

	mov eax,03
	mov ebx,01
	mov ecx,accbuff
	mov edx,02
	int 80h

	cmp byte [accbuff],'+'
	jne case2
	
	call add_proc
	jmp exit
case2:
	cmp byte [accbuff],'-'
	jne case3
	
	call sub_proc
	jmp exit
case3:
	cmp byte [accbuff],'*'
	jne case4
	
	call mul_proc
	jmp exit	
case4:
	cmp byte [accbuff],'/'
	jne caseinv
	
	call div_proc
	jmp exit	
caseinv:
	print wrchmsg,wrchmsg_len


exit:	mov eax,01
	mov ebx,0
	int 80h

add_proc:
	print addmsg,addmsg_len
	mov rax,[no1]
	add rax,[no2]
	jnc addnxt1
	inc qword [resh]
addnxt1:
	mov [resl],rax
	print resmsg,resmsg_len

	mov rbx,[resh]
	call disp64num
	mov rbx,[resl]
	call disp64num
	print nwmsg,1
	
	ret

sub_proc:
	print submsg,submsg_len

	mov rax,[no1]
	sub rax,[no2]
	jnc addnxt1
	inc qword [resh]
subnxt1:
	mov [resl],rax
	print resmsg,resmsg_len

	mov rbx,[resh]
	call disp64num
	mov rbx,[resl]
	call disp64num
	print nwmsg,1
	
	ret

mul_proc:
	print mulmsg,mulmsg_len
	mov rax,[no1]
	mov rbx,[no2]
	mul rbx

	mov [resh],rdx
	mov [resl],rax

	print resmsg,resmsg_len
	mov rbx,[resh]
	call disp64num
	mov rbx,[resl]
	call disp64num
	print nwmsg,1

	ret

div_proc:
	print divmsg,divmsg_len

	mov rax,[no1]
	mov rdx,0
	mov rbx,[no2]
	div rbx

	mov [resh],rdx	;Remainder
	mov [resl],rax	;Quotient

	print rmsg,rmsg_len
	mov rbx,[resh]
	call disp64num
	print qmsg,qmsg_len
	mov rbx,[resl]
	call disp64num
	print nwmsg,1

	ret

disp64num:
	mov ecx,16
	mov edi,dispbuff
dup1:
	rol rbx,4
	mov al,bl
	and al,0fh
	cmp al,09
	jbe dskip
	add al,07h
dskip:	add al,30h
	mov [edi],al
	inc edi
	loop dup1

	print dispbuff,16
	ret

;Output

;[student@localhost]$ nasm -f elf64 MPL4.asm
;[student@localhost]$ ld -o MPL4 MPL4.o
;[student@localhost]$ ./MPL4

;****** Menu ******
;+: Addition
;-: Subtraction
;*: Multiplication
;/: Division

;Enter your choice:: +

;Welcome to additon

;Result is:00000000000000000000000000010004
;[student@localhost]$ ./MPL4

;****** Menu ******
;+: Addition
;-: Subtraction
;*: Multiplication
;/: Division

;Enter your choice:: -

;Welcome to subtraction

;Result is:0000000000000000000000000000FE06
;[student@localhost]$ ./MPL4

;****** Menu ******
;+: Addition
;-: Subtraction
;*: Multiplication
;/: Division

;Enter your choice:: *

;Welcome to Multiplication

;Result is:00000000000000000000000000FE05FB
;[student@localhost]$ ./MPL4

;****** Menu ******
;+: Addition
;-: Subtraction
;*: Multiplication
;/: Division

;Enter your choice:: /

;Welcome to Division

;Remainder::0000000000000005
;Quotient::0000000000000100
;[student@localhost]$ 

