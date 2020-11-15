TITLE "Display VGA color lines"

	IDEAL
	MODEL small
	STACK 256

	DATASEG
;----------- Equates




	CODESEG

Start:
	mov	ax, @data
	mov ds, ax
	
    mov ax,13h
    int 10h
  
    push 0a000h
    pop es
    mov di, 0fa00h
    mov bl, 50
mainLoop:   
    mov [es:di],bl
	mov ax, di
	mov dx, 0
	mov cx, 000ffh
	div cx
	cmp dx, 0
	jne goHere
	inc bl
goHere:
    dec di
    jnz mainLoop
  ; wait for any key and exit
    mov ah, 0       ; wait for keyboard press
    int 016h   
    mov al, 3
	mov ah, 0
	int 10h
    jmp Exit
	

	
Exit: 
	mov ax, 04C00h
	int	21h

END	Start