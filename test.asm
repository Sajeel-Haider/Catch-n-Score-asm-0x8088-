[org 0x0100]
jmp start
message:	db	'Welcome'
strlenMessage: 	dw	'7'

holdMyTnt: 

    mov ax,0xB800
    mov es,ax
    mov di,650
    CLD
    mov ax,0xB4C9
    STOSw 
    mov ax,0xB4CD
    STOSw 
    mov ax,0xB4BB
    STOSw 
    add di,154
    mov ax,0xB4C8
    STOSw 
    mov ax,0xB4CB
    STOSw 
    mov ax,0xB4BC
    STOSw 
    add di,154
    mov ax,0xB4CD
    STOSw
    mov ax,0xB4CA
    STOSw 
    mov ax,0xB4CD
    STOSw



ret 

clearScreen:
    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     00h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xBB  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     20h
    push    ax
    mov     cx,     2000
    push    cx
    call    printDesignShapes
    ret
printDesignShapes:
    push    bp
    mov     bp,     sp
    push    ax
    push    es
    push    di
    push    si
    push    cx

    mov     ax,     0xb800
    mov     es,     ax
    mov     al,     80
    mul     byte[bp+10]
    add     ax,     word[bp+12]
    shl     ax,     1
    mov     di,     ax      ;position
    
    mov     cx,     [bp+4]      ;size
    xor     ax,     ax
    mov     ax,     [bp+8]      ;color   (there was prob here idk why but cant use ah)
    mov     al,     [bp+6]      ;space
    

    CLD
    REP     STOSW

    pop     cx
    pop     si
    pop     di
    pop     es
    pop     ax
    pop     bp

    ret     10

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
	;call	blueScreen
	;call	printText
     call clearScreen
	call holdMyTnt

mov	ax,	0x4c00
int 21h