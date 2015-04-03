module top;

reg        a,b,c,d,r;
wire [4:0] out;

tutorial tutorial_inst
(
	.r(r_sig) ,	// input  r_sig
	.a(a_sig) ,	// input  a_sig
	.b(b_sig) ,	// input  b_sig
	.c(c_sig) ,	// input  c_sig
	.d(d_sig) ,	// input  d_sig
	.out(out_sig) 	// output [4:0] out_sig
);

tutorial duv(
	.a(a) ,
	.b(b) ,
	.c(c) ,
	.d(d) ,
	.r(r) ,
	.out(out)
);

initial begin
  a = 0;
  b = 0;
  c = 0;
  d = 0;
  r = 0;
  #100
  a = 1;
  b = 0;
  c = 0;
  d = 0;
  r = 1;
  #100
  a = 1;
  b = 1;
  c = 0;
  d = 0;
  r = 1;
  #100
  a = 0;
  b = 1;
  c = 1;
  d = 0;
  r = 1;
  #100 ;
end

endmodule