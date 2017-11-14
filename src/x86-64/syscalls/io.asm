; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2017 Return Infinity -- see LICENSE.TXT
;
; Input/Output Functions
; =============================================================================


; -----------------------------------------------------------------------------
; b_input -- Scans keyboard for input
;  IN:	Nothing
; OUT:	AL = 0 if no key pressed, otherwise ASCII code, other regs preserved
;	Carry flag is set if there was a keystroke, clear if there was not
;	All other registers preserved
b_input:
	mov al, [key]
	test al, al
	jz b_input_no_key
	mov byte [key], 0x00	; clear the variable as the keystroke is in AL now
	stc			; set the carry flag
	ret

b_input_no_key:
	clc			; clear the carry flag
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; b_output -- Outputs characters
;  IN:	RSI = message location (non zero-terminated)
;	RCX = number of chars to output
; OUT:	All registers preserved
b_output:
	push rsi
	push rdx
	push rcx
	push rax

	cld				; Clear the direction flag.. we want to increment through the string
	mov dx, 0x03F8			; Address of first serial port

b_output_nextchar:
	jrcxz b_output_done
	dec rcx
	lodsb				; Get char from string and store in AL
	out dx, al			; Send the char to the serial port
	jmp b_output_nextchar

b_output_done:
	pop rax
	pop rcx
	pop rdx
	pop rsi
	ret
; -----------------------------------------------------------------------------


; =============================================================================
; EOF
