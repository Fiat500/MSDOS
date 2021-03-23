TITLE "Read and display file Example" ;z88

	IDEAL
	MODEL small
	STACK 256

	DATASEG
;----------- Equates



msg1 db "-> this is palindrome!", 0Dh,0Ah,'$'
msg2 db "-> this is not a palindrome!", 0Dh,0Ah,'$'


;string db 'able was ere ere saw elba'
string db 'able was ere ere saa elba'
;s_size = $ - m1
  db 0Dh,0Ah,'$'
  
CODESEG

proc pali


; first let's print it:
mov ah, 9
mov dx, offset string
int 21h


;lea di, s
mov di, offset string
mov si, di
add si, 25  ;s_size
dec si  ; point to last char!

mov cx, 25 ;s_size
cmp cx, 1
je is_palindrome  ; single char is always palindrome!

shr cx, 1     ; divide by 2!

next_char:
    mov al, [di]
    mov bl, [si]
    cmp al, bl
    jne not_palindrome
    inc di
    dec si
loop next_char


is_palindrome:  
   ;  the string is "palindrome!"
   mov ah, 9
   mov dx, offset msg1
   int 21h
jmp stop

not_palindrome:
   ;  the string is "not palindrome!"
   mov ah, 9
   mov dx, offset msg2
   int 21h
stop:


; wait for any key press:
mov ah, 0
int 16h


ret

endp pali

;================================
start:
mov ax, @data
mov ds, ax
;================================

   
	call pali

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

   
		
	

	
	

	
