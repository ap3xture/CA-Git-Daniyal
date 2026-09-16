fact:
    addi sp, sp, -16   
    
    li t0, 1            # load  1 into temporary register t0
    sw t0, 0(sp)        # storing acc at 0
    
    #initial 'n'
    li a0, 4
    sw a0, 4(sp)        # Store 'n' 

loop:
#condition
    lw t1, 4(sp)        # Load current 'n' from the stack into t1
    blez t1, done       # If n <= 0, branch to 'done'
    
    # acc = acc * n;
    lw t0, 0(sp)        # acc from the stack into t0
    mul t0, t0, t1      # acc = acc * n
    sw t0, 0(sp)        # updated 'acc' back to the stack
    
    #n = n - 1;
    addi t1, t1, -1     # decrement n by 1
    sw t1, 4(sp)        # Save n' back to the stack
    
    j loop              # Jump back to evaluate the loop condition

done:
    lw a0, 0(sp)        #final 'acc' value into a0 for returning
    addi sp, sp, 16     # restore the stack pointer 
