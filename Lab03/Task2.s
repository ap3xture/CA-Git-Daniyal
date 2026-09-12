#ld load doube word, sd store double word
addi sp, sp, -32 #

li x10, 1 #g
li x11, 2 #h
li x12, 3 #i
li x13, 4 #j

sw x10, 12(sp)
sw x11, 16(sp)
sw x12, 20(sp)
sw x13, 24(sp)



# x20 is f
jal x1, leaf_example

mv x11, x10
li x10, 1
ecall

j exit
leaf_example:

    sw x18, 0(sp)
    sw x19, 4(sp)
    sw x20, 8(sp)

    lw x10, 12(sp)
    lw x11, 16(sp)
    lw x12, 20(sp)
    lw x13, 24(sp)

    add x18, x10,x11 # g+h
    add x19, x12,x13 # i+j 
    sub x20, x18,x19 # (g+h)-(i+j)

    addi x10, x20,0

    lw x18, 0(sp)
    lw x19, 4(sp)
    lw x20, 8(sp)

    addi sp, sp, 16 #

    
    jalr x0, 0(x1)
exit:
