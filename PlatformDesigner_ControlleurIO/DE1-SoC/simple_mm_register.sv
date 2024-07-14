/**
 * @module simple_mm_register
 * @brief This module represents a simple memory-mapped register.
 *        It stores a 32-bit value and provides read and write access to it.
 * @param clk The clock input signal.
 * @param reset_n The active-low reset signal.
 * @param avs_write The write enable signal for the register.
 * @param avs_writedata The data to be written to the register.
 * @param avs_readdata The output signal that holds the value of the register.
 * @param leds The output signal that holds the lower 10 bits of the register value.
 */
module simple_mm_register(
  input  clk,
  input  reset_n,
  input  avs_write,
  input  [31:0] avs_writedata,
  output [31:0] avs_readdata,
  output [9:0]  leds
);

logic [31:0] R; // Internal register to store the value

/**
 * @brief This always block describes the behavior of the register.
 *        It updates the register value based on the clock and reset signals.
 * @note The register is asynchronously reset to 0 when reset_n is low.
 *       When avs_write is high, the register is updated with the value of avs_writedata.
 * @note The always_ff construct ensures that the register is updated on the positive edge of the clock.
 */
always_ff @(posedge clk or negedge reset_n) begin
  if (!reset_n) begin
    R <= 32'b0; // Asynchronously reset the register to 0
  end else if (avs_write) begin
    R <= avs_writedata; // Update the register with the new value
  end
end

/**
 * @brief This assign statement connects the avs_readdata output to the value of the register.
 */
assign avs_readdata = R;

/**
 * @brief This assign statement connects the leds output to the lower 10 bits of the register value.
 */
assign leds = R[9:0];

endmodule

