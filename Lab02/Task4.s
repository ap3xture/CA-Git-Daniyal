main:
    li x7, 0   #i
    li x23, 0   #sum
    li x5, 3 # a, max size to run primary loop

    li x6, 3 # b, max size to run secondary loop
    li x29, 0 #j for second loop
    
    li x10, 0x300 # D array base
loop:
    bge x7, x5, end # end if false , i<a 

    # add x6,x5, x22 # 0x200 .. 0x201 ... 0x202
    #sb x22,0x0(x6)  # set a[i] =i

    loopj:
        bge x29, x6, endj # end if false , j<b 

        slli x8, x29, 2 #j*4

        add x11, x10, x8# 0xDbase + [j*4]

        add x9, x7,x29 #i +j

        sw x9,0x0(x11)  # set D[j*4] = i+j


        addi x29, x29, 1    # j++
        j loopj             # back to loop
    endj:

    li x29, 0 #j =0 after one iteration of i 


    addi x7, x7, 1    # i++
    j loop              # back to loop
end:
    j end