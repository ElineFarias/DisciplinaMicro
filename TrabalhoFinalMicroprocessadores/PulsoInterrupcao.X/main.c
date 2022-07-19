/*
 * File:   main.c
 * Author: eline
 *
 * Created on 11 de Julho de 2022, 14:22
 */


#include <xc.h>

#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include "lcd.h"
#include <stdio.h>

void putch(char data)
{
  escreve_lcd(data);   
}

unsigned char contagem = 0;
#define _XTAL_FREQ 4000000

void main(void) {
   
    TRISBbits.RB0 = 1;
    INTEDG0 = 1; // Borda de subida
    
    TRISD = 0x00;
    inicializa_lcd();
    
    T2CONbits.T2CKPS0 = 1;
    T2CONbits.T2CKPS1 = 1;
    T2CONbits.TMR2ON = 1;
    GIE = 1;
    INT0IE = 1;
    
    while(1) {
     __delay_ms(10);
     caracter_inicio(1,1);  //define o ponto de inicio da frase na primeira linha
     printf("contagem = %d",contagem);
     caracter_inicio(2,1);  //define o ponto de inicio da frase na segunda linha
     printf("periodo = %d",16*contagem);
    
    }
 }

void __interrupt(high_priority) ISR(void){
    
  if(INT0IF){ 
     INT0IF = 0;
     if (INTEDG0){
      // Borda de subida
      TMR2 = 0;
      INTEDG0 = 0; 
     } else {
      // Borda de descida  
      contagem = TMR2;
      INTEDG0 = 1;          
     }       
  }
}
        
    
