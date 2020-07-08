;Обеспечить выравнивание строк текста «по ширине» за счет равномерной вставки дополнительных пробелов между словами.
	.model small
	.stack 100h
	.486
	.data

ptrs	dw 50 dup(?)
lens	db 50 dup(?)
delim	db ' ',',',';',0
msg1 db 'Input: file or keyboard (1/2)$'      
msg11 db 'Enter line:$'                        
msg2 db 'Output: file or screen(1/2)$'         
msg21 db 'Saved:$'       
maxlineerror db 'Max length of string reached$'                      
error db 'Incorrect name of file$'              
msgfi db 'Enter name of file:$'                 
ans1 db 4,2 dup(0)
ans2 db 4,2 dup(0)
fi db 22,20 dup (0) 
fo db 22,20 dup (0) 
string db 102,100 dup (0)  
newstring db 100 dup(?)          
n 		db ?
max		db	80

	.code
	mov ax, @data
	mov ds, ax
	mov es, ax
	cld
dg1:
	mov ah, 9
	lea dx, msg1
	int 21h
	lea dx, ans1
	mov ah, 0ah
	int 21h
	call newline

	lea di, ans1
	mov bl, [di+2]
	cmp bl, '2'
	je short dg2
	cmp bl, '1'
	jne dg1
	;значит выбрал файл

	mov ah, 9
	lea dx, msgfi
	int 21h
	lea dx, fi
	mov ah, 0ah
	int 21h
	call newline ; Ввели имя файла
	;Нужно почистить первые два символа считанные

	lea di, fi
	mov bl, [di+1]
	mov cx, bx
l:
	mov bl, byte ptr [di+2]
	mov byte ptr [di], bl
	inc di
	loop l

	mov byte ptr [di], 0
    mov byte ptr [di + 1], 0
    mov byte ptr [di + 2], 0
    
    xor dx, dx
    mov al, 2; запись и чтение
    mov ah, 3dh
    lea dx, fi
    int 21h

    jc short exitmsg

    mov bx, ax
    xor ax, ax
    lea dx, string
    xor cx, cx
    mov cl, max
    mov ah, 3fh
    int 21h

    jc short exitmsg
    mov ah, 3eh
    int 21h; закрыли файл
    lea si, string
    jmp short dg3

dg2: ;с клавиатуры ввод
	mov ah, 9
	lea dx, msg11
	int 21h
	call newline
	lea dx, string
	mov ah, 0ah
	int 21h
	lea di, string
	mov bl, [di+1]
	mov byte ptr [di+bx+2], 0
	lea si, string[2]
dg3:
	;lea si, string
	lea di, delim
	xor bx, bx
	jmp short m1
exitmsg:
	jmp exiterror
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
	jmp maxline
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
	mov al, '$'
	stosb

dg21:
	call newline
	mov ah, 9
	lea dx, msg2
	int 21h 
	lea dx, ans2
	mov ah, 0ah
	int 21h
	call newline
	lea di,  ans2
	mov bl, [di+2]

	cmp bl, '2'
	je short dg22
	cmp bl, '1'
	jne dg21

	;Выбрали файл
	mov ah, 9
	lea dx, msgfi
	int 21h
	lea dx, fo
	mov ah, 0ah
	int 21h
	call newline

    lea di, fo   
    mov bl,[di+1]      
    mov cx, bx
l1:
    mov bl, byte ptr [di+2]    
    mov byte ptr [di], bl
    inc di
    loop l1

    mov byte ptr [di], 0
    mov byte ptr [di + 1], 0
    mov byte ptr [di + 2], 0

    xor dx, dx
    mov al, 2
    mov ah, 3dh
    lea dx, fo
    int 21h
    jc short exiterror

    mov bx, ax
    mov ah, 40h
    xor cx, cx
    mov cl, max
    lea dx, newstring
    int 21h

    jc short exiterror

    call newline
    mov ah, 9
    lea dx, msg21
    int 21h

dg22:
	call newline
	mov ah, 9
	lea dx, newstring
	int 21h
	jmp short exit
maxline:
	mov ah, 9
	lea dx, maxlineerror
	int 21h
	jmp short exit

exiterror:
	mov ah, 9
	lea dx, error
	int 21h
exit:
	mov ax, 4c00h
	int 21h

newline proc
    push ax
    mov ah, 0eH ; вывод символа al в консоль
    mov al, 0dh
    int 10h
    mov ah, 0eh
    mov al, 0ah
    int 10h
    pop ax
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
	end