.model medium; потому что два файла и два сегмента кода 
	.stack 100h
public	start; чтобы везде метка была доступной ,  так как точка входа !
extrn	items:byte	; все данные внешние
extrn	fn:byte
extrn	ibuf:byte
extrn	obuf:byte
extrn	msg:byte
extrn	frm:byte
extrn	qws:byte
extrn	inp:byte
extrn	bye:byte
extrn	input:far; метки вызова процедур
extrn	inputline:far
extrn	readfile:far
extrn	output:far
extrn	writefile:far
extrn	menu:far
extrn	algorithm:far
	.code
start:	mov ax,@data
	mov ds,ax
	mov es,ax
	cld
m1:	mov ax,5
	push offset items
	call menu
	pop bx
	jnc m2
	push offset msg
	call output
	pop bx
	jmp m10
m2:	cmp ax,1
	jne m3
	push offset inp
	call output
	pop bx
	push offset ibuf
	call input; считывает пока не конечная строка
	pop bx
	jc m4
	jmp m1
m3:	cmp ax,2
	jne m5
	push offset qws
	call output
	pop bx
	push offset fn
	call inputline
	pop bx
	jc m4
	push offset fn
	push offset ibuf
	call readfile; считываем файл 
	pop bx
	pop bx
	jc m4 
	jmp m1
m4:	jmp m11
m5:	cmp ax,3
	jne m6
	push offset obuf
	call output
	pop bx
	jc m4
	jmp m1
m6:	cmp ax,4
	jne m7
	push offset qws
	call output
	pop bx
	push offset fn
	call inputline
	pop bx
	jc m11
	push offset fn
	push offset obuf; передаем в обратном порядке параметры в функцию
	call writefile
	pop bx
	pop bx
	jc m11
	jmp m1
m7:	cmp ax,5
	jne m9
	push offset obuf
	push offset ibuf
	call algorithm
	pop bx
	pop bx
	jc m8
	jmp m1
m8:	push offset frm
	call output
	pop bx
	jmp m1
m9:	push offset bye
	call output
	add sp,2	
m10:	mov ax,4c00h
	int 21h
m11:	push offset msg
	call output
	pop bx
	jmp m1
	end start