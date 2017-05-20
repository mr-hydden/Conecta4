;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			conecta4.asm				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo principal.						;
;								;
; Contiene el programa nucleo que se ejecuta siempre y cuando	;
; el usuario no pulse la tecla de salida en el menu principal	;
; del juego.							;
;								;
; Subrutinas: init						;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			conecta4
		
		.area			_CONECTA4
		
		;>>>> Objetos globales compartidos <<<<
		.globl			SiguientePosicionDinamica
		
		;>>>> Etiquetas globales externas <<<<
		
		.globl			comprueba4
		.globl			columnaLlena
		.globl			println
		.globl			generarTablero
		.globl			imprimirTablero
		.globl			mostrarMenu
		.globl			clrscr
		.globl			getchar
		.globl			mostrarInstrucciones
		.globl			fichaTurno
		.globl			turno
		.globl			tableroLleno
		.globl			actualizarFichaTurno
		.globl			mostrarMensajeGanador
		.globl			mostrarMensajeEmpate
		
		;------------------------------------;
		
;--------------------------------------------------------------------;
		; Fin zona configuracion memoria
		
		
		
		
		
		
		; Inicio definicion de constantes
;--------------------------------------------------------------------;												
			
		.include		"include.txt"

;--------------------------------------------------------------------;
		; Fin definicion de constantes
		
		
		
		
		
		
		; Zona variables
;--------------------------------------------------------------------;

		;>>>> Objetos compartidos <<<<
		
			; Estaticos
			SiguientePosicionDinamica:
				.word			0x0000	; Pagina 0xEE00-0xEEFF reservada para objetos generados
								; en tiempo de ejecucion
			; Constantes
			NumFils: .byte	6	; Variables globales, utilizadas en la mayor parte de
			NumCols: .byte	7	; los modulos. Limitadas a valor maximo 9 por implementacion.
						; Valor superior comportamiento indefinido.
			
			FichaJugador1:	.byte	#'0
			FichaJugador2:	.byte	#'O
			
			; Representacion interna de las fichas de los jugadores.
			; Pueden cambiarse por cualquier caracter del codigo ASCII 
			; de 7 bits.
			; Variables globales utilizadas por gran parte de los modulos.
			
		;----------------------------;	


		;>>>> Variables locales a main <<<<


ptr_tablero:	.word			0x0000	; Usada para almacenar la direccion del tablero,
						; que se genera en tiempo de ejecucion.
						; El tablero esta representado por una cadena de caracteres
						; que se corresponden, a modo de filas colocadas una tras otra,
						; con las posiciones del tablero.
						; Asi, el tablero es una cadena tal como sigue:
						;
						;	"       " <- Parte de arriba del tablero fisico, fila 0
						;	"       "
						;	"       "
						;	"       "
						;	"       "
						;	"       " <- Parte de abajo del tablero fisico, fila N
						;
						; Almacenamiento en memoria (tablero por defecto de 6x7):
						;
						; 0x0000	elemento[0][0]
						; 0x0001	elemento[0][1]
						;    .
						;    .
						;    .
						; 0x0007	elemento[1][0]
						;    .
						;    .
						;    .

		;---------------------------------;
		
		

;--------------------------------------------------------------------;
		; Fin zona variables
		
		
		
		
		
		
		; Comienzo del programa
;--------------------------------------------------------------------;
programa:	
		lbsr			init 	; Inicializa objetos, pilas y otros
						; configura el entorno
						
	programa_menu:
		
		jsr			mostrarMenu	;;;;;;;;;
		cmpa			#'a			
		beq			programa_partida	; Saltamos a la parte de
		cmpa			#'b			
		beq			programa_instrucciones	; que corresponda, segun la
		cmpa			#'c
		beq			programa_finPrograma	; seleccion del usuario
								;
		bra			programa_menu	;;;;;;;;;
		
		
		
	programa_instrucciones:
		
		jsr			clrscr			; Mostramos las instrucciones y volvemos
		jsr			mostrarInstrucciones	; al menu tras ello.
		bra			programa_menu		;
	
	
	
	programa_partida:
		
		leax			[ptr_tablero,pcr]	; Cargamos la posicion del
		lbsr			tableroLleno		; tablero y comprobamos que  
		beq			programa_empate		; no esta lleno aun, en cuyo caso
								; se muestra el mensaje de empate
								
								
								
		lbsr			turno			; Se ejecuta la subrutina turno,
								; que se encarga de la muestra del
								; tablero y las operaciones de E/S
								; asi como la actualizacion del tablero
								; durante el juego
		
		
		
		pshu			y ; Necesario para mostrarMensajeGanador
		
		
		
		lda			fichaTurno		; Actualizamos el turno (ahora le toca
		sta			,y			; al siguiente jugador)
		lbsr			actualizarFichaTurno	;
		
		
		
		lbsr			comprueba4		; Comprobamos que no ha aparecido un 
		beq			programa_cuatroEnRaya	; cuatro en raya, en cuyo caso, mostramos
								; un mensaje indicando que jugador gana.
								
								
		pulu			y ; Si no hemos mostrado el mensaje,
					  ; retiramos la posicion guardada en pila
		
		bra			programa_partida ; Mantiene el bucle
	
	
	
	programa_cuatroEnRaya:
		
		lbsr			clrscr		;;;;;;;;;
		leay			[ptr_tablero,pcr]	;
		lbsr			imprimirTablero		; Si se consigue cuatro en raya,
		pulu			y			; se muestra la situacion en el tablero
		lda			,y			; y un mensaje indicando el jugador ganador
		lbsr			mostrarMensajeGanador	;
								;
		bra			programa	;;;;;;;;;
	
	
	
	programa_empate:
	
		lbsr			clrscr		;;;;;;;;;
		leay			[ptr_tablero,pcr]	;
		lbsr			imprimirTablero		; Si hay empate,
		lbsr			mostrarMensajeEmpate	; se muestra el tablero y un 
								; mensaje de empate.
		bra			programa		;
							;;;;;;;;;
	programa_finPrograma:
		
		jsr			clrscr	; Si se elige finalizar el programa
		lbra			reset	; unicamente se deja la pantalla limpia

;--------------------------------------------------------------------;
		; Fin del programa
		
		
		
		
		
		
		; Subrutinas
;--------------------------------------------------------------------;

init:											;;;;;;;;;
												;
		lds			#0xFE00	;Deberia sobrar mucha pila entre FE00 y FDFF	; Inicializamos las pilas
		ldu			#0xFC00	; Analogamente deberia sobrarnos mucho espacio	;
						; hasta la pagina dinamica, que es lo siguiente	;
						; en el mapa de memoria			;;;;;;;;;
						
		ldd			#0xEE00	; Valor inicial de la pagina dinamica	; Reservamos la pagina 0xEE00-0xEEFF
		std			SiguientePosicionDinamica			; para objetos generados en la ejecucion
		
		lda			FichaJugador1	; Iniciamos la variables estatica fichaTurno
		sta			fichaTurno	; a la ficha del jugador 1
		
		lda			NumFils		;;;;;;;;;
		ldb			NumCols			; Generamos el tablero 
		mul						; vacio para comenzar la
		lbsr			generarTablero		; partida
		sty			ptr_tablero	;;;;;;;;;
	
		
		clra			;;;;;;;;;
		clrb				;
		tfr			d,x	; Reseteamos todos
		tfr			d,y	; los registros
		tfr			a,cc	;
					;;;;;;;;;
		rts

;--------------------------------------------------------------------;		
		; Fin zona subrutinas
		
		
		
		
		
		
		; Terminacion e inicio del programa
;--------------------------------------------------------------------;
										
reset:			clra 
			sta			$Fin

			.area			_RESET(ABS)
			.org			0xFFFE		; Vector de RESET
			.word 			programa

