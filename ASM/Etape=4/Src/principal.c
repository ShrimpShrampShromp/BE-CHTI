#include "../etat.h"
#include "../gassp72.h"

unsigned int M2(short *,int);
volatile unsigned short dma_buf[64];
int compteurs[6]={0,0,0,0,0,0};
int SYSTICK_PER = 5*72000; //5ms en ticks d'horloge � 72MHz
int indices_k[6]={17,18,19,20,23,24};
int M2TIR = 850000; //((4096*2**14)**2)/(2**32) valeur de d�tection du tir (en mV), initialement � 50% de l'amplitude d'entr�e

void sys_callback(){
	GPIO_Set(GPIOB, 1);
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	int i,dft;
	for(i=0;i<6;i++){
		dft=M2((short *)dma_buf,indices_k[i]); //changer i
		if(dft >= M2TIR/1000){
			compteurs[i]++;
		}else{
			compteurs[i]=0;
		}
	}
	GPIO_Clear(GPIOB, 1);
	
}


int main(void)
{
// activation de la PLL qui multiplie la fr�quence du quartz par 9
CLOCK_Configure();
// PA2 (ADC voie 2) = entr�e analog
GPIO_Configure(GPIOA, 2, INPUT, ANALOG);
// PB1 = sortie pour profilage � l'oscillo
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
// PB14 = sortie pour LED
GPIO_Configure(GPIOB, 14, OUTPUT, OUTPUT_PPULL);

// activation ADC, sampling time 1us
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
// D�clenchement ADC par timer2, periode (72MHz/320kHz)ticks
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
// Config DMA pour utilisation du buffer dma_buf (a cr��r)
Init_ADC1_DMA1( 0, dma_buf );

// Config Timer, p�riode exprim�e en p�riodes horloge CPU (72 MHz)
Systick_Period_ff( SYSTICK_PER );
// enregistrement de la fonction de traitement de l'interruption timer
// ici le 3 est la priorit�, sys_callback est l'adresse de cette fonction, a cr��r en C
Systick_Prio_IT( 3, sys_callback );
SysTick_On;
SysTick_Enable_IT;
	while(1) {
		int i;
		for(i=0;i<6;i++){
			if(compteurs[i]>=3){
					GPIO_Set(GPIOB, 14);
			}
		}
	}
}
