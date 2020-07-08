	.model small
	.stack 100h
	.486
	.data
	a dw 67
	.code
Start:
	mov ax, @data
	mov ds, ax
	mov ax, a
	jz en
lp:
	shr ax, 1
	jz en
	jae zero
one:
	inc cx
	jmp lp
zero:
	inc dx
	jmp lp
en:
	inc cx
	add cx, dx
	mov ax, 4c00h; end
	int 21h
	end Start
