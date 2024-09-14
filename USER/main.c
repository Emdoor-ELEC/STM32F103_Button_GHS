#include "led.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "beep.h"
#include <stdio.h>
 
//��������1��num_1++����������2 num_1--;
uint16_t num_1 = 0;   //Logic Analyzer���Ա���





 int main(void)
 {

 	vu8 key=0;	
	delay_init();	    	 //��ʱ������ʼ��	  
	LED_Init();		  		//��ʼ����LED���ӵ�Ӳ���ӿ�
	BEEP_Init();         	//��ʼ���������˿�
	KEY_Init();         	//��ʼ���밴�����ӵ�Ӳ���ӿ�
	LED0=0;					//�ȵ������

	 

	 
	while(1)
	{
		
 		key=KEY_Scan(0);	//�õ���ֵ
	   	if(key)
		{						   
			switch(key)
			{				 
				case WKUP_PRES:	//���Ʒ�����
					BEEP=!BEEP;
					break; 
				
				case KEY1_PRES:	//����LED1��ת	 
					LED1=!LED1;
					num_1++; //���Ա���++
					printf("num_1 = %d\n",num_1);
					break;
				
				case KEY0_PRES:	//ͬʱ����LED0,LED1��ת 
					LED0=!LED0;
					LED1=!LED1;
					num_1--; //���Ա���--
					printf("num_1 = %d\n",num_1);
					break;
			}
		}else delay_ms(10); 
	}	 
}

