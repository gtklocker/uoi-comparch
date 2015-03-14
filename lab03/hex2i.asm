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

        la   $a1, number # Address where the result should go to
        sw   $s0, 0($a1)

        # end the program
        li   $v0, 10
        syscall

