#include <stdio.h>
#include <stdlib.h>
#include <math.h>

char *buf;
long long counter;

// Print combinations of m 1's in a field of n 0/1's starting at s.
void print_combinations(char *s, int n, int m)
{
    /* I want only half variation of combinations */
    if (buf[0] == '1') {
        return;
    }

    *s = '\0';
    // If there is nothing left to append, we are done. Print the buffer.
    if (m == 0 && n == 0) {
        *s = '\0';
        printf("%s\n", buf);
        counter++;
        return;
    }
    // Cut if there are more 1's than positions left or negative numbers.
    if (m > n || m < 0 || n < 0){
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
    scanf("%d", &n);
    buf = (char*) malloc(n + 1);
    int jumlah_c = n / 2;
    print_combinations(buf, n, jumlah_c);
    if (n % 2 == 1) {
        buf[0] = 0;
        jumlah_c = n / 2 + 1;
        print_combinations(buf, n, jumlah_c);
    }
    printf("-----\n");
    printf("%lld\n", counter);
    return 0;
}