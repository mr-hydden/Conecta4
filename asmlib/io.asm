;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				io.asm				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo de funciones genericas de entrada/salida.		;
; 								;
; Autor: Samuel Gomez Sanchez					;
;								;
; Subrutinas:	println						;
;		print						;
;		getstr						;
;		getchar						;
;		clrscr						;
;		clrscrAscii					;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






		; Zona configuracion de memoria
;--------------------------------------------------------------------;	

		.module 		io
		
		.area			_IO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			println
		.globl			print
		.globl			getstr
		.globl			getchar
		.globl			clrscr
		.globl			clrscrAscii
		
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
		;>>>> Objetos de clrscrAscii <<<<
		
			; >>>> Constantes <<<<

			sClrscr_ClrScrAsciiCode:	.asciz		"\33[2J" ; Codigo de escape ASCII que 
										 ; borra la pantalla poniendo el
										 ; cursor al comienzo de esta.
		;------------------------------------;				 
		; Fin objetos clrscrAscii

;--------------------------------------------------------------------;	
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				println					;							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que imprime la cadena apuntada por el registro X con un 	;
; salto de linea al final.						;
;									;
; Input: dato apuntado por registro X					;
; Output: pantalla							;
;									;
; Registros afectados: -						;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

println:
		pshs			a,x,cc
		
		
							
	io_println_while:				;;;;;;;;;
		lda			,x+			;						;
		beq			io_println_finWhile	;
								;
			sta			pantalla	; while (caracter != '\0')
								;
		bra			io_println_while	; 
								;
	io_println_finWhile:				;;;;;;;;;	
													
		lda			#'\n
		sta			pantalla
				
		puls			a,x,cc
		rts
				
;--------------------------------------------------------------------;
		; Fin println
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				print					;							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que imprime la cadena apuntada por el registro X sin un 	;
; salto de linea al final.						;
;									;
; Input: dato apuntado por registro X					;
; Output: pantalla							;
;									;
; Registros afectados: -						;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print:
		pshs			a,x,cc
				
	io_print_while:					;;;;;;;;;
		lda			,x+			;						;
		beq			io_print_finWhile	;
								;
			sta			pantalla	; while (caracter != '\0')
								;
		bra			io_print_while		; 
								;
	io_print_finWhile:				;;;;;;;;;	
													
		puls			a,x,cc
		rts
				
;--------------------------------------------------------------------;
		; Fin print
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				getstr					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que toma una cadena desde el teclado hasta que el se    	;
; escribe un salto de linea, que no es incluido en la misma.		;
; La cadena es guardada desde la posicion indicada por el registro X	;
; con un caracter '\0' al final.				 	;
;									;
; Input: Direccion registro X						;
; Output: Direccion registro X						;
;									;
; Registros afectados: -						;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getstr:
		pshs			x,a,cc
				

	io_getstr_while:				;;;;;;;;;
								;
		lda			teclado			;
		cmpa			#'\n			
		beq			io_getstr_finWhile	; Bucle while (caracter != '\n')
								;
			sta			,x+		;
								;
		bra			io_getstr_while		;
								;
	io_getstr_finWhile:				;;;;;;;;;
				
		lda			#'\0
		sta			,x+
		
		puls			x,a,cc
		rts
				
;--------------------------------------------------------------------;
		; Fin getstr
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				getchar					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que toma una caracter del teclado y lo almacena, en su  	;
; codificacion ASCII en el registro A.				 	;
;									;
; Input: Teclado							;
; Output: Registro A							;
;									;
; Registros afectados: A						;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getchar:	
		pshs			cc
		lda			teclado
		puls			cc
		rts
				
;--------------------------------------------------------------------;
		; Fin getchar
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				clrscr				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Limpia la pantalla, imprimiendo 50 saltos de linea. Feo, pero portable;
;								    	;
; Input: ninguno.							;
; Output: pantalla							;
;									;
; Registros afectados: -					    	;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clrscr:
		pshs			d,cc
		
		pshs			b	; Hacemos espacio en la pila para
						; un contador. 
		
		clrb
		stb			,s	; 0,s es siempre el contador
		lda			#'\n
		
	io_clrscr_for:						;;;;;;;;;
									;
		ldb			,s				;
		cmpb			#50				; for (counter = 0, A = \n; 
		beq			io_clrscr_finFor		; 	counter < 50;
									;	++counter)
			sta			pantalla		;		imprime(A)	
		inc			,s				;						;	
		bra			io_clrscr_for			;		
								;;;;;;;;;
		
	io_clrscr_finFor:
		
		puls			b	; Eliminamos el espacio
						; para el contador
		
		puls			d,cc
		rts

;--------------------------------------------------------------------;
		; Fin clrscr
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				clrscrAscii			    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Limpia la pantalla utilizando el codigo de escape ascii "\33[2J"   	;
; No portable, mas elegante.						;
;								    	;
; Input: ninguno.							;
; Output: pantalla	.						;
;									;
; Registros afectados: -					    	;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscrAscii:

		pshs			x,cc
		leax			sClrscr_ClrScrAsciiCode,pcr
		lbsr			print
		puls			x,cc
		rts

;--------------------------------------------------------------------;
		; Fin clrscrAscii
		
		
		
		
		
		
