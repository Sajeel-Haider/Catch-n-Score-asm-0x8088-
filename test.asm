[org 0x0100]
jmp start

text1: db	' ██████╗ █████╗ ████████╗ ██████╗██╗  ██╗      ███╗   ██╗      ███████╗ ██████╗ ██████╗ ██████╗ ███████╗',0
text2: db	'██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║  ██║      ████╗  ██║      ██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝',0
text3: db	'██║     ███████║   ██║   ██║     ███████║█████╗██╔██╗ ██║█████╗███████╗██║     ██║   ██║██████╔╝█████╗',0
text4: db	'██║     ██╔══██║   ██║   ██║     ██╔══██║╚════╝██║╚██╗██║╚════╝╚════██║██║     ██║   ██║██╔══██╗██╔══╝',0
text5: db	'╚██████╗██║  ██║   ██║   ╚██████╗██║  ██║      ██║ ╚████║      ███████║╚██████╗╚██████╔╝██║  ██║███████╗',0
text6: db	' ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝      ╚═╝  ╚═══╝      ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝',0

clrscr: 
push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
xor di, di 
 mov ax, 0x0720  
 mov cx, 2000  
 cld 
 rep stosw 
 pop di
pop cx 
 pop ax 
 pop es 
 ret 
printstr:
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push cx 
 push si 
 push di 
 push ds 
 pop es ; load ds in es 
 mov di, [bp+4] ; point di to string 
 mov cx, 0xffff ; load maximum number in cx 
 xor al, al ; load a zero in al 
 repne scasb ; find zero in the string 
 mov ax, 0xffff ; load maximum number in ax 
 sub ax, cx ; find change in cx 
 dec ax ; exclude null from length 
 jz exit ; no printing if string is empty
 mov cx, ax ; load string length in cx 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov al, 80 ; load al with columns per row 
 mul byte [bp+8] ; multiply with y position 
 add ax, [bp+10] ; add x position 
 shl ax, 1 ; turn into byte offset 
 mov di,ax ; point di to required location 
 mov si, [bp+4] ; point si to string 
 mov ah, [bp+6] ; load attribute in ah 
 cld ; auto increment mode 
nextchar: lodsb ; load next char in al 
 stosw ; print char/attribute pair 
 loop nextchar ; repeat for the whole string 
exit: pop di 
 pop si 
 pop cx 
 pop ax 
 pop es 
 pop bp 
 ret 8 
start: 
call clrscr
 mov ax, 30 
 push ax
 mov ax, 13
 push ax 
 mov ax, 1 
 push ax 
 mov ax, text1
 push ax 
 call printstr 
mov ax, 30 
 push ax 
 mov ax, 14
 push ax
 mov ax, 1 
 push ax 
 mov ax, text2
 push ax 
 call printstr 
mov ax, 30 
 push ax 
 mov ax, 15
 push ax
 mov ax, 1 
 push ax 
 mov ax, text3
 push ax  
 call printstr 
mov ax, 30 
 push ax 
 mov ax, 16
 push ax 
 mov ax, 1
 push ax 
 mov ax, text4
 push ax
 call printstr 
mov ax, 30 
 push ax 
 mov ax, 17
 push ax 
 mov ax, 1 
 push ax 
 mov ax, text5
 push ax 
 call printstr 
mov ax, 30 
 push ax
 mov ax, 18
 push ax 
 mov ax, 1 
 push ax 
 mov ax, text6
 push ax 
 call printstr 

 mov ax, 0x4c00 
 int 0x21 