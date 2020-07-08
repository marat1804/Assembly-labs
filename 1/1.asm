.model small
.stack 100h
.486
.data
a dw 40
b dw 100
c dw 20
d dw 20
e dw 30
.code
mov ax, @data
mov ds, ax
movsx bx, a
shl bx, 1
movsx ax, b
imul ax
add eax, ebx
movsx cx, a
imul cx, cx
shl cx, 2
idiv cx
mov ecx, eax ; результат первой дроби тут должен быть 
movsx ax, c
imul ax
imul a
movsx bx, d
imul bx,bx
sub ax, bx
movsx bx, e
shl bx, 1
idiv ebx
add eax, ecx
mov ax, 4c00h; end
int 21h
end
