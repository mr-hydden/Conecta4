		.module			instrucciones   
		   
		.area			_INSTRUCCIONES   
		   
		.globl			imprimirTablero
		.globl			print  
		.globl			println
		   
		.globl			mostrarInstrucciones
		.globl			clrscrAscii
		.globl			getchar
		   
		   
		; Inicio definicion de constantes
;--------------------------------------------------------------------;												
			
		.include		"include.txt"

;--------------------------------------------------------------------;
		; Fin definicion de constantes		   
		   
   
sMostrarInstrucciones_Superior1:   
   
		.ascii			"			CONECTA 4\n"   
		.ascii			"			\n"   
		.ascii			"Objetivo\n"   
		.ascii			"--------\n"   
		.ascii			"	Ser el primero en conseguir cuatro de tus fichas\n"   
		.ascii			"en linea -horizontal, vertical o diagonalmente.\n"   
		.ascii			"\n"   
		.ascii			"\n"   
		.ascii			"\n"   
		.ascii			"Como jugar\n"   
		.ascii			"----------\n"   
		.ascii			"\n"   
		.ascii			"1. Decidir quien sera el primer jugador. Los dos jugadores se\n"   
		.ascii			"iran turnando para colocar sus fichas.\n"   
		.ascii			"\n"   
		.ascii			"2. Cuando sea tu turno, selecciona el numero de columna en la\n"   
		.ascii			"que deseas colocar tu siguiente ficha; esta caera hasta la\n"   
		.ascii			"primera posicion libre que haya comenzando por la parte baja del\n"   
		.ascii			"tablero (tal y como ocurriria en un tablero vertical sobre una\n"   
		.ascii			"mesa)."   
		.asciz			"\n"
		
sMostrarInstrucciones_Superior2:

		.ascii			"3. Los jugadores continuan colocando fichas alternativamente\n"   
		.ascii			"hasta que uno de los dos consigue 4 fichas en linea. El cuatro\n"   
		.ascii			"en raya puede ser horizontal, vertical o diagonal, tal como se\n"   
		.ascii			"ve en la imagen (fichas rojas).\n"   
		.ascii			"\n"   
		.asciz			"\n"   
		
		
		
sMostrarInstrucciones_Inferior:
  
		.ascii			"4. Si eres el primer jugador en conseguir cuatro en raya, has\n"   
		.ascii			"ganado el juego!\n"   
		.ascii			"\n"   
		.asciz			"\n"
		
		
		
sMostrarInstrucciones_MensajeImagen1:
		.asciz			"(4 en raya en columna 3)\n"

sMostrarInstrucciones_Imagen1:

		.ascii			"       "
		.ascii			"       "
		.ascii			"  0    "
		.ascii			" O0O   "
		.ascii			" O00O  "
		.ascii			"0O00OOO"



sMostrarInstrucciones_MensajeImagen2:
		.asciz			"(4 en raya en ultima fila)\n"
		
sMostrarInstrucciones_Imagen2:

		.ascii			"       "
		.ascii			"       "
		.ascii			"   0   "
		.ascii			" O0O   "
		.ascii			" OO0O  "
		.ascii			"0000OOO"
		
		
		
sMostrarInstrucciones_MensajeImagen3:
		.asciz			"(4 en raya en diagonal ascendente columnas 1-4)\n"
		
sMostrarInstrucciones_Imagen3:

		.ascii			"       "
		.ascii			"       "
		.ascii			"   0   "
		.ascii			" O0O   "
		.ascii			" 0O0O  "
		.ascii			"00O0OOO"
		
				
sMostrarInstrucciones_Prompt:
		.asciz			"Pulse una tecla para continuar..."
		
sMostrarInstrucciones_UpLineChar:
		.asciz			"\033[F\033[F                                  "
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarInstrucciones				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime un las instrucciones con el formato adecuado			;
;									;
; Input: -								;
; Output: $Pantalla							;
;									;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | |X|X|0| |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		
		
mostrarInstrucciones:

		pshs			y,x,d
		
		jsr			clrscrAscii
		
		ldx			#sMostrarInstrucciones_Superior1
		jsr			print
		
		ldx			#sMostrarInstrucciones_Prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			$Pantalla
		ldx			#sMostrarInstrucciones_UpLineChar
		jsr			println

		ldx			#sMostrarInstrucciones_Superior2
		jsr			print
		
		ldx			#sMostrarInstrucciones_Prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			$Pantalla
		ldx			#sMostrarInstrucciones_UpLineChar
		jsr			println
		
		ldx			#sMostrarInstrucciones_MensajeImagen1
		jsr			println
		ldy			#sMostrarInstrucciones_Imagen1
		jsr			imprimirTablero
		lda			#'\n
		sta			$Pantalla
		sta			$Pantalla
		sta			$Pantalla
		
		ldx			#sMostrarInstrucciones_Prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			$Pantalla
		ldx			#sMostrarInstrucciones_UpLineChar
		jsr			println
		
		ldx			#sMostrarInstrucciones_MensajeImagen2
		jsr			println
		ldy			#sMostrarInstrucciones_Imagen2
		jsr			imprimirTablero
		lda			#'\n
		sta			$Pantalla
		sta			$Pantalla
		sta			$Pantalla
		
		ldx			#sMostrarInstrucciones_Prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			$Pantalla
		ldx			#sMostrarInstrucciones_UpLineChar
		jsr			println
		
		ldx			#sMostrarInstrucciones_MensajeImagen3
		jsr			println
		ldy			#sMostrarInstrucciones_Imagen3
		jsr			imprimirTablero
		lda			#'\n
		sta			$Pantalla
		sta			$Pantalla
		
		ldx			#sMostrarInstrucciones_Inferior
		jsr			print
		
		ldx			#sMostrarInstrucciones_Prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			$Pantalla
		ldx			#sMostrarInstrucciones_UpLineChar
		jsr			println
		
		puls			y,x,d
		rts
		
;--------------------------------------------------------------------;
		; Fin mostrarInstrucciones		
		
