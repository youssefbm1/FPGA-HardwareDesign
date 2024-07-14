module SBox ( i, o);

input [3:0] i;
output logic [3:0] o;
/*****      "present" sboxes       *****
 *
 *   x  0 1 2 3 4 5 6 7 8 9 A B C D E F
 * S[x] C 5 6 B 9 0 A D 3 E F 8 4 7 1 2
 *
 **************************************/
always_comb
case (i)
  4'h0: o <= 4'hC ; 4'h1: o <= 4'h5 ; 4'h2: o <= 4'h6 ; 4'h3: o <= 4'hB ;
  4'h4: o <= 4'h9 ; 4'h5: o <= 4'h0 ; 4'h6: o <= 4'hA ; 4'h7: o <= 4'hD ;
  4'h8: o <= 4'h3 ; 4'h9: o <= 4'hE ; 4'hA: o <= 4'hF ; 4'hB: o <= 4'h8 ;
  4'hC: o <= 4'h4 ; 4'hD: o <= 4'h7 ; 4'hE: o <= 4'h1 ; 4'hF: o <= 4'h2 ;
endcase

endmodule
