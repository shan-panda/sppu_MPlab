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

menu db "=========BCD TO HEX==========",10
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
doh:   ;bcd to hex

print msg1,len1
read bcdcode,6

mov rbx,0Ah
mov rdx,0
mov rax,0
mov byte[count],5
mov rsi,bcdcode

;converting to decimal
unpack:
mul rbx
sub byte[rsi],30h
movsx cx,byte[rsi] ;move with sign extended
add ax,cx
inc rsi
dec byte[count]
jnz unpack
;now we have the decimal value. Convert we have hex val 
mov byte[count],4
mov rsi,asciicode
again:
rol ax,4
mov bl,al
and bl,0Fh
cmp bl,9
jbe nocorrection2
add bl,7
nocorrection2:
add bl,30h
mov byte[rsi],bl
inc rsi
dec byte[count]
jnz again
print asciicode,4
print blank,blen



exit:   ;exit system call
mov rax,60
mov rdx,0h
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

