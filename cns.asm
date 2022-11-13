[org 0x0100]
jmp	start
score:      db      'Score: ',0
time:       db      'Time: ',0
welcomeMess:    db  'W E L C O M E !',0
cnsMess:    db  'C A T C H  &  C A R R Y',0
enterMess:  db  'Press Enter to Continue',0
instrucMess:    db  'Instructions :',0
endMessage:     db  'Thank you for playing!',0
deadMsg:     db  'Y O U  D I E ',0
maxPointMsg:     db  '15 Points ',0
midPointMsg:     db  '10 Points ',0
minPointMsg:     db  '5 Points',0
pointMsg:     db  '>',0
tnt1: db '_   _',0
tnt2: db '||\||',0

text1: db'    __   ___  _____   __  __ __      ____       _____   __   ___   ____     ___ ',0
text2: db'   /  ] /   ||     | /  ]|  |  |    |    \     / ___/  /  ] /   \ |    \   /  _]',0
text3: db'  /  / |  o ||     |/  / |  |  | __ |  _  | __(   \_  /  / |     ||  D  ) /  [_ ',0
text4: db' /  /  |    ||_| |_/  /  |  _  ||  ||  |  ||  |\__  |/  /  |  O  ||    / |    _]',0
text5: db'/   \_ |  _ |  | |/   \_ |  |  ||__||  |  ||__|/  \ /   \_ |     ||    \ |   [_ ',0
text6: db'\     ||  | |  | |\     ||  |  |    |  |  |    \    \     ||     ||  .  \|     |',0
text7: db' \____||__|_|  |_| \____||__|__|    |__|__|     \___|\____| \___/ |__|\_||_____|',0
                                                                                        




clearScreen:
    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     00h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xEE  ;color of the space
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
    push    es 
    push    ax 
    push    cx 
    push    si 
    push    di 
    push    ds 
    pop     es 
    mov     di,     [bp+4] 
    mov     cx,     0xffff 
    xor     al,     al
    repne   scasb  
    mov     ax,     0xffff 
    sub     ax,     cx 
    dec     ax  
    jz      exit 
    mov     cx,     ax 
    mov     ax,     0xb800 
    mov     es,     ax 
    mov     al,     80 
    mul     byte [bp+8] 
    add     ax,     [bp+10]
    shl     ax,     1 
    mov     di,     ax  
    mov     si,     [bp+4] 
    mov     ah,     [bp+6] 
    cld                     
    nextchar:       
            lodsb 
            stosw 
            loop    nextchar 
    exit: 
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 8 
renderScoreNTime:
    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     01h   ;y co-ordinate
    push    ax
    mov     ah,     07h
    push    ax
    mov     ax,     time    ;points to string
    push    ax

    call    printText

    mov     ax,     40h   ;x co-ordinate
    push    ax
    mov     ax,     01h   ;y co-ordinate
    push    ax
    mov     ah,     07h
    push    ax
    mov     ax,     score
    push    ax

    call    printText

    ret

renderCatcher:
    ;for printing stem of pickaxe
    mov     ax,     25h   ;x co-ordinate
    push    ax
    mov     ax,     17h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x06  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xB0
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes
    
    mov     ax,     25h   ;x co-ordinate
    push    ax
    mov     ax,     16h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x06  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xB0
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes

    mov     ax,     25h   ;x co-ordinate
    push    ax
    mov     ax,     15h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x06  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xB0
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes
    ;for axe handle itself
    mov     ax,     25h   ;x co-ordinate
    push    ax
    mov     ax,     14h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x06  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xBB
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes
    ;for axe itself
    mov     ax,     22h   ;x co-ordinate
    push    ax
    mov     ax,     14h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x63  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xC9
    push    ax
    mov     cx,     03h
    push    cx
    call    printDesignShapes

    mov     ax,     23h   ;x co-ordinate
    push    ax
    mov     ax,     14h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xB6  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xCD
    push    ax
    mov     cx,     02h
    push    cx
    call    printDesignShapes

    mov     ax,     26h   ;x co-ordinate
    push    ax
    mov     ax,     14h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xB6  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xCD
    push    ax
    mov     cx,     02h
    push    cx
    call    printDesignShapes

    mov     ax,     28h   ;x co-ordinate
    push    ax
    mov     ax,     14h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x63  ;color of the space   1st color of att and 2nd is background
    push    ax
    xor     ax,     ax
    mov     al,     0xBB
    push    ax
    mov     cx,     01h
    push    cx
    call    printDesignShapes
    ret
MainMenu:
    mov     ax,    0h 
    push    ax
    mov     ax,     2h
    push    ax 
    mov     ax,     8h 
    push    ax 
    mov     ax,     text1
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax 
    mov     ax,     3h
    push    ax
    mov     ax,     8h 
    push    ax 
    mov     ax,     text2
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax 
    mov     ax,     4h
    push    ax
    mov     ax,     7h 
    push    ax 
    mov     ax,     text3
    push    ax  
    call    printText 
    mov     ax,     0h 
    push    ax 
    mov     ax,     5h
    push    ax 
    mov     ax,     7h
    push    ax 
    mov     ax,     text4
    push    ax
    call    printText 
    mov     ax,    0h 
    push    ax 
    mov     ax,     6h
    push    ax 
    mov     ax,     7h 
    push    ax 
    mov     ax,     text5
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax
    mov     ax,     7h
    push    ax 
    mov     ax,     7h 
    push    ax 
    mov     ax,     text6
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax
    mov     ax,     7h
    push    ax 
    mov     ax,     7h 
    push    ax 
    mov     ax,     text7
    push    ax 
    call    printText 

    mov     ax,     1Bh   ;x co-ordinate
    push    ax
    mov     ax,     0Ah   ;y co-ordinate
    push    ax
    mov     ax,     34h     ;color
    push    ax
    mov     ax,     enterMess
    push    ax

    call    printText
    
    mov     ax,     2h   ;x co-ordinate
    push    ax
    mov     ax,     0Dh   ;y co-ordinate
    push    ax
    mov     ax,     0x37
    push    ax
    mov     ax,     instrucMess
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
    mov     ax,     0x72
    push    ax
    mov     ax,     pointMsg
    push    ax

 
    call    printText
    mov     ax,     0xA   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x31
 
    push    ax
    mov     ax,     maxPointMsg
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
    mov     ax,     0x31
    push    ax
    mov     ax,     pointMsg
    push    ax

    
    call    printText
    mov     ax,     0xA   ;x co-ordinate
    push    ax
    mov     ax,     13h   ;y co-ordinate
    push    ax
    mov     ax,     0x31
    push    ax 
    mov     ax,     midPointMsg
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
    mov     ax,     0x36
    push    ax
    mov     ax,     pointMsg
    push    ax


    call    printText
    mov     ax,     0xA   ;x co-ordinate
    push    ax
    mov     ax,     17h   ;y co-ordinate
    push    ax
    mov     ax,     0x36
    push    ax
    mov     ax,     minPointMsg
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
    xor     ax,     ax
    mov     ax,     0x34
    push    ax
    mov     ax,     pointMsg
    push    ax
    
    call    printText
    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     0Fh   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ax,     0x34
    push    ax
    mov     ax,     deadMsg
    push    ax
    
    call    printText


    ret

holdMyTnt: 

    push    bp
    mov     bp,     sp     
    push    di
    push    es
    push    cx    

    mov     cx,     80
    xor     ax,     ax
    mov     al,     [bp+4]
    mul     cl
    add     ax,     [bp+6]
    shl     ax,     1
    mov     di,     ax           ; selecting location on screen
    mov     ax,     0xB800
    mov     es,     ax
    CLD
    mov     cx,     15
    mov     ax,     0x4020       ; just printing shape afterwards
    rep     STOSw 
    add     di,     160
    sub     di,     30
    mov     cx,     15
    mov     ax,     0x4020       ; just printing shape afterwards
    rep     STOSw 
    add     di,     160
    sub     di,     30
    mov     cx,     5
    mov     ax,     0x7020
    rep     STOSw 
    mov     ax,     0x705F
    STOSw 
    mov     ax,     0x7020
    STOSw 
    mov     ax,     0x7020
    STOSw 
    
    mov     ax,     0x7020
    STOSw 
    mov     ax,     0x705F
    STOSw 
    mov     cx,     5
    mov     ax,     0x7020
    rep     STOSw 
     
    add     di,     160
    sub     di,     30
    mov     cx,     5
    mov     ax,     0x7020
    rep     STOSw 
    mov     ax,     0x707C
    STOSw 
    mov     ax,     0x707C
    STOSw 
    mov     ax,     0x705C
    STOSw 
    
    mov     ax,     0x707C
    STOSw 
    mov     ax,     0x707C
    STOSw 
    mov     cx,     5
    mov     ax,     0x7020
    rep     STOSw 
     
    add     di,     160
    sub     di,     30
    
    mov     cx,     15
    mov     ax,     0x4020       ; just printing shape afterwards
    rep     STOSw 
    add     di,     160
    sub     di,     30
    mov     cx,     15
    mov     ax,     0x4020       ; just printing shape afterwards
    rep     STOSw 

    pop     cx
    pop     es
    pop     di
    pop     bp

    ret     4

maxPointShape:
    

    push    bp
    mov     bp,     sp     
    push    di
    push    es
    push    cx    

    mov     cx,     80
    xor     ax,     ax
    mov     al,     [bp+4]
    mul     cl
    add     ax,     [bp+6]
    shl     ax,     1
    mov     di,     ax           ; selecting location on screen
    mov     ax,     0xB800
    mov     es,     ax
    CLD
    mov     cx,     6
    mov     ax,     0x0020
    rep     STOSW   
    add     di,     160
    sub     di,     14
    STOSW   
    mov     ax,     0x3020
    mov     cx,     6
    rep     STOSW
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     18
    
    STOSW   
    mov     ax,     0x3020
    mov     cx,     8
    
    rep     STOSw
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     22
    mov     cx,     3
    l1: 
        STOSW   
        mov     ax,     0x3020
        push    cx
        mov     cx,     10
        
        rep     STOSw
        pop     cx
        mov     ax,     0x0020
        STOSW
        add     di,     160
        sub     di,     24
        loop    l1

    add     di,     2
    STOSW   
    mov     ax,     0x3020
    mov     cx,     8
    
    rep     STOSw
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     18
    mov     cx,     8
    rep     STOSW


    pop     cx
    pop     es
    pop     di
    pop     bp

    ret     4


midPointShape:
    

    push    bp
    mov     bp,     sp     
    push    di
    push    es
    push    cx    

    mov     cx,     80
    xor     ax,     ax
    mov     al,     [bp+4]
    mul     cl
    add     ax,     [bp+6]
    shl     ax,     1
    mov     di,     ax           ; selecting location on screen
    mov     ax,     0xB800
    mov     es,     ax
    CLD
    mov     cx,     6
    mov     ax,     0x0020
    rep     STOSW   
    add     di,     160
    sub     di,     14
    STOSW   
    mov     ax,     0x2020
    mov     cx,     6
    rep     STOSW
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     18
    
    STOSW   
    mov     ax,     0x2020
    mov     cx,     8
    
    rep     STOSw
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     22
    mov     cx,     3
    l2: 
        STOSW   
        mov     ax,     0x2020
        push    cx
        mov     cx,     10
        
        rep     STOSw
        pop     cx
        mov     ax,     0x0020
        STOSW
        add     di,     160
        sub     di,     24
        loop    l2

    add     di,     2
    STOSW   
    mov     ax,     0x2020
    mov     cx,     8
    
    rep     STOSw
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     18
    mov     cx,     8
    rep     STOSW


    pop     cx
    pop     es
    pop     di
    pop     bp

    ret     4


minPointShape:
    

    push    bp
    mov     bp,     sp     
    push    di
    push    es
    push    cx    

    mov     cx,     80
    xor     ax,     ax
    mov     al,     [bp+4]
    mul     cl
    add     ax,     [bp+6]
    shl     ax,     1
    mov     di,     ax       
    mov     ax,     0xB800
    mov     es,     ax
    CLD
    mov     cx,     6
    mov     ax,     0x0020
    rep     STOSW   
    add     di,     160
    sub     di,     14
    STOSW   
    mov     ax,     0xE020  ;Change these ones 
    
    mov     cx,     6
    rep     STOSW
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     16

    STOSW   
    mov     ax,     0xE020
    STOSW
    mov     cx,     4
    mov     ax,     0x8020
    rep     STOSW
    mov     ax,     0xE020
    STOSW
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     16
    STOSW   
    mov     ax,     0xE020
    STOSW
    mov     ax,     0x8020
    STOSW
    mov     ax,     0xE020
    STOSW
    STOSW
    mov     ax,     0x8020
    STOSW
    mov     ax,     0xE020
    STOSW
    mov     ax,     0x0020
    STOSW

    add     di,     160
    sub     di,     16

    STOSW   
    mov     ax,     0xE020
    STOSW
    mov     cx,     4
    mov     ax,     0x8020
    rep     STOSW
    mov     ax,     0xE020
    STOSW
    mov     ax,     0x0020
    STOSW

    

    add     di,     160
    sub     di,     16
    STOSW   
    mov     ax,     0xE020
    mov     cx,     6
    rep     STOSW
    mov     ax,     0x0020
    STOSW

    add     di,     160
    sub     di,     14

    mov     cx,     6
    mov     ax,     0x0020
    rep     STOSW   
    
     
  
    

    pop     cx
    pop     es
    pop     di
    pop     bp

    ret     4

    

    

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
    xor     ax,     ax
    mov     ah,     30h
    push    ax
    mov     ax,     endMessage
    push    ax
    call    printText

    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     0Dh   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x34
    push    ax

    mov     ax,     score
    push    ax
    call    printText
    ret
loadMainMenu:
    call    clearScreen
    call    MainMenu
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
    mov     ax,     4 ; column 
    push    ax
    mov     ax,     4 ; row can be randomly selected using random function
    push    ax
    call    holdMyTnt
    
    mov     ax,     34 ; column
    push    ax 
    mov     ax,     8 ; row can be randomly selected using random function
    push    ax
    call    maxPointShape

    mov     ax,     64 ; column
    push    ax 
    mov     ax,     12 ; row can be randomly selected using random function
    push    ax
    call    midPointShape
    
    
    mov     ax,     2 ; column
    push    ax 
    mov     ax,     14 ; row can be randomly selected using random function
    push    ax
    call    minPointShape

    ;mov     al,16 ; row 
    ;mov     bl,43; column can be randomly selected using random function
    ;call    maxPointShape
;
    ;mov     al,20 ; row 
    ;mov     bl,70 ; column can be randomly selected using random function
    ;call    maxPointShape
;
    ;mov     al,9 ; row 
    ;mov     bl,4; column can be randomly selected using random function
    ;call    midPointShape
;
    ;mov     al,13 ; row 
    ;mov     bl,34; column can be randomly selected using random function
    ;call    midPointShape
;
    ;mov     al,17 ; row 
    ;mov     bl,64; column can be randomly selected using random function
    ;call    midPointShape
;
    ;mov     al,6 ; row 
    ;mov     bl,13; column can be randomly selected using random function
    ;call    minPointShape
;
    ;mov     al,10 ; row 
    ;mov     bl,43; column can be randomly selected using random function
    ;call    minPointShape
;
    ;mov     al,14 ; row 
    ;mov     bl,70; column can be randomly selected using random function
    ;call    minPointShape

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
    ;call    loadMainMenu
    ;call    waitAWhile
    ;call    loadGamePage
    ;call    loadMainMenu
    ;call    waitAWhile
    call    loadGamePage
    ;call    waitAWhile
    ;call    loadEndPage
    
mov 	ax, 	0x4c00
int 	21h