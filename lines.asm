TITLE "Open and Append File Example" ;b2

	IDEAL
	MODEL small
	STACK 256

	DATASEG
	
textBuffer db 10000 dup (255)
stopper db 255

lineBuffer db 200 dup (0)



filename db 'read.txt',0

ErrorMsg db 'Error', 13, 10,'$'

handle dw ?

htext db "Creating and writing to file", 10, "$"
errtext db "Error", 10, "$"

	CODESEG
proc open_file	
	mov ax,3d02h
    mov dx,offset filename
    int 21h
    jc error
    mov [handle],ax
	ret
endp open_file

proc read_file
	;mov bx,ax
	mov ah,3fh
    mov bx,[handle]
    mov cx,10000
    mov dx,offset textBuffer
    int 21h
    jc error
	ret
endp read_file

proc read_line
	mov al,0
	mov di, offset textBuffer
	mov si, offset lineBuffer
lineLoop:
	mov al, [di]
	cmp al, 10
	jz lineEnd
	mov [si],al
	inc si
	inc di
    jmp lineLoop
lineEnd:
	ret
endp read_line





proc error
	mov ah, 9
	mov dx, offset errtext
	int 21h
	ret
endp error

proc out_buffer
	mov ah, 02h
	mov di, offset textBuffer
outLoop:
	mov dl, [di]
	inc di
	cmp dl, 255
	jz outFinish
	push ax
	push dx
	push di
	int 21h
	pop di
	pop dx
	pop ax
	jmp outLoop
outFinish:
	ret
endp out_buffer

proc out_string
	mov al, 024h
	mov dx,offset textBuffer
	int 21h
	ret
endp out_string

Start:
	mov	ax, @data
	mov ds, ax
	
	call open_file
	call read_file
	call out_buffer
	call read_line

Exit: 
	mov ah, 0       ; wait for keyboard press
    int 016h   
    mov al, 3
	mov ah, 0
	int 10h
	mov ax, 04C00h
	int	21h

END	Start