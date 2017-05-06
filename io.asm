			; Zona configuracion de memoria
;--------------------------------------------------------------------;	

		.module 		io
		
		.area			_IO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			println
		.globl			print
		.globl			getstr
		.globl			getchar
		.globl			clearScreen
		.globl			clearScreenAscii
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
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

		; Variables
;--------------------------------------------------------------------;	

clrscr_code:	.asciz			"\33[2J" ; Necesario para clearScreenAscii

;--------------------------------------------------------------------;	
		; Fin variables
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				println					;							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que imprime la cadena apuntada por el registro X con un 	;
; salto de linea al final.						;
;									;
; Input: dato apuntado por REGISTRO X					;
; Output: pantalla							;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | | | |X|X|0| |				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

println:
		pshs			a,x
		
		
							
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
				
		puls			a,x
		rts
				
;---------------- Fin println --------------------------------------;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				print					;							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que imprime la cadena apuntada por el registro X sin un 	;
; salto de linea al final.						;
;									;
; Input: dato apuntado por REGISTRO X					;
; Output: pantalla							;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | | | |X|X|0| |				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print:
		pshs			a,x
				
	io_print_while:					;;;;;;;;;
		lda			,x+			;						;
		beq			io_print_finWhile	;
								;
			sta			pantalla	; while (caracter != '\0')
								;
		bra			io_print_while		; 
								;
	io_print_finWhile:				;;;;;;;;;	
													
		puls			a,x
		rts
				
;---------------- Fin print --------------------------------------;







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				getstr					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que toma una cadena desde el teclado hasta que el se    	;
; escribe un salto de linea, que no es incluido en la misma.		;
; La cadena es guardada desde la posicion indicada por el registro X	;
; con un caracter '\0' al final.				 	;
;									;
; Input: Direccion valida, registro X					;
; Output: Direccion registro X						;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | | | |X|X|0| |				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getstr:
		pshs			x,a
				

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
		
		puls			x,a
		rts
				
;---------------- Fin getstr ----------------------------------------;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				getchar					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que toma una caracter del teclado y lo almacena, en su  	;
; codificacion ASCII en el registro A.				 	;
;									;
; Input: Teclado							;
; Output: Registro A							;
;									;
; Registros afectados: A y CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;			| | | | |X|X|0| |				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getchar:		
		lda			teclado
				
		rts
				
;---------------- Fin getstr ----------------------------------------;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			clearScreen				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Limpia la pantalla, imprimiendo 50 saltos de linea. Feo, pero portable;
;								    	;
; Input: ninguno.							;
; Output: pantalla							;
;									;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|0|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearScreen:
		pshs			d
		
		tfr			s,d	; Hacemos espacio en la pila para
		decb				; un contador. El bloque que lo
		tfr			d,s	; utilice debera inicializarlo
		
		clrb
		stb			,s	; 0,s es siempre el contador
		lda			#'\n
		
	io_clearScreen_for:					;;;;;;;;;
									;
		ldb			,s				;
		cmpb			#50				;
		beq			io_clearScreen_finFor		; for (counter = 0, A = \n; 
									;	counter < 50;
			inc			,s			;	++counter)	
			sta			pantalla		;		imprime(A)
									;	
		bra			io_clearScreen_for		;		
								;;;;;;;;;
		
	io_clearScreen_finFor:
		
		tfr			s,d	; Eliminamos el espacio
		incb				; para el contador
		tfr			d,s	;
		
		puls			d
		rts

;--------- Fin clearScreen ------------------------------------------;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			clearScreenAscii			    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Limpia la pantalla utilizando el codigo de escape ascii "\33[2J"   	;
; No portable, mas elegante.						;
;								    	;
; Input: ninguno.							;
; Output: pantalla	.						;
;									;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | |X|X|0| |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearScreenAscii:

		pshs			x
		ldx			#clrscr_code
		jsr			print
		puls			x
		rts

;--------- Fin clearScreen ------------------------------------------;












