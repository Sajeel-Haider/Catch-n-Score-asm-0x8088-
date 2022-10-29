[org 0x0100]
jmp	start
score:      db      'Score: '
strlenScore:    dw  7
time:       db      'Time: '
strlenTime: dw      6
border:     db      '---------------------------------------------------------------------------------------------------'
strlenBorder:   dw  80
;
welcomeMess:    db  'Welcome!'
strlenWelcomeMess:  dw  8
cnsMess:    db  'Catch & Carry'
strlenCnsMess:  dw  13
enterMess:  db  'Press Enter to Continue'
strlenEnterMess:    dw  23
instrucMess:    db  'Instructions'
strlenInstrucMess:  dw  12
instructions:   db  'blah blah'
strlenInstructionsMess: dw  9
;
clearScreen:
    push    ax 
    push    es 
    push    di  
    push    si
    mov     ax,     0xb800
    mov     es,     ax
    mov     ax,     0x0720
    xor     di,     di
    mov     cx,     2000
    CLD
    REP     stosw
    pop     si
    pop     di 
    pop     es
    pop     ax
    ret
blueScreen:
    mov     ah,     00h
    mov     al,     13h
    int     10h

    mov	ah,	06h ;video mode
    mov	bh,	00h ;set background
    mov	bl,	03h ;color
    int 10h
    ret

printText:
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
    mov     di,     ax
    mov     si,     [bp+8]
    mov     cx,     [bp+6]
    mov     ax,     [bp+4]
    CLD
    nextChar:
        mov     al,     [si]
        mov     [es:di],    ax
        add     si,     1
        add     di,     2
        loop    nextChar
    
    pop     cx
    pop     si
    pop     di
    pop     es
    pop     ax
    pop     bp

    ret     10
setLocationOfText:
    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     01h   ;y co-ordinate
    push    ax
    mov     ax,     time    ;points to string
    push    ax
    push    word[strlenTime]
    xor     ax,     ax
    mov     ah,     07h
    push    ax
    call    printText

    mov     ax,     40h   ;x co-ordinate
    push    ax
    mov     ax,     01h   ;y co-ordinate
    push    ax
    mov     ax,     score
    push    ax
    push    word[strlenScore]
    xor     ax,     ax
    mov     ah,     07h
    push    ax
    call    printText

    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     02h   ;y co-ordinate
    push    ax
    mov     ax,     border
    push    ax
    push    word[strlenBorder]
    xor     ax,     ax
    mov     ah,     07h
    push    ax
    call    printText
    ret

MainMenu:
    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     02h   ;y co-ordinate
    push    ax
    mov     ax,     welcomeMess
    push    ax
    push    word[strlenWelcomeMess]
    xor     ax,     ax
    mov     ah,     03h
    push    ax
    call    printText
    
    mov     ax,     19h   ;x co-ordinate
    push    ax
    mov     ax,     06h   ;y co-ordinate
    push    ax
    mov     ax,     cnsMess
    push    ax
    push    word[strlenCnsMess]
    xor     ax,     ax
    mov     ah,     20h
    push    ax
    call    printText
    
    mov     ax,     19h   ;x co-ordinate
    push    ax
    mov     ax,     08h   ;y co-ordinate
    push    ax
    mov     ax,     enterMess
    push    ax
    push    word[strlenEnterMess]
    xor     ax,     ax
    mov     ah,     40h
    push    ax
    call    printText
    
    mov     ax,     27h   ;x co-ordinate
    push    ax
    mov     ax,     0Bh   ;y co-ordinate
    push    ax
    mov     ax,     instrucMess
    push    ax
    push    word[strlenInstrucMess]
    xor     ax,     ax
    mov     ah,     07h
    push    ax
    call    printText

    mov     ax,     27h   ;x co-ordinate
    push    ax
    mov     ax,     0Eh   ;y co-ordinate
    push    ax
    mov     ax,     instructions
    push    ax
    push    word[strlenInstructionsMess]
    xor     ax,     ax
    mov     ah,     07h
    push    ax
    call    printText
    
    ret
start:
    call    clearScreen
    ;call    blueScreen
    ;call    setLocationOfText
    call    MainMenu
   
mov 	ax, 	0x4c00
int 	21h