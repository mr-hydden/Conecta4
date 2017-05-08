			; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			c4io
		
		.area			_C4IO
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			imprimirTablero
		.globl			mostrarMenu
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			numFils
		.globl			numCols
		;.globl			tablero
		
		.globl			println
		.globl			print
		.globl			getchar
		.globl			clearScreen
		
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

			
			; Datos constantes
;--------------------------------------------------------------------;

		;>>>> Constantes compartidas <<<<
		
		
menu:		.ascii			"\t\t\t\t   *********************\n"	;;;;;;;;;
		.ascii			"\t\t\t\t   **    CONECTA 4    **\n"		;
		.ascii			"\t\t\t\t   *********************\n\n\n"	; Para mostrar
		.ascii			"\t\t\t\t\ta) Nueva partida\n\n"		; el menu
		.ascii			"\t\t\t\t\tb) Salir"				;
		.asciz			"\n\n\n\n\n\n\n\n"				;
											;
promptMenu:	.asciz			"Opcion => "				;;;;;;;;;



inicioBaseTablero:				;;;;;;;;;
		.asciz			"/=="		;
medioBaseTablero:					;
		.asciz			"===="		; Par mostrar
finBaseTablero:						; el tablero
		.asciz			"===\ "		;
inicioFila:	.asciz			" |("		;
medioFila:	.asciz			")|("		;
finFila:	.asciz			")|"	;;;;;;;;;



fichaJugador1:	.asciz			"O"	; Representacion de las fichas 
fichaJugador2:	.asciz			"X"	; de los jugadores, roja y azul

		;------------------------------; <- Fin constantes compartidas
		
		
		
	;>>>> Objetos estaticos de imprimirTablero <<<< Ninguno
	;>>>> Objetos estaticos de imprimirTablero <<<< Ninguno
	;>>>> Objetos estaticos de mostrarMenu <<<<	Ninguno
	
;--------------------------------------------------------------------;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			imprimirTablero				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime un tablero de numFils x numCols apuntado por el registro Y	;
;									;
; Input: tablero apuntado por REGISTRO Y				;
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
		
		clrb							;;;;;;;;; 
		stb			,s	; 0,s es siempre el contador,	;
						; s no se modifica hasta el fin	;
	c4io_imprimirTablero_for1:		; de la subrutina		;
		ldb			,s					;
		cmpb			numCols					;
		beq			c4io_imprimirTablero_finFor1		; 
										;	for (counter = 0; counter < numCols; ++counter)
			inc			,s		;;;;;;;;;	;		imprime("   %d", counter)
									;	;
			lda			#0x20 ; Espacio		;Cuerpo	;
			sta			pantalla		;del	;
			sta			pantalla		;bucle	;
			sta			pantalla		;	;
			ldb			,s			;	;
			addb			#0x30 ; Digito ASCII	;	;
			stb			pantalla	;;;;;;;;;	;		
										;
		bra			c4io_imprimirTablero_for1		;				;
										;
	c4io_imprimirTablero_finFor1:					;;;;;;;;;
		
		lda			#0x0A		;; Imprimimos un salto de linea
		sta			pantalla	;;
		
		
		
		
		clrb							;;;;;;;;; 
		stb			,s					;
										;
	c4io_imprimirTablero_for2:						;	
		ldb			,s					;
		cmpb			numCols					;
		beq			c4io_imprimirTablero_finFor2		; 
										;	for (counter = 0; counter < numCols; ++counter)
			inc			,s		;;;;;;;;;	;		imprime("   v")
									;	;
			lda			#0x20	; Espacio	;Cuerpo	;
			sta			pantalla		;del	;
			sta			pantalla		;bucle	;
			sta			pantalla		;	;
			ldb			#0x76	;Letra 'v'	;	;
			stb			pantalla	;;;;;;;;;	;		
										;
		bra			c4io_imprimirTablero_for2		;
										;
	c4io_imprimirTablero_finFor2:					;;;;;;;;;
		
		lda			#0x0A		;; Imprimimos un salto de linea
		sta			pantalla	;;
		

		
		ldy			1,s	; Direccion del tablero


		clrb							;;;;;;;;; 
		stb			,s					;
										;
	c4io_imprimirTablero_for3:						;		
		ldb			,s					;
		cmpb			numFils					;
		beq			c4io_imprimirTablero_finFor3		; 
										;	for (counter = 0; counter < numFils; ++counter)
			inc			,s		;;;;;;;;;	;		imprimeFila
									;	;
			jsr			imprimirFila		;Cuerpo	;
			tfr			y,x			;del	;
			ldb			numCols			;bucle	;
			abx						;	;
			tfr			x,y		;;;;;;;;;	;		
										;
		bra			c4io_imprimirTablero_for3		;
										;
	c4io_imprimirTablero_finFor3:					;;;;;;;;;
		
		
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
			inc			,s		;;;;;;;;;Cuerpo	;		counter < numCols; 
									;del	;		++counter	)
			jsr			print		;;;;;;;;;bucle	;		
										;		imprime(medioBaseTablero)
										;
		bra			c4io_imprimirTablero_for4		;
									;;;;;;;;;
	c4io_imprimirTablero_finFor4:		
		
			
	
		ldx			#finBaseTablero
		jsr			println

		tfr			s,d	; Eliminamos el espacio
		incb				; para el contador
		tfr			d,s	;
		
		puls			y
		puls			x,b
		rts

;;;; FIN imprimirTablero ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
		
		
		ldb			#1				;;;;;;;;; 
		stb			,s	; 0,s es siempre el contador,	;
						; pues s no se modifica hasta	;
	c4io_imprimirFila_for:			; el final de la subrutina	;
		ldb			,s					;
		cmpb			numCols					;
		beq			c4io_imprimirFila_finFor		; 
										;	for (counter = 1; counter < numCols; ++counter)
			inc			,s		;;;;;;;;;	; 	{
									;	;		imprime (fila[counter-1])
			lda			,y+			;Cuerpo	;		imprime (medioFila)
			sta			pantalla		;del	;	}
									;bucle	;
			ldx			#medioFila		;	;
			jsr			print		;;;;;;;;;	;
										;
		bra			c4io_imprimirFila_for			;
										;
	c4io_imprimirFila_finFor:					;;;;;;;;;
	
	
	
		lda			,y			;; Imprime el ultimo dato de la fila
		sta			pantalla
		
		ldx			#finFila		;; Imprime el final de la fila
		jsr			println
		
		
		tfr			s,d	; Eliminamos el espacio
		incb				; para el contador
		tfr			d,s	;
		
		puls			y,x,d
		rts

;;;; FIN imprimirFila ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarMenu				    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime una el menu y un prompt que solicita una opcion.	    	;
;								    	;	;; Se deberia INCLUIR GESTION DE OPCION
; Registros afectados: CC					    	;	;; INCORRECTA, ya que el string menu se encuentra
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;	;; asociado unicamente a esta funcion, y por tanto
;		   	| | |X| |X|X|0|X|		     		;	;; las opciones que contiene serian naturalmente 
;								    	;	;; gestionadas por esta subrutina.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mostrarMenu:
		jsr			clearScreen
		
		ldx			#menu
		jsr			print
		
		ldx			#promptMenu
		jsr			print
		
		jsr			getchar
		
		rts

;;;; Fin mostrarMenu ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








