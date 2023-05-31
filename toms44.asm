;0-ների քանակ
;string to number
;10-ական
.model small
.stack 256
.data
    num_arr dw 16,17 dup(?)
    str_arr dw 16,17 dup(?)
    entr db 10,13, '$'
.code 
start:
    mov ax,@data
    mov ds,ax

    ; xor si,si
    ; mov cx,14
    ; circle:
    ;     mov ah,10
    ;     lea dx,num_arr
    ;     int 21h

    ;     push dx             ; input dx
    ;     call str_to_number  ; output ax

    ;     ;input ax=number
    ;     ;output ax=count of number which contain 3 "0" in binary
    ;     call count2
    ;     loop circle
        
    ; ;input ax=number
    ; ;output display on screen
    ; call outputnumber

    mov ah,10
    lea dx,str_arr
    int 21h

    mov ah,9
    lea dx, entr
    int 21h

    push dx
    call change_after_last_a

    lea si, str_arr 
    add si,2
    mov cx, [si]
    dec cx
        
    PrintLoop:
        MOV AX, [SI+2] 
        MOV DL, AL 
        MOV AH, 2 
        INT 21h 
        MOV DL, AH 
        INT 21h 
        ADD SI, 2 
        LOOP PrintLoop

    mov ax,4c00h
    int 21h




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




count2 proc	; ax=number
	push bx cx dx
	mov cx,16       ;2bait = 16 bit => 16 circle
	xor dx,dx
    c1:	shl ax,1
        adc dx,0	; dx=dx+0+cf
        loop c1
    
    xor bx,bx       ; count of 0
    mov bx, 8       ; 8 - count of 1 = count of 0
    sub bx,dx

    xor ax,ax 
    cmp bx,3
    jne exit
    inc ax
	
exit:	pop dx cx bx
	ret
count2 endp



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





outputnumber proc		; ax=number =>orinak ax=1234
	push ax cx dx di
	mov di,10
	xor cx,cx
	
    circle2:	cmp ax,0
        je fin1
        xor dx,dx
        div di ; (dx:ax):10 ->dx=4,ax=123/dx=3,ax=12/dx=2,ax=1/dx=1,ax=0
        push dx
        inc cx
        jmp circle2

fin1:	mov ah,2
circle3:	pop dx
	add dl,'0'
	int 21h
	loop circle3
	pop di dx cx ax
	ret
outputNumber endp




change_after_last_a proc
    push bp
	mov bp,sp
	add bp,4    ; [bp] = dx

    push ax bx cx si di

    mov bx,[bp]
    xor cx,cx
	mov cl,[bx+2]   ; cx = arr[1] = count of symbols
    dec cx          ;for end loop when cx=0
    dec cx
    mov si,2

    jcxz fin2

    xor ax,ax   ; ax = last index of 'a'
    xor di,di   ; di = count of symbols after 'a'
    search:
        cmp word ptr [bx+si],'a'
        jne next
            mov ax,si
            mov di,cx   
        next:
            inc si
            inc si
            dec cx
        loop search

        mov cx, di
        mov si, ax
        add si,2
        sub cx,2
    change_loop:
        mov word ptr [bx+si],'A'
        loop change_loop

fin2:	pop di si cx bx ax
	pop bp dx
    ret
change_after_last_a endp

end start