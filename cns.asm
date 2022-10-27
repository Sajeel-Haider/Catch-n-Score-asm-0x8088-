[org 0x0100]
jmp	start
score:      dw      'Score: '
time:       dw      'Time: '
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

printScore:

start:
    call    blueScreen
    


mov 	ax, 	0x4c00
int 	21h