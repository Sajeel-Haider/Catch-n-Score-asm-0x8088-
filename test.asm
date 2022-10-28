[org 0x0100]
jmp start
message:	db	'Welcome'
strlenMessage: 	dw	'7'
printText:
    	mov     ah,     13h
	mov	al,	1
	mov	bh,	0
	mov	bl,	7
	mov	dx,	0x0A03
	mov	cx,	7
	push	cs
	pop	es
	mov	bp,	message

    	int     10h
    	ret
blueScreen:
   	mov ah, 2   ; use function 2 - go to x,y
	mov bh, 0   ; display page 0
	mov dh, 0   ; y coordinate to move cursor to
	mov dl, 0   ; x coordinate to move cursor to
	int 10h ; go!

	mov ah, 0Ah
	mov cx, 1000h
	mov al, 20h
	mov bl, 17h ;color
	int 10h
start:
	call	blueScreen
	call	printText
mov	ax,	0x4c00
int 21h