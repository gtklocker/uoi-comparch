// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
// CREATED		"Thu Feb 12 11:47:05 2015"

module mips(
	clk,
	reset
);


input wire	clk;
input wire	reset;

wire	[2:0] aluCtrl;
wire	[1:0] aluOp;
wire	aluSrc;
wire	[31:0] b;
wire	branch;
wire	brTaken;
wire	[31:0] brTarget;
wire	[31:0] immed;
wire	[31:0] imSh2;
wire	[31:0] instruction;
wire	[31:0] jmpTarget;
wire	jump;
wire	memToReg;
wire	memWrite;
wire	[31:0] mo;
wire	[31:0] npc;
wire	[31:0] npcOpt;
wire	[31:0] pc;
wire	[31:0] pcSeq;
wire	[31:0] rd1;
wire	[31:0] rd2;
wire	regDst;
wire	regWrite;
wire	[31:0] result;
wire	[4:0] wr;
wire	[31:0] writeData;
wire	zero;
wire	[31:0] SYNTHESIZED_WIRE_0;





alu	b2v_alu(
	.a(rd1),
	.alucont(aluCtrl),
	.b(b),
	.zero(zero),
	.result(result));


aludec	b2v_aludec(
	.aluop(aluOp),
	.funct(instruction[5:0]),
	.alucontrol(aluCtrl));


mux2_32	b2v_b_mux(
	.s(aluSrc),
	.d0(rd2),
	.d1(immed),
	.y(b));


adder	b2v_br_adder(
	.a(pcSeq),
	.b(imSh2),
	.y(brTarget));


mux2_32	b2v_br_mux(
	.s(brTaken),
	.d0(pcSeq),
	.d1(brTarget),
	.y(npcOpt));


sl2_32	b2v_br_shift(
	.a(immed),
	.y(imSh2));


dmem	b2v_dmem(
	.clk(clk),
	.we(memWrite),
	.a(result),
	.wd(rd2),
	.rd(mo));


mux2_5	b2v_dst_mux(
	.s(regDst),
	.d0(instruction[20:16]),
	.d1(instruction[15:11]),
	.y(wr));


imem	b2v_imem(
	.a(pc),
	.rd(instruction));


signext	b2v_imm_signext(
	.a(instruction[15:0]),
	.y(immed));

assign	brTaken = branch & zero;

assign	jmpTarget[30] = pcSeq[30];


assign	jmpTarget[29] = pcSeq[29];


assign	jmpTarget[31] = pcSeq[31];


assign	jmpTarget[28] = pcSeq[28];



lpm_constant4	b2v_inst27(
	.result(SYNTHESIZED_WIRE_0));


sl2_26	b2v_jump_shft(
	.a(instruction[25:0]),
	.y(jmpTarget[27:0]));


maindec	b2v_maindec(
	.op(instruction[31:26]),
	.memtoreg(memToReg),
	.memwrite(memWrite),
	.branch(branch),
	.alusrc(aluSrc),
	.regdst(regDst),
	.regwrite(regWrite),
	.jump(jump),
	.aluop(aluOp));


mux2_32	b2v_npc_mux(
	.s(jump),
	.d0(npcOpt),
	.d1(jmpTarget),
	.y(npc));


adder	b2v_pc_adder(
	.a(SYNTHESIZED_WIRE_0),
	.b(pc),
	.y(pcSeq));


flopr	b2v_pc_reg(
	.clk(clk),
	.reset(reset),
	.d(npc),
	.q(pc));


regfile	b2v_regfile(
	.clk(clk),
	.we3(regWrite),
	.ra1(instruction[25:21]),
	.ra2(instruction[20:16]),
	.wa3(wr),
	.wd3(writeData),
	.rd1(rd1),
	.rd2(rd2));


mux2_32	b2v_wd_mux(
	.s(memToReg),
	.d0(result),
	.d1(mo),
	.y(writeData));


endmodule
