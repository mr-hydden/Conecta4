		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			ingame
		
		.area			_INGAME
		
		;>>>> Objetos globales compartidos <<<<
		.globl			siguiente_posicion_dinamica
		
		
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			lda_fichaJugador
		.globl			posicion_ij
		.globl			generarTablero
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numCols
		
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
			
			
			
			; Variables locales
;--------------------------------------------------------------------;

		;>>>> Constantes compartidas <<<<
		;------------------------------;
		
		
		;>>>> Objetos estaticos <<<<
	
	fichaTurno:	.asciz			"O" 	; Se va modificando en cada turno. Solo la funcion lda_fichaJugador
							; puede acceder aqui, en principio.
	
	;----------------------------------------------; <- Fin objetos estaticos lda_fichaJugador
	
	
	
		;>>>> Objetos locales generarTablero <<<<
		
	ingame_generarTablero_numCeldas:
			.word			0
			
		;---------------------------------------;
	
	
	
;--------------------------------------------------------------------;



							
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				lda_fichaJugador			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Carga en el registro A la ficha del jugador al que le toca jugar.	;
; Se encarga por tanto de determinar quien tiene el turno, ademas de 	;
; proporcionar una manera de identificarlo.				;
;									;
; Input: ninguno (necesita fichas para funcionar)			;
; Output: registro A, ficha correspondiente.				;
;									;
; Registros afectados: CC, variable fichaTurno				;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|0|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lda_fichaJugador:
		pshs			b
		
		lda			fichaTurno			;;;;;;;;;
		cmpa			#'O				
		beq			ingame_lda_fichaJugador_else		; if (fichaTurno = 'O')
			ldb			#'O
			stb			fichaTurno			;	A <- 'O' 
			bra			ingame_lda_fichaJugador_finIf	;	fichaTurno <- 'X'
			
	ingame_lda_fichaJugador_else:						; else	
										;	A <- 'X', fichaTurno <- 'O'
			ldb			#'X
			stb			fichaTurno		;;;;;;;;;
				
	ingame_lda_fichaJugador_finIf:
	
		puls			b
		rts
		
;--------------------------------------------------------------------;



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
;		   	| | |X| |X|X|X|X|		     		;
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
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			generarTablero					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Genera un tablero vacio con las dimensiones indicadas en D, cuya	;
; direccion devuelve en Y.						;
;									;
; Input: numero de celdas registro D					;
; Output: registro Y			.				;
;									;
; Registros afectados: CC, Y						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|X|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

generarTablero:
		pshs			d
		
		std			ingame_generarTablero_numCeldas
		
		tfr			s,d	; Hacemos espacio para 
		subd			#2	; un contador en la pila	;<--- Recordar "arreglar PC"
		tfr			d,s	;
		
		ldd			siguiente_posicion_dinamica		;;;;;;;;;
		pshs			d						;
		clra									;
		clrb									;
		std			2,s	; Inicializamos contador a 0		;
											;
	ingame_generarTablero_for:							;
											;
		ldd			2,s						;
		cmpd			ingame_generarTablero_numCeldas			;
		beq			ingame_generarTablero_finFor			;
											;
			lda			#0x20					;
			sta			[siguiente_posicion_dinamica]		;
			ldd			siguiente_posicion_dinamica		;
			addd			#1					;
			std			siguiente_posicion_dinamica		;
											;
			ldd			2,s					;
			addd			#1					;
			std			2,s					;
											;
		bra			ingame_generarTablero_for			;
										;;;;;;;;;
	ingame_generarTablero_finFor:			
		
		puls			y	; Guardamos direccion de inicio del tablero
		
		puls			d	; Eliminamos contadores
		puls			d	; Sacamos D de la pila
		
		rts

;--------------------------------------------------------------------;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				colocarFicha				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Coloca la ficha contenida en A en su representacion ASCII en la	;
; posicion indicada por Y.						;
;									;
; Input: posicion registro Y						;
; Output: posicion registro Y, disponible para comprueba4		;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

colocarFicha:
		sta			,y
		rts
		

			
			
			
		
		
		
		
		
		
		
		
		
		
		

	

