`timescale 1 ps / 1 ps

module testbench();

bit clk;
bit reset_n;

wire [4:0]  avs_address;
wire [31:0] avs_readdata;
wire [31:0] avs_writedata;
wire        avs_write;

wire        avm_write;
wire        avm_read;
wire        avm_waitrequest;
wire [31:0] avm_writedata;
wire [31:0] avm_readdata;
wire [31:0] avm_address;
wire  irq;

avalon_accel dut(.*);

avalon_sram_model sram(.*);
avalon_master_bfm_module master(.reset(!reset_n),.*);

`include "utils.svh"

// clock
always #10ns clk = !clk;

// reset
initial
begin
  #33ns;
  reset_n = 1;
end

localparam K0_ADDR   = 'h00;
localparam K1_ADDR   = 'h04;
localparam K2_ADDR   = 'h08;
localparam K3_ADDR   = 'h0c;
localparam SRC_ADDR  = 'h10;
localparam DEST_ADDR = 'h14;
localparam NUM_ADDR  = 'h18;
localparam CTRL_ADDR = 'h1c;

task wait_irq_with_timeout(input time timeout);
  fork
  begin
    wait(irq);
    $info("Got IRQ from the the DUT");
  end
  begin
    #timeout;
    $error("Timeout waiting for interrupt");
  end
  join_any
  disable fork;
endtask

initial
begin

  // BFM verbosity level
  //verbosity_pkg::set_verbosity(verbosity_pkg::VERBOSITY_DEBUG);

  `BFM.init();

  wait(reset_n);

  // TODO: Put this configuration in an array or a struct
  avalon_write(CTRL_ADDR, 0);
  #33ns;
  // key
  avalon_write(K0_ADDR, 32'hdeadbeef);
  #33ns;
  avalon_write(K1_ADDR, 32'hc01dcafe);
  avalon_write(K2_ADDR, 32'hbadec0de);
  avalon_write(K3_ADDR, 32'h8badf00d);
  #33ns;
  avalon_write(SRC_ADDR, 32'h00000000);
  #33ns;
  avalon_write(DEST_ADDR, 32'h00000100);
  #33ns;
  avalon_write(NUM_ADDR, 32'h00000080);
  #33ns;
  // read back the registers
  $display("-----------------------------------");
  $display("# Read back configuration registers");
  for(int i=0;i<'h20; i=i+4) begin
    logic [31:0] r;
    avalon_read(i, r);
    $display(" - address %02h -> %08h",i,r);
  end
  $display("-----------------------------------");
  // start
  avalon_write(CTRL_ADDR, 1);

  wait_irq_with_timeout(1us*'h80);

  // ack irq
  avalon_write(CTRL_ADDR, 0);
  // new key
  avalon_write(K0_ADDR, 32'hccddeeff);
  avalon_write(K1_ADDR, 32'h8899aabb);
  avalon_write(K2_ADDR, 32'h44556677);
  avalon_write(K3_ADDR, 32'h00112233);
  // src
  avalon_write(SRC_ADDR, 32'h00000200);
  // dest
  avalon_write(DEST_ADDR, 32'h00000100);
  // num
  avalon_write(NUM_ADDR, 32'h00000040);
  // start
  avalon_write(CTRL_ADDR, 1);

  wait_irq_with_timeout(1us*'h40);
  #1us;
  $stop();
end

endmodule
