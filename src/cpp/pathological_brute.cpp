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

int is_equal(int vector1[], int vector2[], int n) {
    for (int i = 0; i < n; ++i) {
        if (vector1[i] != vector2[i]) {
            return 0;
        }
    }
    return 1;
}

void copy_vector(int src[], int dst[], int n) {
    for (int i = 0; i < n; ++i) {
        dst[i] = src[i];
    }
}

void print_vector(int vector[], int k) {
    printf("{");
    for (int i = 0; i < k; ++i) {
        printf("%d,", vector[i]);
    }
    printf("%d}", vector[k]);
}

int main(int argc, char const *argv[]) {
    int n, k, m; // a test case

    int s[17]; // set channel of lies
    int temp_s[17]; // temporary set channel of lies
    int channel[4096]; // what is x channel now?
    char *query; // query
    char answer; // answer of query
    int q;
    long long b, old_b; // berlekamp weight
    double pow2; // 2 ^ q
    double fk; // function fk

    int isBrute = 0;
    int v; // how many turn to brute force?
    int same_b_counter; // how many query has the same berlekamp value
    char **same_b_query;

    int **possible_vector;
    int possible_vector_counter;

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

    /* prepare same b query */
    same_b_query = (char**) malloc(sizeof(char**) * vary);

    /* prepare possible vector */
    possible_vector_counter = c(k + n, k);
    possible_vector = (int**) malloc(sizeof(int**) * possible_vector_counter);
    for (int i = 0; i < possible_vector_counter; ++i) {
        possible_vector[i] = (int*) malloc(sizeof(int*) * k + 1);
    }

    int jumlah_c = n / 2;
    make_combinations(buf, n, jumlah_c);
    if (n % 2 == 1) {
        buf[0] = 0;
        jumlah_c = n / 2 + 1;
        make_combinations(buf, n, jumlah_c); // ditambah jumlah c yang + 1
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

    old_b = b = berlekamp(s, q, k);
    pow2 = pow(2, q);
    fk = pow2 / denominator(q, k);
    printf("q\tquery\tanswer\tvector\tberlekamp\tdelta(x,a)\t");
    printf("2^q\tFk*(q)\tisBrute\tsame berlekamp\n");
    printf("%d\t-\t-\t", q);
    print_vector(s, k);
    printf("\t");
    /* berlekamp weight */
    printf("%lld\t-\t", b);
    /* 2^%-2d */
    printf("%.0lf\t", pow2);
    /* Fk*(q)*/
    printf("%.2lf\n", fk);

    // start the game
    for (int i = 0; i < m; ++i) {
        q--;

        if (!isBrute) {
            scanf("%d", &isBrute);
        }

        same_b_counter = 0;
        possible_vector_counter = 0;
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

                    same_b_query[0] = variation[v];
                    same_b_counter = 1;

                    copy_vector(s, possible_vector[0], k);
                    possible_vector_counter = 1;
                } else if (abs(selisih) == abs(temp_b)) {
                    same_b_query[same_b_counter] = variation[v];
                    same_b_counter++;

                    int sudah_ada = 0;
                    for (int j = 0; j < possible_vector_counter; ++j) {
                        if (is_equal(s, possible_vector[j], k)) {
                            sudah_ada = 1;
                            break;
                        }
                    }
                    if (!sudah_ada) {
                        copy_vector(s, possible_vector[possible_vector_counter], k);
                        possible_vector_counter++;
                    } else {
                    }
                }

                /* klo selisihnya 0 pasti go *
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
                //
            }
        }

        int vector_counter = 0;
        for (int j = 0; j <= k; ++j) {
            vector_counter += s[j];
        }
        print_vector(s, k);
        printf("\t");

        b = berlekamp(s, q, k);
        pow2 = pow(2, q);
        fk = pow2 / denominator(q, k);
        printf("%lld\t", b);
        printf("%lld\t", 2 * b - old_b);
        printf("%.0lf\t", pow2);
        printf("%.2lf\t", fk);
        printf("%d\t", isBrute);
        printf("%d\t", same_b_counter);

        /*
        if (same_b_counter == vary) {
            printf("[all]");
        } else {
            printf("[%s", same_b_query[0]);
            for (int j = 1; j < same_b_counter; ++j) {
                printf(",%s", same_b_query[j]);
            }
            printf("]");
        }
        //*/

        for (int j = 0; j < possible_vector_counter; ++j) {
            print_vector(possible_vector[j], k);
        }

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