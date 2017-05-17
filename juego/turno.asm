		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			turno
		
		.area			_TURNO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			turno
		.globl			fichaTurno
		
		;------------------------------------;
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numFils
		.globl			numCols
		;.globl			tablero
		
		.globl			posicion_ij
		.globl			clearScreen
		.globl			imprimirTablero
		.globl			getchar
		.globl			print
		.globl			comprobarColumnaLlena
		
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
		
		;>>>> Objetos actualizarFichaTurno <<<<
		
			;>>>> Variables <<<<
				; Static
				fichaTurno:.asciz	"O" ; Se va modificando en cada turno.
				
		;---------------------------------;
		; Fin objetos actualizarFichaTurno
		
		;>>>> Objetos mostrarJugadorTurno <<<<
		
			;>>>> Constantes <<<<
			mensajeTurno:
				.asciz			"\nEs el turno del jugador "
		;------------------------------------;
		; Fin objetos actualizarFichaTurno
		
		
		;>>>> Objetos turno <<<<
		
			;>>>> Constantes <<<<
			promptRecogerColumna:
				.asciz			"Siguiente jugada: columna numero _\b"
			mensajeErrorFueraRango:
				.asciz			"Introduzca una columna valida.\n"
			mensajeErrorColumnaLlena:
				.asciz			"Columna llena. Juegue en una columna disponible.\n"
				
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
		
		lda			fichaJugador1
		ldb			fichaJugador2
		
		cmpa			fichaTurno				;;;;;;;;;
		beq			ingame_actualizarFichaTurno_else		; if (fichaTurno = fichaJugador1)
			sta			fichaTurno				;	fichaTurno <- fichaJugador2
			bra			ingame_actualizarFichaTurno_finIf	; else	
											;	fichaTurno <- fichaJugador1
	ingame_actualizarFichaTurno_else:						; 
											;
			stb			fichaTurno			;;;;;;;;;
				
	ingame_actualizarFichaTurno_finIf:
	
		puls			a,b
		rts
		
;--------------------------------------------------------------------;
		; Fin actualizarFichaTurno





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				mostrarJugadorTurno			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Muestra un mensaje informando de que jugador tiene el turno		;	; ESTA MENJOR EN C4IO
;									;
; Input: -								;
; Output: pantalla			.				;
;									;
; Registros afectados: -						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mostrarJugadorTurno:
		pshs			a,b
		
		lda			fichaJugador1
		ldb			fichaJugador2
		
		leax			mensajeTurno,pcr
		lbsr			print
		
		cmpa			fichaTurno				;;;;;;;;;
		beq			ingame_mostrarJugadorTurno_else			; if (fichaTurno = fichaJugador1)
			lda			#0x31 ; Digito 1 en ASCII		;	fichaTurno <- fichaJugador2
			bra			ingame_mostrarJugadorTurno_finIf	; else	
											;	fichaTurno <- fichaJugador1
	ingame_mostrarJugadorTurno_else:						; 
											;
			lda			#0x32 ; Digito 2 en ASCII	;;;;;;;;;
				
	ingame_mostrarJugadorTurno_finIf:
	
		sta			pantalla
		lda			#'\n
		sta			pantalla
		
		puls			a,b
		rts
		
;--------------------------------------------------------------------;
		; Fin actualizarFichaTurno

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				turno				;
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
		
		
	turno_turno_while:						;;;;;;;;;
										;
			lbsr			clearScreen			;
			puls			y				;	
			pshs			y	; Cargamos para		;
							; imprimir tablero	;
										;
			lbsr			imprimirTablero			;
			lbsr			mostrarJugadorTurno		;
			leax			promptRecogerColumna,pcr	;
			lbsr			print				;
										;
			lbsr			getchar				;
			suba			#0x30				;
										;
		cmpa			#1					;
		bhs			turno_turno_test2			;
		bra			turno_turno_mensajeErrorFueraRango	;
										;
										;
	turno_turno_test2:							; do
										;	PedirColumna
		cmpa			numCols					; 	if (Columna < 1 || columna > numCols)
		bhi			turno_turno_mensajeErrorFueraRango	;		mensajeFueraRango
		bra			turno_turno_test3			;		continuar
										;	if (columnaLlena)
	turno_turno_test3:							;		mensajeColumaLlena
										;		continuar
		puls			x					; while (columna < 1 || columna > numCols || columnaLlena)
		pshs			x					;
		tfr			a,b					;
		lbsr			comprobarColumnaLlena			;
		bne			turno_turno_mensajeErrorColumnaLlena	;
		bra			turno_turno_finWhile			;
										;
										;
	turno_turno_mensajeErrorFueraRango:					;
										;
		leax			mensajeErrorFueraRango,pcr		;
		lbsr			print					;
		bra			turno_turno_while			;
										;
	turno_turno_mensajeErrorColumnaLlena:					;
										;
		leax			mensajeErrorColumnaLlena,pcr		;
		lbsr			print					;
		bra			turno_turno_while			;
										;
										;
	turno_turno_finWhile:						;;;;;;;;;
	
		lbsr			actualizarFichaTurno
	
		puls			x
		puls			d
	
		rts	
;--------------------------------------------------------------;
		; Fin turno
