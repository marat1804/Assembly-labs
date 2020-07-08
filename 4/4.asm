;Обеспечить выравнивание строк текста «по ширине» за счет равномерной вставки дополнительных пробелов между словами.
	.model small
	.stack 100h
	.486
	.data
ptrs	dw 50 dup(?)
lens	db 50 dup(?)
delim	db ' ',9,0
string	db 'xcdr a abdr    edr  zaq aqw  jgh t qwe easrtyu zeq',0
n 		db ?
max		db	80
newstring db 82 dup(?); новая строка
	.code
	mov ax, @data
	mov ds, ax
	mov es, ax
	cld
	lea si, string
	lea di, delim
	xor bx, bx
m1:	call space 
	cmp byte ptr [si],0 
	je short m2
	shl bx,1
	mov ptrs[bx],si
	shr bx,1
	mov cx,si
	call words
	sub cx,si
	neg cx;
	mov lens[bx],cl
	inc bx
	cmp byte ptr [si],0 
	jne short m1
m2:	mov n, bl
	dec bl
	mov cl, n
	lea si, lens
m3:	lodsb
	add bl, al
	loop m3
	cmp bl,max
	jle short m4
	mov ax, 4c01h
	int 21h
m4:	sub bl, n
	inc bl
	sub bl, max
	neg bl
	xor ax, ax
	mov al, bl
	mov bl, n
	dec bl
	div bl
	mov dx, ax
	mov cl, n
	xor bx, bx
	lea di, newstring
m5: push cx
	or bx, bx
	je short m6
	mov cl, dl
	mov al, ' '
	rep stosb
	cmp dh, 0
	je short m6
	stosb
	dec dh
m6:	shl bx,1
	mov si,ptrs[bx]
	shr bx,1
	mov cl,lens[bx] 
	xor ch,ch
	rep movsb
	inc bx
	pop cx
	loop m5
	xor al,al
	stosb
	mov ax, 4c00h
	int 21h
space	proc
	locals @@
	push ax
	push cx
	push di
	xor ax, ax
	mov cx,65535
	repne scasb 
	neg cx 
	dec cx
	push cx 
@@m1:	pop cx
	pop di
	push di
	push cx
	lodsb 
	repne scasb
	jcxz @@m2
	jmp @@m1
@@m2:	dec si
	add sp,2
	pop di
	pop cx
	pop ax
	ret
	endp
words	proc
	locals @@
	push ax
	push cx
	push di
	xor al,al
	mov cx,65535
	repne scasb
	neg cx
	push cx
@@m:	pop cx
	pop di
	push di
	push cx
	lodsb
	repne scasb
	jcxz @@m
	dec si
	add sp,2
	pop di
	pop cx
	pop ax
	ret
	endp
	end