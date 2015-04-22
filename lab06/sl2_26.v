module sl2_26(input  [25:0] a,
           output [27:0] y);

  // shift left by 2
  assign y = {a[25:0], 2'b00};
endmodule
