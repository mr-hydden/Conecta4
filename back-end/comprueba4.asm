	; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			comprueba4
		
		.area			_COMPRUEBA4
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			comprueba4
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<

		.globl			posicionij
		
		.globl			negd
		.globl			amodb
		
		;------------------------------------;
		
;--------------------------------------------------------------------;
		; Fin zona configuracion memoria
		
					
		; Inicio definicion de constantes
;--------------------------------------------------------------------;												
			
		.include		"include.txt"

;--------------------------------------------------------------------;
		; Fin definicion de constantes
		
		
		
		
		; Objetos subrutinas	
;--------------------------------------------------------------------;
		;>>>> Objetos comprueba4 <<<<
		comprueba4_comprueba4_coordX:
			.byte		0
		comprueba4_comprueba4_coordY:
			.byte		0
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
		beq			comprueba4_comprueba4filaDerecha_finTest
		
		cmpa			1,y
		bne			comprueba4_comprueba4filaDerecha_finTest
		cmpa			2,y
		bne			comprueba4_comprueba4filaDerecha_finTest
		cmpa			3,y
		bne			comprueba4_comprueba4filaDerecha_finTest
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4filaDerecha_return
		
comprueba4_comprueba4filaDerecha_finTest:
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
comprueba4_comprueba4filaDerecha_return:	
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
		beq			comprueba4_comprueba4filaIzquierda_finTest
		
		cmpa			-1,y
		bne			comprueba4_comprueba4filaIzquierda_finTest
		cmpa			-2,y
		bne			comprueba4_comprueba4filaIzquierda_finTest
		cmpa			-3,y
		bne			comprueba4_comprueba4filaIzquierda_finTest
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4filaIzquierda_return
		
comprueba4_comprueba4filaIzquierda_finTest:
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
comprueba4_comprueba4filaIzquierda_return:	
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
		ldb			NumCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			comprueba4_comprueba4columnaArriba_desigual
		
		
		
		ldb			#3					;;;;;;;;;
		pshs			b,a						;
											;
	comprueba4_comprueba4columnaArriba_for:						;
											;
		tst			1,s						;
		beq			comprueba4_comprueba4columnaArriba_finFor		;
											;
			tfr			y,d					; for (i = 3; i > 0; --i, Y-= NumCols)
			subd			2,s					;	if (ContentOf(Y) != ficha)
			tfr			d,y					;		break
			lda			,s					;
			cmpa			,y					;
			bne			comprueba4_comprueba4columnaArriba_finTest	;
											;
		dec			1,s						;
		bra			comprueba4_comprueba4columnaArriba_for		;
										;;;;;;;;;
										
	comprueba4_comprueba4columnaArriba_finFor:
		
		puls			b,a	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4columnaArriba_return
		
	comprueba4_comprueba4columnaArriba_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	comprueba4_comprueba4columnaArriba_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	comprueba4_comprueba4columnaArriba_return:	
		
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
		ldb			NumCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			comprueba4_comprueba4columnaAbajo_desigual
		
		
		
		ldb			#3					;;;;;;;;;
		pshs			b,a						;
											;
	comprueba4_comprueba4columnaAbajo_for:						;
											;
		tst			1,s						;
		beq			comprueba4_comprueba4columnaAbajo_finFor		;
											;
			tfr			y,d					; for (i = 3; i > 0; --i, Y += NumCols)
			addd			2,s					;	if (ContentOf(Y) != ficha)
			tfr			d,y					;		break
			lda			,s					;
			cmpa			,y					;
			bne			comprueba4_comprueba4columnaAbajo_finTest	;
											;
		dec			1,s						;
		bra			comprueba4_comprueba4columnaAbajo_for		;
										;;;;;;;;;
										
	comprueba4_comprueba4columnaAbajo_finFor:
		
		puls			b,a	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4columnaAbajo_return
		
	comprueba4_comprueba4columnaAbajo_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	comprueba4_comprueba4columnaAbajo_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	comprueba4_comprueba4columnaAbajo_return:	
		
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
		ldb			NumCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			comprueba4_comprueba4diagonalArribaDerecha_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	comprueba4_comprueba4diagonalArribaDerecha_for:						;
												;
		tst			1,s							;
		beq			comprueba4_comprueba4diagonalArribaDerecha_finFor		;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= NumCols)
			subd			2,s						;	if (ContentOf(Y) != ficha)
			addd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			comprueba4_comprueba4diagonalArribaDerecha_finTest	;
												;
		dec			1,s							;
		bra			comprueba4_comprueba4diagonalArribaDerecha_for		;
											;;;;;;;;;
										
	comprueba4_comprueba4diagonalArribaDerecha_finFor:
		
		puls			d	; Sacamos A y B de la pila
		
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4diagonalArribaDerecha_return
		
	comprueba4_comprueba4diagonalArribaDerecha_finTest:

		puls			b,a	; Sacamos A y B de la pila
		
	comprueba4_comprueba4diagonalArribaDerecha_desigual:	
	
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	comprueba4_comprueba4diagonalArribaDerecha_return:	
		
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
		ldb			NumCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			comprueba4_comprueba4diagonalArribaIzquierda_desigual
		
		
		
		ldb			#3							;;;;;;;;;
		pshs			b,a								;
													;
	comprueba4_comprueba4diagonalArribaIzquierda_for:							;
													;
		tst			1,s								;
		beq			comprueba4_comprueba4diagonalArribaIzquierda_finFor			;
													;
			tfr			y,d							; for (i = 3; i > 0; --i, Y-= NumCols)
			subd			2,s							;	if (ContentOf(Y) != ficha)
			subd			#1							;		break
			tfr			d,y							;		
			lda			,s							;
			cmpa			,y							;
			bne			comprueba4_comprueba4diagonalArribaIzquierda_finTest	;
													;
		dec			1,s								;
		bra			comprueba4_comprueba4diagonalArribaIzquierda_for			;
												;;;;;;;;;
										
	comprueba4_comprueba4diagonalArribaIzquierda_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4diagonalArribaIzquierda_return
		
	comprueba4_comprueba4diagonalArribaIzquierda_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	comprueba4_comprueba4diagonalArribaIzquierda_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	comprueba4_comprueba4diagonalArribaIzquierda_return:	
		
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
		ldb			NumCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			comprueba4_comprueba4diagonalAbajoDerecha_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	comprueba4_comprueba4diagonalAbajoDerecha_for:						;
												;
		tst			1,s							;
		beq			comprueba4_comprueba4diagonalAbajoDerecha_finFor		;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= NumCols)
			addd			2,s						;	if (ContentOf(Y) != ficha)
			addd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			comprueba4_comprueba4diagonalAbajoDerecha_finTest	;
												;
												;
		dec			1,s							;	
		bra			comprueba4_comprueba4diagonalAbajoDerecha_for		;
											;;;;;;;;;
										
	comprueba4_comprueba4diagonalAbajoDerecha_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4diagonalAbajoDerecha_return
		
	comprueba4_comprueba4diagonalAbajoDerecha_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	comprueba4_comprueba4diagonalAbajoDerecha_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	comprueba4_comprueba4diagonalAbajoDerecha_return:	
		
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
		ldb			NumCols
		clra
		pshs			d
		
		lda			,y
		cmpa			#0x20	; Caracter espacio
		beq			comprueba4_comprueba4diagonalAbajoIzquierda_desigual
		
		
		
		ldb			#3						;;;;;;;;;
		pshs			b,a							;
												;
	comprueba4_comprueba4diagonalAbajoIzquierda_for:						;
												;
		tst			1,s							;
		beq			comprueba4_comprueba4diagonalAbajoIzquierda_finFor		;
												;
			tfr			y,d						; for (i = 3; i > 0; --i, Y-= NumCols)
			addd			2,s						;	if (ContentOf(Y) != ficha)
			subd			#1						;		break
			tfr			d,y						;		
			lda			,s						;
			cmpa			,y						;
			bne			comprueba4_comprueba4diagonalAbajoIzquierda_finTest	;
												;
		dec			1,s							;	
		bra			comprueba4_comprueba4diagonalAbajoIzquierda_for		;
											;;;;;;;;;
										
	comprueba4_comprueba4diagonalAbajoIzquierda_finFor:
	
		puls			d	; Sacamos A y B de la pila
	
		;orcc			#0x04	; Si hay cuatro en raya encendemos el flag Z, 
						; no hace falta hacerlo, ya lo esta
		bra			comprueba4_comprueba4diagonalAbajoIzquierda_return
		
	comprueba4_comprueba4diagonalAbajoIzquierda_finTest:
		
		puls			b,a	; Sacamos A y B de la pila
	
	comprueba4_comprueba4diagonalAbajoIzquierda_desigual:	
		
		andcc			#0xFB	; Si no hay cuatro en raya, apagamos el flag Z
		
	comprueba4_comprueba4diagonalAbajoIzquierda_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4diagonalAbajoIzquierda
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4horizontal				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si se ha generado un cuatro en raya en torno a la ficha 	;
; con direccion en Y, sobre la horizontal.				;
; La direccion base del tablero debe estar en X				;
;									;
; Input: posicion ficha Y, tablero X					;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4horizontal:
		
		pshs			y,a,cc
		
		lbsr			ldaColumna
		pshs			a		; Almacen temporal
		suba			NumCols
		nega					; Dividimos las opciones entre
		cmpa			,s		; las posiciones entre 0-[NumCols/2]
							; y NumCols/2-NumCols
							
		bhs			comprueba4_c4horizontal_mitadAlta
		
		
		
		
	comprueba4_c4horizontal_mitadBaja:
												;;;;;;;;;
		tfr			s,d	; Hueco en la pila					;
		subd			#1	; para un contador					;
		tfr			d,s	;							;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		comprueba4_c4horizontal_for1:								;
													;
			lda			#4							;
			cmpa			,s							;
			beq			comprueba4_c4horizontal_finFor1				;
			lbsr			posColumna0						;
			beq			comprueba4_c4horizontal_Col0				;
													;
				lbsr			comprueba4filaDerecha				; for (contador = 0;
				beq			comprueba4_c4horizontal_4enRaya			;	contador < 4, Posicion > 0;
				tfr			y,d	; Comprobamos en la posicion anterior	;	contador++, 
				subd			#1	;					;	Posicion = Posicion_anterior)
				tfr			d,y	;					;
				inc			,s	; Aumentamos contador			;	Comprobar4filaDerecha
													;
			bra			comprueba4_c4horizontal_for1				;
													;
			comprueba4_c4horizontal_Col0:							;
													;
			lbsr			comprueba4filaDerecha					;
			beq			comprueba4_c4horizontal_4enRaya				;
													;
	comprueba4_c4horizontal_finFor1:							;;;;;;;;;
			
		bra			comprueba4_c4horizontal_finTest	; No hay cuatro en raya
			
			
			
	comprueba4_c4horizontal_mitadAlta:
												;;;;;;;;;
		tfr			s,d	; Hueco en la pila					;
		subd			#1	; para un contador					;
		tfr			d,s	;							;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		comprueba4_c4horizontal_for2:								;
													;
			lda			#4							;
			cmpa			,s							;
			beq			comprueba4_c4horizontal_finFor2				;
			lbsr			posColumnaN						;
			beq			comprueba4_c4horizontal_ColN				;
													;
				lbsr			comprueba4filaIzquierda				; for (contador = 0;
				beq			comprueba4_c4horizontal_4enRaya			;	contador < 4, 
				tfr			y,d	; Comprobamos en la posicion anterior	;	Posicion < NumCols;
				addd			#1	;					;	contador++,
				tfr			d,y	;					;	Posicion = Posicion_siguiente)
				inc			,s	; Aumentamos contador			;	
													;	Comprobar4filaIzquierda
			bra			comprueba4_c4horizontal_for2				;	
													;
			comprueba4_c4horizontal_ColN:							;
													;
			lbsr			comprueba4filaIzquierda					;
			beq			comprueba4_c4horizontal_4enRaya				;
													;
	comprueba4_c4horizontal_finFor2:							;;;;;;;;;
			
		bra			comprueba4_c4horizontal_finTest	; No hay cuatro en raya
	
	
	
	comprueba4_c4horizontal_4enRaya:
	
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos el almacenamiento temporal
		puls			y,a,cc 	; Recuperamos estado
		
		orcc			#0x04	; Ponemos el flag Z a 1
		rts
		
	
	comprueba4_c4horizontal_finTest:
		
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos el almacenamiento temporal
		puls			y,a,cc 	; Recuperamos estado
		
		andcc			#0xFB	; Ponemos el flag Z a 0
		rts

;--------------------------------------------------------------;
		; Fin comprueba4horizontal
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4vertical				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si se ha generado un cuatro en raya en torno a la ficha 	;
; con direccion en Y. La direccion base del tablero debe estar en X	;
;									;
; Input: posicion ficha Y, tablero X				;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4vertical:
		
		pshs			y,a,cc
		
		lbsr			ldaFila
		pshs			a		; Almacen temporal
		suba			NumFils
		nega					; Dividimos las opciones entre
		cmpa			,s		; las posiciones entre 0-[NumFils/2]
							; y NumFils/2-NumFils
							
		bhs			comprueba4_c4vertical_mitadAlta
		
		
		
		
	comprueba4_c4vertical_mitadBaja:
												;;;;;;;;;
		tfr			s,d	; Hueco en la pila					;
		subd			#1	; para un contador					;
		tfr			d,s	;							;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		comprueba4_c4vertical_for1:								;
													;
			lda			#4							;
			cmpa			,s							;
			beq			comprueba4_c4vertical_finFor1				;
			lbsr			posFila0						;
			beq			comprueba4_c4vertical_Fil0				;
													;
				lbsr			comprueba4columnaAbajo				; for (contador = 0;
				beq			comprueba4_c4vertical_4enRaya			;	contador < 4, Posicion > 0;
				pshs			y	; Temporal				;
				ldb			NumCols	; 					;	contador++, 
				clra				; Comprobamos posicion anterior		;	Posicion = Posicion_anterior)
				subd			,s	;					;
				lbsr			negd	;					;	Comprobar4ColumnaAbajo
				puls			y	;					;
				tfr			d,y	;					;
													;
				inc			,s	; Aumentamos contador			;	
													;
			bra			comprueba4_c4vertical_for1				;
													;
			comprueba4_c4vertical_Fil0:							;
													;
			lbsr			comprueba4columnaAbajo					;
			beq			comprueba4_c4vertical_4enRaya				;
													;
	comprueba4_c4vertical_finFor1:								;;;;;;;;;
			
		bra			comprueba4_c4vertical_finTest	; No hay cuatro en raya
			
			
			
	comprueba4_c4vertical_mitadAlta:
												;;;;;;;;;
		tfr			s,d	; Hueco en la pila					;
		subd			#1	; para un contador					;
		tfr			d,s	;							;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		comprueba4_c4vertical_for2:								;
													;
			lda			#4							;
			cmpa			,s							;
			beq			comprueba4_c4vertical_finFor2				;
			lbsr			posFilaN						;
			beq			comprueba4_c4vertical_FilN				;
													;
				lbsr			comprueba4columnaArriba				; for (contador = 0;
				beq			comprueba4_c4vertical_4enRaya			;	contador < 4, 
				pshs			y	; Temporal				;	Posicion < NumCols;
				ldb			NumCols ;					;	contador++,
				clra				; Comprobamos posicion siguiente	;	Posicion = Posicion_anterior)
				addd			,s	;					;
				puls			y	;					;	Comprobar4ColumnaDerecha
				tfr			d,y	;					;	
				inc			,s	; Aumentamos contador			;	
													;	
			bra			comprueba4_c4vertical_for2				;	
													;
			comprueba4_c4vertical_FilN:							;
													;
			lbsr			comprueba4columnaArriba					;
			beq			comprueba4_c4vertical_4enRaya				;
													;
	comprueba4_c4vertical_finFor2:								;;;;;;;;;
			
		bra			comprueba4_c4vertical_finTest	; No hay cuatro en raya
	
	
	
	comprueba4_c4vertical_4enRaya:
	
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos el almacenamiento temporal
		puls			y,a,cc 	; Recuperamos estado
		
		orcc			#0x04	; Ponemos el flag Z a 1
		rts
		
	
	comprueba4_c4vertical_finTest:
		
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos el almacenamiento temporal
		puls			y,a,cc 	; Recuperamos estado
		
		andcc			#0xFB	; Ponemos el flag Z a 0
		rts

;--------------------------------------------------------------;
		; Fin comprueba4vertical
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			ejecutarDiagPosibleCodigoA			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba las diagonales posibles indicadas por el codigo contenido en;
; el nibble bajo del registro A, en torno a la ficha indicada por Y	;
;									;
; Existen 4 posibilidades: diagonal ascendente/descendente a derecha/	;
; izquierda.								;
; Los bits en A contendran, de MSB a LSB la codificacion de cuales se 	;
; pueden dar en sentido horario. Asi, por ejemplo, si A=0x03=0000 0011	;
; tenemos que: 								;
;		0 -> No puede haber diagonal ascendente a izquierda	;
;		0 -> No puede haber diagonal ascendente a derecha	;
;		1 -> Puede haber diagonal descendente a derecha		;
;		1 -> Puede haber diagonal descendente a izquierda	;
;									;
; (En este caso seria una posicion de fila > NumFils/2 y justo		;
; coincidente con el centro de las columnas, de numero impar)		;
;									;
; Devuelve Z = 1 si encuentra 4 en raya y Z = 0 en otro caso.		;
;									;
; Input: codigo en A, posicion ficha Y					;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ejecutarDiagPosibleCodigoA:
		
		pshs			a,cc
		tsta			; Si a es 0 no hacemos nada
		lbeq			c4_ejecutarDPCodigoA_finTest
	
	c4_ejecutarDPCodigoA_ArribaIzquierda:
	
		anda			#0x08	; Comprobamos diagonalArribaIzquierda
		lbeq			c4_ejecutarDPCodigoA_ArribaDerecha
			
			lbsr			comprueba4diagonalArribaIzquierda
			lbeq			c4_ejecutarDPCodigoA_4enRaya
			
	c4_ejecutarDPCodigoA_ArribaDerecha:
		
		lda			1,s	; Valor original
		anda			#0x04	; Comprobamos diagonalArribaDerecha
		lbeq			c4_ejecutarDPCodigoA_AbajoDerecha
		
			lbsr			comprueba4diagonalArribaDerecha
			lbeq			c4_ejecutarDPCodigoA_4enRaya
		
	c4_ejecutarDPCodigoA_AbajoDerecha:
	
		lda			1,s	; Valor original
		anda			#0x02	; Comprobamos diagonalAbajoDerecha
		lbeq			c4_ejecutarDPCodigoA_AbajoIzquierda
		
			lbsr			comprueba4diagonalAbajoDerecha
			lbeq			c4_ejecutarDPCodigoA_4enRaya

	c4_ejecutarDPCodigoA_AbajoIzquierda:

		lda			1,s	; Valor original
		anda			#0x01	; Comprobamos diagonalAbajoIzquierda
		lbeq			c4_ejecutarDPCodigoA_finTest
		
			lbsr			comprueba4diagonalAbajoIzquierda
			lbeq			c4_ejecutarDPCodigoA_4enRaya
			
			
	c4_ejecutarDPCodigoA_finTest:
	
		puls			a,cc
		andcc			#0xFB	; Ponemos Z a 0
		rts
		
	c4_ejecutarDPCodigoA_4enRaya:
	
		puls			a,cc
		orcc			#0x04	; Ponemos Z a 1
		rts

;--------------------------------------------------------------;
		; Fin ejecutarDiagPosibleCodigoA
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			codificaAdiagPosible				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Devuelve codificadas en el nibble bajo de A las diagonales posibles 	;
; para una posicion indicada en Y. 					;
;									;
; Existen 4 posibilidades: diagonal ascendente/descendente a derecha/	;
; izquierda.								;
; Los bits en A contendran, de MSB a LSB la codificacion de cuales se 	;
; pueden dar en sentido horario. Asi, por ejemplo, si A=0x03=0000 0011	;
; tenemos que: 								;
;		0 -> No puede haber diagonal ascendente a izquierda	;
;		0 -> No puede haber diagonal ascendente a derecha	;
;		1 -> Puede haber diagonal descendente a derecha		;
;		1 -> Puede haber diagonal descendente a izquierda	;
;									;
; (En este caso seria una posicion de fila > NumFils/2 y justo		;
; coincidente con el centro de las columnas, de numero impar)		;
;									;
; Input: posicion ficha Y, tablero X					;
; Output: registro A			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


codificaAdiagPosible:
		
		pshs			b,cc
		
		clra
		pshs			a	; Este hueco lo usaremos para almacenar el
						; resultado y extraerlo al final
						
		pshs			x	; Lo necesitamos un momento
		
		clra								;;;;;;;;;
		ldb			#2						;
		pshs			d						;
		tfr			s,x						;
		clra									;
		ldb			NumFils						;
		lbsr			div						;
		puls			a	; Como NumFils < 256, no lo pisamos	; 
		puls			a	;					; Guardamos numFils/2 y 
		pshs			b						; nomCols/2 en la pila
		clra									; pues se usan con frecuencia
		ldb			#2						; despues
		pshs			d						; .
		tfr			s,x						;
		clra									;
		ldb			NumCols						; En este segmento queda 0,s = numCols/2
		lbsr			div						; y 1,s = numFils/2
		puls			a	; Como NumCols < 256, no lo pisamos	;
		puls			a	;					;
		pshs			b					;;;;;;;;;
		
		ldx			2,s	; Recuperamos la posicion base del tablero

		lbsr			ldaFila
		cmpa			1,s		; Vemos si la posicion es una
							; fila entre 0-NumFils/2 o 
							; NumFils/2-numFils
		
		lbhs			c4_cAdiagPosible_filaAlta
		
		
		
		
	c4_cAdiagPosible_filaBaja:		
	
			lbsr			ldaColumna
			cmpa			,s		; Vemos si la posicion es una
								; fila entre 0-NumCols/2 o 
								; NumCols/2-numCols
		
			lbhs			c4_cAdiagPosible_FB_columnaAlta
			
		c4_cAdiagPosible_FB_ColumnaBaja:
		
				ldb			4,s	; La posicion con el resultado
				orb			#0x02	; Codificacion de diagonalAbajoDerecha
				stb			4,s
				
				lbra			codificaAdiagPosible_finTest
					
		c4_cAdiagPosible_FB_columnaAlta:
				
				ldb			4,s	; La posicion con el resultado
				orb			#0x01	; Codificacion de diagonalAbajoIzquierda
				stb			4,s
				
				pshs			a
				lda			NumCols	; Solo se realiza
				ldb			#2	; esta comprobacion si es impar
				lbsr			amodb	; porque en caso contrario
				puls			a	; no pueden darse ambas
				tstb
				lbeq			codificaAdiagPosible_finTest
				
				cmpa			,s	; A sigue siendo la columna
				lbne			codificaAdiagPosible_finTest
				
					ldb			4,s	; La posicion con el resultado
					orb			#0x02	; Codificacion de diagonalAbajoDerecha
					stb			4,s
					
					lbra			codificaAdiagPosible_finTest
		
		
		
		
	c4_cAdiagPosible_filaAlta:
			
			pshs			a
			lda			NumFils	; Solo se realiza
			ldb			#2	; esta comprobacion si es impar
			lbsr			amodb	; porque en caso contrario
			puls			a	; no pueden darse ambas
			tstb
			lbeq			codificaAdiagPosible_SinFilaMedia
			
				cmpa			1,s	; A sigue siendo la fila
				lbeq			c4_cAdiagPosible_filaMedia
		
		codificaAdiagPosible_SinFilaMedia:
		
			lbsr			ldaColumna
			cmpa			,s		; Vemos si la posicion es una
								; fila entre 0-NumCols/2 o 
								; NumCols/2-numCols
		
			lbhs			c4_cAdiagPosible_FA_columnaAlta
			
		c4_cAdiagPosible_FA_ColumnaBaja:
		
				ldb			4,s	; La posicion con el resultado
				orb			#0x04	; Codificacion de diagonalArribaDerecha
				stb			4,s
				
				lbra			codificaAdiagPosible_finTest
				
				
		c4_cAdiagPosible_FA_columnaAlta:
				
				ldb			4,s	; La posicion con el resultado
				orb			#0x08	; Codificacion de diagonalArribaIzquierda
				stb			4,s
				
				pshs			a
				lda			NumCols	; Solo se realiza
				ldb			#2	; esta comprobacion si es impar
				lbsr			amodb	; porque en caso contrario
				puls			a	; no pueden darse ambas
				tstb
				lbeq			codificaAdiagPosible_finTest
				
				cmpa			,s	; A sigue siendo la columna
				lbne			codificaAdiagPosible_finTest
				
					ldb			4,s	; La posicion con el resultado
					orb			#0x04	; Codificacion de diagonalArribaDerecha
					stb			4,s
					
					lbra			codificaAdiagPosible_finTest
	
	c4_cAdiagPosible_filaMedia:
			
			lbsr			ldaColumna
			cmpa			,s		; Vemos si la posicion es una
								; fila entre 0-NumCols/2 o 
								; NumCols/2-numCols
		
			lbhs			c4_cAdiagPosible_FM_columnaAlta
			
		c4_cAdiagPosible_FM_ColumnaBaja:
		
				ldb			4,s	; La posicion con el resultado
				orb			#0x06	; Codificacion de diagonalArribaDerecha + abajoDerecha
				stb			4,s
				
				lbra			codificaAdiagPosible_finTest
				
		c4_cAdiagPosible_FM_columnaAlta:
				
				ldb			4,s	; La posicion con el resultado
				orb			#0x09	; Codificacion de diagonalArribaIzquierda + abajoIzquierda
				stb			4,s
				
				pshs			a
				lda			NumCols	; Solo se realiza
				ldb			#2	; esta comprobacion si es impar
				lbsr			amodb	; porque en caso contrario
				puls			a	; no pueden darse ambas
				tstb
				lbeq			codificaAdiagPosible_finTest
				
				cmpa			,s	; A sigue siendo la columna
				lbne			codificaAdiagPosible_finTest
				
					ldb			4,s	; La posicion con el resultado
					orb			#0x06	; Codificacion de diagonalArribaDerecha + abajoDerecha
					stb			4,s
					
					lbra			codificaAdiagPosible_finTest
					

	
	codificaAdiagPosible_finTest:
		
		puls			d	; Sacamos NumFils/2 y NumCols/2
		puls			x	; Sacamos la posicion base del tablero
		puls			a	; Sacamos nuestro resultado
		puls			b,cc
		rts

;--------------------------------------------------------------;
		; Fin codificaAdiagPosible
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4diagonal				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si se ha generado un cuatro en raya en torno a la ficha 	;
; con direccion en Y. La direccion base del tablero debe estar en X	;
;									;
; Input: posicion ficha Y, tablero X					;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4diagonal:
		
		pshs		y,d,cc
		
		clra
		pshs		a	; Nos servira de contador

	c4_c4diagonal_while_ArribaIzquierda:					;;;;;;;;;
											;
		lda			,s						;
		cmpa			#4						;
		lbeq			c4_c4diagonal_finWhile_ArribaIzquierda		;
											;
		lbsr			ldaFila						;
		tsta									;
		lbeq			c4_c4diagonal_while_ArribaIzquierda_borde	;
											;
		lbsr			ldaColumna					;
		tsta									;
		lbeq			c4_c4diagonal_while_ArribaIzquierda_borde	;	
											; while (contador < 4 && posAux != borde)
			lbsr			codificaAdiagPosible			;	comprueba4diagonalPosible
			anda			#0x02	; Solo queremos comprobar si	;	posAux = sigPosDiagArribaIzquierda
							; se ha formado abajoDerecha	;	contador++
			lbsr			ejecutarDiagPosibleCodigoA		;
			lbeq			comprueba4diagonal_4enRaya		;	
											;
		inc			,s	; Contador				;
		ldb			NumCols						;
		clra									;
		pshs			d						;
		tfr			y,d						;
		subd			,s						;
		subd			#1						;
		tfr			d,y						;
		puls			d						;
											;
		lbra			c4_c4diagonal_while_ArribaIzquierda		;
											;
											;
		c4_c4diagonal_while_ArribaIzquierda_borde:				;
											;
			lbsr			codificaAdiagPosible			;
			anda			#0x02	; Solo queremos comprobar si	;
							; se ha formado abajoDerecha	;
			lbsr			ejecutarDiagPosibleCodigoA		;
			lbeq			comprueba4diagonal_4enRaya		;
											;
	c4_c4diagonal_finWhile_ArribaIzquierda:					;;;;;;;;;




		ldy			4,s	; Recuperamos posicion original
		clra
		sta			,s	; Reiniciamos contador
		
	c4_c4diagonal_while_ArribaDerecha:							;;;;;;;;;
													;
		lda			,s								;
		cmpa			#4								;
		lbeq			c4_c4diagonal_finWhile_ArribaDerecha				;	
													;	
		lbsr			ldaFila								;
		tsta											;
		lbeq			c4_c4diagonal_while_ArribaDerecha_borde				;	
													;	
		lbsr			ldaColumna							;	
		pshs			a								;	
		lda			NumCols								;
		deca											;
		cmpa			,s								;	
		lbeq			c4_c4diagonal_while_ArribaDerecha_borde				; while (contador < 4 &&
													; 	posAux != borde)	
			puls			a	; Sacamos la A que hemos metido temporalmente	; {	
			lbsr			codificaAdiagPosible					; comprueba4diagonalPosible
			anda			#0x01	; Solo queremos comprobar si			; posAux = sigPosDiagArribaDerecha
							; se ha formado abajoIzquierda			; contador++
			lbsr			ejecutarDiagPosibleCodigoA				; }
			lbeq			comprueba4diagonal_4enRaya				;
													;
		inc			,s	; Contador						;
		ldb			NumCols								;
		clra											;
		pshs			d								;
		tfr			y,d								;
		subd			,s								;
		addd			#1								;
		tfr			d,y								;
		puls			d								;
													;
		lbra			c4_c4diagonal_while_ArribaDerecha				;
													;
													;
		c4_c4diagonal_while_ArribaDerecha_borde:						;
													;
			lbsr			codificaAdiagPosible					;
			anda			#0x01	; Solo queremos comprobar si			;
							; se ha formado abajoDerecha			;
			lbsr			ejecutarDiagPosibleCodigoA				;
			lbeq			comprueba4diagonal_4enRaya				;
													;
	c4_c4diagonal_finWhile_ArribaDerecha:							;;;;;;;;;


		ldy			4,s	; Recuperamos posicion original
		clra
		sta			,s	; Reiniciamos contador
		
	c4_c4diagonal_while_AbajoDerecha:						;;;;;;;;;
												;
		lda			,s							;
		cmpa			#4							;
		lbeq			c4_c4diagonal_finWhile_AbajoDerecha			;
												;
		lbsr			ldaFila							;
		pshs			a							;
		lda			NumFils							;
		deca										;
		cmpa			,s							;
		lbeq			c4_c4diagonal_while_AbajoDerecha_borde			;
												;
		puls			a	; Sacamos la A que hemos metido temporalmente	;	
		lbsr			ldaColumna						; while (contador < 4 &&
		pshs			a							; 	posAux != borde)
		lda			NumCols							;{	
		deca										; comprueba4diagonalPosible
		cmpa			,s							; posAux = sigPosDiagAbajoDerecha
		lbeq			c4_c4diagonal_while_AbajoDerecha_borde			; contador++
												;}
			puls			a ; Sacamos la A que hemos metido temporalmente	;
			lbsr			codificaAdiagPosible				;
			anda			#0x08	; Solo queremos comprobar si		;
							; se ha formado arribaIzquierda		;
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			comprueba4diagonal_4enRaya			;
												;
		inc			,s	; Contador					;
		ldb			NumCols							;
		clra										;
		pshs			d							;
		tfr			y,d							;
		addd			,s							;
		addd			#1							;
		tfr			d,y							;
		puls			d							;
												;	
		lbra			c4_c4diagonal_while_AbajoDerecha			;
												;
												;
		c4_c4diagonal_while_AbajoDerecha_borde:						;
												;
			lbsr			codificaAdiagPosible				;
			anda			#0x08	; Solo queremos comprobar si		;
							; se ha formado abajoDerecha		;
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			comprueba4diagonal_4enRaya			;
												;
	c4_c4diagonal_finWhile_AbajoDerecha:						;;;;;;;;;
	
	
		ldy			4,s	; Recuperamos posicion original
		clra
		sta			,s	; Reiniciamos contador
		
	c4_c4diagonal_while_AbajoIzquierda:						;;;;;;;;;
												;
		lda			,s							;	
		cmpa			#4							;
		lbeq			c4_c4diagonal_finWhile_AbajoIzquierda			;
												;
		lbsr			ldaFila							;
		pshs			a							;
		lda			NumFils							;
		deca										;
		cmpa			,s							;
		lbeq			c4_c4diagonal_while_AbajoIzquierda_borde		;
												;
		puls			a ; Sacamos la A que hemos metido temporalmente		;	
		lbsr			ldaColumna						; while (contador < 4 &&	
		tsta										; 	posAux != borde)
		lbeq			c4_c4diagonal_while_AbajoIzquierda_borde		;{	
												; comprueba4diagonalPosible
			lbsr			codificaAdiagPosible				; posAux = sigPosDiagAbajoIzquierda
			anda			#0x04	; Solo queremos comprobar si		; contador++
							; se ha formado arribaDerecha		;}
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			comprueba4diagonal_4enRaya			;
												;
		inc			,s	; Contador					;
		ldb			NumCols							;
		clra										;
		pshs			d							;
		tfr			y,d							;
		addd			,s							;
		subd			#1							;
		tfr			d,y							;
		puls			d							;
												;
		lbra			c4_c4diagonal_while_AbajoIzquierda			;
												;
												;
		c4_c4diagonal_while_AbajoIzquierda_borde:					;
												;
			lbsr			codificaAdiagPosible				;
			anda			#0x04	; Solo queremos comprobar si		;
							; se ha formado abajoDerecha		;
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			comprueba4diagonal_4enRaya			;
												;
	c4_c4diagonal_finWhile_AbajoIzquierda:						;;;;;;;;;



		puls			a	; Eliminamos el contador
		puls			y,d,cc
		andcc			#0xFB	; Ponemos Z a 0
		rts

	comprueba4diagonal_4enRaya:

		puls			a	; Eliminamos el contador
		puls			y,d,cc
		orcc			#0x04	; Ponemos Z a 1
		rts

;--------------------------------------------------------------;
		; Fin comprueba4diagonal	
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				comprueba4				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si se ha generado un cuatro en raya en torno a la ficha 	;
; con direccion en Y. La direccion base del tablero debe estar en X	;
;									;
; Input: posicion ficha Y, tablero X				;
; Output: flag Z			.				;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprueba4:
		pshs			y,x,d
		
	comprueba4_comprueba4_caseFil0:
	
		lbsr			posFila0
		bne			comprueba4_comprueba4_caseFilN
		
			lbsr			comprueba4filaIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4filaDerecha
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalAbajoIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4columnaAbajo
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalAbajoDerecha
			lbeq			comprueba4_comprueba4_finTest
				
	comprueba4_comprueba4_caseFilN:	
	
		lbsr			posFilaN
		bne			comprueba4_comprueba4_caseCol0
		
			lbsr			comprueba4filaIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4filaDerecha
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalArribaIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4columnaArriba
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalArribaDerecha
			lbeq			comprueba4_comprueba4_finTest
	
	
	comprueba4_comprueba4_caseCol0:	
	
		lbsr			posColumna0
		bne			comprueba4_comprueba4_caseColN
		
			lbsr			comprueba4columnaArriba
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalArribaDerecha
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4filaDerecha
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalAbajoDerecha
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4columnaAbajo
			lbeq			comprueba4_comprueba4_finTest
			
			
	comprueba4_comprueba4_caseColN:	
	
		lbsr			posColumnaN
		bne			comprueba4_comprueba4_caseDefault
		
			lbsr			comprueba4columnaArriba
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalArribaIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4filaIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4diagonalAbajoIzquierda
			lbeq			comprueba4_comprueba4_finTest
		
			lbsr			comprueba4columnaAbajo
			lbeq			comprueba4_comprueba4_finTest			
		
		
	comprueba4_comprueba4_caseDefault:	
	
		lbsr			comprueba4diagonalArribaIzquierda
		lbeq			comprueba4_comprueba4_finTest
	
		lbsr			comprueba4columnaArriba
		lbeq			comprueba4_comprueba4_finTest
	
		lbsr			comprueba4diagonalArribaDerecha
		lbeq			comprueba4_comprueba4_finTest
	
		lbsr			comprueba4filaIzquierda
		lbeq			comprueba4_comprueba4_finTest
	
		lbsr			comprueba4filaDerecha
		lbeq			comprueba4_comprueba4_finTest
		
		lbsr			comprueba4diagonalAbajoIzquierda
		lbeq			comprueba4_comprueba4_finTest
		
		lbsr			comprueba4columnaAbajo
		lbeq			comprueba4_comprueba4_finTest
		
		lbsr			comprueba4diagonalAbajoDerecha
		lbeq			comprueba4_comprueba4_finTest
			
			
	comprueba4_comprueba4_finTest:
	
		puls			y,x,d
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4
