module maindec(input  [5:0] op,
               output       memtoreg, memwrite,
               output       branch, alusrc,
               output       regdst, regwrite,
               output       jump,
               output [1:0] aluop);

  reg [8:0] controls;

  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop} = controls;

  // Implemented instructions:
  // lw, sw
  // beq, j
  // addi
  // add, sub, and, or, slt, 
  always @(*)
    case(op)
      6'b000000: controls = 9'b110000010; //Rtype
      6'b100011: controls = 9'b101001000; //LW
      6'b101011: controls = 9'b001010000; //SW
      6'b000100: controls = 9'b000100001; //BEQ
      6'b001000: controls = 9'b101000000; //ADDI
      6'b000010: controls = 9'b000000100; //J
      6'b001100: controls = 9'b101000011; //ANDI
      default:   controls = 9'bxxxxxxxxx; //???
    endcase
endmodule
