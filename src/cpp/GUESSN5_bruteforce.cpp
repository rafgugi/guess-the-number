#include <stdio.h>
#include <math.h>

/*
Cobak bikin n=8, w=3. ngitungnya gini.
*/

int main(int argc, char const *argv[]) {
    int n, w, m; // range, lies, query

    char s[4097];
    int channel[4097];
    char query[396][4097];
    int answers; // answer variation
    int binary;

    scanf("%d%d%d", &n, &w, &m);
    answers = 1 << m;
    printf("%d\n", answers);
    for (int i = 0; i < m; ++i) {
        scanf("%s", query[i]);
    }

    int gagal = 0;
    for (int i = 0; i < answers; ++i) {
        binary = i;

        // reset channel
        for (int k = 0; k < n; ++k) {
            channel[k] = 0;
        }

        // iterasi tiap query
        for (int j = 0; j < m; ++j) {
            int answer = binary & 1;
            // printf("%d", answer);

            binary = binary >> 1;
            for (int k = 0; k < n; ++k) {
                channel[k] += (query[j][k] - '0') ^ answer;
            }
        }
        // printf(": ");

        /* ngecek lagi */
        gagal = 0;
        for (int k = 0; k < n; ++k) {
            if (channel[k] <= w) {
                gagal += 1;
            }
            // printf("%d", channel[k]);
        }
        // printf("\n");
        if (gagal > 1) {
            break;
        }
    }
    if (gagal > 1) {
        printf("GAGAL\n");
    } else {
        printf("BERHASIL\n");
    }
    return 0;
}