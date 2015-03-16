# Converts a (hex) ASCII string to a number
# lab03 of Computer Architecture course
#  at CSE.UoI.gr 

        .data
number:
        .word    0      # dummy initial value
inmsg:
        .asciiz "BADCAFE" 

        .globl main

        .text
main:   
        # Get address of input string
        la   $a0, inmsg


        #################################
        # Write your program here
        # The following assumes the result is in $s0
        #################################
        
        # Find the least significant digit of the number and start
        # from there in order to support variable-length strings.
        
        li   $s0, 0
        li   $t3, 0
        add  $a3, $a0, $zero # $a3 stores the start of the string
        add  $a2, $a0, $zero
        
findEnd:
        lbu  $t0, 0($a2)
        beq  $t0, $zero, foundEnd
        addi $a2, $a2, 1
        j findEnd
        
foundEnd:
        addi $a2, $a2, -1
        
loop:      
        lbu  $t0, 0($a2)
        
        slti $t2, $t0, 58
        beq  $t2, $zero, letter
        # subtract from '0'
        addi $t0, $t0, -48
        j continue

letter:
        # subtract from 'A', add 10
        addi $t0, $t0, -55
	
continue:
        sllv $t0, $t0, $t3
        addu $s0, $s0, $t0
        
        beq  $a2, $a3, save
        
        addi $a2, $a2, -1
        addi $t3, $t3, 4
        j loop
    
        #################################
save:
        la   $a1, number # Address where the result should go to
        sw   $s0, 0($a1)
exit:
        # end the program
        li   $v0, 10
        syscall

