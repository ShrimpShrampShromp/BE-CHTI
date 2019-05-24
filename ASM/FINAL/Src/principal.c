#include "../etat.h"
#include "../gassp72.h"
#include "../Affichage_Valise.h"
#include <time.h>
#include <stdlib.h>

unsigned int M2(short *,int);
volatile unsigned short dma_buf[64];
int compteurs[6]={0,0,0,0,0,0};
int SYSTICK_PER = 5*72000; //5ms en ticks d'horloge à 72MHz
int indices_k[6]={17,18,19,20,23,24};
int M2TIR = 2000000; //4194304 = ((124 * (2**15 * 2**5)**2) / 2**32 <- 2**7 en sortie de l'ADC, 2**15 plage de tabcos, 2**5 = nb de points d'aquisition/2, au carré parce que modcarré, divisé par 2**32 quand on prend les bits de poids fort
int score[6]={0,0,0,0,0,0};

//variables pour le son
void callback(void );
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;
int resolution;
int i=0;
type_etat StructSon;

//variables malette

//CORRESPONDANCE LED/CIBLE :
// led 2 -> cible 3 
// led 1 -> cible 2
// led 3 -> cible 1
// led 0 -> cible 0

int rand_cible;



void sys_callback(){
	GPIO_Set(GPIOB, 1);
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	int i,dft;
	for(i=0;i<6;i++){
		dft=M2((short *)dma_buf,indices_k[i]); //changer i
		if(dft >= M2TIR){
			compteurs[i]++;
		}else{
			compteurs[i]=0;
		}
		if (compteurs[i] == 3) {
			score[i]++;
			StructSon.position=0;
			//envoi de l'information à la valise
					
			Prepare_Afficheur(i, score[i]);
			
			Prepare_Clear_LED(0);
			Prepare_Clear_LED(1);
			Prepare_Clear_LED(2);
			Prepare_Clear_LED(3);
			
			//nouvelle cible aléatoirement choisie
			
		  rand_cible = (rand() % 4) + 1;
			Choix_Capteur(rand_cible);
			
				switch(rand_cible){
			
				case 1:
						Prepare_Set_LED(LED_Cible_1);
						break;
				case 2:
						Prepare_Set_LED(LED_Cible_2);
						break;
				case 3:
						Prepare_Set_LED(LED_Cible_3);
						break;
				case 4:
						Prepare_Set_LED(LED_Cible_4);
				} 
	}
	GPIO_Clear(GPIOB, 1);
	
	}
}


int main(void){
StructSon.position=LongueurSon-1;
	StructSon.taille=LongueurSon;
	StructSon.son=&Son;
	StructSon.periode_ticks=72*PeriodeSonMicroSec;
// activation de la PLL qui multiplie la fréquence du quartz par 9
CLOCK_Configure();
// PA2 (ADC voie 2) = entrée analog
GPIO_Configure(GPIOA, 2, INPUT, ANALOG);
// config port PB1 pour être utilisé en sortie (son)
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
StructSon.resolution = PWM_Init_ff( TIM3, 3, StructSon.periode_ticks/3 );
// PB1 = sortie pour profilage à l'oscillo
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
// PB14 = sortie pour LED
GPIO_Configure(GPIOB, 14, OUTPUT, OUTPUT_PPULL);

// initialisation du timer 4
// Periode_en_Tck doit fournir la durée entre interruptions,
// exprimée en périodes Tck de l'horloge principale du STM32 (72 MHz)
Timer_1234_Init_ff( TIM4, StructSon.periode_ticks );
	
// lancement du timer
Active_IT_Debordement_Timer( TIM4, 2, callback );
Run_Timer( TIM4 );

// activation ADC, sampling time 1us
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
// Déclenchement ADC par timer2, periode (72MHz/320kHz)ticks
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
// Config DMA pour utilisation du buffer dma_buf (a créér)
Init_ADC1_DMA1( 0, dma_buf );

// Config Timer, période exprimée en périodes horloge CPU (72 MHz)
Systick_Period_ff( SYSTICK_PER );
// enregistrement de la fonction de traitement de l'interruption timer
// ici le 3 est la priorité, sys_callback est l'adresse de cette fonction, a créér en C
Systick_Prio_IT( 3, sys_callback );
SysTick_On;
SysTick_Enable_IT;

//paramétrage de la valise
Init_Affichage();

//on teste d'abord un allumant une seule cible

//rand_cible = rand() % 4;
Choix_Capteur(0);
Prepare_Set_LED(0);

	while(1) {
		int i;
			Mise_A_Jour_Afficheurs_LED();
		
		for(i=0;i<6;i++){
			if(compteurs[i]>=3){
				GPIO_Set(GPIOB, 14);
			}else if(compteurs[i]==0){
				GPIO_Clear(GPIOB, 14);
			}
		}
	}
}
