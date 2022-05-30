%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro
%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro


section .data

menu db "=========HEX TO BCD==========",10
menulen: equ $-menu
msg1:  db "Enter the number",10
len1:  equ $-msg1
blank:  db "",10
blen: equ $-blank

section .bss

hexcode resb 5
bcdcode resb 5
count resb 1
ascdigit resb 1
asciicode resb 4

section .text
global _start:
_start:
print menu,menulen


hod:    ;hex to bcd
print msg1,len1
read hexcode,5
mov byte[count],4
call asciitohex   ;value at dx is hexadecimal ie binary
mov byte[count],0
mov rax,0h
mov ax,dx
mov rdx,0h
mov rbx,0Ah
back:
div rbx
push dx
mov rdx,0
inc byte[count]
cmp ax,0h
jnz back

repeat:
pop dx
add dl,30h
mov byte[ascdigit],dl
print ascdigit,1
dec byte[count]
jnz repeat
print blank,blen

exit: 	mov rax,60
	mov rdi,00h
	syscall



asciitohex:
mov ax,0h
mov dx,0h
mov rsi,hexcode
back2:
rol dx,4
mov al,byte[rsi]
sub al,30h
cmp al,9
jbe nocorrection
sub al,7h
nocorrection:
add dx,ax
add rsi,1
dec byte[count]
jnz back2
ret
