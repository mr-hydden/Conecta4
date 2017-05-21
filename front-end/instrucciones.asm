;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			instrucciones.asm			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modulo con la subrutina de imprimir instrucciones. Escindido	;
; de c4io.asm por su extension.					;
; 								;
; Autor: Samuel Gomez Sanchez y Miguel Diaz Galan		;
;								;
; Subrutinas:	mostrarInstrucciones				;
;		mostrarPrompt					;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		
		
		
		
		
		; Zona configuracion de memoria
;--------------------------------------------------------------------;	

		.module			instrucciones   
		   
		.area			_INSTRUCCIONES  
		
		;>>>> Etiquetas globales internas <<<<
			   
		.globl			mostrarInstrucciones
		
		;------------------------------------;
		
		
		;>>>> Etiquetas globales externas <<<<
			   
		.globl			imprimirTablero
		.globl			print  
		.globl			println

		.globl			clrscr
		.globl			getchar
		
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
		;>>>> Objetos de mostrarInstrucciones <<<<
		
		; >>>> Constantes <<<<

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

		;------------------------------------;				 
		; Fin objetos mostrarInstrucciones		
		
		
		;>>>> Objetos de mostrarPrompt <<<<
		
		; >>>> Constantes <<<<
				
sMostrarPrompt_Prompt:
		.asciz			"Pulse una tecla para continuar..."
		
sMostrarPrompt_UpLineChar:
		.asciz			"\033[F\033[F                                  "
		
		;------------------------------------;				 
		; Fin objetos mostrarPrompt
		
;--------------------------------------------------------------------;	
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;			mostrarInstrucciones				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime las instrucciones con el formato adecuado			;
;									;
; Input: -								;
; Output: pantalla							;
;									;
; Registros afectados: -					    	;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		
		
mostrarInstrucciones:

		pshs			y,x,d,cc
		
		lbsr			clrscr
									;;;;;;;;;
		ldx			#sMostrarInstrucciones_Superior1 	; Mostramos mensaje 1
		lbsr			print					;
										;
		lbsr			mostrarPrompt			;;;;;;;;;
		
		
									;;;;;;;;;
		ldx			#sMostrarInstrucciones_Superior2	; Mostramos mensaje 2
		lbsr			print					;
										;
		lbsr			mostrarPrompt			;;;;;;;;;
		
		
		
								;;;;;;;;;;;;;;;;;;;;;;;;;
									;;;;;;;;;	;
										;	;
		ldx			#sMostrarInstrucciones_MensajeImagen1	;	;
		lbsr			println					;	;
		ldy			#sMostrarInstrucciones_Imagen1		;	;
		lbsr			imprimirTablero				;	;
		lda			#'\n
		sta			$Pantalla				;	;
		sta			$Pantalla				;	;
		sta			$Pantalla				;	;
										;	; Mostramos los ejemplos
		lbsr			mostrarPrompt			;;;;;;;;;	; de posiciones ganadoras
											;
											;
											;
									;;;;;;;;;	;
										;	;
		ldx			#sMostrarInstrucciones_MensajeImagen2	;	;
		lbsr			println					;	;
		ldy			#sMostrarInstrucciones_Imagen2		;	;
		lbsr			imprimirTablero				;	;
		lda			#'\n					
		sta			$Pantalla				;	;
		sta			$Pantalla				;	;
		sta			$Pantalla				;	;
										;	;
		lbsr			mostrarPrompt			;;;;;;;;;	;
											;
											;
											;
									;;;;;;;;;	;
										;	;
		ldx			#sMostrarInstrucciones_MensajeImagen3	;	;
		lbsr			println					;	;
		ldy			#sMostrarInstrucciones_Imagen3		;	;
		lbsr			imprimirTablero				;	;
		lda			#'\n
		sta			$Pantalla				;	;
		sta			$Pantalla				;	;
										;	;
		lbsr			mostrarPrompt			;;;;;;;;;	;
								;;;;;;;;;;;;;;;;;;;;;;;;;
								
								
									;;;;;;;;;
		ldx			#sMostrarInstrucciones_Inferior		; Mostramos mensaje 3
		lbsr			print					;
										;
		lbsr			mostrarPrompt			;;;;;;;;;
		
		puls			y,x,d,cc
		rts
		
;--------------------------------------------------------------------;
		; Fin mostrarInstrucciones		
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				mostrarPrompt				;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Imprime el prompt de "Pulsar tecla para continuar"			;
;									;
; Input: -								;
; Output: pantalla							;
;									;
; Registros afectados: -					    	;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mostrarPrompt:

		pshs			x,a,cc
		
		ldx			#sMostrarPrompt_Prompt
		lbsr			print
		lbsr			getchar
		
		lda			#'\n
		sta			$Pantalla
		
		ldx			#sMostrarPrompt_UpLineChar
		lbsr			println
		
		puls			x,a,cc
		
		rts
;--------------------------------------------------------------;
		; Fin mostrarPrompt
		
		
		
		
		
		
		
