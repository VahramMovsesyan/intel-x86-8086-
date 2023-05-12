.model small
.stack 256
.data 
    str1 db 8,9 dup(?)
    str2 db 4,5 dup(?)
    no db "NO$"
.code
start:
    mov ax,@data
    mov ds,ax

    mov ah,10
    lea dx,str1
    int 21h

    call entr

    mov ah,10
    lea dx,str2
    int 21h

    mov si, 2
    mov di, 2
    mov cl, str1[1]
    xor ch,ch
    mov dl, str2[1]
    xor dh,dh

    call check_sub
exit:
    mov ax, 4c00h
    int 21h

    check_sub PROC
        push ax bx cx dx si di 
        circle:
            mov al,str1[si]
            mov ah, str2[di]

            cmp al,ah
            jne next_a
            je next_ab
            next_a: 
                cmp cx,1
                je print
                inc si
                dec cx
                mov dx, 3
                mov di, 2
                jmp circle
                print:
                    call print_no
                jmp exit
            
            next_ab:
                ; for returning the last match index
                ; mov bx, si
                ; add bx, "0"
                cmp dx,cx
                ja printn                
                cmp dx,1
                je check_dx
                inc si
                dec cx
                inc di
                dec dx
                jmp circle
                printn:
                    call print_no
                check_dx:
                    ; for returning the first match index
                    ; mov bx, si
                    ; sub bx, word ptr str2[1]
                    ; add bx, 1
                    ; add bx, "0"

                    mov ah,2
                    mov dx,bx
                    int 21h
        pop di si dx cx bx ax
        ret
    check_sub ENDP

    
    print_no PROC
        push ax dx 

        call entr
        
        mov ah,9
        lea dx,no
        int 21h

        pop dx ax
        ret
    print_no ENDP

    entr proc
        push ax dx

        mov ah,2
        mov dl,10
        int 21h
        mov dl,13
        int 21h

        pop dx ax
	ret
entr endp

end start
