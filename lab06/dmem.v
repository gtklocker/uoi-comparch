module dmem(input         clk, we,
            input  [31:0] a, wd,
            output [31:0] rd);

  reg  [31:0] RAM[63:0];

  initial
    begin
      $readmemh("data_memfile.dat",RAM);
    end
	 
  wire [5:0] address;
  assign address = a[7:2];

  assign rd = RAM[address]; // word aligned

  always @(posedge clk)
    if (we)
      RAM[address] <= wd;
endmodule
