
main:
    li x10, 0x78786464
    li x11, 0xA8A81919

    sw x10, 0x100(x0)
    sw x11, 0x1F0(x0)

    lhu x12, 0x100(x0)

    lh x13, 0x1F0(x0)

    lb x14, 0x1F0(x0)

    # li x20, 5       #a = 5
    # li x21, 0       #b = 0
    
    # #addi x21, x0, 10  #int b = 0 + 0;
    
    # addi x20, x21, 32    #a = b + 32;

    # add x22, x20, x21
    # addi x22, x22, -5    #int d = (a + b)- 5;

    # sub x23, x20, x22          # 5 int e = (((a- d)
    # sub x24, x21, x20       #(b- a))
    # add x25, x23, x24
    # add x25, x25, x22 #int e = (((a- d) + (b- a)) + d);

    # add x25, x25, x20 # +a
    # add x25, x25, x21 # +b
    # add x25, x25, x22 # +d
    
    

end:
    j end