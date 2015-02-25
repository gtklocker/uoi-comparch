# Introduction to MIPS assembly programming using MARS
# for MYY402 - Computer Architecture
# Aris Efthymiou
# Department of Computer Engineering, University of Ioannina

# These are comments! Anything up to the end of line is ignored

        .globl main # declare the label main as global. 
        
        .text      # Special assembler direcrive. what follows is code
     
main:   # Words ending with ':' are **labels**
        # The convention is to write labels starting from the leftmost column.
        # "main" is a special label. Executions starts from here
        # Try to keep label names short so they are to the left of instructions
        # Do not write instrucions in the same line as a label.
        
        # Instructions are indented a few spaces to the right
        #   (so that we can see the labels more clearly)
        # Instruction operands are indented a few spaces, so that the
        #    instruction type is more visible.
      
        la         $a0, mesg1        # get address of mesg1 into $a0
        # la is a pseudo-instruction. Notice that is gets converted to 2
        #   instructions after assemblying.
        #   Ignore this detail for now. We'll get back to this later
        
        la         $t0, matric       # $t0 gets address of matric
        lw         $s0, 0($t0)       # $s0 gets the value of matric
        add        $v0, $zero, $s0   # set $v0 to the value of matric
        
        add        $s1, $zero, $v0   # $s1 = (read value)
                                     # Note: this just moves the value to
                                     #   a different register
        
        la         $t0, var1         # $t0 gets the **address** of var1
                                     # Note: this is address **not** value of var1
        lw         $s0, 0($t0)       # $s0 gets the value of var1
        add        $s0, $s0, $s1     # $s0 = var1 + $s1
        sw         $s0, 0($t0)       # var1 = var1 + (read value)
        
        la         $s2, array        # get address of array into $s2
                                     # This is called the **base** of the array
        sw         $s0, 0xc($s2)     # Store $s0 to the 4th element of array
                                     # Note the use of offset (0xc = 12 = 3*4)
                                     # array[0]  - array + 0
                                     # array[1]  - array + 4
                                     # array[2]  - array + 8
                                     # array[3]  - array + 12
                                     
        addiu      $t1, $s2, 0x10    # Note: address arithmetic.
                                     #  Calculates address of 5th element of array
        la         $t0, var2         # $t0 gets address of var2
        sw         $t0, 0($t1)       # 5th element of array = address of var2
                                     # Note: we can store addresses to locations 
                                     #   in memory just like we do with real data!
        
        la         $t0, var3         # Get address of var 3
        lb         $s0, 0($t0)       # Get value of var3, sign-extended to 32 bits, to $s0
        lbu        $s1, 0($t0)       # Get value of var3, zero-extended to 32 bits, to $s1
        
exit: 
        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outa here.
        
###############################################################################

        .data      # Special assembler **direcrive**. what follows is data
        # Usually data are declared before text. Try to follow that convention 
        #     in your other programs
        #  
matric: .word 2454    # This will be used by your submitted code

mesg1:  .asciiz "Enter matriculation number: "
        # Data can have labels too, so we can refer to them
        # asciiz is a directive, which tells the assmbler that a string (ending
        #      with special character '\0') follows
        .align 2     # Align next data item on specified byte bounday (0-byte,
                     #    1-half, 2-word, 3-double)
var1:   .word 1      # store a word-sized 0 in data memory
var2:   .word 0
array:  .word 0 : 9 # Array of 10 words (initialized to 0)
var3:   .byte -1
