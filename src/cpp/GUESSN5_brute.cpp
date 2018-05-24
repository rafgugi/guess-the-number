#include <cmath>
#include <iostream>
#include <string>
#include <vector>

#define MAX_M 4096
#define MAX_m 12

using namespace std;

int main(int argc, char const *argv[]) {
    int t; // test cases
    int M, e, max_query_allowed; // a test case
    int the_real_M; // trick if M isn't power of 2

    string code[MAX_m][MAX_M]; // all the codewords
    bool is_code[MAX_m]; // has the codeword been made?
    int code_distance[MAX_m][MAX_M]; // only distance from 0 to 1..M
    int code_min[MAX_m]; // min distance
    int code_order[MAX_m][MAX_M]; // the best efficient order of code
    int code_order_pointer[MAX_m]; // how many codeword is sorted?
    bool code_order_check[MAX_m][MAX_M]; // is the codeword sorted?
    int code_minimal[MAX_m][MAX_M/2+2]; // param: d needed; return: query

    cin >> t;
    while (t--) {
        cin >> M >> e >> max_query_allowed;

        the_real_M = M;
        M = pow(2, ceil(log2(M))); // M is the closest power(2)

        int m = log2(M); // log2(M)
        int d = (2*e + 1); // minimal distance

        /* initial coding, if hasnt made yet */
        if (!is_code[m]) {
            is_code[m] = 1;
            /* Make a perfect (M-1,M,M/2) binary code */
            for (int i = 1; i < M; ++i) {
                string ans = "";
                /* binary start from 0 to M */
                for (int j = 0; j < M; ++j) {
                    int bitstring = i & j;
                    short binary = 0;
                    /* counting bit set */
                    for (binary = 0; bitstring; bitstring >>= 1) {
                        binary ^= bitstring & 1;
                    }
                    ans += '0' + binary;
                }
                code[m][i] = ans;
            }

            /* generate initial code order (m,M,1) */
            int two = 1; // power of two
            for (int i = 0; i < m; ++i, two <<= 1) {
                code_order[m][code_order_pointer[m]++] = two;
                code_order_check[m][two] = 1;
                for (int j = 1; j < M; ++j) { // update the distances
                    code_distance[m][j] += (code[m][two][0] != code[m][two][j]);
                }
            }
            code_min[m] = 1;
            code_minimal[m][1] = code_order_pointer[m];
        }

        /* find the best order */
        while (code_min[m] < d && code_min[m] < M/2) {
            int best = 0;
            int delta = MAX_M;
            /* each loop find the one best code order candidate */
            for (int i = 1; i < M; ++i) {
                int min = MAX_M;
                int max = 0;
                if (code_order_check[m][i]) continue;
                for (int j = 1; j < M; ++j) { // test the distance
                    int local = code_distance[m][j] + (code[m][i][0] != code[m][i][j]);
                    if (local > max) max = local;
                    if (local < min) min = local;
                }
                if (max - min < delta) { // save the best
                    best = i;
                    delta = max - min;
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

        /* Debug code_minimal *
        for (int i = 1; i < M/2 + 1; ++i) {
            cout << code_minimal[m][i] << "|";
        }
        cout << endl;
        //*/

        /* total query needed */
        int rounds = d / (M / 2);
        int mod = d % (M / 2);
        bool new_algo = code_minimal[m][mod] < mod * m;
        int total = rounds * (M - 1) + (new_algo ? code_minimal[m][mod] : mod * m);

        // cout << (new_algo? "true " : "false ");
        cout << total << endl;

        for (int i = 0; i < rounds; ++i) { // round query
            for (int j = 1; j < M; ++j) {
                cout << code[m][j].substr(0, the_real_M) << endl;
            }
        }
        if (new_algo) {
            for (int i = 0; i < code_minimal[m][mod]; ++i) { // mod query
                cout << code[m][code_order[m][i]].substr(0, the_real_M) << endl;
            }
        } else {
            for (int i = 0; i < mod; ++i) { // old query
                for (int j = 0; j < m; ++j) {
                    cout << code[m][code_order[m][j]].substr(0, the_real_M) << endl;
                }
            }
        }
    }
    return 0;
}