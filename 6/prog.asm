	.model medium
public inputline, input, readfile, output, writefile, menu, algo
extrn start:far
extrn lens:byte
extrn ptrs:word
extrn n:byte
extrn maxlen:byte
extrn delim:byte
	.code
output proc
	locals @@
@@buffer equ [bp+6]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov di, @@buffer
	xor al, al
	mov cx, 0ffffh
	repne scasb
	neg cx
	dec cx
	dec cx
	jcxz @@ex
	cmp cx, 4095
	jbe @@m
	mov cx, 4095
@@m: mov ah, 40h
	xor bx, bx
	inc bx
	mov dx, @@buffer
	int 21h
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
input	proc
	locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	xor bx,bx
	mov cx,4095
	mov dx,@@buffer
@@m1:	mov ah,3fh
	int 21h
	jc @@ex
	cmp ax,2
	je @@m2
	sub cx,ax
	jcxz @@m2
	add dx,ax
	jmp @@m1
@@m2:	mov di,@@buffer
	add di,4095
	sub di,cx
	xor al,al
	stosb
@@ex:	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
inputline proc
	locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp, sp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ah, 3fh
	xor bx, bx
	mov cx, 80
	mov dx, @@buffer
	int 21h
	jc @@ex
	cmp ax, 80
	jne @@m
	stc
	jmp short @@ex
@@m: mov di, @@buffer
	dec ax
	dec ax
	add di, ax
	xor al, al
	stosb
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
readfile proc
	locals @@
@@buffer equ [bp+6]
@@filename equ [bp+8]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 3d00h
	mov dx, @@filename
	int 21h
	jc @@ex
	mov bx, ax
	mov cx, 4095
	mov dx, @@buffer
@@m1: mov ah, 3fh
	int 21h
	jc @@er
	or ax, ax
	je @@m2
	sub cx, ax
	jcxz @@m2
	add dx, ax
	jmp @@m1
@@m2: mov di, @@buffer
	add di, 4095
	sub di, cx
	xor al, al
	stosb
	mov ah, 3eh
	int 21h
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
@@er: mov ah, 3eh
	int 21h
	stc
	jmp @@ex
	endp
writefile proc
	locals @@
@@filename equ [bp+8]
@@buffer equ [bp+6]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
    mov ah,3ch
	xor cx,cx
	mov dx,@@filename
	int 21h
	jc @@ex
	mov bx, ax
	mov di, @@buffer
	xor al, al
	mov cx, 0ffffh
	repne scasb
	neg cx
	dec cx
	dec cx
	jcxz @@ex1
	cmp cx, 4095
	jbe @@m
	mov cx, 4095
@@m: mov ah, 40h
	mov dx, @@buffer
	int 21h
	jc @@er
@@ex1: mov ah, 3eh
	int 21h
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
@@er:	mov ah, 3eh
	int 21h
	stc
	jmp @@ex
	endp
menu proc
	locals @@
@@ax	equ [bp-82]
@@buffer equ [bp-80]
@@items equ[bp+6]
	push bp
	mov bp, sp
	sub sp,80
	push ax
@@m: push @@items
	call output
	pop ax
	jc @@ex
	push ds
	push es
	push ss
	push ss
	pop ds
	pop es
	mov ax, bp
	sub ax, 80
	push ax
	call inputline
	pop ax
	pop es
	pop ds
	jc @@ex
	mov al, @@buffer
	cbw
	sub ax,'0'
	cmp ax, 0
	jl @@m
	cmp ax, @@ax
	jg @@m
	clc
@@ex: mov sp, bp
	pop bp
	ret
	endp
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
algo proc
	locals @@
@@ibuf equ [bp+6]
@@obuf equ [bp+8]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di; add check
	mov bx, @@obuf
	push bx
	mov si, @@ibuf
	lea di, delim
	xor bx, bx
@@m1: call space
	cmp byte ptr [si], 13
	je short @@m2
	shl bx, 1
	mov ptrs[bx], si
	shr bx, 1
	mov cx, si
	call words
	sub cx, si
	neg cx
	jcxz @@mm2
	mov lens[bx], cl
	inc bx
	cmp byte ptr[si], 13
	jne short @@m1
	jmp short @@m2
@@mm2: dec bx
@@m2: mov n, bl
	dec bl
	mov cl, n
	push si
	lea si, lens
@@m3: lodsb
	add bl, al
	loop @@m3
	cmp bl, maxlen
	jl short @@m4
	; maxline
@@m4: sub bl, n
	inc bl
	sub bl, maxlen
	neg bl
	xor ax, ax
	mov al, bl
	mov bl, n
	dec bl
	div bl
	mov dx, ax
	mov cl, n
	pop bx ; si
	pop di ; di
	push di
	push bx
	xor bx, bx
	;mov di, @@obuf
	jmp @@m5
@@mm1: jmp @@m1
@@m5: push cx
	or bx, bx
	je short @@m6
	mov cl, dl
	mov al, ' '
	rep stosb
	cmp dh, 0
	je short @@m6
	stosb
	dec dh
@@m6: shl bx,1
	mov si,ptrs[bx]
	shr bx,1
	mov cl,lens[bx] 
	xor ch,ch
	rep movsb
	inc bx
	pop cx
	loop @@m5
	mov al, 13
	stosb
	mov al, 10
	stosb
	pop si
	pop ax
	push di
	add si, 4
	cmp byte ptr [si], 0
	je @@m7
	dec si
	dec si
	xor bx, bx
	lea di, delim	
	jmp @@mm1
@@m7: sub bl, n
@@ex:	pop dx
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
	end
