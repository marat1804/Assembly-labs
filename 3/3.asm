	.model small
	.stack 100h
	.486
	.data
Rows 	equ 3 
Cols	equ	3 
len		dw	Rows*Cols
matrix	dw	23, 4, 10, 15, 17, 14, 2, 71, 66
	.code
	mov ax, @data
	mov ds, ax
	mov cx, len
	cld
	lea bx,matrix

	mov dx,[bx];min
	mov di,[bx];max
	inc bx
	inc bx
	dec cx
l1:
	mov ax, [bx]
	cmp ax,di
	jnl short more
	cmp ax, dx
	jl short less
	jmp short l
more:
	mov di, ax
	jmp short l
less:
	mov dx,ax
l:
	inc bx
	inc bx
	loop l1

	lea bx, matrix
	mov cx, len

l2:
	mov ax, [bx]
	shr ax, 1
	jae short zero
ones:
	mov [bx],di
	jmp short l3
zero:
	mov [bx], dx
l3:
	inc bx
	inc bx
	loop l2

	mov ax, 4c00h
	int 21h
	end
