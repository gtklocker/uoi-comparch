module top;

reg        a,b,c,d,r;
wire [4:0] out;

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
  #100 ;
end

endmodule
