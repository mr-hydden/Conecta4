		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			conecta4
		
		.area			_CONECTA4
		
		;>>>> Objetos globales compartidos <<<<
		.globl			SiguientePosicionDinamica
		
		;>>>> Etiquetas globales externas <<<<
		
		;.globl			comprueba4
		.globl			columnaLlena
		.globl			println
		;.globl			generarTablero
		.globl			imprimirTablero
		.globl			mostrarMenu
		.globl			clrscr
		.globl			getchar
		.globl			mostrarInstrucciones
		
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
				.word			0xEE00	; Pagina 0xEE00-0xEEFF reservada para objetos generados
								; en tiempo de ejecucion
			; Constantes
			NumFils: .byte	6
			NumCols: .byte	7
			
			FichaJugador1:	.byte	#'0
			FichaJugador2:	.byte	#'O
		;----------------------------;	


		;>>>> Variables locales a main <<<<
tablero:	.ascii			"   0   "
		.ascii			"   0   "
		.ascii			"   O   "
		.ascii			"   0   "
		.ascii			"0O O0O0"
		.ascii			"O0OO000"



ptr_tablero:	.word			0x0000

		;---------------------------------;
		
		

;--------------------------------------------------------------------;
		; Fin zona variables

		; Comienzo del programa
;--------------------------------------------------------------------;
programa:			
		jsr			mostrarMenu
		cmpa			#'a
		beq			nuevoJuego
		cmpa			#'b
		beq			opcionB_instrucciones
		cmpa			#'c
		beq			finPrograma
		bra			programa
		
	opcionB_instrucciones:
		
		jsr			clrscr
		jsr			mostrarInstrucciones
		bra			programa
	
	
		
	nuevoJuego:
	
		jsr			clrscr
		ldy			#tablero
		jsr			imprimirTablero
		jsr			getchar
		tfr			a,b
		subb			#0x30
		tfr			y,x
		jsr			columnaLlena
		beq			programa
		lda			#'O
		sta			,y
		ldy			#tablero
		jsr			clrscr
		jsr			imprimirTablero
		jsr			getchar
		
		bra			nuevoJuego
		
	finPrograma:
		
		jsr			clrscr
		lbra			reset

;--------------------------------------------------------------------;
		; Fin del programa



		; Subrutinas
;--------------------------------------------------------------------;

;--------------------------------------------------------------------;		
		; Fin zona subrutinas




		; Terminacion e inicio del programa
;--------------------------------------------------------------------;
										
reset:			clra 
			sta				$Fin

			.area			_RESET(ABS)
			.org			0xFFFE		; Vector de RESET
			.word 			programa

