# Palindrome detection in MIPS assembly using MARS
# for MYΥ-402 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

        .globl main # declare the label main as global. 
        
        .text 
     
main:
        la         $s1, mesg         # get address of mesg to $s1
        addu       $s2, $s1,   $zero # $s2=$s1
loop:
        addiu      $s2, $s2,   1     # $s2=$s1 + 1
        lbu        $t0, 0($s2)       # get next character
        bne        $t0, $zero, loop  # repeat if char not '\0'
        # end of loop here

        addiu      $s2, $s2,  -1     # Adjust $s2 to point to last char

        ########################################################################
        #  Write your code here
        ########################################################################
        addu       $s3, $s2,   $zero # $s3=$s2

insideLoop:
        lbu        $t1, 0($s1)	     # $t1 = s1
        lbu        $t2, 0($s2) 	     # $t2 = s2
        bne        $t1, $t2, exitFail
        beq        $s1, $s3, exitSuccess
	
        addiu      $s1, $s1, 1       # $s1 inside
        addiu      $s2, $s2, -1      # $s2 outside
        j insideLoop

        
exitSuccess: 
        addiu      $v0, $zero, 10    # system service 10 is exit
        addiu      $a0, $zero, 0     # exit 0
        syscall                      # we are outta here.

exitFail:
        addiu      $v0, $zero, 10    # system service 10 is exit
        addiu      $a0, $zero, 1     # exit 1
        syscall                      # we are outta here,
        
###############################################################################

        .data
mesg:   .asciiz "racecar"
#mesg:   .asciiz "madamimadam"
#mesg:   .asciiz "alitiz"