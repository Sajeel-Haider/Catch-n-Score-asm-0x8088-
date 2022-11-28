[org 0x0100]
jmp	start
;----------------------------------------------------------------------------------------------------------------
; Messages
score:      db      'Score: ',0
time:       db      'Time: ',0
welcomeMess:    db  'W E L C O M E !',0
cnsMess:    db  'C A T C H  &  C A R R Y',0
enterMess:  db  'Press Enter to Continue',0
newMsg: db '       D o d g e  t h e  T N T  (ITS ALL UP TO YOU)',0
instrucMess:    db  'I N S T R U C T I O N S',0
endMessage:     db  'T H A N K  Y O U  F O R  P L A Y I N G!',0
deadMsg:     db  'Y O U  D I E ',0
maxPointMsg:     db  '15 Points ',0
midPointMsg:     db  '10 Points ',0
minPointMsg:     db  '5 Points',0
timeLimitMsg: db 'The Time has Reached 2 min Press any key to continue ',0
pointMsg:     db  '>',0
tnt1: db '_   _',0
tnt2: db '||\||',0
endMsg1: db 'The time was over',0
endMsg2: db 'You got crashed',0
endMsg3: db 'You got crashed. Press Any Key to Continue',0
text1: db'    __   ___  _____   __  __ __      ____       _____   __   ___   ____     ___ ',0
text2: db'   /  ] /   ||     | /  ]|  |  |    |    \     / ___/  /  ] /   \ |    \   /  _]',0
text3: db'  /  / |  o ||     |/  / |  |  | __ |  _  | __(   \_  /  / |     ||  D  ) /  [_ ',0
text4: db' /  /  |    ||_| |_/  /  |  _  ||  ||  |  ||  |\__  |/  /  |  O  ||    / |    _]',0
text5: db'/   \_ |  _ |  | |/   \_ |  |  ||__||  |  ||__|/  \ /   \_ |     ||    \ |   [_ ',0
text6: db'\     ||  | |  | |\     ||  |  |    |  |  |    \    \     ||     ||  .  \|     |',0
text7: db' \____||__|_|  |_| \____||__|__|    |__|__|     \___|\____| \___/ |__|\_||_____|',0
;Messages
;-------------------------------------------------------------------------------------------------------------------
;Variables

posOfPickaxe:   dw  25h
oldSegPx:     dd  0
oldSegPx1:     dd  0
seed: dw 1
seed1: dw 1
carry: db 0
scrollTime: dw 4        ;Starting Srcoll
tickcount: dw 0 
tickseconds: db 0 
tickmins: db 0 
timeOver: db 0

spawnTime: dw 21         ;Starting Spawn
Score: dw 0
tntHit: db  1

;Variable
;---------------------------------------------------------------------------------------------------------------------
;=====================================================================================================================
;..................................................................................................................     
RANDSTART:
    ; generate a rand no using the system          ; generate a rand no using the system time
    push bp
    mov bp,sp
    push ax
    push bx

    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx
   
    add al,[carry]  ;
    add ah,[tickcount]
    mov bx,[bp+4]
    cmp bx,1
    jne nextSeed
    mov bx,[seed1]
    jmp endSeed
    nextSeed:
    mov bx,[seed]
    endSeed:
    mov   dx, bx
    mov  cx, [bp+6]
    div  cx       
    add dl,[bp+8]
    mov [carry],al
    mov bx,[bp+4]
    cmp bx,1
    jne nextSeed1
    mov [seed1],dx
    jmp endSeed1
    nextSeed1:
    mov [seed],dx
    mov bx,[seed]
    cmp bx,[bp+6]
    jb endSeed1
    mov bx,[bp+8]
    sub [seed],bx

    endSeed1:

    pop bx
    pop ax
    pop bp
    RET    6
detectComingObjLocation:
    push    ax
    push    bx
    xor     ax,     ax

    mov     bl,     13h
    mov     al,     80
    mul     bl
    add     ax,     [posOfPickaxe]
    shl     ax,     1
    mov     si,     ax  
    pop     bx
    pop     ax
    ret
clearGameScreen:
    push    ax
    push    bx
    push    cx
    push    dx

    mov     cx,     4
    mov     bx,     16
    loopToClearGameArea:

    mov     ax,     00h   ;x co-ordinate
    push    ax
    mov     ax,     bx   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ah,     0x67  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     20h
    push    ax
    mov     dx,     80
    push    dx
    call    printDesignShapes
    add     bx,     1
    loop    loopToClearGameArea

    pop     dx
    pop     cx
    pop     bx
    pop     ax
    ret
    
dontScrollmid:
    jmp     dontScroll
objectDetected:

      
        cmp     word[es:si],0x002D
        jne     check0INdex
        cmp     byte[spawnIndex+2],   1
        jne     check2Index
        add     word[Score],    15
        call    clearGameScreen
        jmp     shortJmp
        check2Index:
        cmp     byte[spawnIndex+2],   2
        jne     check3Index
        add     word[Score],    10
        call    clearGameScreen
        
        jmp     shortJmp
        check3Index:
        cmp     byte[spawnIndex+2],   3
        jne     check0INdex
        add     word[Score],    5
        call    clearGameScreen
        jmp     shortJmp
        check0INdex:
        cmp     word[es:si], 0x442D
        jne     notTnt
        cmp     byte[spawnIndex+2],   0
        jne     shortJmp
        mov     word[tntHit],   0
        notTnt:
        jmp     shortJmp


        shortJmp: 
            jmp noObject

scrollAndSpawnCheck:
    push cx
    push dx
    push ax
    push es
    push si

    mov cx, [tickcount]
    cmp cx,[scrollTime]        ; This Code tell the speed of scroll down Which is based on per second rn 
    jne dontScrollmid
        add word [scrollTime],4; Scrolling time selection

        mov ax,[scrollTime]
        mov dx,0
        mov cx, 1080
        div cx
        mov [scrollTime],dx
        push 1
        call scrolldown
         
        
        ; Add your code here to compare the pickaxe above
        ;calculate 
        call    detectComingObjLocation

        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected  
        sub     si,     2  
        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected
        sub     si,     2  
        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected
        sub     si,     2  
        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected
        add     si,     8
        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected
        add     si,     2
        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected
        add     si,     2
        mov     ax,     word[es:si]
        cmp     ax,     0x6720
        
        jne      objectDetected
        

        noObject:


        ;here jump
    dontScroll:
    mov cx,[tickcount]
    cmp cx, [spawnTime]
    jne dontSpawn
        call spawnObject
        add word [spawnTime],21;Spawning Time selection
        xor dx,dx
        mov ax,[spawnTime]
        mov cx,1080
        div cx
        mov [spawnTime],dx
    dontSpawn:


    pop si
    pop es
    pop ax
    pop dx
    pop cx

    ret

spawnObject:
    push ax
    push cx
    push dx


    mov ax,0
    push ax
    mov ax,4
    push ax
    mov ax,1
    push ax
    call RANDSTART
    mov bl,dl
    mov ax,4
    push ax
    mov ax,60
    push ax
    mov ax,0
    push ax

    call RANDSTART
    mov bh, dl
    mov ax,[spawnIndex+1]
    mov [spawnIndex+2],ax
    mov ax, [spawnIndex]
    mov [spawnIndex+1],ax
    mov [spawnIndex],bl


    cmp bl,0
    jne nextSpawn
    xor     ax, ax
    mov     al,     bh ; column 
    push    ax
    mov     ax,     4 ; row can be randomly selected using random function
    push    ax
    call    renderMyTnt
    mov byte[spawnIndex],0
    jmp finishSpawn
    
    nextSpawn:
    cmp bl,1
    jne nextSpawn1
    xor     ax, ax
    mov     al,     bh ; column 
    push    ax
    mov     ax,     4 ; row can be randomly selected using random function
    push    ax
    call    maxPointShape
    mov byte[spawnIndex],1
    jmp finishSpawn
    

    nextSpawn1:
    cmp bl,2
    jne nextSpawn2
    xor     ax, ax
    mov     al,     bh ; column 
    push    ax
    mov     ax,     4 ; row can be randomly selected using random function
    push    ax
    call    midPointShape
    mov byte[spawnIndex],2
    jmp finishSpawn
    
    
    nextSpawn2:
    xor     ax, ax
    mov     al,     bh ; column 
    push    ax
    mov     ax,     4 ; row can be randomly selected using random function
    push    ax
    call    minPointShape
    mov byte[spawnIndex],3
    finishSpawn:
     
    pop dx
    pop cx
    pop ax

    ret

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
    cmp byte[timeOver], 1
    je printLimitMsg
    
    cmp     word[tntHit],   0
    jne     dontCrash
    ;print tnt hit
    mov     ax,     20   ;x co-ordinate
    push    ax
    mov     ax,     2   ;y co-ordinate
    push    ax
    mov     ax,     0x67
    push    ax
    mov     ax,     endMsg3
    push    ax
    call    printText
    jmp     dontPrintLimitMsg

    dontCrash:
    inc word [tickcount]; increment tick count

    mov ax,0xB800
    mov es, ax
    
    mov ax, [tickcount]
    mov bl, 18                       ; Time controller
    div bl
    mov byte [tickseconds],al
    cmp byte [tickseconds], 60
    jne dontIncMin
    mov byte [tickseconds],0
    inc byte [tickmins]
    mov word [tickcount],0
    
    mov di,178
    mov word [es:di],0x6720
    dontIncMin:


    cmp byte[tickmins],2
    jne dontEnd
    mov byte [timeOver],1
    jmp printLimitMsg
    dontEnd:
    
    call scrollAndSpawnCheck
    call printTimeFormat
    mov di,174
    mov word [es:di], 0x673A
    
        
    jmp dontPrintLimitMsg
    printLimitMsg:
        mov     ax,    13
        push    ax
        mov     ax,     13
        push    ax 
        mov     ax,     67h 
        push    ax 
        mov     ax,     timeLimitMsg
        push    ax 
        call    printText 
        mov     byte [tickseconds],0
        mov     word [tickmins],2
        call printTimeFormat
    
    dontPrintLimitMsg:   
        mov al, 0x20 
        out 0x20, al ; end of interrupt
        pop es 
        pop ax 


    iret ; return from interrupt 
  
    ; subroutine to scrolls down the screen 
    ; take the number of lines to scroll as parameter 

printTimeFormat:
    push ax
    push di


    mov ax, 176
    push ax
    xor ax,ax
    mov al,[tickseconds]
    push ax
    call printnum ; print tick count
    
    xor     ax,     ax
    mov ax, 306
    push ax
    push word [Score]
    call printnum
    
    xor     ax,     ax
    mov ax, 172
    push ax
    push word [tickmins]
    call printnum ; print tick count
    pop di
    pop ax
    ret
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
    mov     ah,     0x67  ;color of the space
    push    ax
    xor     ax,     ax
    mov     al,     0x20
    push    ax
    mov     cx,     2000
    push    cx
    call    printDesignShapes
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
    mov     cx,     7
    mov     ax,     0x4020       ; just printing shape afterwards
    rep     STOSw 
    
    add     di,     160
    sub     di,     14
    mov     cx,     2
    mov     ax,     0x7020
    rep     STOSw
	mov 	ah,		0x70 
    mov     al,     'T'
    STOSw 
    mov     al,     'N'
    STOSw 
    mov     al,     'T'
    STOSw 

    mov     cx,     2
    mov     ax,     0x7020
    rep     STOSw
	

    add     di,     160
    sub     di,     14
    mov     cx,     7
    mov     ax,     0x442D
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
    mov     cx,     3
    mov     ax,     0x0020
    rep     STOSW   
    add     di,     160
    sub     di,     8
    STOSW   
    mov     ax,     0x3020
    mov     cx,     3
    rep     STOSW
    mov     ax,     0x0020
    STOSW
    
    add     di,     160
    sub     di,     12
    
    STOSW   
    mov     ax,     0x3020
    push    cx
    mov     cx,     5
    
    rep     STOSw
    pop     cx
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     12
    mov 	cx,		5
    mov     ax,     0x002D
    rep STOSW
    

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
    mov     cx,     3
    mov     ax,     0x0020
    rep     STOSW   
    add     di,     160
    sub     di,     8
    STOSW   
    mov     ax,     0x2020
    mov     cx,     3
    rep     STOSW
    mov     ax,     0x0020
    STOSW
    
    add     di,     160
    sub     di,     12
    
     
    STOSW   
    mov     ax,     0x2020
    push    cx
    mov     cx,     5
    
    rep     STOSw
    pop     cx
    mov     ax,     0x0020
    STOSW
    add     di,     160
    sub     di,     12

    mov 	cx,		5
    mov     ax,     0x002D
    rep STOSW
    

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
    mov     cx,     2
    mov     ax,     0x0020
    rep     STOSW
	add 	di,		2
	mov     cx,		2
	rep     STOSW
	add     di,     160
    sub     di,     12
	
    STOSW   
	mov 	ax,		0x4020
	mov		cx,		2
	rep     STOSW
	mov     ax,		0x0020
	STOSW
	mov 	ax,		0x4020
	mov		cx,		2
	rep     STOSW
	mov 	ax,		0x0020
	STOSW
    
	add     di,     160
    sub     di,     14

	STOSW
	mov 	cx,		5
	mov 	ax,		0x4020
	rep 	STOSW
	mov 	ax,		0x0020
	STOSW
	add		di,		160
	sub  	di,		12
	
	STOSW
	mov 	cx,		4
	mov 	ax,		0x4020
	
	mov 	ax,		0x002D
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
    cmp byte [timeOver],1
    jne msgNo2
    mov     ax,     30   ;x co-ordinate
    push    ax
    mov     ax,     10   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ax,     67h
    push    ax
    mov     ax,     endMsg1
    push    ax
    call    printText
    jmp msgNo1
    msgNo2:
    mov     ax,     30   ;x co-ordinate
    push    ax
    mov     ax,     10   ;y co-ordinate
    push    ax
    xor     ax,     ax
    mov     ax,     67h
    push    ax
    mov     ax,     endMsg2
    push    ax
    call    printText
    msgNo1:

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
    mov ax, 2162
    push ax
    push word [Score]
    call printnum
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
    mov     ax,     11
    push    ax
    mov     ax,     8
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
    mov     ax,     11
    push    ax
    mov     ax,     18
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
    mov     ax,     49
    push    ax
    mov     ax,     8
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
    mov     ax,     47
    push    ax
    mov     ax,     19
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
    mov     ah,     0x67  ;color of the space
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
    sub     ax,     2
    mov     word[posOfPickaxe],     ax
    mov     ax,     [posOfPickaxe]
    cmp     ax,     5h
    je      dontMovLeft
    push    ax
    call    renderCatcher
    jmp     backFromDontMovLeft
    dontMovLeft:
    push    ax
    call    renderCatcher
    backFromDontMovLeft:
    jmp     endPickaxe
    
    rightKey:
    cmp     al,    77
    jne     endPickaxe
    call    clearPickaxeArea
    xor     ax,     ax
    mov     ax,     [posOfPickaxe]
    add     ax,     2
    mov     word[posOfPickaxe],     ax
    cmp     ax,     49h
    je      dontMovRight
    push    ax
    call    renderCatcher
    jmp     backFromDontMovRight
    dontMovRight:
    push    ax
    call    renderCatcher
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
    call    spawnObject

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
        cmp     byte [tickmins],2
        je     endLoop
        cmp     byte [tntHit], 0
        jne restorePickaxe
        ;tnt hit

    endLoop:
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

    ;-----------------------------------------------------------------------------------------------------------------
    
    ;heh:
    ;call timer
    ;jmp heh
    ;call    loadMainMenu
    ;call    loadInstructionsPage
    ;call    waitAWhile
    call    hookTimer
    call    loadGamePage
    ;call    loadEndPage
    
    ;-----------------------------------------------------------------------------------------------------------------
    mov 	ax, 	0x4c00
    int 	21h


spawnIndex: db 10,10,10