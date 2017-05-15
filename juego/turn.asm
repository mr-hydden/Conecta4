	
	; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			turn
		
		.area			_TURN
		
		
		
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
;			compruebaColumnaLlena				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Comprueba si hay algun hueco libre en la columna y guarda el primer 	;
; lugar libre de la columna si lo hay en Y. Si no hay lugar libre, 	;
; cambia el flag Z							;
;									;
; Input: columna elegida en Y						;
; Output: flag Z							;
;									;
; Registros afectados: CC						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | |?| | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

compruebaColumnaLLena:

		pshs			y	;introduce en la pila la lista de registros Y
		ldb			numFils	;carga el numero de columnas en el registro B
		clra				;limpia el registro A
		pshs			d	;Introduce en la pila D
		
		
		
		
		ldb			numFils					;;;;;;;;;
		pshs			b,a						;
											;
	turn_Comprueba_Columna_for:							;
											;
		tst			1,s						;
		beq			turn_Comprueba_Columna_finFor			;
											;
			dec			1,s					;
											;
			tfr			y,d					; for (i = numFils; i > 0; --i, Y-= y)
			subd			2,s					;	if (ContentOf(Y) != ficha)
			tfr			d,y					;		break
			lda			,s					;
			cmpa			,y					;
			bne			turn_Comprueba_Columna_finTest		;
			bra			turn_Comprueba_Columna_for		;
										;;;;;;;;;
										
	turn_Comprueba_Columna_finFor:
		
		puls			b,a	; Sacamos A y B de la pila
		
		bra			turn_Comprueba_Columna_return
		
	turn_Comprueba_Columna_finTest:

		ldy			a       ;dejo el valor del hueco que esta vacio en y 		
		puls			b,a	; Sacamos A y B de la pila
		 
		
	turn_Comprueba_Columna_return:	
		
		puls			d	; Sacamos D de la pila
		
		puls			y,d
		rts

;--------------------------------------------------------------------;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			pideColumnaJugador				;
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

pideColumnaJugador:
		lda			teclado ;recojo la fila y la meto en el acumulador A
		ldy			a
		jsr			compruebaColumnaLlena
		pshs			y	;introduce en la pila la lista de registros Y		
		cmpy			#0x20
		puls			y,a
		rts
		


