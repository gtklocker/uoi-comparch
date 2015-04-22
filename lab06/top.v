module top;

reg clk;
reg reset;

mips duv(
  .clk(clk),
  .reset(reset)
);

initial begin
    clk = 0;
    reset = 1;
    #100   reset = 0;
    #10000 $finish;
end

always 
   #200 clk = ~clk;

endmodule
