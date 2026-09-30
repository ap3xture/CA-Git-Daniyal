
.text
.globl main

main:
    addi x10, x0, 8     # x10(n) = 8
    
    jal  ra, fib         # Call fib
    
    addi x11, x0, 1      # x11 = 1 (print integer syscall)
    ecall                # Print the result
    
    addi x11, x0, 10     # x11 = 10 (exit syscall)
    ecall                # exit

fib:
    addi sp, sp, -12     # stack for 3
    sw   ra, 8(sp)       # ra is saved into stack
    sw   x10, 4(sp)      # x10(n) is saved into stack

    blt  x10, x0, neg    # if n < 0
    addi t0, x0, 1       # t0 = 1
    ble  x10, t0, base   # if n <= 1

    lw   x10, 4(sp)      # x10 = n
    addi x10, x10, -1    # n = n - 1
    jal  ra, fib         # Call fib(n-1)
    
    sw   x10, 0(sp)      # fib(n-1) is saved into stack
    
    lw   x10, 4(sp)      # x10 = n
    addi x10, x10, -2    # n = n - 2
    jal  ra, fib         # Call fib(n-2)
    
    lw   t1, 0(sp)       # t1 = fib(n-1)
    add  x10, x10, t1    # x10 = fib(n-2) + fib(n-1)
    
    j    done            # Jump to done

neg:
    addi x10, x0, -1     # x10 = -1
    j    done            # Jump to done

base:
    lw   x10, 4(sp)      # x10 = n 

done:
    lw   ra, 8(sp)       # ra is restored from stack
    addi sp, sp, 12      # Adjust stack pointer back
    jalr x0, 0(ra)       # Return to caller

exit:
