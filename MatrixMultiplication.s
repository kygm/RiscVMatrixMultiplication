# CSCI 320 Computer Architecture 2
# 3x3 Matrix Multiplication RISC V implementation
# Kevin Gutierrez
# 4/1/25


.text

_boot:
    # Load addresses for matrices
    li x1, 0x1000          # x1 -> Matrix A (Base Address)
    li x2, 0x1020          # x2 -> Matrix B (Base Address)
    li x3, 0x1040          # x3 -> Matrix Result (Base Address)

    # Branch to POPULATE Matrix A
    jal x0, POPULATE_A

    # Branch to POPULATE Matrix B
    jal x0, POPULATE_B

    # Branch to CALCULATE A * B Product
    jal x0, CALCULATE_A_B_PRODUCT

    # End execution
    

POPULATE_A:
    # Matrix A [row 1]
    li t0, 2
    sb t0, 0(x1)          # A[0][0]
    li t0, 1
    sb t0, 1(x1)          # A[0][1]
    li t0, 3
    sb t0, 2(x1)          # A[0][2]

    # Matrix A [row 2]
    li t0, 3
    sb t0, 3(x1)          # A[1][0]
    li t0, 4
    sb t0, 4(x1)          # A[1][1]
    li t0, 1
    sb t0, 5(x1)          # A[1][2]

    # Matrix A [row 3]
    li t0, 5
    sb t0, 6(x1)          # A[2][0]
    li t0, 2
    sb t0, 7(x1)          # A[2][1]
    li t0, 3
    sb t0, 8(x1)          # A[2][2]
    

POPULATE_B:
    # Matrix B [row 1]
    li t0, 1
    sb t0, 0(x2)          # B[0][0]
    li t0, 2
    sb t0, 1(x2)          # B[0][1]
    li t0, 0
    sb t0, 2(x2)          # B[0][2]

    # Matrix B [row 2]
    li t0, 4
    sb t0, 3(x2)          # B[1][0]
    li t0, 1
    sb t0, 4(x2)          # B[1][1]
    li t0, 2
    sb t0, 5(x2)          # B[1][2]

    # Matrix B [row 3]
    li t0, 3
    sb t0, 6(x2)          # B[2][0]
    li t0, 2
    sb t0, 7(x2)          # B[2][1]
    li t0, 1
    sb t0, 8(x2)          # B[2][2]
    

CALCULATE_A_B_PRODUCT:
    # Registers: t0, t1, t2 for working; t3, t4, t5 for results
    # Compute AB[0][0], AB[0][1], AB[0][2] (Row 0)
    
    li t2, 0              # Reset sum register
    lb t0, 0(x1)          # Load A00
    lb t1, 0(x2)          # Load B00
    mul t0, t0, t1        # A00 * B00
    add t2, t2, t0        # Sum += A00 * B00
    lb t0, 1(x1)
    lb t1, 3(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 2(x1)
    lb t1, 6(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 0(x3)          # Store AB[0][0]

    li t2, 0              # Reset sum register
    lb t0, 0(x1)          # Load A00
    lb t1, 1(x2)          # Load B01
    mul t0, t0, t1        # A00 * B01
    add t2, t2, t0
    lb t0, 1(x1)
    lb t1, 4(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 2(x1)
    lb t1, 7(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 4(x3)          # Store AB[0][1]

    li t2, 0              # Reset sum register
    lb t0, 0(x1)          # Load A00
    lb t1, 2(x2)          # Load B02
    mul t0, t0, t1        # A00 * B02
    add t2, t2, t0
    lb t0, 1(x1)
    lb t1, 5(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 2(x1)
    lb t1, 8(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 8(x3)          # Store AB[0][2]

    # Compute AB[1][0], AB[1][1], AB[1][2] (Row 1)
    
    li t2, 0              # Reset sum register
    lb t0, 3(x1)          # Load A10
    lb t1, 0(x2)          # Load B00
    mul t0, t0, t1        # A10 * B00
    add t2, t2, t0
    lb t0, 4(x1)
    lb t1, 3(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 5(x1)
    lb t1, 6(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 12(x3)         # Store AB[1][0]

    li t2, 0              # Reset sum register
    lb t0, 3(x1)          # Load A10
    lb t1, 1(x2)          # Load B01
    mul t0, t0, t1        # A10 * B01
    add t2, t2, t0
    lb t0, 4(x1)
    lb t1, 4(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 5(x1)
    lb t1, 7(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 16(x3)         # Store AB[1][1]

    li t2, 0              # Reset sum register
    lb t0, 3(x1)          # Load A10
    lb t1, 2(x2)          # Load B02
    mul t0, t0, t1        # A10 * B02
    add t2, t2, t0
    lb t0, 4(x1)
    lb t1, 5(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 5(x1)
    lb t1, 8(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 20(x3)         # Store AB[1][2]

    # Compute AB[2][0], AB[2][1], AB[2][2] (Row 2)
    
    li t2, 0              # Reset sum register
    lb t0, 6(x1)          # Load A20
    lb t1, 0(x2)          # Load B00
    mul t0, t0, t1        # A20 * B00
    add t2, t2, t0
    lb t0, 7(x1)
    lb t1, 3(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 8(x1)
    lb t1, 6(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 24(x3)         # Store AB[2][0]

    li t2, 0              # Reset sum register
    lb t0, 6(x1)          # Load A20
    lb t1, 1(x2)          # Load B01
    mul t0, t0, t1        # A20 * B01
    add t2, t2, t0
    lb t0, 7(x1)
    lb t1, 4(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 8(x1)
    lb t1, 7(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 28(x3)         # Store AB[2][1]

    li t2, 0              # Reset sum register
    lb t0, 6(x1)          # Load A20
    lb t1, 2(x2)          # Load B02
    mul t0, t0, t1        # A20 * B02
    add t2, t2, t0
    lb t0, 7(x1)
    lb t1, 5(x2)
    mul t0, t0, t1
    add t2, t2, t0
    lb t0, 8(x1)
    lb t1, 8(x2)
    mul t0, t0, t1
    add t2, t2, t0
    sw t2, 32(x3)         # Store AB[2][2]

    ret