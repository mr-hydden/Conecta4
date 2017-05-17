		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			internal
		
		.area			_INTERNAL
				
		;>>>> Etiquetas globales internas <<<<
		
		.globl			posicion_ij
		.globl			generarTablero
		.globl			tableroLleno
		.globl			comprobarColumnaLlena
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numFils
		.globl			numCols
		.globl			fichaJugador1
		.globl			fichaJugador2
		
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

		;>>>> Objetos de comprobarColumnaLlena <<<<
		
			;>>>> Variables <<<<
			turno_comprobarColumnaLlena_col:
				.byte			0
		;-------------------------------;
		; Fin objetos comprobarColumnaLlena
		
		
		;>>>> Objetos generarTablero <<<<
		
			; >>>> Variables  <<<<
			ingame_generarTablero_numCeldas:.word	0
				
		;---------------------------------------;
		; Fin objetos generarTablero
	
		;>>>> Objetos globales compartidos <<<<
			; >>>> Variables <<<<
			.globl			siguiente_posicion_dinamica
	
	
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				posicion_ij				;
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

posicion_ij:
		pshs			d

		clra
		pshs			d	; Guardamos #0 y el contenido del registro B en S
		pshs			x	; Guardamos X en la pila
		ldd			4,s
		
		ldb			numCols
		mul
		
		addd			,s
		addd			2,s 	; Operacion resultante: A*B+X+B = 
						; = posicion base + fila * numCols + col
		
		puls			y	; Sacamos X y 0/B de la pila
		puls			y
		
		tfr			d,y
		
		puls			d
		rts

;--------------------------------------------------------------------;		
		; Fin posicion_ij
		
		
		
		
		
		
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
		
		std			ingame_generarTablero_numCeldas
		
		tfr			s,d	; Hacemos espacio para 
		subd			#2	; un contador en la pila
		tfr			d,s	;
		
		ldd			siguiente_posicion_dinamica		;;;;;;;;;
		pshs			d						;
		clra									;
		clrb									;
		std			2,s	; Inicializamos contador a 0		;
											;
	ingame_generarTablero_for:							;
											; for (contador = 0; contador < numCeldas; contador++)
		ldd			2,s						;	guarda(caracterEspacio,
		cmpd			ingame_generarTablero_numCeldas			;		siguiente_posicion_dinamica)
		beq			ingame_generarTablero_finFor			;	siguiente_posicion_dinamica++
											;
			lda			#0x20					;
			sta			[siguiente_posicion_dinamica]		;
			ldd			siguiente_posicion_dinamica		;
			addd			#1					;
			std			siguiente_posicion_dinamica		;
											;
		ldd			2,s						;
		addd			#1						;
		std			2,s						;
		bra			ingame_generarTablero_for			;
										;;;;;;;;;
	ingame_generarTablero_finFor:			
		
		puls			y	; Guardamos direccion de inicio del tablero
		
		puls			d	; Eliminamos contador
		puls			d	; Sacamos D de la pila
		
		rts

;--------------------------------------------------------------------;
		; Fin generarTablero
		
		
		
		
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			comprobarColumnaLlena				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay algun hueco libre en la columna indicada en el 	;
; registro B y guarda la direccion del primer hueco libre.		;
; Mediante el flag Z se indica si existe ese hueco libre: si esta a 1	;
; se encontro un hueco libre que se devuelve en el registro Y. En caso	;
; contrario, Z = 0							;
;									;
; Input: direccion base del tablero en X, numero de columna en B.	;
; Output: registro Y, flag Z						;
;									;
; Registros afectados: Y, CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

comprobarColumnaLlena:

		pshs			d
		
		decb
		stb			turno_comprobarColumnaLlena_col
			
		tfr			s,d	; Hacemos hueco
		subd			#1	; en la pila para
		tfr			d,s	; un contador
		
		lda			numFils					;;;;;;;;;
		deca									;
		sta			,s	; Inicializamos contador a NumFils -1 	;
						; e Y a la posicion mas baja del tablero;
		lda			numFils	; en esa columna			;
		deca									;
		ldb			turno_comprobarColumnaLlena_col			;
		jsr			posicion_ij					;
											;
	turno_comprobarColumnaLlena_for:						;
											;
		lda			#-1						;
		cmpa			,s						;
		beq			turno_comprobarColumnaLlena_finFor		; for (contador = numFils -1;
		lda			,y						;	contador >= 0, Y == fichaJugador;
		cmpa			fichaJugador1					;	--contador)
		bne			turno_comprobarColumnaLlena_compararFicha2	;
		bra			turno_comprobarColumnaLlena_seguir		;	Y = posicion_ij (contador, 
											;			turno_comprobarColumnaLlena_col);
	turno_comprobarColumnaLlena_compararFicha2:					;
											;
		cmpa			fichaJugador2					;
		bne			turno_comprobarColumnaLlena_finFor		;
											;
	turno_comprobarColumnaLlena_seguir:						;
											;
			lda			,s					;
			ldb			turno_comprobarColumnaLlena_col		;
			; X no se ha visto modificado.					;
			jsr			posicion_ij				;		
											;
		dec			,s						;
		bra			turno_comprobarColumnaLlena_for			;
											;
	turno_comprobarColumnaLlena_finFor:					;;;;;;;;;
	
		lda			,y
		cmpa			fichaJugador1
		beq			turno_comprobarColumnaLlena_Llena
		cmpa			fichaJugador2
		beq			turno_comprobarColumnaLlena_Llena
		
		orcc			#0x04	; Ponemos a 1 el flag Z
		bra			turno_comprobarColumnaLlena_finTest
		
	turno_comprobarColumnaLlena_Llena:
		
		andcc			#0xFB	; Ponemos a 0 el flag Z
		
	turno_comprobarColumnaLlena_finTest:
	
		puls			a	; Eliminamos el contador de la pila
		
		puls			d	
		rts
		

;--------------------------------------------------------------------;
		; Fin comprobarColumnaLlena
		
		
		
		
		
		
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
		
		lda			numFils				
		ldb			numCols				
		deca							
		decb							
		lbsr			posicion_ij			
		pshs			y				
									
	internal_tableroLleno_while:					;;;;;;;;;
										;
		tfr			x,d					;
		cmpd			,s					;
		bhi			internal_tableroLleno_finWhile		;
										;
			lda			#0x20 ; Caracter espacio	; for  (X = tablero[0][0];
			cmpa			,x+				;	X < tablero[numFils - 1][numCols -1];
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
		
		
		
