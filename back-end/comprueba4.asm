		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			comprueba4
		
		.area			_COMPRUEBA4
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			comprueba4
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			negd
		
		.globl			comprueba4filaDerecha
		.globl			comprueba4filaIzquierda
		.globl			comprueba4columnaAbajo
		.globl			comprueba4columnaArriba
		.globl			ejecutarDiagPosibleCodigoA
		.globl			codificaAdiagPosible
		
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
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
			

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
; con direccion en Y, en la vertical.					;
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
;			comprueba4diagonal				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si se ha generado un cuatro en raya en torno a la ficha 	;
; con direccion en Y, en alguna de las diagonales			;
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
		pshs			cc
		
		lbsr			comprueba4horizontal
		lbeq			comprueba4_comprueba4_4enRaya
		
		lbsr			comprueba4vertical
		lbeq			comprueba4_comprueba4_4enRaya
		
		lbsr			comprueba4diagonal
		lbeq			comprueba4_comprueba4_4enRaya
		
		puls			cc
		andcc			#0xFB	; Ponemos Z a 0
		rts

	comprueba4_comprueba4_4enRaya:
		
		puls			cc
		orcc			#0x04	; Ponemos Z a 1
		rts

;--------------------------------------------------------------------;
		; Fin comprueba4
