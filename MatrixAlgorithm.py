import numpy as np


M = 16
N = 16
P = 16
NUM_CORES = 64


MAT1 = np.random.randint(256, size=(M*N))
MAT2 = np.random.randint(256, size=(N*P))

expected_result = np.matmul(MAT1.reshape(M, N), MAT2.reshape(N, P))
output = np.zeros((M*P), dtype=np.int64)

for core_id in range(NUM_CORES):
    print(f"CORE: {core_id}")

    total_cells = M*P
    cells_per_core = (total_cells // NUM_CORES)
    output_cell = cells_per_core * core_id
    
    column = output_cell
    row = 0
    while column >= P:
        row += 1
        column -= P         

    row_start = row*N
    column_start = column
    mat1_idx = mat2_idx = 0


    # wait here for all AXI data transfer to complete
    for i in range(cells_per_core):
        print(f"\tComputing output cell: {output_cell}\n\tUsing row: {row} starting at memory index: {row_start}\n\tUsing column: {column} starting at memory index: {column_start}")
        sum = 0
        for idx in range(N):
            sum += MAT1[row_start + mat1_idx] * MAT2[column_start + mat2_idx]
            mat1_idx += 1
            mat2_idx += P
        output[output_cell] = sum
        output_cell += 1
        column_start += 1
        if column_start >= P:
            column_start = 0
            row_start += N
        mat1_idx = mat2_idx = 0

output = output.reshape(M,P)

print ("OUTPUT MATCHES EXPECTED RESULT:", np.array_equal(output, expected_result))
