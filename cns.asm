[org 0x0100]
jmp	start
; Messages
score:      db      'Score: ',0
time:       db      'Time: ',0
welcomeMess:    db  'W E L C O M E !',0
cnsMess:    db  'C A T C H  &  C A R R Y',0
enterMess:  db  'Press Enter to Continue',0
newMsg: db 'Don',96,'t Let any other object hover above the pickaxe ',0
instrucMess:    db  'I N S T R U C T I O N S',0
endMessage:     db  'T H A N K  Y O U  F O R  P L A Y I N G!',0
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
;Messages

;Variables
oldSegPx:     dd  0
oldSegPx1:     dd  0

posOfPickaxe:   dw  25h
tickcount: dw 0 
tickseconds: dw 0 
tickmins: db 0 
Score: dw 0
timeOver: db 0
;Variable


printnum: 
    push bp 
    mov bp, sp 
    push es 
    push ax 
    push bx 
    push cx 
    push dx 
    push di 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    mov ax, [bp+4] ; load number in ax 
    mov bx, 10 ; use base 10 for division 
    mov cx, 0 ; initialize count of digits 
    nextdigit: mov dx, 0 ; zero upper half of dividend 
    div bx ; divide by 10 
    add dl, 0x30 ; convert digit into ascii value 
    push dx ; save ascii value on stack 
    inc cx ; increment count of values 
    cmp ax, 0 ; is the quotient zero 
    jnz nextdigit ; if no divide it again 
    mov di, [bp+6] ; point di to 70th column 
    nextpos: pop dx ; remove a digit from the stack 
    mov dh, 0x67 ; use normal attribute 
    mov [es:di], dx ; print char on screen 
    add di, 2 ; move to next screen location 
    loop nextpos ; repeat for all digits on stack 
    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax
    pop es 
    pop bp 
    ret 4
; timer interrupt service routine 
timer:
    push ax
    push es
    inc word [tickcount]; increment tick count

    mov ax,0xB800
    mov es, ax
    
    mov word ax, [tickcount]
    mov byte bl, 5
    mov cx, [tickseconds]
    div bl

    mov [tickseconds],al
    cmp cx,[tickseconds]
    je dontScroll
        mov ax,1 
        push ax ; push number of lines to scroll 
        call scrolldown
    dontScroll:
    mov ax, 176
    push ax
    push word [tickseconds]
    call printnum ; print tick count
    mov ax, [tickseconds] 
    cmp ax, 60
    jne dontIncMin
    mov word [tickseconds],0
    
    mov di,178
    mov word [es:di],0x6720
    mov word [tickcount],0
    mov ax,[tickmins]
    inc ax
    mov [tickmins],ax
    cmp byte[tickmins],10
    jne dontIncMin
    mov byte [timeOver],1
    mov bp,sp
    mov word[bp+4], timeEnded
    dontIncMin:
        mov di,174
        mov word [es:di], 0x673A
        mov ax, 172
        push ax
        push word [tickmins]
        call printnum ; print tick count
        mov al, 0x20 
        out 0x20, al ; end of interrupt
        pop es 
        pop ax 
    iret ; return from interrupt 
  
; subroutine to scrolls down the screen 
; take the number of lines to scroll as parameter 
scrolldown: 
    push bp 
    mov bp,sp 
    push ax 
    push cx 
    push si 
    push di 
    push es 
    push ds 
    mov ax, 80 ; load chars per row in ax 
    mul byte [bp+4] ; calculate source position 
    push ax ; save position for later use 
    shl ax, 1 ; convert to byte offset 
    mov si, 3198 ; last location on the screen 
    sub si, ax ; load source position in si 
    mov cx, 1520 ; number of screen locations 
    sub cx, ax ; count of words to move 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    mov ds, ax ; point ds to video base 
    mov di, 3198 ; point di to lower right column 
    std ; set auto decrement mode 
    rep movsw ; scroll up 
    mov ax, 0x6720 ; space in normal attribute 
    pop cx ; count of positions to clear 
    rep stosw ; clear the scrolled space 
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop bp 
    ret 2
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
    xor     ax,     ax
    mov     ax,     67h
    push    ax
    mov     ax,     time    ;points to string
    push    ax

    call    printText

    mov     ax,     40h   ;x co-ordinate
    push    ax
    mov     ax,     01h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ax,     67h
    push    ax
    mov     ax,     score
    push    ax

    call    printText

    ret

renderCatcher:
    push    bp
    mov     bp,     sp

    push    ax
    push    bx
    push    cx

    ;for printing stem of pickaxe
    mov     ax,     [bp+4]   ;x co-ordinate
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
    
    mov     ax,     [bp+4]   ;x co-ordinate
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

    mov     ax,     [bp+4]   ;x co-ordinate
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
    mov     ax,     [bp+4]   ;x co-ordinate
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
    mov     bx,     [bp+4]
    sub     bx,     3
    mov     ax,     bx   ;x co-ordinate
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

    mov     bx,     [bp+4]
    sub     bx,     2
    mov     ax,     bx   ;x co-ordinate
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

    mov     bx,     [bp+4]
    add     bx,     1
    mov     ax,     bx   ;x co-ordinate
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

    mov     bx,     [bp+4]
    add     bx,     3
    mov     ax,     bx   ;x co-ordinate
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

    pop     cx
    pop     bx
    pop     ax
    pop     bp
    ret     2
MainMenu:
    mov     ax,    0h 
    push    ax
    mov     ax,     7
    push    ax 
    mov     ax,     68h 
    push    ax 
    mov     ax,     text1
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax 
    mov     ax,     8
    push    ax
    mov     ax,     68h 
    push    ax 
    mov     ax,     text2
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax 
    mov     ax,     9
    push    ax
    mov     ax,     67h 
    push    ax 
    mov     ax,     text3
    push    ax  
    call    printText 
    mov     ax,     0h 
    push    ax 
    mov     ax,     10
    push    ax 
    mov     ax,     67h
    push    ax 
    mov     ax,     text4
    push    ax
    call    printText 
    mov     ax,    0h 
    push    ax 
    mov     ax,     11
    push    ax 
    mov     ax,     67h 
    push    ax 
    mov     ax,     text5
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax
    mov     ax,     12
    push    ax 
    mov     ax,     67h 
    push    ax 
    mov     ax,     text6
    push    ax 
    call    printText 
    mov     ax,     0h 
    push    ax
    mov     ax,     13
    push    ax 
    mov     ax,     67h 
    push    ax 
    mov     ax,     text7
    push    ax 
    call    printText 

    mov     ax,     12   ;x co-ordinate
    push    ax
    mov     ax,     0x12   ;y co-ordinate
    push    ax
    mov     ax,     67h     ;color
    push    ax
    mov     ax,     newMsg
    push    ax

    call    printText

    mov     ax,     1Bh   ;x co-ordinate
    push    ax
    mov     ax,     0x13   ;y co-ordinate
    push    ax
    mov     ax,     60h     ;color
    push    ax
    mov     ax,     enterMess
    push    ax

    call    printText
    
    

    ret

renderMyTnt: 

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
    mov     ax,     0x5020  ;Change these ones 
    
    mov     cx,     6
    rep     STOSW
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     16

    STOSW   
    mov     ax,     0x5020
    STOSW
    mov     cx,     4
    mov     ax,     0x8020
    rep     STOSW
    mov     ax,     0x5020
    STOSW
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     16
    STOSW   
    mov     ax,     0x5020
    STOSW
    mov     ax,     0x8020
    STOSW
    mov     ax,     0x5020
    STOSW
    STOSW
    mov     ax,     0x8020
    STOSW
    mov     ax,     0x5020
    STOSW
    mov     ax,     0x0020
    STOSW

    add     di,     160
    sub     di,     16

    STOSW   
    mov     ax,     0x5020
    STOSW
    mov     cx,     4
    mov     ax,     0x8020
    rep     STOSW
    mov     ax,     0x5020
    STOSW
    mov     ax,     0x0020
    STOSW

    

    add     di,     160
    sub     di,     16
    STOSW   
    mov     ax,     0x5020
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
    mov     ax,     15h   ;x co-ordinate
    push    ax
    mov     ax,     08h   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ax,     60h
    push    ax
    mov     ax,     endMessage
    push    ax
    call    printText

    mov     ax,     20h   ;x co-ordinate
    push    ax
    mov     ax,     0Dh   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ax,     60h
    push    ax
    mov     ax,     score
    push    ax
    call    printText
    ret

InstructionsPage:
    
    mov     ax,     28   ;x co-ordinate
    push    ax
    mov     ax,     2   ;y co-ordinate
    push    ax
    mov     ax,     0x67
    push    ax
    mov     ax,     instrucMess
    push    ax

    call    printText
  
    ;Printing MAX Point Instruction
    mov     ax,     8
    push    ax
    mov     ax,     6
    push    ax
    call    maxPointShape
  
    mov     ax,     19   ;x co-ordinate
    push    ax
    mov     ax,     10   ;y co-ordinate
    push    ax
    mov     ax,     0x67
    push    ax
    mov     ax,     pointMsg
    push    ax
    call    printText
 
    mov     ax,     21   ;x co-ordinate
    push    ax
    mov     ax,     10   ;y co-ordinate
    push    ax   
    xor     ax,     ax
    mov     ax,     0x67
    push    ax
 

    mov     ax,     maxPointMsg
    push    ax
    call    printText
    ;Printing MID Point Instruction
    mov     ax,     8
    push    ax
    mov     ax,     16
    push    ax
    call    midPointShape
    mov     ax,     19   ;x co-ordinate
    push    ax
    mov     ax,     20   ;y co-ordinate
    push    ax
    mov     ax,     0x67
    push    ax
    mov     ax,     pointMsg
    push    ax
    call    printText
    
    mov     ax,     21   ;x co-ordinate
    push    ax
    mov     ax,     20   ;y co-ordinate
    push    ax 
    mov     ax,     0x67
    push    ax
    mov     ax,     midPointMsg
    push    ax
    call    printText
    ;Printing MIN Point Instruction
    mov     ax,     48
    push    ax
    mov     ax,     6
    push    ax
    call    minPointShape
  
    mov     ax,     57   ;x co-ordinate
    push    ax
    mov     ax,     10   ;y co-ordinate
    push    ax
    mov     ax,     0x67
    push    ax
    mov     ax,     pointMsg
    push    ax
    call    printText
 
    mov     ax,     59   ;x co-ordinate
    push    ax
    mov     ax,     10   ;y co-ordinate
    push    ax   
    xor     ax,     ax
    mov     ax,     0x67
    push    ax
 

    mov     ax,     minPointMsg
    push    ax
    call    printText
    ;Printing DEAD Point Instruction
    mov     ax,     40
    push    ax
    mov     ax,     17
    push    ax
    call    renderMyTnt
    mov     ax,     57   ;x co-ordinate
    push    ax
    mov     ax,     20   ;y co-ordinate
    push    ax
    mov     ax,     0x67
    push    ax
    mov     ax,     pointMsg
    push    ax
    call    printText
    
    mov     ax,     59   ;x co-ordinate
    push    ax
    mov     ax,     20   ;y co-ordinate
    push    ax 
    mov     ax,     0x67
    push    ax
    mov     ax,     deadMsg
    push    ax
    call    printText
    
    ret


loadInstructionsPage:
    call    clearScreen
    call    InstructionsPage
    ret

loadMainMenu:
    call    clearScreen
    call    MainMenu
    pressEnter:
        mov ah,0
        int 16h
        cmp ah,28
        jne pressEnter

    ret
loadEndPage:
    call    clearScreen
    call    EndPage
    ret
scrollLeft:
    push bp 
    mov bp,sp 
    push ax 
    push cx 
    push si 
    push di 
    push es 
    push ds 
    mov si, [bp+6] ; last location on the screen 
    mov cx, 7 ; number of screen locations 
    ;sub cx, ax ; count of words to move 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    mov ds, ax ; point ds to video base 
    mov di, [bp+4] ; point di to lower right column 
    CLI
    rep movsw
    ;mov ax, 0x0620 ; space in normal attribute 
    ;mov cx, 2
    ;rep stosw ; clear the scrolled space 
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop bp 
    ret 4
scrollRight:

    ret
clearPickaxeArea:
    push    ax
    push    bx
    push    cx
    push    dx

    mov     cx,     4
    mov     bx,     17h
    loopToClearPickaxeArea:

    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     bx   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0xEE  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     20h
    push    ax
    mov     dx,     80
    push    dx
    call    printDesignShapes
    sub     bx,     1
    loop    loopToClearPickaxeArea

    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
movPickaxe:
    push ax
	push es
	mov ax, 0xb800
	mov es, ax 
    cmp     word [tickmins],     2 
    je endPickaxe
	in al, 0x60 
	
    cmp     al,     75
    jne     rightKey
    
    call    clearPickaxeArea
    xor     ax,     ax
    mov     ax,     [posOfPickaxe]
    cmp     ax,     5h
    je      dontMovLeft
    push    ax
    call    renderCatcher
    mov     ax,     [posOfPickaxe]
    sub     ax,     2
    mov     word[posOfPickaxe],     ax
    jmp     backFromDontMovLeft
    dontMovLeft:
    push    ax
    call    renderCatcher
    ;jmp     backFromDontMovLeft
    backFromDontMovLeft:
    jmp     endPickaxe
    
    rightKey:
    cmp     al,    77
    jne     endPickaxe
    call    clearPickaxeArea
    xor     ax,     ax
    mov     ax,     [posOfPickaxe]
    cmp     ax,     49h
    je      dontMovRight
    push    ax
    call    renderCatcher
    add     ax,     2
    mov     word[posOfPickaxe],     ax
    jmp     backFromDontMovRight
    dontMovRight:
    push    ax
    call    renderCatcher
    ;jmp     backFromDontMovRight
    backFromDontMovRight:
    jmp     endPickaxe

  
    endPickaxe:
    pop es
    pop ax
    jmp far [cs:oldSegPx]
    
loadGamePage:
    push    ax
    push    bx
    push    es

    call    clearScreen
    call    renderScoreNTime
    mov     ax,     [posOfPickaxe]
    push    ax
    call    renderCatcher
    ; maybe a loop to call it again and again
    mov     ax,     4 ; column 
    push    ax
    mov     ax,     4 ; row can be randomly selected using random function
    push    ax
    call    renderMyTnt
    
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

    xor     ax,     ax
    mov     es,     ax
    mov     ax,     [es:9*4]
    mov     [oldSegPx], ax
    mov     ax,     [es:9*4+2]
    mov     [oldSegPx+2],   ax
    CLI
    mov     word[es:9*4],   movPickaxe
    mov     [es:9*4+2],   cs
    STI
    restorePickaxe:
        mov     ah,     0
        int     16h

        jmp     restorePickaxe

    timeEnded:
        mov     ax,     [oldSegPx]
        mov     bx,     [oldSegPx+2]
        CLI
        mov     [es:9*4],   ax
        mov     [es:9*4+2],   bx
        STI
        mov     ax,     [oldSegPx1]
        mov     bx,     [oldSegPx1+2]
        CLI
        mov     [es:8*4],   ax
        mov     [es:8*4+2],   bx
        STI
    pop     es
    pop     bx
    pop     ax
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
hookTimer:
    push ax 
    push es
    xor ax, ax 
    mov es, ax ; point es to IVT base 
    mov     ax,     [es:8*4]
    mov     [oldSegPx1], ax
    mov     ax,     [es:8*4+2]
    mov     [oldSegPx1+2],   ax
    cli ; disable interrupts 
    mov word [es:8*4], timer; store offset at n*4 
    mov [es:8*4+2], cs ; store segment at n*4+2 
    sti

    pop es 
    pop ax


    ret 



start:
    call    loadMainMenu
    call    loadInstructionsPage
    call    waitAWhile
    call    hookTimer
    call    loadGamePage
    
    call    loadEndPage
    
    mov 	ax, 	0x4c00
    int 	21h