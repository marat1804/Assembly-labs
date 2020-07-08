	.model medium
public	items,fn,ibuf,obuf,msg,frm,qws,inp,bye, ptrs, lens, maxlen, delim, n
	.data
items	db '1. Input from keyboard',13,10
	db '2. Read from file',13,10
	db '3. Output to screen',13,10
	db '4. Write to file',13,10
	db '5. Run the algorithm',13,10
	db '0. Exit to DOS',13,10
	db 'Input item number',13,10,0
fn	db 80 dup (?)
ibuf	db 4096 dup(?)
obuf	db 4096 dup(?)
ptrs	dw 100 dup(?)
lens	db 100 dup(?)
maxlen db 80
n 	db 	?
msg	db 'Error',13,10,0
frm	db 'Incorrect format',13,10,0
qws	db 'Input file name:',13,10,0
inp	db 'Input text. To end press enter.',13,10,0
bye	db 'Good bye!',13,10,0
delim	db ' ',',',';',13,0
	end