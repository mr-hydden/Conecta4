;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				c4io.asm			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo de subrutinas de entrada/salida en el contexto del	;
; juego. Contiene el codigo para mostrar el tablero, el menu 	;
; del juego, y diferentes mensajes al usuario final.		;
; 								;
; Autor: Samuel Gomez Sanchez y Miguel Diaz Galan		;
;								;
; Subrutinas:	imprimirTablero					;
;		imprimirFila					;
;		mostrarMenu					;
;		mostrarJugadorTurno				;
;		mostrarMensajeGanador				;
;		mostrarMensajeEmpate				;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			
			
			
			
			; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			c4io
		
		.area			_C4IO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			imprimirTablero
		.globl			mostrarMenu
		.globl			mostrarJugadorTurno
		.globl			mostrarMensajeGanador
		.globl			mostrarMensajeEmpate
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		;.globl			tablero
		
		.globl			println
		.globl			print
		.globl			getchar
		.globl			clrscr
		.globl			tolower
		
		.globl			fichaTurno
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

		;>>>> Objetos de mostrarMenu <<<<
		
			;>>>> Constantes <<<<
		
			menu:		.ascii			"\t\t\t   *********************\n"	;;;;;;;;;
					.ascii			"\t\t\t   **    CONECTA 4    **\n"		;
					.ascii			"\t\t\t   *********************\n\n\n"		;
					.ascii			"\t\t\t   a) \033[4mNueva partida\033[0m\n\n"	;
					.ascii			"\t\t\t   b) \033[4mInstrucciones\033[0m\n\n"	;
					.ascii			"\t\t\t   c) \033[4mSalir\033[0m"		;
					.asciz			"\n\n\n\n\n\n\n\n"				;
														;
			promptMenu:	.asciz			"\033[F\033[FOpcion: "			;;;;;;;;;
			
			promptMenuAdvertencia:
					.asciz			"\033[F\033[FOpcion incorrecta.\nSeleccione una opcion disponible: "
		;-------------------------------;
		; Fin objetos mostrarMenu



		;>>>> Objetos de imprimirTablero <<<<
		
			; >>>> Constantes <<<<
		
			sImprimirTablero_InicioBaseTablero:				;;;;;;;;;
					.asciz			"/=="				;
												;
			sImprimirTablero_MedioBaseTablero:					;
					.asciz			"===="				;
												;
			sImprimirTablero_FinBaseTablero:					;
					.asciz			"===\ "				;
												;
			sImprimirTablero_InicioFila:	.asciz			" |("		;
			sImprimirTablero_MedioFila:	.asciz			")|("		;
			sImprimirTablero_FinFila:	.asciz			")|"	;;;;;;;;;

			sImprimirTablero_ColorRojo:	.asciz			"\033[31m"
			sImprimirTablero_ColorAzul:	.asciz			"\033[34m"
			sImprimirTablero_ColorAmarillo:	.asciz			"\033[33m"
			sImprimirTablero_ColorOriginal:	.asciz			"\033[0m"
			
		;-----------------------------------;
		; Fin objetos imprimirTablero
		
		
			
		;>>>> Objetos mostrarJugadorTurno <<<<
		
			;>>>> Constantes <<<<
			sMostrarJugadorTurno_MensajeTurno:
				.asciz			"\nEs el turno del jugador "
		;------------------------------------;
		; Fin objetos mostrarJugadorTurno
		
		
		;>>>> Objetos mostrarMensajeGanador <<<<
		
			;>>>> Constantes <<<<
			sMostrarMensajeGanador_MensajeGanador:
				.ascii			"\n"
				.asciz			"Victoria del JUGADOR "

		;------------------------------------;
		; Fin objetos mostrarMensajeGanador
		
		
		;>>>> Objetos mostrarMensajeEmpate <<<<
		
			;>>>> Constantes <<<<
			sMostrarMensajeEmpate_MensajeEmpate:
				.ascii			"\n"
				.asciz			"Hay un EMPATE."
		;------------------------------------;
		; Fin objetos mostrarMensajeEmpate
		
		
		;>>>> Objetos compartidos <<<<
		sMostrarMensaje_Prompt:
			.asciz			"Pulse una tecla para volver al menu..."
		;----------------------------;
		; Fin objetos compartidos
		
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			imprimirTablero				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime un tablero de NumFils x NumCols apuntado por el registro Y	;
;									;
; Input: tablero apuntado por registro Y				;
; Output: $Pantalla							;
;									;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|X|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprimirTablero:
		pshs			x,b
		pshs			y
		
		tfr			s,d	; Hacemos espacio en la pila para
		decb				; un contador. El bloque que lo
		tfr			d,s	; utilice debera inicializarlo

		;; Imprimir numeros y flechas
		
		
		lda			#'\t
		sta			$Pantalla	; Para alinear el tablero
		sta			$Pantalla	;
		sta			$Pantalla	;
		
		ldb			#1				;;;;;;;;; 
		stb			,s	; 0,s es siempre el contador,	;
						; s no se modifica hasta el fin	;
	c4io_imprimirTablero_for1:		; de la subrutina		;
		ldb			,s					;
										;
		decb	; Decrementamos para que el comportamiento del bucle	;
			; sea el correcto sin tener que modificar NumCols	;
										;
		cmpb			NumCols					;
		beq			c4io_imprimirTablero_finFor1		; 
										;	for (counter = 1; counter <= NumCols; ++counter)
								;;;;;;;;;	;		imprime("   %d", counter)
									;	;
			lda			#0x20 ; Espacio		;Cuerpo	;
			sta			$Pantalla		;del	;
			sta			$Pantalla		;bucle	;
			sta			$Pantalla		;	;
			ldb			,s			;	;
			addb			#0x30 ; Digito ASCII	;	;
			stb			$Pantalla	;;;;;;;;;	;	
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for1		;
										;
	c4io_imprimirTablero_finFor1:					;;;;;;;;;
		
		lda			#0x0A		;; Imprimimos un salto de linea
		sta			$Pantalla	;;
		
		
	
		lda			#'\t
		sta			$Pantalla	;
		sta			$Pantalla	; Para alinear el tablero
		sta			$Pantalla	;
		
		
		clrb							;;;;;;;;; 
		stb			,s					;
										;
	c4io_imprimirTablero_for2:						;	
		ldb			,s					;
		cmpb			NumCols					;
		beq			c4io_imprimirTablero_finFor2		; 
										;	for (counter = 0; counter < NumCols; ++counter)
								;;;;;;;;;	;		imprime("   v")
									;	;
			lda			#0x20	; Espacio	;Cuerpo	;
			sta			$Pantalla		;del	;
			sta			$Pantalla		;bucle	;
			sta			$Pantalla		;	;
			ldb			#0x76	;Letra 'v'	;	;
			stb			$Pantalla	;;;;;;;;;	;	
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for2		;
										;
	c4io_imprimirTablero_finFor2:					;;;;;;;;;
		
		lda			#0x0A		;; Imprimimos un salto de linea
		sta			$Pantalla	;;
		sta			$Pantalla	;;
		

		
		ldy			1,s	; Direccion del tablero

		ldx			#sImprimirTablero_ColorAzul	; Imprimimos el tablero
		jsr			print		; en sImprimirTablero_Color azul

		clrb							;;;;;;;;; 
		stb			,s					;
										;
	c4io_imprimirTablero_for3:						;		
		ldb			,s					;
		cmpb			NumFils					;
		beq			c4io_imprimirTablero_finFor3		; 
										;	for (counter = 0; counter < NumFils; ++counter)
								;;;;;;;;;	;		imprimeFila
									;	;
			lda			#'\t			;	;
			sta			$Pantalla ; Alinear	;	;
			sta			$Pantalla ; tablero	;	;
			sta			$Pantalla ;		;	;
			jsr			imprimirFila		;Cuerpo	;
			tfr			y,x			;del	;
			ldb			NumCols			;bucle	;
			abx						;	;
			tfr			x,y		;;;;;;;;;	;
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for3		;
										;
	c4io_imprimirTablero_finFor3:					;;;;;;;;;
		
		
		
		lda			#'\t
		sta			$Pantalla
		sta			$Pantalla
		sta			$Pantalla
		ldx			#sImprimirTablero_InicioBaseTablero
		jsr			print
		
		ldb			#1				;;;;;;;;; 
		stb			,s					;
		ldx			#sImprimirTablero_MedioBaseTablero	;
										;
	c4io_imprimirTablero_for4:						;
		ldb			,s					;
		cmpb			NumCols					;
		beq			c4io_imprimirTablero_finFor4		; 
										;	for (	counter = 1, 
										;               X = sImprimirTablero_MedioBaseTablero; 
								;;;;;;;;;Cuerpo	;		counter < NumCols; 
			jsr			print			;del	;		++counter	)
								;;;;;;;;;bucle	;		
										;		imprime(sImprimirTablero_MedioBaseTablero)
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for4		;
									;;;;;;;;;
	c4io_imprimirTablero_finFor4:		
		
			
	
		ldx			#sImprimirTablero_FinBaseTablero
		jsr			println

		ldx			#sImprimirTablero_ColorOriginal	; Reseteamos el sImprimirTablero_Color
		jsr			print		                ; del terminal
		
		tfr			s,d	; Eliminamos el espacio
		incb				; para el contador
		tfr			d,s	;
		
		puls			y
		puls			x,b
		rts

;--------------------------------------------------------------------;
		; Fin imprimirTablero
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			imprimirFila				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime una fila del tablero, apuntada por el registro Y	    	;
;									;
; Input: fila apuntada por el REGISTRO Y				;
; Output: $Pantalla							;
;								    	;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|X|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprimirFila:
		pshs			y,x,d
		
		tfr			s,d			;
		decb						; Hacemos espacio en la pila para
		tfr			d,s			; un contador
								; No lo inicializamos, porque lo hace el bucle for. 
		
		
		ldx			#sImprimirTablero_InicioFila		;; Imprime el inicio de fila
		jsr			print
		
		
		ldb			#1					;;;;;;;;; 
		stb			,s	; 0,s es siempre el contador,		;
						; pues s no se modifica hasta		;
	c4io_imprimirFila_for:			; el final de la subrutina		;
		ldb			,s						;
		cmpb			NumCols						;
		beq			c4io_imprimirFila_finFor			;	 
											; for (counter = 1; counter < NumCols; ++counter)
									;;;;;;;;;	; {
										;	;	imprime (fila[counter-1])
			lda			,y+				;Cuerpo	;	imprime (sImprimirTablero_MedioFila)
			cmpa			FichaJugador1			;       ;
			bne			c4io_imprimirFila_otraFicha	;del	; }
			ldx			#sImprimirTablero_ColorRojo	;bucle	;
			jsr			print				;	;
			bra			c4io_imprimirFila_imprimirFicha	;	;
										;	;
		c4io_imprimirFila_otraFicha:					;	;
										;	;
			ldx			#sImprimirTablero_ColorAmarillo	;	;
			jsr			print				;	;
										;	;
		c4io_imprimirFila_imprimirFicha:				;	;
										;	;
			sta			$Pantalla			;	;
										;	;
			ldx			#sImprimirTablero_ColorAzul	;	;
			jsr			print				;	;
			ldx			#sImprimirTablero_MedioFila	;	;
			jsr			print			;;;;;;;;;	;
											;
		inc			,s						;
		bra			c4io_imprimirFila_for				;
											;
	c4io_imprimirFila_finFor:						;;;;;;;;;
	
	
	
		lda			,y ; Imprime el ultimo dato de la fila
		cmpa			FichaJugador1
		bne			c4io_imprimirFila_ultimo_otraFicha
		ldx			#sImprimirTablero_ColorRojo
		jsr			print
		bra			c4io_imprimirFila_ultimo_imprimirFicha
		
	c4io_imprimirFila_ultimo_otraFicha:
	
		ldx			#sImprimirTablero_ColorAmarillo
		jsr			print		
		
	c4io_imprimirFila_ultimo_imprimirFicha:
		
		sta			$Pantalla
		
		ldx			#sImprimirTablero_ColorAzul
		jsr			print
		ldx			#sImprimirTablero_FinFila ; Imprime el final de la fila
		jsr			println
		
		
		tfr			s,d	; Eliminamos el espacio
		incb				; para el contador
		tfr			d,s	;
		
		puls			y,x,d
		rts

;--------------------------------------------------------------------;
		; Fin imprimirFila
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarMenu				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime una el menu y un prompt que solicita una opcion.	    	;
;									;
; Input: -								;
; Output: $Pantalla							;
;								    	;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|0|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mostrarMenu:
		pshs			b
		
		clrb
		
	c4io_mostrarMenu_opcionIncorrecta:		
		
		jsr			clrscr
		
		ldx			#menu
		jsr			print
		
		tstb
		bne			c4io_mostrarMenu_promptAdvertencia
		
		ldx			#promptMenu
		jsr			print
		
		bra			c4io_mostrarMenu_promptNormal
		
	c4io_mostrarMenu_promptAdvertencia:
	
		ldx			#promptMenuAdvertencia
		jsr			print
		
	c4io_mostrarMenu_promptNormal:
	
		jsr			getchar
		jsr			tolower
		
		cmpa			#'a
		beq			c4io_mostrarMenu_opcionCorrecta
		cmpa			#'b
		beq			c4io_mostrarMenu_opcionCorrecta
		cmpa			#'c
		beq			c4io_mostrarMenu_opcionCorrecta
		
		tstb							; Si se elige una opcion incorrecta
		bne			c4io_mostrarMenu_flagSet	; ponemos un flag para imprimir mensaje
		incb							; de opcion incorrecta
		
	c4io_mostrarMenu_flagSet:
	
		bra			c4io_mostrarMenu_opcionIncorrecta
		
	c4io_mostrarMenu_opcionCorrecta:
		
		puls			b
		rts

;--------------------------------------------------------------------;
		; Fin mostrarMenu
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarJugadorTurno				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Muestra un mensaje informando de que jugador tiene el turno		;
;									;
; Input: -								;
; Output: $Pantalla			.				;
;									;
; Registros afectados: -						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mostrarJugadorTurno:
		pshs			a,b
		
		lda			FichaJugador1
		ldb			FichaJugador2
		
		leax			sMostrarJugadorTurno_MensajeTurno,pcr
		lbsr			print
		
		cmpa			fichaTurno				;;;;;;;;;
		bne			c4io_mostrarJugadorTurno_else			;
											;
			lda			#0x31 ; Digito 1 en ASCII		;
			sta			$Pantalla				;
			lda			#0x20	; Caracter espacio		;
			sta			$Pantalla				;
											;
			lda			#'(					;
			sta			$Pantalla				;
			leax			sImprimirTablero_ColorRojo,pcr		;
			lbsr			print					;
			lda			FichaJugador1				;
			sta			$Pantalla				; if (fichaTurno = FichaJugador1)
			leax			sImprimirTablero_ColorOriginal,pcr	;	imprimir(FichaJugador1)
			lbsr			print					; else	
			lda			#')					
			sta			$Pantalla				;	imprimir(FichaJugador2)
											;
			bra			c4io_mostrarJugadorTurno_finIf		; 
											;
	c4io_mostrarJugadorTurno_else:							; 
											;
			lda			#0x32 ; Digito 1 en ASCII		;
			sta			$Pantalla				;
			lda			#0x20	; Caracter espacio		;
			sta			$Pantalla				;
											;
			lda			#'(					;
			sta			$Pantalla				;
			leax			sImprimirTablero_ColorAmarillo,pcr	;
			lbsr			print					;
			lda			FichaJugador2				;
			sta			$Pantalla				;
			leax			sImprimirTablero_ColorOriginal,pcr	;
			lbsr			print					;
			lda			#')					;
			sta			$Pantalla				;
											;
	c4io_mostrarJugadorTurno_finIf:						;;;;;;;;;
	
		lda			#'\n
		sta			$Pantalla
		
		puls			a,b
		rts
		
;--------------------------------------------------------------------;
		; Fin actualizarFichaTurno
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarMensajeGanador				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Muestra un mensaje con el ganador					;
;									;
; Input: Posicion Y							;
; Output: $Pantalla							;
;								    	;
; Registros afectados: -					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | | | | | |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mostrarMensajeGanador:
		pshs			x,a,cc
		
		leax			sMostrarMensajeGanador_MensajeGanador,pcr
		lbsr			print
		lda			FichaJugador1
		cmpa			,y
		bne			c4io_mMensajeGanador_J2
		
			lda			#0x31	; Digito 1
			sta			$Pantalla
			lbra			c4io_mMensajeGanador_finMensaje
			
	c4io_mMensajeGanador_J2:
	
			lda			#0x32	; Digito 1
			sta			$Pantalla
		
	c4io_mMensajeGanador_finMensaje:
		
		lda			#'!
		sta			$Pantalla
		lda			#'\n
		sta			$Pantalla
		
		leax			sMostrarMensaje_Prompt,pcr
		lbsr			print
		lbsr			getchar
		
		puls			x,a,cc
		rts

;--------------------------------------------------------------------;
		; Fin mostrarMensajeGanador
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarMensajeEmpate				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Muestra un mensaje de empate						;
;									;
; Input: Posicion Y							;
; Output: pantalla							;
;								    	;
; Registros afectados: -					    	;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mostrarMensajeEmpate:

		pshs			x,a,cc
		
		leax			sMostrarMensajeEmpate_MensajeEmpate,pcr
		lbsr			print
		
		lda			#'\n
		sta			$Pantalla
		
		leax			sMostrarMensaje_Prompt,pcr
		lbsr			print
		lbsr			getchar
		
		puls			x,a,cc
		rts

;--------------------------------------------------------------------;
		; Fin mostrarMensajeEmpate	
		
		
		
		
