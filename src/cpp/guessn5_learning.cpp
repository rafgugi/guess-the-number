#include <algorithm>
#include <cmath>
#include <cstdlib>
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>

#define MAX_M 4096
using namespace std;

int main(int argc, char const *argv[]) {
    int M, e, max_query_allowed; // a test case
    int d; // minimal distance
    int the_real_M; // trick if M isn't power of 2
    vector <string> queries;
    short distances[MAX_M]; // only distance from 0 to 1..M
    short minimal[MAX_M / 2 + 1]; // param: d needed; return: query
    vector <int> permutation;

    M = atoi(argv[1]);
    int threshold = atoi(argv[2]);

    // cin >> M; // >> e >> max_query_allowed; // variabel m buat coba coba
    int m = log2(M);

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
        queries.push_back(ans); // only the real M
        permutation.push_back(i);
    }
    // random_shuffle(permutation.begin(), permutation.end());

    do {
        /* reset the distances and the minimal */
        for (int i = 0; i < M; ++i) {
            if (i <= M/2) {
                minimal[i] = 0;
            }
            distances[i] = 0;
        }

        bool thresholding = true;
        /* Min */
        for (int i = 1; i < M; ++i) {
            string ans = queries[permutation[i-1] - 1];
            int min = 999;
            /* update distance from the ans[0] view */
            for (int j = 1; j < M; ++j) {
                distances[j] += (ans[0] != ans[j]);
                if (distances[j] < min) {
                    min = distances[j];
                }
            }
            if (minimal[min] == 0) { // see above
                minimal[min] = i;
                if (min != 0) {
                    if (minimal[min] - minimal[min - 1] > threshold) {
                        thresholding = false;
                        break;
                    }
                }
            }
        }
        if (!thresholding) {
            continue;
        }

        cout << minimal[0];
        for (int i = 1; i <= M / 2; ++i) {
            cout << "," << minimal[i];
        }
        cout << ": " << permutation[0];
        for (int i = 1; i < permutation.size(); ++i) {
            cout << "," << permutation[i];
        }
        cout << endl;
    } while (next_permutation(permutation.begin(), permutation.end()));
    return 0;
}
