TITLE "Open and Append File Example" ;b2

	IDEAL
	MODEL small
	STACK 256

	DATASEG
	
textBuffer db 1000 dup (36)
charBuffer db 1000 dup (0)

filename db 'test.txt',0

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
    mov cx,1000
    mov dx,offset textBuffer
    int 21h
    jc error
	ret
endp read_file



proc error
	mov ah, 9
	mov dx, offset errtext
	int 21h
	ret
endp error

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
	call out_string

Exit: 
	mov ah, 0       ; wait for keyboard press
    int 016h   
    mov al, 3
	mov ah, 0
	int 10h
	mov ax, 04C00h
	int	21h

END	Start