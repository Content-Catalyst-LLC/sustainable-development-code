#include "stm32f0xx.h"
#include <stdint.h>

volatile uint8_t event_flag = 0;

void SysTick_Handler(void)
{
    event_flag = 1;
}

static void enter_low_power_mode(void)
{
    __DSB();
    __WFI();
}

static void sample_and_process(void)
{
    // Minimal sensor read / DSP / TinyML trigger / radio batching.
}

int main(void)
{
    SystemInit();

    while (1)
    {
        if (event_flag)
        {
            event_flag = 0;
            sample_and_process();
        }

        enter_low_power_mode();
    }
}
