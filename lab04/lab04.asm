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
        slt  $t0, $a1, $a0
        beq  $t0, 1, modLoop
        beq  $a0, $a1, modLoop
        j    modReturn
modLoop:
        sub  $a0, $a0, $a1
        j    mod
modReturn:
        add  $v0, $zero, $a0
        jr   $ra

gcd:
        slt  $t0, $a0, $a1
        beq  $t0, 1, gcdSwap
        beq  $a1, 0, gcdReturn
        
        addi $sp, $sp, -12
        sw   $a0, 0($sp)
        sw   $a1, 4($sp)
        sw   $ra, 8($sp)
        jal  mod
        
        lw   $a0, 0($sp)
        lw   $a1, 4($sp)
        lw   $ra, 8($sp)
        addi $sp, $sp, 12
        
        add  $a0, $zero, $a1
        add  $a1, $zero, $v0
        j    gcd
gcdReturn:
        add  $v0, $zero, $a0
        jr   $ra
gcdSwap:
        add  $t1, $zero, $a0
        add  $a0, $zero, $a1
        add  $a1, $zero, $t1
        j    gcd