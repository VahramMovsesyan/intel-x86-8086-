ten proc
	push ax bx cx dx
	xor cx,cx
	mov bh,10
	mov ax,bx   
    t1:	cmp al,0
        je finish
        xor ah,ah		; al->ax
        div bh		; al=/, ah=%
        push ax	
        inc cx
        jmp t1
    finish:
    ; al=123:10->12,3	-> 3,12->stack,  cx=1	
    ; al=12:10->1,2	-> 2,1->stack,    cx=2
    ;al=1:10->0,1	-> 1,0->stack,    cx=3

        mov ah,2
        t2:	pop dx	; dl=al=0/1/12,dh=ah=1/2/3
            mov dl,dh
            add dl,'0'	; or dl,'0'
            int 21h
            loop t2
	pop dx cx bx ax
	ret
ten endp