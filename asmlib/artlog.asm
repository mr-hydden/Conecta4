		; Zona configuracion de memoria
;--------------------------------------------------------------------;		
		.module			artlog
		
		.area			_ARTLOG
		
		;>>>> Etiquetas globales internas <<<<
		
		.globl			negd
		.globl			amodb
		
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
		
		
		
		
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				amodb					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calcula el resto de A entre B, dejando el resultado en B		;
;									;
; Input: A dividendo, B divisor						;
; Output: resto en B			.				;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
amodb:
		pshs			cc
		pshs			b
		
		tfr			a,b
		
	artlog_amodb_while:
	
		cmpa			,s
		blo			artlog_amodb_finWhile
			suba			,s
		bra			artlog_amodb_while	
	
	artlog_amodb_finWhile:
		
		exg			a,b
		puls			cc	; Sacamos b
		puls			cc	; Recuperamos cc
		
		rts
		
;--------------------------------------------------------------;
		; Fin amodb
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				div					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Divide D entre el valor contenido en la direccion apuntada por X	;
;									;
; Input: D dividendo, 0,X divisor					;
; Output: cociente en D		.					;
;									;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
	
div:
		pshs			d,cc	; Guarda, CC y luego D, no? NO
		
		tfr			s,d	; Hacemos un hueco en la pila
		subd			#2	; para trabajar con cociente
		tfr			d,s	; y dividendo

		clra
		clrb
		std			,s	; Inicializamos cociente a 0
		
		ldd			3,s	; Recuperamos el dividendo
		
	artlog_div_while:
	
		cmpd			,x
		blo			artlog_div_finWhile
			subd			,x
			pshs			d
			ldd			2,s	; El cociente desplazado
			addd			#1
			std			2,s
			puls			d
		bra			artlog_div_while	
	
	artlog_div_finWhile:
		
		ldd			,s
		std			3,s	; Guardamos el cociente sobre
						; el valor inicial de D
						; para poder hacer puls sin perderlo
						
		puls			d	; Eliminamos el cociente
		puls			cc	; Recuperamos cc
		puls			d	; Guardamos cociente en D
		
		rts

;--------------------------------------------------------------;
		; Fin div		
		
		
		
		
		
		
				
