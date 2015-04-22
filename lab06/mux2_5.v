module mux2_5(
input  [4:0] d0, d1, 
input         s, 
output [4:0] y);

  assign y = s ? d1 : d0; 
endmodule