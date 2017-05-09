	; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			check4
		
		.area			_CHECK4
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			comprueba4
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numFils
		.globl			numCols
		.globl			tablero
		
		.globl			posicion_ij
		
		.globl			negd
		
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4filaDerecha				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la fila correspondiente, partiendo	;
; de la posicion indicada por Y. Lo hace comprobando solo hacia las 	;
; siguientes columnas, en orden ascendente				;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4filaDerecha:

		pshs			a
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4filaDerecha_finTest
		
		cmpa			1,y
		bne			check4_comprueba4filaDerecha_finTest
		cmpa			2,y
		bne			check4_comprueba4filaDerecha_finTest
		cmpa			3,y
		bne			check4_comprueba4filaDerecha_finTest
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4filaDerecha_return
		
check4_comprueba4filaDerecha_finTest:
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
check4_comprueba4filaDerecha_return:	
		puls			a
		rts

;--------------------------------------------------------------------;	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4filaIzquierda				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la fila correspondiente, partiendo	;
; de la posicion indicada por Y. Lo hace comprobando solo hacia las 	;
; anteriores columnas, en orden descendente				;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4filaIzquierda:

		pshs			a
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4filaIzquierda_finTest
		
		cmpa			-1,y
		bne			check4_comprueba4filaIzquierda_finTest
		cmpa			-2,y
		bne			check4_comprueba4filaIzquierda_finTest
		cmpa			-3,y
		bne			check4_comprueba4filaIzquierda_finTest
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4filaIzquierda_return
		
check4_comprueba4filaIzquierda_finTest:
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
check4_comprueba4filaIzquierda_return:	
		puls			a
		rts

;--------------------------------------------------------------------;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4columnaArriba				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la columna correspondiente, 	;
; partiendo de la posicion indicada por Y. Lo hace comprobando solo 	;
; hacia las filas anteriores, en orden descendente			;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4columnaArriba:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4columnaArriba_desigual
		
		
		
		ldb			#3					;;;;;;;;;
		pshs			b,a						;
											;
	check4_comprueba4columnaArriba_for:						;
											;
		tst			1,s						;
		beq			check4_comprueba4columnaArriba_finFor		;
											;
			dec			1,s					;
											;
			tfr			y,d					; for (i = 3; i > 0; --i, Y-= numCols)
			subd			2,s					;	if (ContentOf(Y) != ficha)
			tfr			d,y					;		break
			lda			,s					;
			cmpa			,y					;
			bne			check4_comprueba4columnaArriba_finTest	;
			bra			check4_comprueba4columnaArriba_for	;
										;;;;;;;;;
										
	check4_comprueba4columnaArriba_finFor:
		
		puls			b,a	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4columnaArriba_return
		
	check4_comprueba4columnaArriba_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	check4_comprueba4columnaArriba_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4columnaArriba_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonalDerecha			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la diagonal ascendente hacia la	;
; derecha, partiendo de la posicion indicada.				;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4diagonalDerecha:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4diagonalDerecha_desigual
		
		
		
		ldb			#3					;;;;;;;;;
		pshs			b,a						;
											;
	check4_comprueba4diagonalDerecha_for:						;
											;
		tst			1,s						;
		beq			check4_comprueba4diagonalDerecha_finFor		;
											;
			dec			1,s					;
											;
			tfr			y,d					; for (i = 3; i > 0; --i, Y-= numCols)
			subd			2,s					;	if (ContentOf(Y) != ficha)
			addd			#1					;		break
			tfr			d,y					;		
			lda			,s					;
			cmpa			,y					;
			bne			check4_comprueba4diagonalDerecha_finTest;
			bra			check4_comprueba4diagonalDerecha_for	;
										;;;;;;;;;
										
	check4_comprueba4diagonalDerecha_finFor:
		
		puls			d	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4diagonalDerecha_return
		
	check4_comprueba4diagonalDerecha_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	check4_comprueba4diagonalDerecha_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4diagonalDerecha_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;	



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonalIzquierda			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la diagonal ascendente hacia la	;
; izquierda, partiendo de la posicion indicada.				;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4diagonalIzquierda:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4diagonalIzquierda_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	check4_comprueba4diagonalIzquierda_for:							;
												;
		tst			1,s							;
		beq			check4_comprueba4diagonalIzquierda_finFor		;
												;
			dec			1,s						;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= numCols)
			subd			2,s						;	if (ContentOf(Y) != ficha)
			subd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			check4_comprueba4diagonalIzquierda_finTest	;	
			bra			check4_comprueba4diagonalIzquierda_for		;
											;;;;;;;;;
										
	check4_comprueba4diagonalIzquierda_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4diagonalIzquierda_return
		
	check4_comprueba4diagonalIzquierda_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	check4_comprueba4diagonalIzquierda_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4diagonalIzquierda_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;	




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				comprueba4				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en el tablero, referenciado por Y.	;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4:

		pshs			y,d
		
		lda			numCols		; Guardamos en la pila el limite
		suba			#3		; de los bucles, que es siempre
		ldb			numFils		; tres veces menor que el numero 
		subb			#3		; de filas/columnas
		pshs			d		;
		
		
		tfr			s,d	; Hacemos espacio en la pila para
		subd			#2	; dos contadores de hasta 256
		tfr			d,s	;
		
		
		ldx			#tablero	; Cargamos X con
		lda			numFils		; la posicion de abajo
		deca					; a la izquierda
		clrb					; del tablero, visualmente
		jsr			posicion_ij	; hablando. Comenzamos a comprobar
		tfr			y,x		; por ahi porque las fichas comenzaran
							; a entrar ahi.
		
		clra				; Inicializamos un contador			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		sta			,s	; a 0											;
																	;
	check4_comprueba4_for1:														;
																	;
		lda			,s	; Contador1										;
		cmpa			3,s	; numFils -3										;
		beq			check4_comprueba4_finFor1									;
																	;
				clra				; Inicializamos el otro					;;;;;;;;;	;
				sta			1,s	; contador a 0							;	;
																;	;
			check4_comprueba4_for2:											;	;
																;	;
				lda			1,s	; Contador2							;	;
				cmpa			2,s	; numCols -3							;	;
				beq			check4_comprueba4_finFor2						;	;
																;	;
					;- Aqui cargamos Y con la direccion adecuada para empezar a comprobar -;		;	;
					;- Lo que hacemos es realizar un desplazamiento relativo a la posicion -;		;	;
					;- inicial, la de abajo a la derecha -;							;	;
					pshs			y								;	;
					lda			numCols								;	;
					ldb			2,s	; Counter 1						;	;
					mul											;	;
					jsr			negd								;	;
					addd			,s	; Y, direccion de comienzo en e el tablero		;	;
					pshs			d								;	;
					clra											;	;
					ldb			5,s	; Counter 2						;	;
					addd			,s	; Lo que había en D					;	;
					tfr			d,y								;	;
					puls			d	; Sacamos lo que hemos metido temporalmente		;	;
									; en pila						;	;
					;----------------------------;								;	;
																;	;
					jsr			comprueba4filaDerecha						;	;
					beq			check4_comprueba4_fixPC1					;	;
																;	;
					jsr			comprueba4columnaArriba						;	;
					beq			check4_comprueba4_fixPC1					;	;
																;	;
					jsr			comprueba4diagonalDerecha					;	;
					beq			check4_comprueba4_fixPC1					;	;
																;	;
					bra			check4_comprueba4_continuar					;	;
																;	;
				check4_comprueba4_fixPC1:									;	;
																;	;
					puls			y								;	;
					bra			check4_comprueba4_finTest					;	;
																;	;	
																;	;
					;- Aqui cargamos Y con la direccion adecuada para empezar a comprobar -;		;	;
					;- Lo que hacemos es realizar un desplazamiento relativo a la posicion -;		;	;
					;- inicial, la de abajo a la derecha							;	;
																;	;
				check4_comprueba4_continuar:									;	;
																;	;
					lda			numCols								;	;
					ldb			2,s	; Counter 1						;	;
					mul											;	;
					jsr			negd								;	;
					addd			,s	; Y, direccion de comienzo en e el tablero		;	;
					pshs			d								;	;
					clra											;	;
					ldb			numCols								;	;
					subb			#1								;	;
					subb			5,s	; Counter 2						;	;
					addd			,s								;	;
					tfr			d,y								;	;
					puls			d	; Sacamos de la pila D lo que 				;	;
									; habiamos metido temporalmente (D)			;	;
					;----------------------------;								;	;
																;	;
					jsr			comprueba4filaIzquierda						;	;
					beq			check4_comprueba4_finfixPC2					;	;
																;	;
					jsr			comprueba4columnaArriba						;	;
					beq			check4_comprueba4_finfixPC2					;	;
																;	;
					jsr			comprueba4diagonalIzquierda					;	;
					beq			check4_comprueba4_finfixPC2					;	;
																;	;
					puls			y								;	;
					inc			1,s								;	;
					bra			check4_comprueba4_for2						;	;
																;	;
				check4_comprueba4_finfixPC2:									;	;
																;	;
					puls			y								;	;	
					bra			check4_comprueba4_finTest					;	;
																;	;
			check4_comprueba4_finFor2:									;;;;;;;;;	;
																	;
			inc			,s											;
			bra			check4_comprueba4_for1									;
																	;
	check4_comprueba4_finFor1:								;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
		andcc			#0xFB	; Si hemos llegado aqui, Z vale 1.
						; Lo ponemos a 0
	check4_comprueba4_finTest:
		puls			d	; Sacamos los contadores
		puls			d	; Sacamos D
		puls			y,d	; Volvemos a la rutina principal
		rts

;--------------------------------------------------------------------;