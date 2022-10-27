[org 0x0100]
jmp	start
score:      db      'Score: '
strlenScore:    db  7
time:       db      'Time: '
strlenTime: db      6

clearScreen:
    push    ax 
    push    es 
    push    di  
    push    si
    mov     ax,     0xb800
    mov     es,     ax
    mov     ax,     0x0320
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
    mov     al,     03h
    int     10h
    mov     ah,     09h
    mov     bh,     00h
    mov     al,     20h
    mov     cx,     800h    
    mov     bl,     3Fh
    int     10h
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
    mul     byte[bp+8]
    add     ax,     byte[bp+10]
    shl     ax,     1
    mov     di,     ax
    mov     si,     [bp+4]
    mov     cx,     [bp+2]
    mov     ah,     [bp+6]
    CLD
    nextChar:
        lodsb
        stosw
        loop    newChar
    
    pop     cx
    pop     si
    pop     di
    pop     es
    pop     ax
    pop     bp

    ret     8
setLocationOfText:
    mov     ax,     0   ;x co-ordinate
    push    ax
    mov     ax,     0   ;y co-ordinate
    push    ax
    mov     ax,     time
    push    ax
    push    byte[strlenTime]
    call    printText
    ret
start:
    ;call    blueScreen
    call    clearScreen
    call    setLocationOfText


mov 	ax, 	0x4c00
int 	21h