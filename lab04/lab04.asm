# Calculates gcd of 2 numbers
# lab04 of Computer Architecture course
#  at CSE.UoI.gr 

        .data
n1:
        .word  462
n2:
        .word  1071
result:
        .word 0

        .globl main

        .text
main:   
        
        la   $s0, n1       # Get address of n1
        lw   $a0, 0($s0)   # Get n1

        lw   $a1, 4($s0)   # Get n2

        jal  gcd

        la   $t0, result  # Address where the result should go to
        sw   $v0, 0($t0)

        # end the program
        li   $v0, 10
        syscall

		######################################
        # Write your code here for mod and gcd
mod:

gcd:
        
