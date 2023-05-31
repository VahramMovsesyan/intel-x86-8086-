.model small
.stack 256
.data
    arr dw 16,17 dup(?)
.code 
start:
    mov ax,@data
    mov ds,ax

    
    mov ah,10
    lea dx,arr
    int 21h

    push dx
    call str_to_number

    mov ax,4c00h
    int 21h


str_to_number proc		; input:   stack->address of string(number)
			            ; output: ax=number
	push bp
	mov bp,sp
	add bp,4		; [bp]=dx

	push bx cx dx di si

	mov bx,[bp]	; bx=dx=address of number
	xor ax,ax
	xor cx,cx
	mov cl,[bx+1]	; cx=number[1]=count of digits

	jcxz fin	

	mov si,2
	mov di,10

; orinak number='7568'
circle1:	mul di		; dx:ax=ax*10=0 /7*10=70...
	xor dx,dx
	mov dl,[bx+si]	; dl='7' / '5'
	sub dl,'0'		; dl=7 /5
	add ax,dx		; ax=7 /70+5=75...
	inc si
	loop circle1

fin:	pop si di dx cx bx
	pop bp
	ret 2
str_to_number endp

end start