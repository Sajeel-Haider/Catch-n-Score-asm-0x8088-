[org 0x0100]
jmp	start
score:      db      'Score: '
strlenScore:    dw  7
time:       db      'Time: '
strlenTime: dw      6
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
endMessage:     db  'Thank you for playing!'
strlenEndMessage:   dw  25


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
renderScoreNTime:
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

    ret

renderCatcher:
    mov     ax,     22h   ;x co-ordinate
    push    ax
    mov     ax,     17h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xB0  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     5Bh
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes

    mov     ax,     29h   ;x co-ordinate
    push    ax
    mov     ax,     17h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xB0  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     5Dh
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes

    mov     ax,     22h   ;x co-ordinate
    push    ax
    mov     ax,     18h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xB0  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     7Eh
    push    ax
    mov     cx,     08h
    push    cx
    call    printDesignShapes
    ret
MainMenu:
    mov     ax,     23h   ;x co-ordinate
    push    ax
    mov     ax,     02h   ;y co-ordinate
    push    ax
    mov     ax,     welcomeMess
    push    ax
    push    word[strlenWelcomeMess]
    xor     ax,     ax
    mov     ah,     30h
    push    ax
    call    printText
    
    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     08h   ;y co-ordinate
    push    ax
    mov     ax,     cnsMess
    push    ax
    push    word[strlenCnsMess]
    xor     ax,     ax
    mov     ah,     20h
    push    ax
    call    printText
    
    mov     ax,     1Bh   ;x co-ordinate
    push    ax
    mov     ax,     0Ah   ;y co-ordinate
    push    ax
    mov     ax,     enterMess
    push    ax
    push    word[strlenEnterMess]
    xor     ax,     ax
    mov     ah,     34h     ;color
    push    ax
    call    printText
    
    mov     ax,     2Dh   ;x co-ordinate
    push    ax
    mov     ax,     0Dh   ;y co-ordinate
    push    ax
    mov     ax,     instrucMess
    push    ax
    push    word[strlenInstrucMess]
    xor     ax,     ax
    mov     ah,     0xC0
    push    ax
    call    printText

    mov     ax,     2Dh   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    mov     ax,     instructions
    push    ax
    push    word[strlenInstructionsMess]
    xor     ax,     ax
    mov     ah,     30h
    push    ax
    call    printText
    
    ret

holdMyTnt: 

    push    di
    push    es
    push    cx    

    mov     cx,80
    mov     ah,0
    mul     cx
    mov     bh,0
    add     ax,bx
    shl     ax,1
    mov     di,ax           ; selecting location on screen
    mov     ax,0xB800
    mov     es,ax
    CLD
    mov     ax,0x34C9       ; just printing shape afterwards
    STOSw 
    mov     ax,0x34CD
    STOSw 
    mov     ax,0x34BB
    STOSw 
    add     di,154
    mov     ax,0x34C8
    STOSw 
    mov     ax,0x34CB
    STOSw 
    mov     ax,0x34BC
    STOSw 
    add     di,154
    mov     ax,0x34CD
    STOSw
    mov     ax,0x34CA
    STOSw 
    mov     ax,0x34CD
    STOSw

    pop     cx
    pop     es
    pop     di

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
designShapes:
    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     05h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xB4  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     7Eh
    push    ax
    mov     cx,     50h
    push    cx
    call    printDesignShapes
    
    ret

EndPage:
    mov     ax,     1Ch   ;x co-ordinate
    push    ax
    mov     ax,     08h   ;y co-ordinate
    push    ax
    mov     ax,     endMessage
    push    ax
    push    word[strlenEndMessage]
    xor     ax,     ax
    mov     ah,     30h
    push    ax
    call    printText

    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     0Dh   ;y co-ordinate
    push    ax
    mov     ax,     score
    push    ax
    push    word[strlenScore]
    xor     ax,     ax
    mov     ah,     0x34
    push    ax
    call    printText
    ret
loadMainMenu:
    call    clearScreen
    call    MainMenu
    call    designShapes
    ret
loadEndPage:
    call    clearScreen
    call    EndPage
    ret
loadGamePage:
    call    clearScreen
    call    renderScoreNTime
    call    renderCatcher
    ; maybe a loop to call it again and again
    mov     al,4 ; row can be randomly selected using random function
    mov     bl,4 ; column selected 
    call    holdMyTnt
    
    mov     al,7 ; row can be randomly selected using random function
    mov     bl,140 ; column selected 
    call    holdMyTnt

    mov     al,21 ; row can be randomly selected using random function
    mov     bl,60 ; column selected 
    call    holdMyTnt

    ; maybe end the loop here

    ret
waitAWhile
    mov     cx, 2Dh
    mov     dx, 0xC0C6
    mov     al,0
    mov     ah, 86h
    int     15h
    ret
start:
    call    loadMainMenu
    call    waitAWhile
    call    loadEndPage
    call    waitAWhile
    call    loadGamePage
    ;hello bitches
    
mov 	ax, 	0x4c00
int 	21h