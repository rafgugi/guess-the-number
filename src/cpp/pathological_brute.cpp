#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *buf;
char **variation;
long long counter = 0;

// Print combinations of m 1's in a field of n 0/1's starting at s.
void make_combinations(char *s, int n, int m) {
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
    make_combinations(s + 1, n - 1, m);
    // Now do the same with 1.
    *s = '1';
    make_combinations(s + 1, n - 1, m - 1);
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

    int isBrute = 0;
    int v; // how many turn to brute force?

    printf("Masukkan <n> <k> <q>,\n");
    scanf("%d%d%d", &n, &k, &q);
    printf("n\t%d\nk\t%d\nq\t%d\n", n, k, q);
    m = q;
    query = (char*) malloc(sizeof(char) * n);

    /* initiate the variation */
    long long vary = c(n, n / 2) / 2;
    if (n % 2) {
        vary += c(n-1, n / 2 + 1);
    }
    variation = (char**) malloc(sizeof(char**) * vary);
    buf = (char*) malloc(n + 1);
    int jumlah_c = n / 2;
    make_combinations(buf, n, jumlah_c);
    if (n % 2 == 1) {
        buf[0] = 0;
        jumlah_c = n / 2 + 1;
        make_combinations(buf, n, jumlah_c);
    }
    printf("make %lld combinations (%lld)\n", vary, counter);

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
    printf("q\tquery\tanswer\tvector\tberlekamp\tdelta(x,a)\t2^q\tFk*(q)\tbrute\tisBrute\n");
    printf("%d\t-\t-\t", q);
    printf("{");
    for (int j = 0; j < k; ++j) {
        printf("%d, ", s[j]);
    }
    printf("%d}\t", s[k]);
    /* berlekamp weight */
    printf("%lld\t0\t", b);
    /* 2^%-2d */
    printf("%.0lf\t", pow2);
    /* Fk*(q)*/
    printf("%.2lf\n", fk);

    for (int i = 0; i < m; ++i) {
        q--;

        if (!isBrute) {
            scanf("%d", &isBrute);
        }

        if (isBrute) {
            /* Brute force query */
            query = NULL; // no longer needed to malloc
            answer = '1';
            old_b = b;
            long long temp_b = b;
            for (v = 0; v < vary; ++v) {
                /* init the vector */
                for (int j = 0; j <= k; ++j) {
                    s[j] = 0;
                }

                /* make a vector state */
                for (int j = 0; j < n; ++j) {
                    int lie = (variation[v][j] != answer);
                    if (channel[j] + lie <= k) {
                        s[channel[j] + lie]++;
                    }
                }

                /* compare the berlekamp */
                b = berlekamp(s, q, k);
                long long selisih = 2 * b - old_b;
                if (abs(selisih) < abs(temp_b)) {
                    temp_b = selisih;
                    query = variation[v];
                }

                /* klo selisihnya 0 pasti go */
                if (temp_b == 0) {
                    break;
                }
                //*/
            }

            if (temp_b < 0) {
                answer = '0';
            }
            /* end of bruteforce */
            //*/
        } else {
            v = -1;
            scanf("%s %c\n", query, &answer);
        }

        printf("%d\t'%s\t%c\t", q, query, answer);

        /* init the vector */
        // printf("init the vector\n");
        for (int j = 0; j <= k; ++j) {
            s[j] = 0;
        }

        /* make a vector state */
        // printf("make a vector state\n");
        for (int j = 0; j < n; ++j) {
            int lie = (query[j] != answer);
            channel[j] += lie;
            if (channel[j] <= k) {
                s[channel[j]]++;
            }
        }

        printf("{");
        int vector_counter = 0;
        for (int j = 0; j < k; ++j) {
            printf("%d, ", s[j]);
            vector_counter += s[j];
        }
        printf("%d}\t", s[k]);
        vector_counter += s[k];

        b = berlekamp(s, q, k);
        pow2 = pow(2, q);
        fk = pow2 / denominator(q, k);
        printf("%lld\t", b);
        printf("%lld\t", 2 * b - old_b);
        printf("%.0lf\t", pow2);
        printf("%.2lf\t", fk);
        printf("%d\t", v);
        printf("%d\t", isBrute);

        // printf("status kebohongan setiap angka:\n  ");
        // for (int j = 0; j < n; ++j) {
        //     printf("%d:(%d) ", j+1, channel[j]);
        // }
        printf("\n");

        old_b = b;
        if (vector_counter <= 1) {
            break;
        }
    }
    printf("done in %d rounds.\n", m - q);

    return 0;
}