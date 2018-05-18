#include <stdio.h>
#include <math.h>

int main(int argc, char const *argv[]) {
    int t, n, w, m; // a test case
    int q, qe, qb;

    char s[4097];

    scanf("%d", &t);
    while (t--) {
        scanf("%d%d%d", &n, &w, &m);

        qe = 2 * w + 1; // repeater
        qb = ceil(log2(n)); // closest power of 2
        q = qe * qb; // query count
        printf("%d\n", q);
        for (int i = 0, pow2 = 1; i < qb; ++i, pow2 <<= 1) {
            for (int j = 0; j < n; ++j) {
                s[j] = j & pow2 ? '1' : '0';
            }
            s[n] = 0;
            for (int j = 0; j < qe; ++j) {
                printf("%s\n", s);
            }
        }
    }
    return 0;
}