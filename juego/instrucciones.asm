		.module			instrucciones   
		   
		.area			_INSTRUCCIONES   
		   
		.globl			imprimirTablero
		.globl			print  
		.globl			println
		   
		.globl			mostrar_instrucciones
		.globl			clearScreenAscii
		.globl			getchar
		   
		   
		; Inicio definicion de constantes
;--------------------------------------------------------------------;												
			
fin		.equ			0xFF01				
teclado		.equ			0xFF02
pantalla	.equ			0xFF00

;--------------------------------------------------------------------;
		; Fin definicion de constantes		   
		   
   
instrucciones_superior1:   
   
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
		
instrucciones_superior2:

		.ascii			"3. Los jugadores continuan colocando fichas alternativamente\n"   
		.ascii			"hasta que uno de los dos consigue 4 fichas en linea. El cuatro\n"   
		.ascii			"en raya puede ser horizontal, vertical o diagonal, tal como se\n"   
		.ascii			"ve en la imagen (fichas rojas).\n"   
		.ascii			"\n"   
		.asciz			"\n"   
		
		
		
instrucciones_inferior:
  
		.ascii			"4. Si eres el primer jugador en conseguir cuatro en raya, has\n"   
		.ascii			"ganado el juego!\n"   
		.ascii			"\n"   
		.asciz			"\n"
		
		
		
instrucciones_mensaje_imagen1:
		.asciz			"(4 en raya en columna 3)\n"

instrucciones_imagen1:

		.ascii			"       "
		.ascii			"       "
		.ascii			"  0    "
		.ascii			" O0O   "
		.ascii			" O00O  "
		.ascii			"0O00OOO"



instrucciones_mensaje_imagen2:
		.asciz			"(4 en raya en ultima fila)\n"
		
instrucciones_imagen2:

		.ascii			"       "
		.ascii			"       "
		.ascii			"   0   "
		.ascii			" O0O   "
		.ascii			" OO0O  "
		.ascii			"0000OOO"
		
		
		
instrucciones_mensaje_imagen3:
		.asciz			"(4 en raya en diagonal ascendente columnas 1-4)\n"
		
instrucciones_imagen3:

		.ascii			"       "
		.ascii			"       "
		.ascii			"   0   "
		.ascii			" O0O   "
		.ascii			" 0O0O  "
		.ascii			"00O0OOO"
		
				
instrucciones_prompt:
		.asciz			"Pulsa una tecla para continuar..."
		
instrucciones_goUpLine:
		.asciz			"\033[F\033[F                                  "
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrar_instrucciones				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime un las instrucciones con el formato adecuado			;
;									;
; Input: -								;
; Output: pantalla							;
;									;
; Registros afectados: CC					    	;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | | | |X|X|0| |		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		
		
mostrar_instrucciones:

		pshs			y,x,d
		
		jsr			clearScreenAscii
		
		ldx			#instrucciones_superior1
		jsr			print
		
		ldx			#instrucciones_prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			pantalla
		ldx			#instrucciones_goUpLine
		jsr			println

		ldx			#instrucciones_superior2
		jsr			print
		
		ldx			#instrucciones_prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			pantalla
		ldx			#instrucciones_goUpLine
		jsr			println
		
		ldx			#instrucciones_mensaje_imagen1
		jsr			println
		ldy			#instrucciones_imagen1
		jsr			imprimirTablero
		lda			#'\n
		sta			pantalla
		sta			pantalla
		sta			pantalla
		
		ldx			#instrucciones_prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			pantalla
		ldx			#instrucciones_goUpLine
		jsr			println
		
		ldx			#instrucciones_mensaje_imagen2
		jsr			println
		ldy			#instrucciones_imagen2
		jsr			imprimirTablero
		lda			#'\n
		sta			pantalla
		sta			pantalla
		sta			pantalla
		
		ldx			#instrucciones_prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			pantalla
		ldx			#instrucciones_goUpLine
		jsr			println
		
		ldx			#instrucciones_mensaje_imagen3
		jsr			println
		ldy			#instrucciones_imagen3
		jsr			imprimirTablero
		lda			#'\n
		sta			pantalla
		sta			pantalla
		
		ldx			#instrucciones_inferior
		jsr			print
		
		ldx			#instrucciones_prompt
		jsr			print
		jsr			getchar
		lda			#'\n
		sta			pantalla
		ldx			#instrucciones_goUpLine
		jsr			println
		
		puls			y,x,d
		rts
		
;--------------------------------------------------------------------;
		; Fin mostrar_instrucciones		
		
