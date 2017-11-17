#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

char *buf;
int now = 0;
char query_variation[900][4097];

// Print combinations of m 1's in a field of n 0/1's starting at s.
void print_combinations(char *s, int n, int m)
{
    // If there is nothing left to append, we are done.  Print the buffer.
    if (m == 0 && n == 0) {
        *s = '\0';
        // printf("%s\n", buf);
        strcpy(query_variation[now++], buf);
        return;
    }
    // Cut if there are more 1's than positions left or negative numbers.
    if (m > n || m < 0 || n < 0) {
        return;
    }
    // Append a 0 and recur to print the rest.
    *s = '0';
    print_combinations(s + 1, n - 1, m);
    // Now do the same with 1.
    *s = '1';
    print_combinations(s + 1, n - 1, m - 1);
}

int main(int argc, char const *argv[]) {
    int n, w, m; // range, lies, query

    char s[4097];
    int channel[4097];
    char query[396][4097];
    int answers; // answer variation
    int binary;

    scanf("%d%d", &n, &w);
    buf = (char*) malloc(n + 1);
    print_combinations(buf, n, n/2);

    answers = 1 << m;
    printf("%d\n", answers);
    for (int i = 0; i <= now; ++i) {
        printf("%s\n", query_variation[i]);
    }

    int gagal = 0;
    
    return 0;
}