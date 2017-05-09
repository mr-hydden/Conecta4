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
		
		
		
		
		
		
		; Objetos subrutinas
;--------------------------------------------------------------------;	
											
		;>>>> Objetos comprueba4 <<<<
			; >>>> Variables <<<<
				
			check4_comprueba4_coordX:
					.byte			0
		
			check4_comprueba4_coordY:		
					.byte			0
		
		;---------------------------;
		; Fin objetos comprueba4

;--------------------------------------------------------------------;
		; Fin objetos subrutinas






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
		; Fin comprueba4filaDerecha
		
		
		
		
		
		
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
		; Fin comprueba4filaIzquierda
		
		
		
		
		
		
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
			tfr			y,d					; for (i = 3; i > 0; --i, Y-= numCols)
			subd			2,s					;	if (ContentOf(Y) != ficha)
			tfr			d,y					;		break
			lda			,s					;
			cmpa			,y					;
			bne			check4_comprueba4columnaArriba_finTest	;
											;
		dec			1,s						;
		bra			check4_comprueba4columnaArriba_for		;
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
		; Fin comprueba4columnaArriba
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4columnaAbajo				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la columna correspondiente, 	;
; partiendo de la posicion indicada por Y. Lo hace comprobando solo 	;
; hacia las filas posteriores, en orden ascendente			;
;									;
; Input: posicion registro Y						;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4columnaAbajo:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4columnaAbajo_desigual
		
		
		
		ldb			#3					;;;;;;;;;
		pshs			b,a						;
											;
	check4_comprueba4columnaAbajo_for:						;
											;
		tst			1,s						;
		beq			check4_comprueba4columnaAbajo_finFor		;
											;
			tfr			y,d					; for (i = 3; i > 0; --i, Y += numCols)
			addd			2,s					;	if (ContentOf(Y) != ficha)
			tfr			d,y					;		break
			lda			,s					;
			cmpa			,y					;
			bne			check4_comprueba4columnaAbajo_finTest	;
											;
		dec			1,s						;
		bra			check4_comprueba4columnaAbajo_for		;
										;;;;;;;;;
										
	check4_comprueba4columnaAbajo_finFor:
		
		puls			b,a	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4columnaAbajo_return
		
	check4_comprueba4columnaAbajo_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	check4_comprueba4columnaAbajo_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4columnaAbajo_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4columnaAbajo
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonalArribaDerecha			;
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

comprueba4diagonalArribaDerecha:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4diagonalArribaDerecha_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	check4_comprueba4diagonalArribaDerecha_for:						;
												;
		tst			1,s							;
		beq			check4_comprueba4diagonalArribaDerecha_finFor		;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= numCols)
			subd			2,s						;	if (ContentOf(Y) != ficha)
			addd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			check4_comprueba4diagonalArribaDerecha_finTest	;
												;
		dec			1,s							;
		bra			check4_comprueba4diagonalArribaDerecha_for		;
											;;;;;;;;;
										
	check4_comprueba4diagonalArribaDerecha_finFor:
		
		puls			d	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4diagonalArribaDerecha_return
		
	check4_comprueba4diagonalArribaDerecha_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	check4_comprueba4diagonalArribaDerecha_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4diagonalArribaDerecha_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;	
		; Fin comprueba4diagonalArribaDerecha
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonalArribaIzquierda		;
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

comprueba4diagonalArribaIzquierda:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4diagonalArribaIzquierda_desigual
		
		
		
		ldb			#3							;;;;;;;;;
		pshs			b,a								;
													;
	check4_comprueba4diagonalArribaIzquierda_for:							;
													;
		tst			1,s								;
		beq			check4_comprueba4diagonalArribaIzquierda_finFor			;
													;
			tfr			y,d							; for (i = 3; i > 0; --i, Y-= numCols)
			subd			2,s							;	if (ContentOf(Y) != ficha)
			subd			#1							;		break
			tfr			d,y							;		
			lda			,s							;
			cmpa			,y							;
			bne			check4_comprueba4diagonalArribaIzquierda_finTest	;
													;
		dec			1,s								;
		bra			check4_comprueba4diagonalArribaIzquierda_for			;
												;;;;;;;;;
										
	check4_comprueba4diagonalArribaIzquierda_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4diagonalArribaIzquierda_return
		
	check4_comprueba4diagonalArribaIzquierda_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	check4_comprueba4diagonalArribaIzquierda_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4diagonalArribaIzquierda_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;	
		; Fin comprueba4diagonalArribaIzquierda
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonalAbajoDerecha			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la diagonal descendente hacia la	;
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

comprueba4diagonalAbajoDerecha:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4diagonalAbajoDerecha_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	check4_comprueba4diagonalAbajoDerecha_for:						;
												;
		tst			1,s							;
		beq			check4_comprueba4diagonalAbajoDerecha_finFor		;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= numCols)
			addd			2,s						;	if (ContentOf(Y) != ficha)
			addd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			check4_comprueba4diagonalAbajoDerecha_finTest	;
												;
												;
		dec			1,s							;	
		bra			check4_comprueba4diagonalAbajoDerecha_for		;
											;;;;;;;;;
										
	check4_comprueba4diagonalAbajoDerecha_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4diagonalAbajoDerecha_return
		
	check4_comprueba4diagonalAbajoDerecha_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	check4_comprueba4diagonalAbajoDerecha_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4diagonalAbajoDerecha_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4diagonalAbajoDerecha
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonalAbajoIzquierda		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay cuatro en raya en la diagonal descendente hacia la	;
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

comprueba4diagonalAbajoIzquierda:

		pshs			y,d
		ldb			numCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			check4_comprueba4diagonalAbajoIzquierda_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	check4_comprueba4diagonalAbajoIzquierda_for:						;
												;
		tst			1,s							;
		beq			check4_comprueba4diagonalAbajoIzquierda_finFor		;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= numCols)
			addd			2,s						;	if (ContentOf(Y) != ficha)
			subd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			check4_comprueba4diagonalAbajoIzquierda_finTest	;
												;
		dec			1,s							;	
		bra			check4_comprueba4diagonalAbajoIzquierda_for		;
											;;;;;;;;;
										
	check4_comprueba4diagonalAbajoIzquierda_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			check4_comprueba4diagonalAbajoIzquierda_return
		
	check4_comprueba4diagonalAbajoIzquierda_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	check4_comprueba4diagonalAbajoIzquierda_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	check4_comprueba4diagonalAbajoIzquierda_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4diagonalAbajoIzquierda
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				comprueba4				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si se ha generado un cuatro en raya en torno a la ficha 	;
; con coordenadas (A,B). La direccion base del tablero debe estar en X	;
;									;
; Input: posicion registros A y B, tablero X				;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4:
		pshs			y,d
		sta			check4_comprueba4_coordY	; Guardamos las coordenadas de 
		stb			check4_comprueba4_coordX	; la ficha
		
		jsr			posicion_ij			; Obtenemos la direccion
									; en la que se encuentra
									; la ficha en el tablero	
									; que queda en Y
		
	check4_comprueba4_caseFil0:
	
		clra		
		cmpa			check4_comprueba4_coordY
		bne			check4_comprueba4_caseFilN
		
			jsr			comprueba4filaIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4filaDerecha
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalAbajoIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4columnaAbajo
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalAbajoDerecha
			lbeq			check4_comprueba4_finTest
				
	check4_comprueba4_caseFilN:	
	
		lda			numFils
		deca		
		cmpa			check4_comprueba4_coordY
		bne			check4_comprueba4_caseCol0
		
			jsr			comprueba4filaIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4filaDerecha
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalArribaIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4columnaArriba
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalArribaDerecha
			lbeq			check4_comprueba4_finTest
	
	
	check4_comprueba4_caseCol0:	
	
		clra	
		cmpa			check4_comprueba4_coordX
		bne			check4_comprueba4_caseColN
		
			jsr			comprueba4columnaArriba
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalArribaDerecha
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4filaDerecha
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalAbajoDerecha
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4columnaAbajo
			lbeq			check4_comprueba4_finTest
			
			
	check4_comprueba4_caseColN:	
	
		lda			numCols
		deca		
		cmpa			check4_comprueba4_coordX
		bne			check4_comprueba4_caseDefault
		
			jsr			comprueba4columnaArriba
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalArribaIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4filaIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4diagonalAbajoIzquierda
			lbeq			check4_comprueba4_finTest
		
			jsr			comprueba4columnaAbajo
			lbeq			check4_comprueba4_finTest			
		
		
	check4_comprueba4_caseDefault:	
	
		jsr			comprueba4diagonalArribaIzquierda
		lbeq			check4_comprueba4_finTest
	
		jsr			comprueba4columnaArriba
		lbeq			check4_comprueba4_finTest
	
		jsr			comprueba4diagonalArribaDerecha
		lbeq			check4_comprueba4_finTest
	
		jsr			comprueba4filaIzquierda
		lbeq			check4_comprueba4_finTest
	
		jsr			comprueba4filaDerecha
		lbeq			check4_comprueba4_finTest
		
		jsr			comprueba4diagonalAbajoIzquierda
		lbeq			check4_comprueba4_finTest
		
		jsr			comprueba4columnaAbajo
		lbeq			check4_comprueba4_finTest
		
		jsr			comprueba4diagonalAbajoDerecha
		lbeq			check4_comprueba4_finTest
			
			
	check4_comprueba4_finTest:
	
		puls			y,d
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4
		
		
		
		
		
		
