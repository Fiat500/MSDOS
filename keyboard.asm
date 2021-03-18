TITLE "Read and display file Example"  ;z9

	IDEAL
	MODEL small
	STACK 256

	DATASEG
;----------- Equates

keyPressed db 1 dup (0)

CODESEG



; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
proc SCAN_NUM 
        PUSH    DX
        PUSH    AX
        PUSH    SI
        mov 	di, offset keyPressed
        MOV     CX, 0

        ; reset flag:
       ; MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
		mov 	[di],al
        

       
        POP     SI
        POP     AX
        POP     DX
        RET
endp SCAN_NUM  

proc print_chr
		PUSH    DX
        PUSH    AX
        PUSH    SI
        mov 	di, offset keyPressed
		mov 	al, [di]
		; and print it:
		sub 	al,32 ;change case
        MOV     AH, 0Eh
        INT     10h
		
		POP     SI
        POP     AX
        POP     DX
		
	ret
endp print_chr 

Start:
	mov	ax, @data
	mov ds, ax
check_char:	
	call SCAN_NUM  
	;cmp al, 98
	;jnz check_char
	
	call print_chr
	

Exit: 
	mov ah, 0       ; wait for keyboard press
    int 016h   
    mov al, 3
	mov ah, 0
	int 10h
	mov ax, 04C00h
	int	21h

END	Start