module incrementer(
 input      [3:0] in,
 output reg [4:0] out
 );
 
 always @(in)
     out = in + 4'h1;
 
 endmodule