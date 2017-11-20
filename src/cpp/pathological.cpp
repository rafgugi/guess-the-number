#include <stdio.h>
#include <math.h>

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
    int c[4096]; // what is x channel now?
    char query[4097]; // query
    char answer; // answer of query
    int q;
    long long b, old_b; // berlekamp weight
    double pow2; // 2 ^ q
    double fk; // function fk

    printf("Masukkan <n> <k> <q>,\n");
    printf("lalu sebanyak q, masukkan <query> <answer>\n");
    scanf("%d%d%d", &n, &k, &q);
    m = q;

    /* initiate s */
    s[0] = n;
    for (int i = 1; i < k; ++i) {
        s[i] = 0;
    }

    /* what is x channel now? */
    for (int i = 0; i < n; ++i) {
        c[0] = 0;
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
        scanf("%s %c", query, &answer);
        printf("(%d) query & answer: %s %c\n", q, query, answer);
        q--;

        /* process the channel */
        for (int j = 0; j < n; ++j) {
            int lie = (query[j] != answer);
            if (lie) {
                s[c[j]]--;
                c[j]++;
                if (c[j] <= k) {
                    s[c[j]]++;
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
            printf("%d:(%d) ", j+1, c[j]);
        }
        printf("\n");
    }

    return 0;
}