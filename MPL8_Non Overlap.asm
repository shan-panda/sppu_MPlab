; Non overlap block transfer without string instruction

section .data
	msg: db 'Non Overlap Block Transfer!!!!'
	msglen: equ $-msg
	msg1: db 10,'Source Block contents before Non overlap'
	msg1len: equ $-msg1
	msg2: db 10,'Destination Block contents before Non overlap'
	msg2len: equ $-msg2
	msg3: db 10,'Source Block contents After Non overlap'
	msg3len: equ $-msg3
	msg4: db 10,'Destination Block contents After Non overlap'
	msg4len: equ $-msg4
	srcblk db 10h,20h,30h,40h,50h
	destblk times 5 db 0
	cnt: equ 5
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
	
	print msg2,msg2len
	mov esi,destblk
	call disp_blk

	call non_overlap

	print msg3,msg3len
	mov esi,srcblk
	call disp_blk
	
	print msg4,msg4len
	mov esi,destblk
	call disp_blk

	
	mov eax,1
	mov ebx,0
	int 80h

non_overlap:
	mov rcx,cnt
	mov esi,srcblk
	mov edi,destblk

transfer:	mov al,[esi]
		mov [edi],al
		inc esi
		inc edi
		loop transfer
		ret
disp_blk:
	mov rcx,cnt
	
again:	mov bl,[esi]
	push rcx
	call disp
	print dispbuf,2
	print space,1
	pop rcx
	inc esi
	loop again
ret

disp:					;hex to ascii conversion
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
