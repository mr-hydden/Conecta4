		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			artlog
		
		.area			_ARTLOG
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			negd
		
		;------------------------------------;
		
		
		
		;>>>> Etiquetas globales externas <<<<
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
;--------------------------------------------------------------------;
		; Fin objetos subrutinas
		
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				negd					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Multiplica el contenido del registro D por -1 (complemento a 2)	;
;									;
; Input: regsitro D							;
; Output: registro D			.				;
;									;
; Registros afectados: CC, D						;
; Flags afectados: 	|E|F|H|I|N|Z|V|C|				;
;		   	| | |X| |X|X|X|X|		     		;
;								    	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

negd:		
		cmpd			#0		; Si es 0, no
		beq			artlog_negd_fin	; hace nada.
		
		nega				
		negb				
		deca				
		decb			
		addd			#1	
		
	artlog_negd_fin:	
	
		rts

;--------------------------------------------------------------------;
		; Fin negd
		
		
		
		
		
				
