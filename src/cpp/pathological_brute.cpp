#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *buf;
char **variation;
long long counter = 0;

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
        // printf("%s\n", buf);
        variation[counter] = strdup(buf);
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

/* permutasi */
long long p(int m, int n) {
    long long p = 1;
    while (n--) {
        p *= m--;
    }
    return p;
}

/* kombinasi */
long long c(int m, int n) {
    if (n > m) {
        return 0;
    } else if (n > m / 2) {
        return c(m, m - n);
    } else {
        return p(m, n) / p(n, n);
    }
}

/* denominator adalah c(q, <=k) */
long long denominator(int q, int k) {
    long long p = 0;
    for (int i = 0; i < k; ++i) {
        p += c(q, i);
    }
    return p;
}

/* fungsi berlekamp */
long long berlekamp(int vector[], int question_left, int max_lies) {
    long long weight = 0;
    for (int i = 0; i < max_lies; ++i) {
        int x = vector[i];
        weight += x * denominator(question_left, max_lies - i);
    }
    return weight;
}

int main(int argc, char const *argv[]) {
    int n, k, m; // a test case

    int s[17]; // set channel of lies
    int temp_s[17]; // temporary set channel of lies
    int channel[4096]; // what is x channel now?
    char* query; // query
    char answer; // answer of query
    int q;
    long long b, old_b; // berlekamp weight
    double pow2; // 2 ^ q
    double fk; // function fk

    printf("Masukkan <n> <k> <q>,\n");
    printf("lalu sebanyak q, masukkan <query> <answer>\n");
    scanf("%d%d%d", &n, &k, &q);
    m = q;

    /* initiate the variation */
    long long vary = c(n, n / 2) / 2;
    if (n % 2) {
        vary += c(n-1, n / 2 + 1);
    }
    variation = (char**) malloc(sizeof(char**) * vary);
    buf = (char*) malloc(n + 1);
    int jumlah_c = n / 2;
    print_combinations(buf, n, jumlah_c);
    if (n % 2 == 1) {
        buf[0] = 0;
        jumlah_c = n / 2 + 1;
        print_combinations(buf, n, jumlah_c);
    }

    /* Print the variation */
    for (int i = 0; i < vary; ++i) {
        puts(variation[i]);
    }

    /* initiate s */
    s[0] = n;
    for (int i = 1; i < k; ++i) {
        s[i] = 0;
    }

    /* what is x channel now? */
    for (int i = 0; i < n; ++i) {
        channel[0] = 0;
    }

    b = berlekamp(s, q, k);
    pow2 = pow(2, q);
    fk = pow2 / denominator(q, k);
    printf("berlekamp weight = %lld\n", b);
    printf("2^%-2d             = %.0lf\n", q, pow2);
    printf("Fk*(q)           = %.2lf\n", fk);
    printf("x: ");
    for (int j = 0; j < k; ++j) {
        printf("(%d) ", s[j]);
    }
    printf("\n");

    for (int i = 0; i < m; ++i) {
        printf("---------------------------------------------\n");

        /* Brute force query */
        answer = 1;
        old_b = b;
        long long temp_b = b;
        for (int v = 0; v < vary; ++v) {
            puts(variation[v]);

            /* init the vector */
            printf("init the vector\n");
            for (int j = 0; j <= k; ++j) {
                s[j] = 0;
            }

            /* make a vector state */
            printf("make a vector state\n");
            printf(" . ");
            printf("%d", n);
            for (int j = 0; j < n; ++j) {
                printf(".");
                int lie = (query[j] != answer);
                printf("%d\n", lie);
                printf("%d\n", channel[j]);
                if (channel[j] + lie <= k) {
                    s[channel[j] + lie]++;
                }
            }

            /* compare the berlekamp */
            printf("compare the berlekamp\n");
            b = berlekamp(s, q, k);
            long long selisih = abs(2 * b - old_b);
            if (selisih < temp_b) {
                temp_b = selisih;
                query = variation[v];
            }
            if (temp_b == 0) {
                break;
            }
            //*/
        }

        printf("(%d) query & answer: %s %c\n", q, query, answer);
        q--;

        /* process the channel */
        for (int j = 0; j < n; ++j) {
            int lie = (query[j] != answer);
            if (lie) {
                s[channel[j]]--;
                channel[j]++;
                if (channel[j] <= k) {
                    s[channel[j]]++;
                }
            }
        }

        old_b = b;
        b = berlekamp(s, q, k);
        pow2 = pow(2, q);
        fk = pow2 / denominator(q, k);
        printf("berlekamp weight = %lld\n", b);
        printf("2^%-2d             = %.0lf\n", q, pow2);
        printf("Delta(x,a)       = %lld\n", 2 * b - old_b);
        printf("Fk*(q)           = %.2lf\n", fk);

        printf("x: ");
        for (int j = 0; j < k; ++j) {
            printf("(%d) ", s[j]);
        }
        printf("\n");

        printf("status kebohongan setiap angka:\n  ");
        for (int j = 0; j < n; ++j) {
            printf("%d:(%d) ", j+1, channel[j]);
        }
        printf("\n");
    }

    return 0;
}