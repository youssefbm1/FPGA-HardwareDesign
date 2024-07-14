/**
 * @file test.c
 * @brief This file contains the code for testing GPIO interrupts on the DE1-SoC board.
 *
 * The code configures the GPIO pins, registers an interrupt service routine (ISR),
 * and toggles an LED when a switch is pressed. The number of interrupts received is
 * counted and displayed using the simple_printf function.
 *
 * The GPIO registers are represented by a structure, and the GPIO pins are accessed
 * through a pointer to this structure. The interrupt service routine increments the
 * interrupt count, toggles the interrupt polarity, acknowledges the interrupt, and
 * prints a message using simple_printf.
 *
 * @note This code is specific to the DE1-SoC board and assumes the presence of the
 * necessary header files and libraries.
 */
#include "stdint.h"
#include "nios2_irq.h"
#include "simple_printf.h"

// Define a structure to represent the GPIO registers
typedef struct {
    uint32_t register_data; // Data register
    uint32_t enable; // Enable register
    uint32_t irq_mask; // Interrupt mask register
    uint32_t irq_pol; // Interrupt polarity register
    uint32_t irq_ack; // Interrupt acknowledge register
} GPIO_t;

// Define a pointer to the GPIO registers at address 0x0009000
#define PIO ((volatile GPIO_t*) 0x0009000)

// Declare a global variable to count the number of interrupts
volatile uint32_t interrupt_count = 0;

// Interrupt service routine for the GPIO interrupt
void prog_gpio_ISR() {
    interrupt_count++;
    PIO->irq_pol = ~PIO->irq_pol; // Toggle the interrupt polarity
    simple_printf("Interrupt #%d received successfully :)\n", interrupt_count);
    PIO->irq_ack = 0; // Acknowledge the interrupt
}

int main() {
    // Configure the GPIO
    PIO->enable = 0xF; // Enable all GPIO pins
    PIO->irq_mask = 0x1; // Enable interrupt for GPIO pin 0
    PIO->irq_pol = 0x0; // Set interrupt polarity to active low

    // Register the GPIO interrupt service routine
    RegisterISR(1, prog_gpio_ISR);

    // Enable interrupts
    irq_enable();

    // Variable to store the previous state of the switch
    uint32_t previous_switch_state = 0;

    // Main loop
    while(1) {
        // Read the current state of the switch
        uint32_t current_switch_state = PIO->register_data & 0x1;

        // Check if the switch state has changed
        if (current_switch_state != previous_switch_state) {
            // If the switch is pressed
            if (current_switch_state == 0) {
                simple_printf("Switch pressed, toggling LED\n");
                PIO->register_data ^= 0x1; // Toggle the LED
            }
            previous_switch_state = current_switch_state;
        }
    }
}
