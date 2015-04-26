
        .data
number:
        .word  15
       
        .globl main

        .text
main:   
	lw  $t1, 0($zero)
	add $t2, $t1, $t1
	sub $t3, $t2, $t1
	and $t4, $t3, $zero
	or  $t5, $t3, $zero
	
	beq $t5, $t5, beqValid
beqValid:
	beq $t5, $zero, beqInvalid
	j end
beqInvalid:
	j main
end:
	add $t6, $zero, $zero