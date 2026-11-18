.equ SWITCH_ADDR, 0x10000000
.equ LED_ADDR,    0x10000004
.equ RESET_ADDR,  0x10000008
.equ DELAY_CNT,   2500000

.text
.globl _start

_start:
    # Manually load 32-bit addresses bypassing buggy 'li' macro
    lui s1, 0x10000
    addi s1, s1, 4            # s1 = 0x10000004 (LED_ADDR)
    
    lui s2, 0x10000           # s2 = 0x10000000 (SWITCH_ADDR)
    
    lui s3, 0x10000
    addi s3, s3, 8            # s3 = 0x10000008 (RESET_ADDR)

INPUT_WAIT:
    sw zero, 0(s1)            # Clear LEDs
    lw a0, 0(s2)              # Read switches
    beq a0, zero, INPUT_WAIT  # If switch == 0, keep waiting

    sw a0, 0(s1)              # Display initial captured value on LEDs
    jal ra, COUNTDOWN         # Call countdown subroutine, pass initial count in a0
    j INPUT_WAIT              # Return to waiting state after countdown or reset

# ---------------------------------------------------------
# Subroutine: COUNTDOWN
# Arguments: a0 = initial count value
# ---------------------------------------------------------
COUNTDOWN:
    # Prologue: Demonstrate correct stack usage for subroutine
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)
    
    mv s0, a0                 # s0 = Current counter value

COUNT_LOOP:
    # 1. Check for immediate reset
    lw t1, 0(s3)
    bne t1, zero, COUNT_RESET

    # 2. Update LEDs with current count
    sw s0, 0(s1)

    # 3. Check if countdown is finished
    beq s0, zero, COUNT_DONE

    # 4. Wait 1 second (interruptible by reset)
    jal ra, DELAY_1S_WITH_RESET
    bne a0, zero, COUNT_RESET # If a0 != 0, reset was pressed during the delay

    # 5. Decrement and loop
    addi s0, s0, -1
    j COUNT_LOOP

COUNT_RESET:
    sw zero, 0(s1)            # Clear LEDs immediately
    j COUNT_EPILOGUE

COUNT_DONE:
    sw zero, 0(s1)            # Clear LEDs when done
    j COUNT_EPILOGUE

COUNT_EPILOGUE:
    # Epilogue: Restore registers and return
    lw s1, 0(sp)
    lw s0, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    ret

# ---------------------------------------------------------
# Subroutine: DELAY_1S_WITH_RESET
# Returns: a0 = 1 if reset was pressed, a0 = 0 if delay completed
# ---------------------------------------------------------
DELAY_1S_WITH_RESET:
    # Manually load 2500000 (0x2625A0) to bypass buggy 'li' macro
    lui t2, 0x262
    addi t2, t2, 0x5a0

DELAY_LOOP:
    lw t1, 0(s3)                  # Read reset button
    bne t1, zero, DELAY_ABORTED   # If pressed, break delay
    addi t2, t2, -1               # Decrement loop counter
    bne t2, zero, DELAY_LOOP      # Loop until 0

    li a0, 0                      # Delay finished naturally
    ret

DELAY_ABORTED:
    li a0, 1                      # Reset detected during delay
    ret
