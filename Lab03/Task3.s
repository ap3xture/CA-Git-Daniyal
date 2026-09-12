li x10, 0x100 #arr
li x11,2  #k

jal x1, swap

j exit

swap:
    slli x5, x11, 2  #k*4
    add  x5, x10, x5 # baseoffset + k*4
    lw x6, 0(x5)
    lw x7, 4(x5)
    
    sw   x7, 0(x5)      
    sw   x6, 4(x5)     
    jalr x0, 0(x1)     
exit: