#include "../gassp72.h"
#include "../etat.h"

void callback(void );
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;
int resolution;
int i=0;
type_etat StructSon;

int main(void)
{
	StructSon.position=0;
	StructSon.taille=LongueurSon;
	StructSon.son=&Son;
	StructSon.periode_ticks=72*PeriodeSonMicroSec;
	// activation de la PLL qui multiplie la fr�quence du quartz par 9
CLOCK_Configure();
// config port PB1 pour �tre utilis� en sortie
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	StructSon.resolution = PWM_Init_ff( TIM3, 3, StructSon.periode_ticks/3 );
// initialisation du timer 4
// Periode_en_Tck doit fournir la dur�e entre interruptions,
// exprim�e en p�riodes Tck de l'horloge principale du STM32 (72 MHz)
Timer_1234_Init_ff( TIM4, StructSon.periode_ticks );
// enregistrement de la fonction de traitement de l'interruption timer
// ici le 2 est la priorit�, timer_callback est l'adresse de cette fonction, a cr��r en asm,
// cette fonction doit �tre conforme � l'AAPCS
Active_IT_Debordement_Timer( TIM4, 2, callback );
// lancement du timer
Run_Timer( TIM4 );
while	(1)
	{
	
	}
}
