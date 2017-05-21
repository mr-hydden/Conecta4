;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprueba4.asm				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo de funciones de alto nivel para comprobar la existencia;
; de una posicion de 4 en raya. Empleando las herramientas de	;
; comprueba4-bajoNivel.asm, estas subrutinas realizan un	;
; analisis completo y eficiente del tablero en busca de un 4	;
; en raya, dada una posicion de referencia.			;
; 								;
; Autor: Samuel Gomez Sanchez y Miguel Diaz Galan		;
;								;
; Subrutinas:	comprueba4horizontal				;
;		comprueba4vertical				;
;		comprueba4diagonal				;
;		comprueba4					;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		
		
		
		
		
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
		
		.globl			ldaFila
		.globl			ldaColumna
		
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
		inca
		pshs			a		; Almacen temporal
		suba			NumCols
		nega					; Dividimos las opciones entre
		cmpa			,s		; las posiciones entre 0-[NumCols/2]
							; y NumCols/2-NumCols
							
		lblo			c4_c4h_mitadAlta
		
		
		
		
	c4_c4h_mitadBaja:
												;;;;;;;;;
		pshs			a	; Hueco en la pila					;
						; para un contador					;
						;							;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		c4_c4h_for1:										;
													;
			lda			#4							;
			cmpa			,s							;
			lbeq			c4_c4h_finFor1						;
			lbsr			ldaColumna						;
			tsta										;
			lbeq			c4_c4h_Col0						;
													;
				lbsr			comprueba4filaDerecha				; for (contador = 0;
				lbeq			c4_c4h_4enRaya					;	contador < 4, Posicion > 0;
				tfr			y,d	; Comprobamos en la posicion anterior	;	contador++, 
				subd			#1	;					;	Posicion = Posicion_anterior)
				tfr			d,y	;					;
				inc			,s	; Aumentamos contador			;	Comprobar4filaDerecha
													;
			lbra			c4_c4h_for1						;
													;
			c4_c4h_Col0:									;
													;
			lbsr			comprueba4filaDerecha					;
			lbeq			c4_c4h_4enRaya						;
													;
	c4_c4h_finFor1:										;;;;;;;;;
			
		lbra			c4_c4h_finTest	; No hay cuatro en raya
			
			
			
	c4_c4h_mitadAlta:
												;;;;;;;;;
		pshs			a	; Hueco en la pila					;
						; para un contador					;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		c4_c4h_for2:										;
													;
			lda			#4							;
			cmpa			,s							;
			lbeq			c4_c4h_finFor2						;
			lbsr			ldaColumna						;
			pshs			a							;
			lda			NumCols							;
			deca										;
			cmpa			,s							;
			lbeq			c4_c4h_ColN						;
													;
				puls			b ; Sacamos el A guardado temporalmente		;
				lbsr			comprueba4filaIzquierda				; for (contador = 0;
				lbeq			c4_c4h_4enRaya					;	contador < 4, 
				tfr			y,d	; Comprobamos en la posicion anterior	;	Posicion < NumCols;
				addd			#1	;					;	contador++,
				tfr			d,y	;					;	Posicion = Posicion_siguiente)
				inc			,s	; Aumentamos contador			;	
													;	Comprobar4filaIzquierda
			lbra			c4_c4h_for2						;	
													;
			c4_c4h_ColN:									;
													;
			puls			b ; Sacamos el A guardado temporalmente			;
			lbsr			comprueba4filaIzquierda					;
			lbeq			c4_c4h_4enRaya						;
													;
	c4_c4h_finFor2:										;;;;;;;;;
			
		lbra			c4_c4h_finTest	; No hay cuatro en raya
	
	
	
	c4_c4h_4enRaya:
	
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos el almacenamiento temporal
		puls			y,a,cc 	; Recuperamos estado
		
		orcc			#0x04	; Ponemos el flag Z a 1
		rts
		
	
	c4_c4h_finTest:
		
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
		inca
		pshs			a		; Almacen temporal
		suba			NumFils
		nega					; Dividimos las opciones entre
		cmpa			,s		; las posiciones entre 0-[NumFils/2]
							; y NumFils/2-NumFils
							
		lblo			c4_c4v_mitadAlta
		
		
		
		
	c4_c4v_mitadBaja:
												;;;;;;;;;
		pshs			a	; Hueco en la pila					;
						; para un contador					;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		c4_c4v_for1:										;
													;
			lda			#4							;
			cmpa			,s							;
			lbeq			c4_c4v_finFor1						;
			lbsr			ldaFila							;
			tsta										;
			lbeq			c4_c4v_Fil0						;
													;
				lbsr			comprueba4columnaAbajo				; for (contador = 0;
				lbeq			c4_c4v_4enRaya					;	contador < 4, Posicion > 0;
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
			lbra			c4_c4v_for1						;
													;
			c4_c4v_Fil0:									;
													;
			lbsr			comprueba4columnaAbajo					;
			lbeq			c4_c4v_4enRaya						;
													;
	c4_c4v_finFor1:										;;;;;;;;;
			
		lbra			c4_c4v_finTest	; No hay cuatro en raya
			
			
			
	c4_c4v_mitadAlta:
												;;;;;;;;;
		pshs			a	; Hueco en la pila					;
						; para un contador					;
													;
		clra				; Inicializamos contador a 0				;
		sta			,s	;							;
													;
		c4_c4v_for2:										;
													;
			lda			#4							;
			cmpa			,s							;
			lbeq			c4_c4v_finFor2						;
			lbsr			ldaFila							;
			pshs			a							;
			lda			NumFils							;
			deca										;
			cmpa			,s							;
			lbeq			c4_c4v_FilN						;
													;
				puls			b ; Sacamos el A guardado temporalmente		;
				lbsr			comprueba4columnaArriba				; for (contador = 0;
				lbeq			c4_c4v_4enRaya					;	contador < 4, 
				pshs			y	; Temporal				;	Posicion < NumCols;
				ldb			NumCols ;					;	contador++,
				clra				; Comprobamos posicion siguiente	;	Posicion = Posicion_anterior)
				addd			,s	;					;
				puls			y	;					;	Comprobar4ColumnaDerecha
				tfr			d,y	;					;	
				inc			,s	; Aumentamos contador			;	
													;	
			lbra			c4_c4v_for2						;	
													;
			c4_c4v_FilN:									;
			puls			b ; Sacamos el A guardado temporalmente			;
			lbsr			comprueba4columnaArriba					;
			lbeq			c4_c4v_4enRaya						;
													;
	c4_c4v_finFor2:										;;;;;;;;;
			
		lbra			c4_c4v_finTest	; No hay cuatro en raya
	
	
	
	c4_c4v_4enRaya:
	
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos almacen temporal
		puls			y,a,cc 	; Recuperamos estado
		
		orcc			#0x04	; Ponemos el flag Z a 1
		rts
		
	
	c4_c4v_finTest:
		
		puls			a	; Eliminamos el contador
		puls			a	; Eliminamos almacen temporal
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

	c4_c4d_while_ArI:							;;;;;;;;;
											;
		lda			,s						;
		cmpa			#4						;
		lbeq			c4_c4d_finWhile_ArI				;
											;
		lbsr			ldaFila						;
		tsta									;
		lbeq			c4_c4d_while_ArI_borde				;
											;
		lbsr			ldaColumna					;
		tsta									;
		lbeq			c4_c4d_while_ArI_borde				;	
											; while (contador < 4 && posAux != borde)
			lbsr			codificaAdiagPosible			;	comprueba4diagonalPosible
			anda			#0x02	; Solo queremos comprobar si	;	posAux = sigPosDiagArribaIzquierda
							; se ha formado abajoDerecha	;	contador++
			lbsr			ejecutarDiagPosibleCodigoA		;
			lbeq			c4_c4d_4enRaya				;	
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
		lbra			c4_c4d_while_ArI				;
											;
											;
		c4_c4d_while_ArI_borde:							;
											;
			lbsr			codificaAdiagPosible			;
			anda			#0x02	; Solo queremos comprobar si	;
							; se ha formado abajoDerecha	;
			lbsr			ejecutarDiagPosibleCodigoA		;
			lbeq			c4_c4d_4enRaya				;
											;
	c4_c4d_finWhile_ArI:							;;;;;;;;;




		ldy			4,s	; Recuperamos posicion original
		clra
		sta			,s	; Reiniciamos contador
		
	c4_c4d_while_ArD:									;;;;;;;;;
													;
		lda			,s								;
		cmpa			#4								;
		lbeq			c4_c4d_finWhile_ArD						;	
													;	
		lbsr			ldaFila								;
		tsta											;
		lbeq			c4_c4d_while_ArD_borde						;	
													;	
		lbsr			ldaColumna							;	
		pshs			a								;	
		lda			NumCols								;
		deca											;
		cmpa			,s								;	
		lbeq			c4_c4d_while_ArD_bordeA						; while (contador < 4 &&
													; 	posAux != borde)	
			puls			a	; Sacamos la A que hemos metido temporalmente	; {	
			lbsr			codificaAdiagPosible					; comprueba4diagonalPosible
			anda			#0x01	; Solo queremos comprobar si			; posAux = sigPosDiagArribaDerecha
							; se ha formado abajoIzquierda			; contador++
			lbsr			ejecutarDiagPosibleCodigoA				; }
			lbeq			c4_c4d_4enRaya						;
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
		lbra			c4_c4d_while_ArD						;
													;
													;
		c4_c4d_while_ArD_bordeA:								;
													;
			puls			a	; Sacamos la A que hemos metido temporalmente	;
													;
		c4_c4d_while_ArD_borde:									;
													;
			lbsr			codificaAdiagPosible					;
			anda			#0x01	; Solo queremos comprobar si			;
							; se ha formado abajoDerecha			;
			lbsr			ejecutarDiagPosibleCodigoA				;
			lbeq			c4_c4d_4enRaya						;
													;
	c4_c4d_finWhile_ArD:									;;;;;;;;;


		ldy			4,s	; Recuperamos posicion original
		clra
		sta			,s	; Reiniciamos contador
		
	c4_c4d_while_AbD:								;;;;;;;;;
												;
		lda			,s							;
		cmpa			#4							;
		lbeq			c4_c4d_finWhile_AbD					;
												;
		lbsr			ldaFila							;
		pshs			a							;
		lda			NumFils							;
		deca										;
		cmpa			,s							;
		lbeq			c4_c4d_while_AbD_borde					;
												;
		puls			a	; Sacamos la A que hemos metido temporalmente	;	
		lbsr			ldaColumna						; while (contador < 4 &&
		pshs			a							; 	posAux != borde)
		lda			NumCols							;{	
		deca										; comprueba4diagonalPosible
		cmpa			,s							; posAux = sigPosDiagAbajoDerecha
		lbeq			c4_c4d_while_AbD_borde					; contador++
												;}
			puls			a ; Sacamos la A que hemos metido temporalmente	;
			lbsr			codificaAdiagPosible				;
			anda			#0x08	; Solo queremos comprobar si		;
							; se ha formado arribaIzquierda		;
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			c4_c4d_4enRaya					;
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
		lbra			c4_c4d_while_AbD					;
												;
												;
		c4_c4d_while_AbD_borde:								;
												;
			puls			a ; Sacamos la A que hemos metido temporalmente	;
			lbsr			codificaAdiagPosible				;
			anda			#0x08	; Solo queremos comprobar si		;
							; se ha formado abajoDerecha		;
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			c4_c4d_4enRaya					;
												;
	c4_c4d_finWhile_AbD:								;;;;;;;;;
	
	
		ldy			4,s	; Recuperamos posicion original
		clra
		sta			,s	; Reiniciamos contador
		
	c4_c4d_while_AbI:								;;;;;;;;;	
												;
		lda			,s							;	
		cmpa			#4							;
		lbeq			c4_c4d_finWhile_AbI					;
												;
		lbsr			ldaFila							;
		pshs			a							;
		lda			NumFils							;
		deca										;
		cmpa			,s							;
		lbeq			c4_c4d_while_AbI_bordeA					;
												;
		puls			a ; Sacamos la A que hemos metido temporalmente		;	
		lbsr			ldaColumna						; while (contador < 4 &&	
		tsta										; 	posAux != borde)
		lbeq			c4_c4d_while_AbI_borde					;{	
												; comprueba4diagonalPosible
			lbsr			codificaAdiagPosible				; posAux = sigPosDiagAbajoIzquierda
			anda			#0x04	; Solo queremos comprobar si		; contador++
							; se ha formado arribaDerecha		;}
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			c4_c4d_4enRaya					;
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
		lbra			c4_c4d_while_AbI					;
												;
		c4_c4d_while_AbI_bordeA:							;
												;
			puls			a ; Sacamos la A que hemos metido temporalmente	;			
												;
		c4_c4d_while_AbI_borde:								;
												;
			lbsr			codificaAdiagPosible				;
			anda			#0x04	; Solo queremos comprobar si		;
							; se ha formado abajoDerecha		;
			lbsr			ejecutarDiagPosibleCodigoA			;
			lbeq			c4_c4d_4enRaya					;
												;
	c4_c4d_finWhile_AbI:								;;;;;;;;;



		puls			a	; Eliminamos el contador
		puls			y,d,cc
		andcc			#0xFB	; Ponemos Z a 0
		rts

	c4_c4d_4enRaya:

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
