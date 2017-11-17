#include <stdio.h>
#include <math.h>

int main(int argc, char const *argv[]) {
    int t; // test cases
    int n, w, m; // a test case
    int q; // query count
    int at_count; // always truth repeater (2w + 1)
    int ceilog2; // ceil(log2(n))

    char s[4097];
    char flag = 0;

    scanf("%d", &t);
    while (t--) {
        scanf("%d%d%d", &n, &w, &m);

        at_count = 2 * w + 1;
        ceilog2 = ceil(log2(n));
        q = at_count * ceilog2;
        printf("%d\n", q);
        for (int i = 0, pow2 = 1; i < ceilog2; ++i, pow2 *= 2) {
            flag = 1;
            int j;
            for (j = 0; j < n; ++j) {
                if (j % pow2 == 0) {
                    flag = !flag; // reverse flag
                }
                s[j] = flag ? '1' : '0';
            }
            s[j] = 0;
            for (int j = 0; j < at_count; ++j) {
                printf("%s\n", s);
            }
        }
    }
    return 0;
}