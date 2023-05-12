.model small
.stack 256
.data
	mess db 10,11 dup(?)
	no_mess db 10,13, "NO$"
	
.code
start:
	mov ax,@data
	mov ds, ax

	mov ah,10
	lea dx,mess
	INT 21h

	; call entr

	call search_a
	jnc cf_is_0
	mov ah,9
	lea dx,no_mess
	INT 21h
	jmp cf_is_1
	

cf_is_0: 
	call delete_a

cf_is_1:
	mov ax, 4c00h
	INT 21h





delete_a proc
	
	mov cl,mess[1]
	mov dl,cl
	dec cl	
	
	cmp mess[2],"a"
	jne last_a

	mov si,2
circle_1:
	mov bh, mess[si+1]
	mov mess[si], bh
	inc si
	loop circle_1
	dec dl
	mov mess[1], dl

last_a: 
	xor dh,dh
	mov si,dx
	cmp mess[si+1],"a"	;cmp with the last symbol in array
	jne printstr
	dec dl
	mov mess[1], dl

printstr:
	call printsymbol
	
	ret
delete_a endp


search_a proc

	push si cx bx

	mov si,2
	mov cl,mess[1]
	xor ch,ch
	STC

	circle:	mov bl,mess[si]
		cmp bl,"a"
		jne next
		CLC

	next: inc si
		
		loop circle
		
		pop bx cx si

	ret
search_a endp


printsymbol proc
	push si cx dx 

	mov si,2
	mov cl,mess[1]
	xor ch,ch
	mov ah,2

print_loop:
	mov dl,mess[si]
	INT 21h
	inc si
	loop print_loop

	pop dx cx si
	ret
printsymbol endp

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