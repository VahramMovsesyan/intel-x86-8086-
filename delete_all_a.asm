.model small
.stack 128
.data
 arr1 db 10,11 dup(?)
 mess_no db "NO$"
 entr db 10,13,"$"
.code
start:
    mov ax, @data
    mov ds, ax

    mov ah,10
    lea dx,arr1
    int 21h

    mov ah,9
    lea dx,entr
    int 21h

    call delete_all_a

    jnc exit
    mov ah,9
    lea dx,mess_no
    int 21h

exit:
    mov ax, 4c00h
    int 21h

 
delete_all_a PROC
    push ax bx cx dx si
    
    mov si, 2
    mov cl, arr1[1]
    xor ch,ch

    mov di, si
    mov bl, arr1[1]
    xor bh, bh

    ; զնագվածի մեջ հանդիող a-երը տանում ենք վերջ abcadefa -> bcdefaaa կամ եթե a չկա՝ bcd -> bcd
    circle:
        mov al, arr1[si]
        cmp al, "a"
        jne next_si

        next_di: 
            cmp bl, 1
            je finish
            inc di
            dec bx
            cmp arr1[di], 'a'
            je next_di
            mov ah, arr1[di]
            mov arr1[si], ah
            mov arr1[di], "a"

        next_si:
            inc si
    loop circle

    ;եթե a կա, ապա CF=0 և a-երի քանակով փոքրացնում ենք size-ը
    finish:
        ; di = 2 այն ժամանակ, երբ a չկա
        cmp di,2
        jne a
        STC
        jmp b
    
        ; CF = 0 եթե գոնե մեկ հատ a կա
        a:
            CLC
            dec si      ; si-ն վերջում ցույց է տալու զանգվածում վերջին տարրի ինդեքս, որը հավասար չէ a-ի
            dec si      ; si-2 = է a-ից տարբեր տարրերի քանակը
            mov dx, si
            mov arr1[1], dl ; ենթադրենք size-ը փոքր է 255-ից

            call print_arr
        b:
    pop si dx cx bx ax
    ret
delete_all_a ENDP


print_arr PROC
    push si cx dx
    
    mov si, 2
    mov cl, arr1[1]
    xor ch, ch
    mov ah,2

    print_circle:
        mov dl,arr1[si]
        INT 21h
        inc si
        loop print_circle

    pop dx cx si
    ret
print_arr ENDP

end start