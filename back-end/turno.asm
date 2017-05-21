;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			turno.asm				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo de subrutinas de operaciones a realizar durante un 	;
; turno en la partida. 						;
; 								;
; Autor: Samuel Gomez Sanchez y Miguel Diaz Galan		;
;								;
; Subrutinas:	actualizarFichaTurno				;
;		turno						;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		
		
		
		
		
		
		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			turno
		
		.area			_TURNO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			turno
		.globl			fichaTurno
		.globl			actualizarFichaTurno
		
		;------------------------------------;
		
		;>>>> Etiquetas globales externas <<<<
		;.globl			tablero
		
		.globl			posicionij
		.globl			clrscr
		.globl			imprimirTablero
		.globl			getchar
		.globl			print
		.globl			columnaLlena
		.globl			mostrarJugadorTurno
		
		.globl			negd
				
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
		
		;>>>> Objetos actualizarFichaTurno <<<<
		
			;>>>> Variables <<<<
				; Static
				fichaTurno:	.byte	0 ; Se va modificando en cada turno.
				
		;---------------------------------;
		; Fin objetos actualizarFichaTurno
			
		
		;>>>> Objetos turno <<<<
		
			;>>>> Constantes <<<<
			sTurno_PromptRecogerColumna:
				.asciz			"Siguiente jugada: columna numero _\b"
			sTurno_MensajeErrorFueraRango:
				.asciz			"Introduzca una columna valida. "
			sTurno_MensajeErrorColumnaLlena:
				.asciz			"Columna llena. Juegue en una columna disponible. "
				
		;----------------------;
		; Fin objetos turno
		

;--------------------------------------------------------------;
		; Fin objetos subrutinas


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			actualizarFichaTurno				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actualiza la variable estatica que contiene la ficha del jugador que	;
; tiene el turno							;
;									;
; Input: -								;
; Output: static fichaTurno						;
;									;
; Registros afectados: -						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|0|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

actualizarFichaTurno:
		pshs			a,b
		
		lda			FichaJugador1
		ldb			FichaJugador2
		
		cmpa			fichaTurno				;;;;;;;;;
		beq			turno_actualizarFichaTurno_else			; if (fichaTurno = FichaJugador1)
			sta			fichaTurno				;	fichaTurno <- FichaJugador2
			bra			turno_actualizarFichaTurno_finIf	; else	
											;	fichaTurno <- FichaJugador1
	turno_actualizarFichaTurno_else:						; 
											;
			stb			fichaTurno			;;;;;;;;;
				
	turno_actualizarFichaTurno_finIf:
	
		puls			a,b
		rts
		
;--------------------------------------------------------------------;
		; Fin actualizarFichaTurno
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				turno					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Solicita al jugador una columna para realizar la proxima jugada y	;
; realiza las comprobaciones pertinentes para ver que es posible jugar	;
; sobre ella. Devuelve la direccion de memoria en la que se debe jugar 	;
; la siguiente ficha sobre el registro Y				;
;									;
; Input: posicion base tablero registro X 				;
; Output: registro Y			.				;
;									;
; Registros afectados: registro Y					;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

turno:
		pshs			d
		pshs			x
		
		
	turno_turno_while:							;;;;;;;;;
											;
			lbsr			clrscr					;
			puls			y					;		
			pshs			y	; Cargamos para			;
							; imprimir tablero		;
											;
			lbsr			imprimirTablero				;
			lbra			turno_turno_sinMensajesError		;
											;
											;
	turno_turno_mensajeErrorColumnaLlena:						;	
											;
			lbsr			clrscr					;
			puls			y					;	
			pshs			y	; Cargamos para			;
							; imprimir tablero		;
											;
			lbsr			imprimirTablero				;
			leax			sTurno_MensajeErrorColumnaLlena,pcr	;
			lbsr			print					;
			lbra			turno_turno_sinMensajesError		;
											;
											;
	turno_turno_mensajeErrorFueraRango:						;
											;
			lbsr			clrscr					;
			puls			y					;	
			pshs			y	; Cargamos para			;
							; imprimir tablero		;
											;
			lbsr			imprimirTablero				;
			leax			sTurno_MensajeErrorFueraRango,pcr	;
			lbsr			print					;
											;
	turno_turno_sinMensajesError:							;
											;
			lbsr			mostrarJugadorTurno			;
			leax			sTurno_PromptRecogerColumna,pcr		;
			lbsr			print					;
											;
		lbsr			getchar						;
		suba			#0x30						;
											;
		cmpa			#1						;
		bhs			turno_turno_test2				;
		bra			turno_turno_mensajeErrorFueraRango		;
											;
											;
	turno_turno_test2:								; do
											;	PedirColumna
		cmpa			NumCols						; 	if (Columna < 1 || columna > NumCols)
		bhi			turno_turno_mensajeErrorFueraRango		;		mensajeFueraRango
		bra			turno_turno_test3				;		continuar
											;	if (columnaLlena)
	turno_turno_test3:								;		mensajeColumaLlena
											;		continuar
		puls			x						; while (columna < 1 || 
		pshs			x						; columna > NumCols || columnaLlena)
		tfr			a,b						;
		lbsr			columnaLlena					;
		beq			turno_turno_mensajeErrorColumnaLlena		;
		bra			turno_turno_finWhile				;
											;
											;
											;
											;
											;
	turno_turno_finWhile:							;;;;;;;;;
	
		puls			x
		puls			d
	
		rts	
;--------------------------------------------------------------;
		; Fin turno
