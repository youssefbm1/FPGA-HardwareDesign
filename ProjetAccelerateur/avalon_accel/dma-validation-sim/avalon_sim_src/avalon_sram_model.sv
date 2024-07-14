module avalon_sram_model (
  input               clk,
  input               reset_n,
  input [31:0]        avm_address,
  output logic        avm_waitrequest,
  input               avm_read,
  output logic [31:0] avm_readdata,
  input               avm_write,
  input [31:0]        avm_writedata
);

parameter  MEM_WORD_SIZE = 2048;

logic [31:0] mem [];

wire[29:0] word_addr = avm_address[31:2];

initial
begin
  mem = new[MEM_WORD_SIZE];
  for(int i=0;i<MEM_WORD_SIZE;i++)
    //mem[i] = $random();
    mem[i] = i | 32'hbade0000;
end

const int unsigned max_read_delay  = 3;
const int unsigned max_write_delay = 3;
int unsigned read_delay = 0;
int unsigned write_delay = 0;

initial
begin
  avm_waitrequest = 1;
  avm_readdata    = 'x;
  forever
  begin
    @(negedge clk);
    avm_waitrequest = 1;
    if(avm_read && !avm_write)
    begin
      read_delay = $random()%max_read_delay;
      read_delay = (read_delay==0)? 1 : read_delay;
      avm_waitrequest = 1;
      repeat(read_delay) @(negedge clk);
      avm_readdata = mem[word_addr];
      avm_waitrequest = 0;
    end
    else if(!avm_read && avm_write)
    begin
      write_delay = $random()%max_write_delay;
      avm_waitrequest = 1;
      repeat(write_delay) @(negedge clk);
      mem[word_addr] = avm_writedata ;
      avm_waitrequest = 0;
    end
    else if(avm_read && avm_write)
      $error("Can not issue read and write requests simultaneously");
  end
end
endmodule

