bubble:
    # --- PROLOGUE (Stack Allocation) ---
    addi sp, sp, -32        # Allocate 32 bytes on the stack
    sw x10, 28(sp)          # Store base address 'a' to stack
    sw x11, 24(sp)          # Store 'len' to stack

    # --- INITIAL CHECKS ---
    # if (a == NULL || len == 0) return;
    lw t0, 28(sp)           # Load 'a' from stack
    beq t0, x0, done        # if a == NULL, exit
    lw t1, 24(sp)           # Load 'len' from stack
    beq t1, x0, done        # if len == 0, exit

    # --- OUTER LOOP INIT ---
    # int i = 0;
    sw x0, 20(sp)           # Store 0 into 'i' on the stack

outer_loop:
    # Check: i < len
    lw t0, 20(sp)           # Load 'i'
    lw t1, 24(sp)           # Load 'len'
    bgeu t0, t1, done       # if i >= len (unsigned), exit outer loop

    # --- INNER LOOP INIT ---
    # int j = i;
    lw t0, 20(sp)           # Load 'i'
    sw t0, 16(sp)           # Store 'i's value into 'j' on the stack

inner_loop:
    # Check: j < len
    lw t2, 16(sp)           # Load 'j'
    lw t1, 24(sp)           # Load 'len'
    bgeu t2, t1, inner_end  # if j >= len (unsigned), exit inner loop

    # --- ARRAY ACCESS & COMPARISON ---
    # Calculate address of a[i]
    lw t3, 28(sp)           # Load base address 'a'
    lw t0, 20(sp)           # Load 'i'
    slli t4, t0, 2          # t4 = i * 4 (byte offset)
    add t4, t3, t4          # t4 = &a[i]
    lw t5, 0(t4)            # t5 = a[i]

    # Calculate address of a[j]
    lw t2, 16(sp)           # Load 'j'
    slli t6, t2, 2          # t6 = j * 4 (byte offset)
    add t6, t3, t6          # t6 = &a[j]
    lw t0, 0(t6)            # t0 = a[j] (reusing t0)

    # if (a[i] < a[j])
    bge t5, t0, skip_swap   # If a[i] >= a[j] (signed), skip the swap block

    # --- SWAP BLOCK ---
    # int temp = a[i];
    sw t5, 12(sp)           # Store a[i] into 'temp' on the stack

    # a[i] = a[j];
    sw t0, 0(t4)            # Store a[j] into memory at &a[i]

    # a[j] = temp;
    lw t1, 12(sp)           # Load 'temp' from the stack
    sw t1, 0(t6)            # Store 'temp' into memory at &a[j]

skip_swap:
    # --- INNER LOOP INCREMENT ---
    # j++
    lw t2, 16(sp)           # Load 'j'
    addi t2, t2, 1          # Increment by 1
    sw t2, 16(sp)           # Save updated 'j' to stack
    j inner_loop            # Jump to top of inner loop

inner_end:
    # --- OUTER LOOP INCREMENT ---
    # i++
    lw t0, 20(sp)           # Load 'i'
    addi t0, t0, 1          # Increment by 1
    sw t0, 20(sp)           # Save updated 'i' to stack
    j outer_loop            # Jump to top of outer loop

done:
    # --- EPILOGUE (Stack Deallocation) ---
    addi sp, sp, 32         # Restore the stack pointer
    jalr x0, 0(x1)          # Return to caller