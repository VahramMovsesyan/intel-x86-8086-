count2 proc	; bl=symbol='A'=65=01000001b
	push ax bx cx dx
	mov cx,8
	xor dl,dl
    c1:	shl bl,1
        adc dl,0	; dl=dl+0+cf
        loop c1

	mov ah,2
	add dl,'0'
	int 21h
	pop dx cx bx ax
	ret
count2 endp