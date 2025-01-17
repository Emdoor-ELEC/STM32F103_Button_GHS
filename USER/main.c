#include "led.h"
#include "delay.h"
#include "key.h"
#include "sys.h"
#include "beep.h"
#include <stdio.h>
 
//触发按键1，num_1++；触发按键2 num_1--;
uint16_t num_1 = 0;   //Logic Analyzer测试变量





 int main(void)
 {

 	vu8 key=0;	
	delay_init();	    	 //延时函数初始化	  
	LED_Init();		  		//初始化与LED连接的硬件接口
	BEEP_Init();         	//初始化蜂鸣器端口
	KEY_Init();         	//初始化与按键连接的硬件接口
	LED0=0;					//先点亮红灯

	 

	 
	while(1)
	{
		
 		key=KEY_Scan(0);	//得到键值
	   	if(key)
		{						   
			switch(key)
			{				 
				case WKUP_PRES:	//控制蜂鸣器
					BEEP=!BEEP;
					break; 
				
				case KEY1_PRES:	//控制LED1翻转	 
					LED1=!LED1;
					num_1++; //测试变量++
					printf("num_1 = %d\n",num_1);
					break;
				
				case KEY0_PRES:	//同时控制LED0,LED1翻转 
					LED0=!LED0;
					LED1=!LED1;
					num_1--; //测试变量--
					printf("num_1 = %d\n",num_1);
					break;
			}
		}else delay_ms(10); 
	}	 
}

