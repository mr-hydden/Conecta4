		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			turn
		
		.area			_TURN
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			comprobarColumnaLLena
		
		;------------------------------------;
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numFils
		.globl			numCols
		;.globl			tablero
		
		.globl			posicion_ij
		
		.globl			negd
		
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
;--------------------------------------------------------------;
		; Fin objetos subrutinas


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

comprobarColumnaLLena:

		pshs			d
		
		decb
		stb			turno_comprobarColumnaLlena_col
			
		tfr			s,d	; Hacemos hueco
		subd			#1	; en la pila para
		tfr			d,s	; un contador
		
		lda			numFils					;;;;;;;;;
		deca									;
		deca									;
		sta			,s	; Inicializamos contador a 0 e Y	;
						; a la posicion mas baja del tablero	;
		lda			numFils	; en esa columna			;
		deca									;
		ldb			turno_comprobarColumnaLlena_col			;
		jsr			posicion_ij					;
											;
	turno_comprobarColumnaLlena_for:						;
											;
		tst			,s						;
		beq			turno_comprobarColumnaLlena_finFor		; for (contador = numFils -2;
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
		; Fin comprobarColumnaLLena




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				promptTurno				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pide por pantalla al jugador que le toque en este turno la columna	;
; de la 1 a la 7 donde quiere colocar su ficha, despues de saber la  	;
; columna se comprobara que tenga hueco y si lo tiene cual es el lugar	;
; donde debe colocarse.							;
; Input: teclado (columna a colocar)					;
; Output: flag Z			.				;
;									;
; Registros afectados: A						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

promptTurno:
		;pshs			d
		
		;lda			teclado
		;suba			#0x30
		;cmpa			#1
		;bhs			turno_promptTurno_seguir
	
	turno_promptTurno_seguir:
	
		;cmpa			numCols
		;bhi			turno_promptTurno_while
		
		;rts				


