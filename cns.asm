[org 0x0100]
jmp	start
score:      db      'Score: '
strlenScore:    dw  7
time:       db      'Time: '
strlenTime: dw      6
welcomeMess:    db  'W E L C O M E !'
strlenWelcomeMess:  dw  15
cnsMess:    db  'C A T C H  &  C A R R Y'
strlenCnsMess:  dw  23
enterMess:  db  'Press Enter to Continue'
strlenEnterMess:    dw  23
instrucMess:    db  'Instructions :'
strlenInstrucMess:  dw  14
endMessage:     db  'Thank you for playing!'
strlenEndMessage:   dw  25
deadMsg:     db  'Y O U  D I E '
deadMsgLength:   dw  13
maxPointMsg:     db  '15 Points '
maxMsgLength:   dw  10
midPointMsg:     db  '10 Points '
midMsgLength:   dw  10
minPointMsg:     db  '5 Points'
minMsgLength:   dw  8
pointMsg:     db  '>'
pointMsgLength:   dw  1


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
    
    mov     ax,     2h   ;x co-ordinate
    push    ax
    mov     ax,     0Dh   ;y co-ordinate
    push    ax
    mov     ax,     instrucMess
    push    ax
    push    word[strlenInstrucMess]
    xor     ax,     ax
    mov     ah,     0x37
    push    ax
    call    printText
    
    ;Printing MAX Point Instruction

    mov     al,14
    mov     bl,2
    call    maxPointShape
    
    mov     ax,     7   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    mov     ax,     pointMsg
    push    ax
    push    word[pointMsgLength]
    xor     ax,     ax
    mov     ah,     0x72
    push    ax
    call    printText
    mov     ax,     0xA   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    mov     ax,     maxPointMsg
    push    ax
    push    word[maxMsgLength]
    xor     ax,     ax
    mov     ah,     0x72
    push    ax
    call    printText

    ;Printing MID Point Instruction

    mov     al,18
    mov     bl,2
    call    midPointShape
    
    mov     ax,     7   ;x co-ordinate
    push    ax
    mov     ax,     13h   ;y co-ordinate
    push    ax
    mov     ax,     pointMsg
    push    ax
    push    word[pointMsgLength]
    xor     ax,     ax
    mov     ah,     0x31
    push    ax
    call    printText
    mov     ax,     0xA   ;x co-ordinate
    push    ax
    mov     ax,     13h   ;y co-ordinate
    push    ax
    mov     ax,     midPointMsg
    push    ax
    push    word[midMsgLength]
    xor     ax,     ax
    mov     ah,     0x31
    push    ax
    call    printText

    ;Printing MIN Point Instruction

    mov     al,22
    mov     bl,2
    call    minPointShape
    
    mov     ax,     7   ;x co-ordinate
    push    ax
    mov     ax,     17h   ;y co-ordinate
    push    ax
    mov     ax,     pointMsg
    push    ax
    push    word[pointMsgLength]
    xor     ax,     ax
    mov     ah,     0x36
    push    ax
    call    printText
    mov     ax,     0xA   ;x co-ordinate
    push    ax
    mov     ax,     17h   ;y co-ordinate
    push    ax
    mov     ax,     minPointMsg
    push    ax
    push    word[minMsgLength]
    xor     ax,     ax
    mov     ah,     0x36
    push    ax
    call    printText

    ;Printing DEAD Point Instruction

    mov     al,14
    mov     bl,25
    call    holdMyTnt
    
    mov     ax,     1Eh   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    mov     ax,     pointMsg
    push    ax
    push    word[pointMsgLength]
    xor     ax,     ax
    mov     ah,     0x34
    push    ax
    call    printText
    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    mov     ax,     deadMsg
    push    ax
    push    word[deadMsgLength]
    xor     ax,     ax
    mov     ah,     0x34
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

maxPointShape:
    

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
    mov     ax,0x72C9       ; just printing shape afterwards
    STOSw 
    mov     ax,0x72B0
    STOSw 
    mov     ax,0x72BB
    STOSw 
    add     di,154
    mov     ax,0x72B0
    STOSw 
    mov     ax,0x72B2
    STOSw 
    mov     ax,0x72B0
    STOSw 
    add     di,154
    mov     ax,0x72C8
    STOSw
    mov     ax,0x72C9
    STOSw 
    mov     ax,0x72BC
    STOSw

    pop     cx
    pop     es
    pop     di

ret 

midPointShape:
    

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
    mov     ax,0x31C9       ; just printing shape afterwards
    STOSw 
    mov     ax,0x31B0
    STOSw 
    mov     ax,0x31BB
    STOSw 
    add     di,154
    mov     ax,0x31B0
    STOSw 
    mov     ax,0x31B2
    STOSw 
    mov     ax,0x31B0
    STOSw 
    add     di,154
    mov     ax,0x31C8
    STOSw
    mov     ax,0x31CD
    STOSw 
    mov     ax,0x31BC
    STOSw

    pop     cx
    pop     es
    pop     di

ret 

minPointShape:
    

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
    mov     ax,0x36C9       ; just printing shape afterwards
    STOSw 
    mov     ax,0x36CD
    STOSw 
    mov     ax,0x36BB
    STOSw 
    add     di,154
    mov     ax,0x36B0
    STOSw 
    mov     ax,0x36B2
    STOSw 
    mov     ax,0x36B0
    STOSw 
    add     di,154
    mov     ax,0x36C8
    STOSw
    mov     ax,0x36CD
    STOSw 
    mov     ax,0x36BC
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
    mov     al,4 ; row 
    mov     bl,4 ; column can be randomly selected using random function
    call    holdMyTnt
    
    mov     al,8 ; row 
    mov     bl,34 ; column can be randomly selected using random function
    call    holdMyTnt

    mov     al,12 ; row 
    mov     bl,64 ; column can be randomly selected using random function
    call    holdMyTnt
    
    
    mov     al,12 ; row 
    mov     bl,13 ; column can be randomly selected using random function
    call    maxPointShape

    mov     al,16 ; row 
    mov     bl,43; column can be randomly selected using random function
    call    maxPointShape

    mov     al,20 ; row 
    mov     bl,70 ; column can be randomly selected using random function
    call    maxPointShape

    mov     al,9 ; row 
    mov     bl,4; column can be randomly selected using random function
    call    midPointShape

    mov     al,13 ; row 
    mov     bl,34; column can be randomly selected using random function
    call    midPointShape

    mov     al,17 ; row 
    mov     bl,64; column can be randomly selected using random function
    call    midPointShape

    mov     al,6 ; row 
    mov     bl,13; column can be randomly selected using random function
    call    minPointShape

    mov     al,10 ; row 
    mov     bl,43; column can be randomly selected using random function
    call    minPointShape

    mov     al,14 ; row 
    mov     bl,70; column can be randomly selected using random function
    call    minPointShape

    ret
waitAWhile
    push    cx
    push    dx 
    push    ax

    mov     cx, 0x20
    mov     dx, 0x4240
    mov     al,0
    mov     ah, 86h
    int     15h

    pop     ax
    pop     dx
    pop     cx

ret
start:
    call    loadMainMenu
    call    waitAWhile
    call    loadEndPage
    call    waitAWhile
    call    loadGamePage
    ;hello bitches
    ;im done with this shit bro
    
mov 	ax, 	0x4c00
int 	21h