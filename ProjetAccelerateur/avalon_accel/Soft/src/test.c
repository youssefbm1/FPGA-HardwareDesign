#include "interval_timer.h"
#include "simple_printf.h"
#include "stdint.h"
#include "nios2_irq.h"
#include <string.h>

#define DMA_BASE 0x0000a000
#define NUM 80

// Define the structure for the DMA controller
typedef struct {
    uint32_t k[4];      // Key values
    uint32_t src;       // Source address
    uint32_t dest;      // Destination address
    uint32_t num;       // Number of elements to transfer
    uint32_t ctrl;      // Control register
} DMA_t;

// Define a macro to access the DMA registers
#define DMA ((volatile DMA_t*) DMA_BASE)

volatile uint8_t irq_received;      // Flag to indicate if an interrupt is received
volatile uint32_t time_elapsed;     // Variable to store the time elapsed

// Interrupt service routine for the Avalon Accelerator
void avalon_accel_ISR()
{
    // Reset the interruption
    DMA->ctrl = 0;
    
    // Measure the time elapsed
    time_elapsed = interval_timer_val();
    
    // Set the interrupt received flag
    irq_received = 1;
}

uint32_t src[NUM*2];    // Source memory block
uint32_t dst[NUM*2];    // Destination memory block

int main()
{   
    uint32_t value = 0xbade0000;
    irq_received = 0;
    time_elapsed = 0;

    // Set the key values for the DMA controller
    DMA->k[0] = 0xdeadbeef;
    DMA->k[1] = 0xc01dcafe;
    DMA->k[2] = 0xbadec0de;
    DMA->k[3] = 0x8badf00d;
    
    // Set the source and destination addresses for the DMA transfer
    DMA->src = (uint32_t) &src[0];
    DMA->dest = (uint32_t) &dst[0];
    
    // Set the number of elements to transfer
    DMA->num = (uint32_t) NUM;

    // Set values in the source memory block
    for (uint16_t i = 0; i < NUM*2; i++)
    {
        src[i] = value++;
    };
    
    // Start the timer
    interval_timer_start();

    // Copy the source memory block to the destination memory block
    memcpy(&dst, &src, sizeof(uint32_t)*NUM*2);

    // Get the time elapsed for the memory block copy
    time_elapsed = interval_timer_val();

    // Print the time elapsed for the memory block copy
    simple_printf("Time elapsed for copying a memory block %d ticks \n", time_elapsed);
    
    // Register the interrupt service routine for the Avalon Accelerator
    RegisterISR(0, avalon_accel_ISR);
    
    // Enable interrupts
    irq_enable();

    // Start the timer
    interval_timer_start();

    // Start the DMA transfer
    DMA->ctrl = 0x00000001;

    // frequency used 50Mhz
    // 1/(50Mhz) * ticks = time elapsed

    while (1)
    {
        // Check if an interrupt is received
        if (irq_received)
        {   
            // Reset the interrupt received flag
            irq_received = 0;
            
            // Print the time elapsed for the memory block cyphering
            simple_printf("Time elapsed for cyphering the memory block %d ticks \n", time_elapsed);
        }
    }
}