#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <sys/syscall.h>  // Include this if your system has syscall support
#include <unistd.h>
#include <string.h>

#define SYSCALL_NUM 454

// Function prototypes
void baseline_matrix_mult(int n, int *a, int *b, int *result);
void syscall_matrix_mult(int n, int *a, int *b, int *result);
void generate_random_matrix(int n, int *matrix);
bool compare_matrices(int n, int *m1, int *m2);
double time_function(void (*func)(int, int *, int *, int *), int n, int *a, int *b, int *result);
void flush_cache(void *p, size_t len);

int main() {
    srand(time(NULL));  // Seed for random number generation

    int sizes[] = {4, 8, 16, 32};
    int num_sizes = sizeof(sizes) / sizeof(sizes[0]);

    for (int i = 0; i < num_sizes; ++i) {
        int n = sizes[i];
        // Allocate memory for matrices
        int *a = malloc(n * n * sizeof(int));
        int *b = malloc(n * n * sizeof(int));
        int *result_baseline = malloc(n * n * sizeof(int));
        int *result_syscall = malloc(n * n * sizeof(int));

        // Generate random matrices
        generate_random_matrix(n, a);
        generate_random_matrix(n, b);

        // Time the baseline implementation
        double baseline_time = time_function(baseline_matrix_mult, n, a, b, result_baseline);

        // Time the syscall implementation
        double syscall_time = time_function(syscall_matrix_mult, n, a, b, result_syscall);
        //double syscall_time = time_function(baseline_matrix_mult, n, a, b, result_syscall);


        // Compare the results
        bool are_equal = compare_matrices(n, result_baseline, result_syscall);

        printf("Matrix size: %dx%d\n", n, n);
        printf("Baseline time: %.3f ms\n", baseline_time);
        printf("Syscall time: %.3f ms\n", syscall_time);
        printf("Results are %s\n\n", are_equal ? "equal" : "not equal");

        // Free allocated memory
        free(a);
        free(b);
        free(result_baseline);
        free(result_syscall);
    }

    return 0;
}

void baseline_matrix_mult(int n, int *a, int *b, int *result) {
    memset(result, 0, n * n * sizeof(int));
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            for (int k = 0; k < n; ++k) {
                result[i * n + j] += a[i * n + k] * b[k * n + j];
            }
        }
    }
}

// Replace the following stub with the actual syscall
void syscall_matrix_mult(int n, int *a, int *b, int *result) {
    // Assuming syscall number is 333 and it takes n, a, b, and result as parameters
    syscall(SYSCALL_NUM, n, a, b, result);
}

void generate_random_matrix(int n, int *matrix) {
    for (int i = 0; i < n * n; ++i) {
        matrix[i] = rand() % 10;  // Random number between 0 and 9
    }
}

bool compare_matrices(int n, int *m1, int *m2) {
    for (int i = 0; i < n * n; ++i) {
        if (m1[i] != m2[i]) {
            return false;
        }
    }
    return true;
}

double time_function(void (*func)(int, int *, int *, int *), int n, int *a, int *b, int *result) {
    clock_t start, end;
    start = clock();
    func(n, a, b, result);
    end = clock();
    return (double)((end - start) * 1000) / CLOCKS_PER_SEC;
}

void flush_cache(void *p, size_t len) {
    const size_t cache_line_size = 64;
    char *cp = (char *)p;
    for (size_t i = 0; i < len; i += cache_line_size) {
        asm volatile("clflush (%0)" :: "r"(cp + i));
    }
    asm volatile("mfence");
}
