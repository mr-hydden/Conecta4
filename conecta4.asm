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


ptr_tablero:	.word			0x0000

		;---------------------------------;
		
		

;--------------------------------------------------------------------;
		; Fin zona variables

		; Comienzo del programa
;--------------------------------------------------------------------;
programa:	
		ldd			#0xEE00
		std			SiguientePosicionDinamica
		lda			FichaJugador1
		sta			fichaTurno
		lda			NumFils
		ldb			NumCols
		mul
		lbsr			generarTablero
		sty			ptr_tablero
		
	programa_menu:
		
		jsr			mostrarMenu
		cmpa			#'a
		beq			programa_partida
		cmpa			#'b
		beq			programa_instrucciones
		cmpa			#'c
		beq			programa_finPrograma
		
		bra			programa_menu
		
	programa_instrucciones:
		
		jsr			clrscr
		jsr			mostrarInstrucciones
		bra			programa_menu
	
	programa_partida:
		
		leax			[ptr_tablero,pcr]
		lbsr			tableroLleno
		beq			programa_empate
		lbsr			turno
		lbsr			actualizarFichaTurno
		lda			fichaTurno
		sta			,y
		lbsr			comprueba4
		beq			programa_cuatroEnRaya
		
		bra			programa_partida
	
	programa_cuatroEnRaya:
	
		lbsr			clrscr
		lda			#'!
		sta			$Pantalla
		lbsr			getchar	
		
		bra			programa
	
	programa_empate:
	
		lbsr			clrscr
		lda			#'?
		sta			$Pantalla
		lbsr			getchar
		
		bra			programa
		
	programa_finPrograma:
		
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

