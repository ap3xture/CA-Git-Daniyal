
# Assume there are three arrays a, b, and c located at the following addresses:
# • a at address x20
# • b at address x21
# • c at address x22

#  for (int i = 0; i < 4; i++)
#       c[i] = a[i] + b[i];


main:
    li x10, 0 #let i = 0
    li x20, 0x100
    li x21, 0x200
    li x22, 0x300

    # li x10, 0x78786464
    # li x11, 0xA8A81919

    
    lw x10, 0(x20)  #a0
    lw x11, 0(x21)#b0
    lw x12, 0(x22)#c0
     
    add x12, x10, x11 #x12=a0+b0

    sw x12, 0(x22)#c0 = a0 +b0

    ##iteration 1
    lw x10, 4(x20)#a1
    lw x11, 4(x21)#b1
    lw x12, 4(x22)#c1
     
    add x12, x10, x11 #x12=a0+b0

    sw x12, 4(x22)#c1 = a1 +b1

    ##iteration 2
    lw x10, 8(x20)#a2
    lw x11, 8(x21)#b2
    lw x12, 8(x22)#c2
     
    add x12, x10, x11 #x12=a2+b2

    sw x12, 8(x22)#c2 = a2 +b2

    
    ##iteration 3
    lw x10, 12(x20)#a3
    lw x11, 12(x21)#b3
    lw x12, 12(x22)#c3
     
    add x12, x10, x11 #x12=a3+b3

    sw x12, 12(x22)#c3 = a3 +b3

   

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