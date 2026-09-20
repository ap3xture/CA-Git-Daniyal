strcpy:
    addi sp, sp, -4      # stack for 1
    sw   x19, 0(sp)      # x19(i) is saved into stack
    
    add  x19, x0, x0     # i = 0

L1:
    add  x5, x19, x11    # x5 = address of y[i
    lb   x6, 0(x5)       # x6 = y[i] 
    
    add  x7, x19, x10    # x7 = address of x[i]
    sb   x6, 0(x7)       # x[i] = y[i] 
    
    beq  x6, x0, L2      # if y[i] == '\0' (0)
    
    addi x19, x19, 1     # i += 1
    j    L1              # Jump back to L1
    
L2:
    lw   x19, 0(sp)      # Restore saved register x19 from the stack
    addi sp, sp, 4       # Adjust stack pointer back
    ret                  # Return to caller
