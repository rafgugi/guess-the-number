#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
using namespace std;

#define MAX_M 4096
#define MAX_m 12

/**
 * Print first n bit of a code
 */
void print_codeword(char *code, int n) {
    for (int i = 0; i < n; ++i) {
        putchar(code[i]);
    }
    putchar('\n');
}

int main(int argc, char const *argv[]) {
    int t; // test cases
    int M, e, max_query_allowed; // a test case
    int the_real_M; // trick if M isn't power of 2

    // string code[MAX_m][MAX_M]; // all the codewords
    char **code[MAX_m]; // all the codewords
    bool is_code[MAX_m]; // has the codeword been made?
    int code_distance[MAX_m][MAX_M]; // only distance from 0 to 1..M
    int code_min[MAX_m]; // min distance
    int code_order[MAX_m][MAX_M]; // the best efficient order of code
    int code_order_pointer[MAX_m]; // how many codeword is sorted?
    bool code_order_check[MAX_m][MAX_M]; // is the codeword sorted?
    int code_minimal[MAX_m][MAX_M/2+2]; // param: d needed; return: query

    scanf("%d", &t);
    while (t--) {
        scanf("%d%d%d", &M, &e, &max_query_allowed);
        int d = (2*e + 1); // minimal distance
        the_real_M = M; // save the real M for printing the query

        /* M must be power of two */
        int m = ceil(log2(M)); // log2(M)
        M = pow(2, m); // M is the closest power(2)

        /* initial coding, if hasnt made yet */
        if (!is_code[m]) {
            is_code[m] = 1;
            /* Make a perfect (M-1,M,M/2) binary code */
            code[m] = (char**) malloc(sizeof(char*) * M);
            char ans[M+1];
            for (int i = 1; i < M; ++i) {
                /* binary start from 0 to M */
                for (int j = 0; j < M; ++j) {
                    int bitstring = i & j;
                    short binary = 0;
                    /* counting bit set */
                    for (binary = 0; bitstring; bitstring >>= 1) {
                        binary ^= bitstring & 1;
                    }
                    ans[j] = '0' + binary;
                }
                ans[M] = 0; // close the string
                code[m][i] = strdup(ans);
            }
        }

        /* find the best order */
        while (code_min[m] < d && code_min[m] < M/2) {
            int best = 0; // best candidate
            int best_min = 0; // most
            int best_max = MAX_M; // least
            int best_min_count = MAX_M; // least
            int best_max_count = MAX_M; // least
            /* each loop find the one best code order candidate */
            for (int i = 1; i < M; ++i) {
                int min = MAX_M;
                int max = 0;
                int min_count, max_count;
                if (code_order_check[m][i]) continue; // skip used code
                for (int j = 1; j < M; ++j) { // test the distance
                    int local = code_distance[m][j] + (code[m][i][0] != code[m][i][j]);
                    if (local >= max) {
                        if (local == max) {
                            max_count++;
                        } else {
                            max = local;
                            max_count = 1;
                        }
                    }
                    if (local <= min) {
                        if (local == min) {
                            min_count++;
                        } else {
                            min = local;
                            min_count = 1;
                        }
                    }
                }
                /* save the best */
                if (min > best_min || (min == best_min && min_count < best_min_count)) {
                    best = i;
                    best_min = min;
                    best_max = max;
                    best_min_count = min_count;
                }
            }

            /* update the distance */
            code_min[m] = MAX_M;
            for (int j = 1; j < M; ++j) {
                code_distance[m][j] += (code[m][best][0] != code[m][best][j]);
                if (code_distance[m][j] < code_min[m]) {
                    code_min[m] = code_distance[m][j];
                }
            }

            /* update the code order */
            code_order[m][code_order_pointer[m]++] = best;
            code_order_check[m][best] = 1;
            if (code_minimal[m][code_min[m]] == 0) {
                code_minimal[m][code_min[m]] = code_order_pointer[m];
            }
        }

        /* Debug: show code_minimal *
        for (int i = 1; i < M/2 + 1; ++i) {
            cout << code_minimal[m][i] << "|";
        }
        cout << endl;
        //*/

        /* total query needed */
        int rounds = d / (M / 2);
        int mod = d % (M / 2);
        bool new_algo = code_minimal[m][mod] <= mod * m;
        int total = rounds * (M - 1) + (new_algo ? code_minimal[m][mod] : mod * m);

        printf("%d\t%d\t%s\t", M, e, new_algo? "1" : "0");
        printf("%d\n", total);

        continue; // Debug: skip print the codes
        for (int i = 0; i < rounds; ++i) { // round query
            for (int j = 1; j < M; ++j) {
                print_codeword(code[m][j], the_real_M);
            }
        }
        if (new_algo) {
            for (int i = 0; i < code_minimal[m][mod]; ++i) { // mod query
                print_codeword(code[m][code_order[m][i]], the_real_M);
            }
        } else {
            for (int i = 0; i < mod; ++i) { // old query
                for (int j = 0; j < m; ++j) {
                    print_codeword(code[m][code_order[m][j]], the_real_M);
                }
            }
        }
    }
    int two = 1;
    for (int i = 0; i < MAX_m; ++i, two <<= 1) {
        free(code[i]);
        /* Debug: show the generated code order */
        if (is_code[i]) {
            printf("%d:", two);
            for (int j = 0; j < code_order_pointer[i]; ++j) {
                printf(" %d", code_order[i][j]);
            }
            printf("\n");
        }
    }
    return 0;
}