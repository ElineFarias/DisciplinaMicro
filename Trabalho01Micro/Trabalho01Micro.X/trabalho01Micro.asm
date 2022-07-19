;Trabalho 01 da Disciplina Microprocessadores - 2022.1
;Maria Eline Silva de Farias - 516229
#include"p18f4550.inc"		   
    ;Configuração Bits
    CONFIG FOSC = XT_XT		   ;Oscilador externo 
    CONFIG WDT = OFF     
    CONFIG LVP = OFF
    
    VARIAVEIS UDATA_ACS 0 
	CONT1  RES 1		    ;reserva 1byte da da RAM para a variável CONT1
	CONT2  RES 1		    ;reserva 1byte da RAM para a variável  CONT2
	TEMP   RES 1		    ;reserva 1byte da RAM para a variável  TEMP
	sw1    EQU  .0		    ;Pino RC0
	sw2    EQU  .1		    ;Pino RC1
       
RES_VECT CODE 0X0000		    ;Code memoria
 
GOTO START			    
MAIN_PROG CODE  
 
 
START
    BSF TRISC,sw1		    ;RC0 entrada (SW1)
    BSF TRISC,sw2		    ;RC1 entrada (SW2)
    CLRF TRISD			    ;Coloca 0 no registrador TRISD em todos os Pinos
    CLRF PORTD			    ;Coloca 0 na PORTD em todos os Pinos
 
 ;DEFINE UMA SEÇÃO DE CÓDIGO LOOP 
 LOOP				    ;loop principal  para acender o Led 
    BTFSC PORTC, sw1		    ;Se sw1 for 0 , então pula para a proxima  intrução. 
    CALL SEC			    ;pula para sec
    BTFSC PORTC, sw2		    ;Se sw2 for 0 , então pula para a proxima  intrução.
    CALL SEC			    ;pula para sec
    MOVFF TEMP, PORTD
 GOTO LOOP			    ;Retorna ao loop 
 
 ;DEFINE UMA SEÇÃO DE CODIGO SEC
 SEC
 ;DELAY DE 1 SEGUNDO 
 CALL DELAY200MS		    ;call chamada de função 
 CALL DELAY200MS		    ;atrasos de 1 segundo 
 CALL DELAY200MS		    ;atrasos de 1 segundo 
 CALL DELAY200MS		    ;atrasos de 1 segundo 
 CALL DELAY200MS		    ;atrasos de 1 segundo 
 ;Soma 1 a variável Temp que vai ser movida para PORTD
  BTFSS PORTC, sw1		    ;Se o sw1 for 1, pula para a proxima instrução 
    RETURN 
  INCF TEMP			    ;incrementa a variável TEMP
  MOVFF TEMP, PORTD		    ;se nenhuma chave tiver  pressionada o programa atualiza o PORTD Com valor atual  da variavél contadora 
    RETURN   
  ;Subtrai 1 da variável Temp que vai ser movida para PORTD
  BTFSS PORTC, sw2		    ;Se o sw2 for 1, pula para a proxima instrução 
    RETURN 
  INCF TEMP			    ;incrementa a variável TEMP
  MOVFF TEMP, PORTD		    ;se nenhuma chave tiver  pressionada o programa atualiza o PORTD Com valor atual  da variavél TEMP 
 RETURN  
 GOTO LOOP
 DELAY200MS
   MOVLW .200			    ;Coloca o valor 200 no registrador
   MOVWF CONT2			    ;Passa o valor 200 do registrador para variável CONT2
 DELAYM 
  CALL DELAY200U		    ;Chama a função de delay de 200us
  CALL DELAY200U		    ;Chama a função de delay de 200us
  CALL DELAY200U		    ;Chama a função de delay de 200us
  CALL DELAY200U		    ;Chama a função de delay de 200us
  CALL DELAY200U		    ;Chama a função de delay de 200us
  DECFSZ CONT2			    ;Decrementa CONT2 e pula caso seja 0
  BRA DELAYM			    ;Volta para a Subrotina DELAYM
  RETURN			    ;Retorna para a última posição antes da função
  
 DELAY200U
  MOVLW .46			    ;Coloca o valor 46 no registrador
  MOVWF CONT1			    ;Passa o valor 46 do registrador para variável CONT1
   
 DELAY
  NOP				    ;Não faz nada por 1 ciclo de clock
  DECFSZ CONT1			    ;Decrementa CONT1 e pula caso seja 0
  BRA DELAY			    ;Volta para a Subrotina DELAY
  BTFSC PORTC,sw1		    ;Caso o pino fique em zero em algum momento
  RETURN			    ;Retorna para a ultima posição antes da função
  BTFSC PORTC,sw2
  RETURN
  POP				    ;Limpa pilha
  POP				    ;Limpa pilha
  RETURN
 END				    ;fim do programa

