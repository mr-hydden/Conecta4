			; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			c4io
		
		.area			_C4IO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			imprimirTablero
		.globl			mostrarMenu
		.globl			fichaJugador1
		.globl			fichaJugador2
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numFils
		.globl			numCols
		;.globl			tablero
		
		.globl			println
		.globl			print
		.globl			getchar
		.globl			clearScreen
		.globl			tolower
		
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
		
			inicioBaseTablero:				;;;;;;;;;
					.asciz			"/=="		;
			medioBaseTablero:					;
					.asciz			"===="		;
			finBaseTablero:						;
					.asciz			"===\ "		;
			inicioFila:	.asciz			" |("		;
			medioFila:	.asciz			")|("		;
			finFila:	.asciz			")|"	;;;;;;;;;

			colorRojo:	.asciz			"\033[31m"
			colorAzul:	.asciz			"\033[34m"
			colorAmarillo:	.asciz			"\033[33m"
			colorOriginal:	.asciz			"\033[0m"
			
		;-----------------------------------;
		; Fin objetos imprimirTablero
		
		
		
		;>>>> Objetos constantes compartidos <<<<

fichaJugador1:	.byte			#'0	
fichaJugador2:	.byte			#'O	
						; Representacion de las fichas 
						; de los jugadores

		;------------------------------;
		; Fin objetos constates compartidos
		
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			imprimirTablero				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime un tablero de numFils x numCols apuntado por el registro Y	;
;									;
; Input: tablero apuntado por registro Y				;
; Output: pantalla							;
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
		sta			pantalla	; Para alinear el tablero
		sta			pantalla	;
		sta			pantalla	;
		
		ldb			#1				;;;;;;;;; 
		stb			,s	; 0,s es siempre el contador,	;
						; s no se modifica hasta el fin	;
	c4io_imprimirTablero_for1:		; de la subrutina		;
		ldb			,s					;
										;
		decb	; Decrementamos para que el comportamiento del bucle	;
			; sea el correcto sin tener que modificar numCols	;
										;
		cmpb			numCols					;
		beq			c4io_imprimirTablero_finFor1		; 
										;	for (counter = 1; counter <= numCols; ++counter)
								;;;;;;;;;	;		imprime("   %d", counter)
									;	;
			lda			#0x20 ; Espacio		;Cuerpo	;
			sta			pantalla		;del	;
			sta			pantalla		;bucle	;
			sta			pantalla		;	;
			ldb			,s			;	;
			addb			#0x30 ; Digito ASCII	;	;
			stb			pantalla	;;;;;;;;;	;	
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for1		;
										;
	c4io_imprimirTablero_finFor1:					;;;;;;;;;
		
		lda			#0x0A		;; Imprimimos un salto de linea
		sta			pantalla	;;
		
		
	
		lda			#'\t
		sta			pantalla	;
		sta			pantalla	; Para alinear el tablero
		sta			pantalla	;
		
		
		clrb							;;;;;;;;; 
		stb			,s					;
										;
	c4io_imprimirTablero_for2:						;	
		ldb			,s					;
		cmpb			numCols					;
		beq			c4io_imprimirTablero_finFor2		; 
										;	for (counter = 0; counter < numCols; ++counter)
								;;;;;;;;;	;		imprime("   v")
									;	;
			lda			#0x20	; Espacio	;Cuerpo	;
			sta			pantalla		;del	;
			sta			pantalla		;bucle	;
			sta			pantalla		;	;
			ldb			#0x76	;Letra 'v'	;	;
			stb			pantalla	;;;;;;;;;	;	
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for2		;
										;
	c4io_imprimirTablero_finFor2:					;;;;;;;;;
		
		lda			#0x0A		;; Imprimimos un salto de linea
		sta			pantalla	;;
		sta			pantalla	;;
		

		
		ldy			1,s	; Direccion del tablero

		ldx			#colorAzul	; Imprimimos el tablero
		jsr			print		; en color azul

		clrb							;;;;;;;;; 
		stb			,s					;
										;
	c4io_imprimirTablero_for3:						;		
		ldb			,s					;
		cmpb			numFils					;
		beq			c4io_imprimirTablero_finFor3		; 
										;	for (counter = 0; counter < numFils; ++counter)
								;;;;;;;;;	;		imprimeFila
									;	;
			lda			#'\t			;	;
			sta			pantalla ; Alinear	;	;
			sta			pantalla ; tablero	;	;
			sta			pantalla ;		;	;
			jsr			imprimirFila		;Cuerpo	;
			tfr			y,x			;del	;
			ldb			numCols			;bucle	;
			abx						;	;
			tfr			x,y		;;;;;;;;;	;
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for3		;
										;
	c4io_imprimirTablero_finFor3:					;;;;;;;;;
		
		
		
		lda			#'\t
		sta			pantalla
		sta			pantalla
		sta			pantalla
		ldx			#inicioBaseTablero
		jsr			print
		
		ldb			#1				;;;;;;;;; 
		stb			,s					;
		ldx			#medioBaseTablero			;
										;
	c4io_imprimirTablero_for4:						;
		ldb			,s					;
		cmpb			numCols					;
		beq			c4io_imprimirTablero_finFor4		; 
										;	for (	counter = 1, X = &medioBaseTablero; 
								;;;;;;;;;Cuerpo	;		counter < numCols; 
			jsr			print			;del	;		++counter	)
								;;;;;;;;;bucle	;		
										;		imprime(medioBaseTablero)
										;
		inc			,s					;
		bra			c4io_imprimirTablero_for4		;
									;;;;;;;;;
	c4io_imprimirTablero_finFor4:		
		
			
	
		ldx			#finBaseTablero
		jsr			println

		ldx			#colorOriginal	; Reseteamos el color
		jsr			print		; del terminal
		
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
; Output: pantalla							;
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
		
		
		ldx			#inicioFila		;; Imprime el inicio de fila
		jsr			print
		
		
		ldb			#1					;;;;;;;;; 
		stb			,s	; 0,s es siempre el contador,		;
						; pues s no se modifica hasta		;
	c4io_imprimirFila_for:			; el final de la subrutina		;
		ldb			,s						;
		cmpb			numCols						;
		beq			c4io_imprimirFila_finFor			;	 
											; for (counter = 1; counter < numCols; ++counter)
									;;;;;;;;;	; {
										;	;	imprime (fila[counter-1])
			lda			,y+				;Cuerpo	;	imprime (medioFila)
			cmpa			fichaJugador1				
			bne			c4io_imprimirFila_otraFicha	;del	; }
			ldx			#colorRojo			;bucle	;
			jsr			print				;	;
			bra			c4io_imprimirFila_imprimirFicha	;	;
										;	;
		c4io_imprimirFila_otraFicha:					;	;
										;	;
			ldx			#colorAmarillo			;	;
			jsr			print				;	;
										;	;
		c4io_imprimirFila_imprimirFicha:				;	;
										;	;
			sta			pantalla			;	;
										;	;
			ldx			#colorAzul			;	;
			jsr			print				;	;
			ldx			#medioFila			;	;
			jsr			print			;;;;;;;;;	;
											;
		inc			,s						;
		bra			c4io_imprimirFila_for				;
											;
	c4io_imprimirFila_finFor:						;;;;;;;;;
	
	
	
		lda			,y			;; Imprime el ultimo dato de la fila
		cmpa			fichaJugador1
		bne			c4io_imprimirFila_ultimo_otraFicha
		ldx			#colorRojo
		jsr			print
		bra			c4io_imprimirFila_ultimo_imprimirFicha
		
	c4io_imprimirFila_ultimo_otraFicha:
	
		ldx			#colorAmarillo
		jsr			print		
		
	c4io_imprimirFila_ultimo_imprimirFicha:
		
		sta			pantalla
		
		ldx			#colorAzul
		jsr			print
		ldx			#finFila		;; Imprime el final de la fila
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
; Output: pantalla							;
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
		
		jsr			clearScreen
		
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
;			mensajeGanador				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Muestra un mensaje con el ganador					;
;									;
; Input: -								;
; Output: pantalla							;
;								    	;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|0|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;--------------------------------------------------------------------;
		; Fin mostrarMenu	
		
		
		
		
