module imem(input  [31:0] a,
            output [31:0] rd);

  reg  [31:0] RAM[127:0];

  initial
    begin
      $readmemh("instr_memfile.dat",RAM);
    end

  wire [6:0] address;

  assign address = a[8:2];
  assign rd = RAM[address]; // word aligned
endmodule
