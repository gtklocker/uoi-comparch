# Converts a number to ASCII in hexadecimal
# 
# Written by Aris Efthymiou, 5/02/2015
# Based on hex.s program from U. of Manchester for the ARM ISA

        .data
number:
        .word 0xDEADC0DE 
outmsg:
        .space 9  # Leave space for 8 hex digits plus '\0'

        .globl main

        .text
main:   
        la  $a0, number
        lw  $s0, 0($a0)  # Load the number in $s0

        la   $a0, outmsg # Get address of output string

        # set up the loop counter variable
        li   $t0, 8      # 8 hex digits in a 32-bit number

loop:   # Main loop ----------
        srl  $t1, $s0, 28  # get leftmost digit by shifting it
                           # to the 4 least significant bits of $t1

        # The following instructions convert the number to a char
        slti $t2, $t1,   10  # t2 is set to 1 if $t1 < 10	
        beq  $t2, $zero, over10
        addi $t1, $t1,   '0' # ASCII for '0' is 48
        j    save_c
over10:
        addi $t1, $t1, 55 # convert to ASCII for A-F
                          # ASCII code for 'A' is 65
                          # Use 55 because $t1 is over 10

save_c: # store one hex digit (in $t1)
        sb   $t1, 0($a0)
        addi $a0, $a0, 1

        # Prepare for next iteration
        sll  $s0, $s0, 4   # Drop current leftmost digit
        addi $t0, $t0, -1  # Update loop counter
        bne  $t0, $0, loop # Still not 0?, go to loop
        # End of loop --------

		# store special end of string (null) char
        sb   $zero, 0($a0)

        # end the program
        li   $v0, 10
        syscall

