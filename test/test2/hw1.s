.data
    n: .word 10 # You can change this number
    
.text
.globl __start

compute:
    addi sp, sp, -16  # store n and return address in stack
    sw a0, 0(sp)
    sw x1 ,8(sp)
    srli a0, a0, 1  # n = n/2
    beq a0, zero, base # if n == 0 set t0 = 1 and return
    jal x1, compute  # else recursive compute 

    # after recursive, t0 is f(n/2)
    lw a1, 0(sp) # load n to a1 and return address to x1 from stack
    lw x1 ,8(sp)
    slli a1, a1, 1  # compute f(n) = 4f(n/2) + 2n
    slli a0, a0, 2
    add a0, a1, a0 
    addi sp, sp, 16 # pop stack
    jalr x0, 0(x1)  # return
    
base:
    addi a0, a0, 1
    addi sp, sp, 16
    jalr x0, 0(x1)

# Do not modify this part!!! #
__start:                     #
    la   t0, n               #
    lw   x10, 0(t0)          #
    jal  x1,compute          #
    la   t0, n               #
    sw   x10, 4(t0)          #
    addi a0,x0,10            #
    ecall                    #
##############################
