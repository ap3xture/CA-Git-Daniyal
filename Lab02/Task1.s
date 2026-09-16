
  bne x22, x23, Else   
  add x19, x20, x21     
  beq x0, x0, Exit      
Else: sub x19, x20, x21 
Exit:


# Loop: slli x10, x22, 2  
#       add x10, x10, x25       
#       lw x9, 0(x10)     
#       bne x9, x24, Exit 
#       addi x22, x22, 1        
#       beq x0, x0, Loop 
# Exit: 
