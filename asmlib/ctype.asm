;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			ctype.asm				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo de funciones genericas para el tratamiento de		;
; caracteres alfanumericos.					;
; 								;
; Autor: Samuel Gomez Sanchez					;
;								;
; Subrutinas:	isdigit						;
;		isalpha						;
;		toupper						;
;		tolower						;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
			
			
			
			
			
			; Zona configuracion de memoria
;--------------------------------------------------------------------;
		
		.module 		ctype
		
		.area			_CTYPE
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			isdigit
		.globl			isalpha
		.globl			tolower
		.globl			toupper
		
		;------------------------------------;
		
		
;--------------------------------------------------------------------;
		; Fin zona configuracion memoria
		
		
		
		
		
		
		; Inicio definicion de constantes
;--------------------------------------------------------------------;												
			
fin		.equ			0xFF01				
teclado		.equ			0xFF02
pantalla	.equ			0xFF00

;--------------------------------------------------------------------;
		; Fin definicion de constantes
		
		
		
		
		; Objetos subrutinas
;--------------------------------------------------------------------;
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				isdigit					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si el contenido del registro A es un digito en ASCII	;
; Si es así, pone el flag Z a 1, en otro caso, lo pone a 0.		;
;									;	
; Input: Dato contenido en registro A 					;
; Output: flag Z 							;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | | | | |X| | |				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isdigit:		
		pshs			b,cc
		
		
		ldb			#0x30			;;;;;;;;;
		pshs			a				;
									;	
	ctype_isdigit_for:						;
									;
		cmpb			#0x3A				;
		beq			ctype_isdigit_finFor		; Bucle for (B = 0x30; B <= 0x40; ++B)
									;	if (A = B)
			cmpb			,s			;		break
			beq			ctype_isdigit_finFor	;
		incb							;
		bra			ctype_isdigit_for	;;;;;;;;;

	ctype_isdigit_finFor:
	
		puls			a
		
		cmpb			#0x3A			;;;;;;;;;
		beq			ctype_isdigit_notDigit		;
									;
			puls			cc			;
			orcc			#0x04 	; Ponemos a	; 	
							; 1 el flag Z	; 
			puls			b			;
			rts						; if (B = 0x3A)
									;	noEsUnDigito
									; else	
									; 	esDigito
	ctype_isdigit_notDigit:						;	
									;
			puls			cc			;
			andcc			#0xFB	; Ponemos a	;
							; 0 el flag Z	;
			puls			b			;
			rts					;;;;;;;;;
				
;--------------------------------------------------------------------;
		; Fin isdigit
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				isalpha					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si el contenido del registro A es un caracter alfabetico	;
; en ASCII; si es así, pone el flag Z a 1, en otro caso, lo pone a 0.	;
;									;
; Input: Dato contenido en registro A 					;
; Output: flag Z 							;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | | | | |X| | |				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

isalpha:		
		pshs			b,cc
		
		ldb			#0x41			;;;;;;;;;
		pshs			a				;
									;
	ctype_isalpha_for1:						;
									;
		cmpb			#0x5B				;
		beq			ctype_isalpha_finFor1		; Bucle for (B = 'A'; B <= '['; ++B)
									;	if (A = B)
			cmpb			,s			;		break
			beq			ctype_isalpha_finFor2	;
									; En ASCII (... 'x', 'y', 'z', '[')
		incb							;
		bra			ctype_isalpha_for1	;;;;;;;;;

	ctype_isalpha_finFor1:
		
		
		ldb			#0x61			;;;;;;;;;
									;
	ctype_isalpha_for2:						;
									;
		cmpb			#0x7B				;
		beq			ctype_isalpha_finFor2		; Bucle for (B = 'a'; B <= '{'; ++B)
									;	if (A = B)
			cmpb			,s			;		break
			beq			ctype_isalpha_finFor2	;
									; En ASCII (... 'X', 'Y', 'Z', '{')
		incb							;
		bra			ctype_isalpha_for2	;;;;;;;;;

	ctype_isalpha_finFor2:
		
		
		puls			a
				
		cmpb			#0x5B			;;;;;;;;;
		beq			ctype_isalpha_notAlpha		;
		cmpb			#0x7B				; if (B = 0x5B || B = 0x7B)
		beq			ctype_isalpha_notAlpha		;	noEsAlpha
			puls			cc			;
			orcc			#0x04	; Ponemos a 	; else
							; 1 el flag Z	;	esAlpha
			puls			b			;
			rts						;
									; 
	ctype_isalpha_notAlpha:						;
									;	
			puls			cc			;
			andcc			#0xFB	; Ponemos a 	;
							; 0 el flag Z	;
			puls			b			;
			rts						;
								;;;;;;;;;
			
;--------------------------------------------------------------------;
		; Fin isalpha
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				toupper					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cambia los caracteres alfabeticos por sus correspondientes mayusculas	;
;									;	
; Input: Dato contenido en registro A 					;
; Output: Dato contenido en el registro A 				;
;									;
; Registros afectados: A						;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

toupper:
		pshs			cc
		
		cmpa			#'a
		blo			ctype_toupper_sinCambios
		cmpa			#'z
		bhi			ctype_toupper_sinCambios
		
		suba			#0x20	; Diferencia entre letra minuscula y
						; mayuscula en el codigo ASCII
		
	ctype_toupper_sinCambios:
	
		puls			cc
		rts
		
;--------------------------------------------------------------;
		; Fin toupper
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				tolower					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cambia los caracteres alfabeticos por sus correspondientes minusculas	;
;									;	
; Input: Dato contenido en registro A 					;
; Output: Dato contenido en el registro A 				;
;									;
; Registros afectados: A, CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | |X| |X|X|X|X|				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

tolower:
		pshs			cc
		
		cmpa			#'A
		blo			ctype_tolower_sinCambios
		cmpa			#'Z
		bhi			ctype_tolower_sinCambios
		
		adda			#0x20	; Diferencia entre letra minuscula y
						; mayuscula en el codigo ASCII
		
	ctype_tolower_sinCambios:
	
		puls			cc
		rts
		
;--------------------------------------------------------------;
		; Fin tolower
