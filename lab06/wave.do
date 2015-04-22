onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/reset
add wave -noupdate /top/clk
add wave -noupdate -radix hexadecimal /top/duv/pc
add wave -noupdate -radix hexadecimal /top/duv/instruction
add wave -noupdate -radix hexadecimal /top/duv/b2v_regfile/ra1
add wave -noupdate -radix hexadecimal /top/duv/b2v_regfile/ra2
add wave -noupdate -radix hexadecimal /top/duv/rd1
add wave -noupdate -radix hexadecimal /top/duv/rd2
add wave -noupdate -radix hexadecimal /top/duv/b
add wave -noupdate -radix hexadecimal /top/duv/immed
add wave -noupdate -radix hexadecimal /top/duv/result
add wave -noupdate /top/duv/zero
add wave -noupdate -radix hexadecimal /top/duv/mo
add wave -noupdate -radix hexadecimal /top/duv/wr
add wave -noupdate -radix hexadecimal /top/duv/writeData
add wave -noupdate -divider {NextPC datapath}
add wave -noupdate -radix hexadecimal /top/duv/pcSeq
add wave -noupdate -radix hexadecimal /top/duv/jmpTarget
add wave -noupdate -radix hexadecimal /top/duv/brTarget
add wave -noupdate -radix hexadecimal /top/duv/npc
add wave -noupdate -divider {Control Signals}
add wave -noupdate /top/duv/aluSrc
add wave -noupdate -radix hexadecimal /top/duv/aluOp
add wave -noupdate -radix hexadecimal /top/duv/aluCtrl
add wave -noupdate /top/duv/memWrite
add wave -noupdate /top/duv/memToReg
add wave -noupdate /top/duv/regWrite
add wave -noupdate /top/duv/regDst
add wave -noupdate /top/duv/branch
add wave -noupdate /top/duv/jump
add wave -noupdate /top/duv/brTaken
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 318
configure wave -valuecolwidth 90
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {22580 ps}
