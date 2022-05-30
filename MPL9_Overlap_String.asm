; Overlap block transfer with string instruction

section .data
	msg: db 'Overlap Block Transfer String Instruction!!!!'
	msglen: equ $-msg
	msg1: db 10,' Array contents before overlap block transfer'
	msg1len: equ $-msg1
	msg2: db 10,'Array contents After overlap block transfer '
	msg2len: equ $-msg2
	srcblk db 10h,20h,30h,40h,50h,00,00,00
	cnt: equ 8
	space db 20h
section .bss
dispbuf resb 2
%macro print 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

section .text

	global _start
_start:
	print msg,msglen

	print msg1,msg1len
	mov esi,srcblk
	call disp_blk
	
	call overlap

	print msg2,msg2len
	mov esi,srcblk
	call disp_blk
	
	mov eax,1
	mov ebx,0
	int 80h
overlap:
	mov ecx,3
	mov esi,srcblk+4
	mov edi,srcblk+7
	std
	rep movsb	
ret
disp_blk:
	mov  ecx,cnt
	
again:	mov bl,[esi]
	push ecx
	call disp
	print dispbuf,2
	print space,1
	pop ecx
	inc esi
	loop again
ret

disp:
	mov ecx,2
	mov edi,dispbuf

next:	rol bl,4
	mov dl,bl
	and dl,0Fh
	add dl,30h
	cmp dl,39h
	jle dont_add
	add dl,07h
dont_add: mov [edi],dl
	inc edi
	loop next	
ret
