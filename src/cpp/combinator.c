#include <stdio.h>
#include <stdlib.h>

char *buf;

// Print combinations of m 1's in a field of n 0/1's starting at s.
void print_combinations(char *s, int n, int m)
{
    *s = '\0';
    printf("%d %d: %s\n", n, m, buf);
    // If there is nothing left to append, we are done.  Print the buffer.
    if (m == 0 && n == 0) {
        *s = '\0';
        printf("%s\n", buf);
        return;
    }
    // Cut if there are more 1's than positions left or negative numbers.
    if (m > n || m < 0 || n < 0){
        printf("must return\n");
        return;
    }
    // Append a 0 and recur to print the rest.
    *s = '0';
    print_combinations(s + 1, n - 1, m);
    // Now do the same with 1.
    *s = '1';
    print_combinations(s + 1, n - 1, m - 1);
}

int main(void)
{  
    int n = 4;
    buf = (char*) malloc(n + 1);
    int m = n/2;
    print_combinations(buf, n, m);
    printf("-----\n");
    return 0;
}