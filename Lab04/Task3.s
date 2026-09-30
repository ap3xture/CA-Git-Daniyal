.data
my_array:
    .word 8, 3, 7, 1, 4  # values for array
array_len:
    .word 5              # length of array

.text
.globl main

main:
    la   x10, my_array   # x10(a) = address of my_array
    la   t0, array_len   # t0 = address of array_len
    lw   x11, 0(t0)      # x11(len) = 5

    jal  ra, bubble      # Call bubble sort

    addi a0, x0, 10      # a0 = 10 (exit syscall)
    ecall                # exit

bubble:
    addi sp, sp, -32     # stack for 8
    sw   x10, 28(sp)     # x10(a) is saved into stack
    sw   x11, 24(sp)     # x11(len) is saved into stack

    lw   t0, 28(sp)      # t0 = a
    beq  t0, x0, done    # if a == 0
    lw   t1, 24(sp)      # t1 = len
    beq  t1, x0, done    # if len == 0

    sw   x0, 20(sp)      # i = 0

outer_loop:
    lw   t0, 20(sp)      # t0 = i
    lw   t1, 24(sp)      # t1 = len
    bgeu t0, t1, done    # if i >= len

    lw   t0, 20(sp)      # t0 = i
    sw   t0, 16(sp)      # j = i

inner_loop:
    lw   t2, 16(sp)      # t2 = j
    lw   t1, 24(sp)      # t1 = len
    bgeu t2, t1, inner_end # if j >= len

    lw   t3, 28(sp)      # t3 = a
    lw   t0, 20(sp)      # t0 = i
    slli t4, t0, 2       # t4 = i * 4
    add  t4, t3, t4      # t4 = address of a[i]
    lw   t5, 0(t4)       # t5 = a[i]

    lw   t2, 16(sp)      # t2 = j
    slli t6, t2, 2       # t6 = j * 4
    add  t6, t3, t6      # t6 = address of a[j]
    lw   t0, 0(t6)       # t0 = a[j]

    bge  t5, t0, skip_swap # if a[i] >= a[j]

    sw   t5, 12(sp)      # temp = a[i]
    sw   t0, 0(t4)       # a[i] = a[j]
    lw   t1, 12(sp)      # t1 = temp
    sw   t1, 0(t6)       # a[j] = temp

skip_swap:
    lw   t2, 16(sp)      # t2 = j
    addi t2, t2, 1       # j += 1
    sw   t2, 16(sp)      # save j
    j    inner_loop      # Jump back to inner_loop

inner_end:
    lw   t0, 20(sp)      # t0 = i
    addi t0, t0, 1       # i += 1
    sw   t0, 20(sp)      # save i
    j    outer_loop      # Jump back to outer_loop

done:
    addi sp, sp, 32      # Adjust stack pointer back
    jalr x0, 0(ra)       # Return to caller
