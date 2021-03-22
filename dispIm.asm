TITLE "Read and display file Example" ;z8

	IDEAL
	MODEL small
	STACK 256

	DATASEG
;----------- Equates

filename db 'test.bmp',0
textFile db 'vga.txt',0

filehandle dw ?
filePointer dw 4

Header db 54 dup (0)

Palette db 256*4 dup (0)

ScrLine db 320 dup (0)

ErrorMsg db 'Error', 13, 10,'$'

charBuffer db 300 dup (0)
char1Buffer db 300 dup (0)
char2Buffer db 255, 165, 255, 165,  255, 124, 255, 34,  255, 100, 255, 100,  255, 100, 255, 100,  255, 100, 255, 100,  255, 100, 255, 100,  255, 100, 255, 100,  255, 100, 255, 100
fileBuffer db 1000 dup ('$')

CODESEG

include "methods.asm"

proc hexNum
	push ax
	;and al,240  ;clear ist 4 bits
	shr al, 4
	cmp al,9  ;9
	jg numHex1a
	add al,48
	mov [di],al
	jp nextNum1
numHex1a:
	add al,55
	mov [di],al
nextNum1:
	inc di
	pop ax
	and al,15
	cmp al,9
	jg numHex1b1
	add al,48
	mov [di],al
	jp hexEnd1
numHex1b1:
	add al,55
	mov [di],al
hexEnd1:
	ret
endp hexNum

proc hexNum1
	push ax
	and al,15
	cmp al,10  ;9
	jg numHex1
	add al,48
	mov [di],al
	jp nextNum
numHex1:
	add al,55
	mov [di],al
nextNum:
	inc di
	pop ax
	shr al, 4
	and al,15
	cmp al,9
	jg numHex1b
	add al,48
	mov [di],al
	jp hexEnd
numHex1b:
	add al,55
	mov [di],al
hexEnd:
	ret
endp hexNum1




proc getChar2
	mov ax, 08000h
    mov es, ax
	mov di,33
	mov si, offset char1Buffer
	mov ch, 18
get_LoopO2a:
	mov cl, 15
get_LoopI2a:
	mov al,[es:di]
	mov [si], al
	;mov [ byte es:di],8
	;mov [byte si],255
	inc si
	inc di
	dec cl
	jnz get_LoopI2a
	add di,305
	dec ch
	jnz get_LoopO2a
	mov [byte si], '$'
	ret
endp getChar2

proc putChar2
	mov ax, 0A000h
    mov es, ax
	;mov di,48000
	mov si, offset charBuffer
	mov ch, 18
get_LoopOa2:
	mov cl, 15
get_LoopIa2:
	mov al,[si]
	mov [es:di],al
	;mov [ byte es:di],8
	inc si
	inc di
	dec cl
	jnz get_LoopIa2
	add di,305
	dec ch
	jnz get_LoopOa2
	ret
endp putChar2

proc putChar
	mov ax, 0A000h
    mov es, ax
	;mov di,48000
	mov si, offset char1Buffer
	mov ch, 18
get_LoopOa:
	mov cl, 15
get_LoopIa:
	mov al,[si]
	mov [es:di],al
	;mov [ byte es:di],8
	inc si
	inc di
	dec cl
	jnz get_LoopIa
	add di,305
	dec ch
	jnz get_LoopOa
	ret
endp putChar

proc getChar
	mov ax, 08000h
    mov es, ax
	mov di,0
	mov si, offset charBuffer
	mov ch, 18
get_LoopO:
	mov cl, 15
get_LoopI:
	mov al,[es:di]
	mov [si], al
	;mov [ byte es:di],8
	;mov [byte si],255
	inc si
	inc di
	dec cl
	jnz get_LoopI
	add di,305
	dec ch
	jnz get_LoopO
	mov [byte si], '$'
	ret
endp getChar


;================================
start:
mov ax, @data
mov ds, ax
;================================

    ; Graphic mode
    mov ax, 13h
    int 10h

    ; Process BMP file
    call OpenFile
    call ReadHeader
    call ReadPalette
    call CopyPal
    call CopyBitmap
	
	call getChar
	mov di,48000
	call getChar2
	
	call putChar
	mov di,32000
	call putChar
	
	mov di,15400
	call putChar
	
	mov di,16400
	call putChar2
	
	call createFile
	call writeFile

    ; Wait for key press
    mov ah,1

    int 21h
    ; Back to text mode
    mov ah, 0
    mov al, 2
    int 10h
	
	;================================
exit:
    mov ax, 4c00h
    int 21h
    END start

   
		
	

	
	

	
