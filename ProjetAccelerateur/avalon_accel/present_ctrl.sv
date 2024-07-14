module present_ctrl  (
                       clk,
                       nrst,
                       start,
                       eoc,
                       round 
                      );

import present_pkg::N_ROUNDS;
import present_pkg::ROUNDS_PER_CYCLE;

input        clk;
input        nrst;
input        start;
output       eoc;
output [4:0] round ;

// round counter
logic [4:0] round ;
logic eoc;

logic computing;

always_ff @(posedge clk or negedge nrst)
if(!nrst)
begin
    round <= 5'd1;;
    eoc <= 1'b0;
    computing <= 1'b0;
end
else
begin
  eoc <= 1'b0;

  if (start)
  begin
    round <= 5'b1;
    computing <= 1'b1;
  end

  if(computing)
  begin
    round <= round + 1'b1;
    if(round == N_ROUNDS/ROUNDS_PER_CYCLE -1)
    begin
      eoc <= 1'b1;
      computing <= 1'b0;
    end
  end
end

endmodule
