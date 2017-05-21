;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			internal.asm				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo de herramientas utilizadas en el contexto del juego.	;
; Contiene subrutinas para obtener la direccion de memoria de 	;
; una ficha del tablero, calcular la fila o la columna de una	;
; posicion dada en el tablero, comprobar si una columna esta	;
; llena, etc.							;
; 								;
; Autor: Samuel Gomez Sanchez y Miguel Diaz Galan		;
;								;
; Subrutinas:	ldaFila						;
;		ldaColumna					;
;		posicionij					;
;		generarTablero					;
;		columnaLlena					;
;		tableroLleno					;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

		
		
		
		
		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			internal
		
		.area			_INTERNAL
				
		;>>>> Etiquetas globales internas <<<<
		
		.globl			posicionij
		.globl			generarTablero
		.globl			tableroLleno
		.globl			columnaLlena
		.globl			ldaFila
		.globl			ldaColumna
		
		;------------------------------------;
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			amodb
		.globl			div
		
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

		;>>>> Objetos de columnaLlena <<<<
		
			;>>>> Variables <<<<
			bColumnaLlena_Col:
				.byte			0
		;-------------------------------;
		; Fin objetos columnaLlena
		
		
		;>>>> Objetos generarTablero <<<<
		
			; >>>> Variables  <<<<
			wGenerarTablero_NumCeldas:.word	0
				
		;---------------------------------------;
		; Fin objetos generarTablero
	
		;>>>> Objetos globales compartidos <<<<
			; >>>> Variables <<<<
			.globl			SiguientePosicionDinamica
	
	
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				ldaFila					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Carga en A la fila en la que se encuentra la posicion indicada 	;
; en el registro Y. La posicion base del tablero debe estar en X	;
;									;
; Input: posicion registro Y, tablero registro X			;
; Output: registro A			.				;
;									;
; Registros afectados: A						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

ldaFila:
		pshs			x,b,cc
		
		tfr			y,d
		subd			2,s		; Posicion base del tablero
		
		lda			NumCols		;
		pshs			a		; Guardamos temporalmente NumCols con 16 bits
		clra					; en la pila para poder dividir
		pshs			a		; 
		
		tfr			s,x		; La posicion siempre es igual a NumCols*fila + columna
		lbsr			div		; por ello [(NumCols*fila + columna)/NumCols] = fila
						
		tfr			b,a	; Siempre menor o igual a NumFils
		
		puls			x	; Extraemos NumCols
		puls			x,b,cc
		
		rts
		
;--------------------------------------------------------------;
		; Fin ldaFila
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				ldaColumna				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Carga en A la columna en la que se encuentra la posicion indicada 	;
; en el registro Y. La posicion base del tablero debe estar en X	;
;									;
; Input: posicion registro Y, tablero registro X			;
; Output: registro A			.				;
;									;
; Registros afectados: A						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

ldaColumna:
		pshs			x,b,cc
		
		tfr			y,d
		subd			2,s	; Posicion base del tablero
		tfr			b,a	; Siempre menor de NumFils * NumCols < 256
		ldb			NumCols	; La posicion siempre es igual a NumCols*fila + columna
		lbsr			amodb	; por ello [NumCols*fila + columna] = columna
		tfr			b,a
		
		puls			x,b,cc
		
		rts
		
;--------------------------------------------------------------;
		; Fin ldaColumna
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				posicionij				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Devuelve en el registro Y la direccion de la posicion ij del tablero	;
; siendo i indicado en el registro A y j en el registro B. La direccion	;
; base del tablero debe estar guardada en X				;
;									;
; Input: fila registro A, columna registro B, tablero registro X	;
; Output: registro Y			.				;
;									;
; Registros afectados: CC, Y						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

posicionij:
		pshs			d

		clra
		pshs			d	; Guardamos #0 y el contenido del registro B en S
		pshs			x	; Guardamos X en la pila
		ldd			4,s
		
		ldb			NumCols
		mul
		
		addd			,s
		addd			2,s 	; Operacion resultante: A*B+X+B = 
						; = posicion base + fila * NumCols + col
		
		puls			y	; Sacamos X y 0/B de la pila
		puls			y
		
		tfr			d,y
		
		puls			d
		rts

;--------------------------------------------------------------------;		
		; Fin posicionij
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			generarTablero					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Genera un tablero vacio con el numero de celdas indicado en D, cuya	;
; direccion devuelve en Y.						;
;									;
; Input: numero de celdas registro D					;
; Output: registro Y			 				;
;									;
; Registros afectados: CC, Y						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

generarTablero:
		pshs			d
		
		std			wGenerarTablero_NumCeldas
		
		tfr			s,d	; Hacemos espacio para 
		subd			#2	; un contador en la pila
		tfr			d,s	;
		
		ldd			SiguientePosicionDinamica		;;;;;;;;;
		pshs			d						;
		clra									;
		clrb									;
		std			2,s	; Inicializamos contador a 0		;
											;
	internal_generarTablero_for:							;
											; for (contador = 0; contador < numCeldas; contador++)
		ldd			2,s						;	guarda(caracterEspacio,
		cmpd			wGenerarTablero_NumCeldas			;		SiguientePosicionDinamica)
		beq			internal_generarTablero_finFor			;	SiguientePosicionDinamica++
											;
			lda			#0x20					;
			sta			[SiguientePosicionDinamica]		;
			ldd			SiguientePosicionDinamica		;
			addd			#1					;
			std			SiguientePosicionDinamica		;
											;
		ldd			2,s						;
		addd			#1						;
		std			2,s						;
		bra			internal_generarTablero_for			;
										;;;;;;;;;
	internal_generarTablero_finFor:			
		
		puls			y	; Guardamos direccion de inicio del tablero
		
		puls			d	; Eliminamos contador
		puls			d	; Sacamos D de la pila
		
		rts

;--------------------------------------------------------------------;
		; Fin generarTablero
		
		
		
		
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				columnaLlena				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay algun hueco libre en la columna indicada en el 	;
; registro B y guarda la direccion del primer hueco libre.		;
; Mediante el flag Z se indica si existe ese hueco libre: si esta a 0	;
; se encontro un hueco libre que se devuelve en el registro Y. En caso	;
; contrario, Z = 1							;
;									;
; Input: direccion base del tablero en X, numero de columna en B.	;
; Output: registro Y, flag Z						;
;									;
; Registros afectados: Y, CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

columnaLlena:

		pshs			d
		
		decb
		stb			bColumnaLlena_Col
			
		tfr			s,d	; Hacemos hueco
		subd			#1	; en la pila para
		tfr			d,s	; un contador
		
		lda			NumFils					;;;;;;;;;
		deca									;
		sta			,s	; Inicializamos contador a NumFils -1 	;
						; e Y a la posicion mas baja del tablero;
		lda			NumFils	; en esa columna			;
		deca									;
		ldb			bColumnaLlena_Col				;
		jsr			posicionij					;
											;
	internal_columnaLlena_for:							;
											;
		lda			#-1						;
		cmpa			,s						;
		beq			internal_columnaLlena_finFor			; for (contador = NumFils -1;
		lda			,y						;	contador >= 0, Y == fichaJugador;
		cmpa			FichaJugador1					;	--contador)
		bne			internal_columnaLlena_compararFicha2		;
		bra			internal_columnaLlena_seguir			;	Y = posicionij (contador, 
											;			bColumnaLlena_Col);
	internal_columnaLlena_compararFicha2:						;
											;
		cmpa			FichaJugador2					;
		bne			internal_columnaLlena_finFor			;
											;
	internal_columnaLlena_seguir:							;
											;
			lda			,s					;
			ldb			bColumnaLlena_Col			;
			; X no se ha visto modificado.					;
			jsr			posicionij				;		
											;
		dec			,s						;
		bra			internal_columnaLlena_for			;
											;
	internal_columnaLlena_finFor:						;;;;;;;;;
	
		lda			,y
		cmpa			FichaJugador1
		beq			internal_columnaLlena_Llena
		cmpa			FichaJugador2
		beq			internal_columnaLlena_Llena
		
		andcc			#0xFB	; Ponemos a 0 el flag Z
		bra			internal_columnaLlena_finTest
		
	internal_columnaLlena_Llena:
		
		orcc			#0x04	; Ponemos a 1 el flag Z
		
	internal_columnaLlena_finTest:
	
		puls			a	; Eliminamos el contador de la pila
		
		puls			d	
		rts
		

;--------------------------------------------------------------------;
		; Fin columnaLlena
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				tableroLleno				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si el tablero con base en X esta lleno. Devuelve Z = 1 si 	;
; esta lleno y Z = 0 si hay algun hueco.				;
;									;
; Input: base tablero registro X					;
; Output: flag Z							;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

tableroLleno:
		pshs			y,x,d
		
		lda			NumFils				
		ldb			NumCols				
		deca							
		decb							
		lbsr			posicionij			
		pshs			y				
									
	internal_tableroLleno_while:					;;;;;;;;;
										;
		tfr			x,d					;
		cmpd			,s					;
		bhi			internal_tableroLleno_finWhile		;
										;
			lda			#0x20 ; Caracter espacio	; for  (X = tablero[0][0];
			cmpa			,x+				;	X < tablero[NumFils - 1][NumCols -1];
			beq			internal_tableroLleno_hueco	;	++X)
										;		if (esHueco)
		bra			internal_tableroLleno_while		;			break
										;
	internal_tableroLleno_hueco:						;
										;
		andcc			#0xFB	; Ponemos Z a 0			;
		bra			internal_tableroLleno_finTest		;
										;
	internal_tableroLleno_finWhile:					;;;;;;;;;
	
		orcc			#0x04	; Ponemos Z a 1
		
	internal_tableroLleno_finTest:
	
		puls			y	; Sacamos el valor de la Y final
		puls			y,x,d
	
		rts
	
	
		
;--------------------------------------------------------------------;
		; Fin tableroLleno
		
		
		
