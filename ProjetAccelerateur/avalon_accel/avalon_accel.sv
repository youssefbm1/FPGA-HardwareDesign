module avalon_accel(
  input  clk,
  input  reset_n,
  // target interface
  input         avs_write,
  input  [31:0] avs_writedata,
  output [31:0] avs_readdata,
  input  [4:0]  avs_address,
  // initiator interface
  output logic       avm_write,
  output logic       avm_read,
  input              avm_waitrequest,
  output logic [31:0] avm_writedata,
  input  [31:0]      avm_readdata,
  output logic [31:0] avm_address,
  // interrupt
  output logic       irq
);

  /*******************************
  * Registers
    R0  -> K0
    R1  -> K1
    R2  -> K2
    R3  -> K3
    R4  -> src
    R5  -> dest
    R6  -> num
    R7  -> ctrl/status
  *******************************/
  logic [31:0] R[0:7];

  // Aliases
  wire[3:0][31:0] key_reg  = {R[3],R[2],R[1],R[0]};
  wire[31:0]      src_addr_reg = R[4];
  wire[31:0]     dest_addr_reg = R[5];
  wire[31:0]       num_blk_reg = R[6];
  wire[31:0]          ctrl_reg = R[7];

  wire start_dma = ctrl_reg;

  // Avalon Target interface to update the registers
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      for (int i = 0; i < 8; i++) begin
        R[i] <= '0;
      end
    end else if (avs_write) begin
      R[avs_address[4:2]] <= avs_writedata;
    end
  end

  assign avs_readdata = R[avs_address[4:2]];

  // Déclaration des signaux de contrôle pour le chiffrement
  logic start_present;
  logic eoc_present;
  logic [63:0] plaintext;
  logic [127:0] key;
  logic [63:0] ciphertext;

  // Instanciation du module de chiffrement PRESENT
  present u_present (
    .clk(clk),
    .nrst(reset_n),
    .start(start_present),
    .eoc(eoc_present),
    .plaintext(plaintext),
    .key(key),
    .ciphertext(ciphertext)
  );

  /*******************************
  * Finite State Machine
  *******************************/
  typedef enum logic [2:0] {
    IDLE, READ1, READ2, PROCESS, WRITE1, WRITE2, INTERRUPT, WAIT_ACK
  } state_t;

  state_t state;

  // Variable for counting the number of blocks encrypted
  logic [31:0] block_count;

  // Variable for going through the memory
  logic [31:0] src_addr;
  logic [31:0] dest_addr;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state <= IDLE;
      block_count <= 32'b0;
      start_present <= 0;
      src_addr <= 0;
      dest_addr <= 0;
      plaintext <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (start_dma) begin
            block_count <= 0;
            state <= READ1;
            src_addr <= src_addr_reg;
            dest_addr <= dest_addr_reg;
          end
        end
        READ1: begin
          if (!avm_waitrequest) begin
            plaintext[31:0] <= avm_readdata;
            state <= READ2;
            src_addr <= src_addr + 4;
            block_count <= block_count + 1;
          end
        end
        READ2: begin
          if (!avm_waitrequest) begin
            plaintext[63:32] <= avm_readdata;
            start_present <= 1;
            state <= PROCESS;
            src_addr <= src_addr + 4;
          end
        end
        PROCESS: begin
          start_present <= 1;
          if (eoc_present) begin
            state <= WRITE1;
          end
        end
        WRITE1: begin
          if (!avm_waitrequest) begin
            state <= WRITE2;
            dest_addr <= dest_addr + 4;
          end
        end
        WRITE2: begin
          if (!avm_waitrequest) begin
            if (block_count == num_blk_reg)
              state <= INTERRUPT;
            else
              state <= READ1;
            dest_addr <= dest_addr + 4;
          end
          else
            state <= WRITE2;
        end
        INTERRUPT: begin
          if (!ctrl_reg)
            state <= IDLE;
          else
            state <= INTERRUPT;
        end
        WAIT_ACK: begin
          if (!start_dma) begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

  assign irq = (state == INTERRUPT) ? 1 : 0;
  assign avm_read = ((state == READ1) || (state == READ2)) ? 1 : 0;
  assign avm_address = ((state == READ2) || (state == READ2)) ? src_addr : dest_addr;
  assign avm_write = ((state == WRITE1) || (state == WRITE2)) ? 1 : 0;
  assign avm_writedata = (state == WRITE1) ? plaintext[31:0] : plaintext[63:32];

endmodule