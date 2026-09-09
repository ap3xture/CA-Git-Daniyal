# i = x22, array_a_base = x5,
# sum = x23, max = 10 = x24

main:
    li x22, 0   #i
    li x23, 0   #sum
    li x24, 10 # 10
    li x5, 0x200 # array base
loop:
    bge x22, x24, end # end if false

    slli x6, x22, 2
    add x6, x5, x6 # 0x200 .. 0x204 ... 0x208
    sw x22, 0x0(x6)  # set a[i] =i

    addi x22, x22, 1    # i++
    j loop              # back to loop
end:

main1:
    li x22, 0   #i
    li x23, 0   #sum
    li x24, 10 # 10
    li x5, 0x200 # array base
loop1:
    bge x22, x24, end1 # end if false

    slli x6, x22, 2
    add x6, x5, x6 # 0x200 .. 0x204 ... 0x208
    lw x25, 0x0(x6)  # put a[i in x25
    add x23, x23, x25 # sum += a[i

    addi x22, x22, 1    # i++
    j loop1              # back to loop
end1:
    j end1