/**
 * @module prog_gpio
 * @brief This module implements a programmable GPIO (General Purpose Input/Output) controller.
 *
 * The prog_gpio module provides the following functionalities:
 * - Reading and writing data to the GPIO registers
 * - Configuring interrupt masks and polarity
 * - Generating an interrupt signal based on input values and configuration
 *
 * @param clk The clock signal
 * @param reset_n The active-low reset signal
 * @param avs_write The write enable signal for the AVS (Address-Value-Select) bus
 * @param avs_writedata The data to be written on the AVS bus
 * @param avs_address The address on the AVS bus
 * @param avs_readdata The data read from the AVS bus
 * @param pio_i The input data from the GPIO pins
 * @param pio_o The output data to the GPIO pins
 * @param irq The interrupt signal
 */
module prog_gpio(
    input logic clk,
    input logic reset_n,
    input logic avs_write,
    input logic [31:0] avs_writedata,
    input logic [4:0] avs_address,
    output logic [31:0] avs_readdata,
    input logic [31:0] pio_i,
    output logic [31:0] pio_o,
    output logic irq
);

// Internal signals and registers
logic [31:0] register_data;
logic [31:0] enable;
logic [31:0] irq_mask;
logic [31:0] irq_pol;
logic irq_ack;
logic interrupt_register;

/**
 * @brief Combinational logic to read data from the GPIO registers based on the AVS address
 */
always_comb
begin
    avs_readdata = '0;
    if (avs_address == 0)
        avs_readdata = enable & pio_i;
    else if (avs_address == 4)
        avs_readdata = enable;
    else if (avs_address == 8)
        avs_readdata = irq_mask;
    else if (avs_address == 12)
        avs_readdata = irq_pol;
end

/**
 * @brief Sequential logic to handle register writes and reset
 */
always_ff @(posedge clk or negedge reset_n)
  if(!reset_n) begin
    register_data <= 32'b0;
    enable <= 32'b0;
    irq_mask <= 32'b0;
    irq_pol <= 32'b0;
    irq_ack <= 1'b0;
    end
  else
begin
    irq_ack <= 1'b0;
    if(avs_write) begin
        if (avs_address == 0)
            register_data <= enable & avs_writedata;
        else if (avs_address == 4)
            enable <= avs_writedata;
        else if (avs_address == 8)
            irq_mask <= avs_writedata;
        else if (avs_address == 12)
            irq_pol <= avs_writedata;
        else if (avs_address == 16)
            irq_ack <= 1'b1;
    end
end

/**
 * @brief Combinational logic to generate the interrupt signal based on input values and configuration
 */
wire interrupt_signal = | ( (pio_i ^ irq_pol) & enable & irq_mask );

/**
 * @brief Sequential logic to handle interrupt register updates and reset
 */
always_ff @(posedge clk or negedge reset_n)
  if(!reset_n)
    interrupt_register <= 1'b0;
  else
    if(irq_ack)
      interrupt_register <= 1'b0;
    else if(interrupt_signal)
      interrupt_register <= 1'b1;

// Assign outputs
assign irq = interrupt_register;
assign pio_o  = register_data;

endmodule

