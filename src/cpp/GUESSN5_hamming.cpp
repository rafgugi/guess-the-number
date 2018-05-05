#include <cmath>
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>

#define MAX_M 4096

using namespace std;

int main(int argc, char const *argv[]) {
    int t; // test cases
    int M, e, max_query_allowed; // a test case
    int m; // log2(M)
    int d; // minimal distance
    int the_real_M; // trick if M isn't power of 2
    vector <string> queries;
    short distances[MAX_M]; // only distance from 0 to 1..M
    short minimal[MAX_M / 2]; // param: d needed; return: query

    cin >> t;
    while (t--) {
        queries.clear(); // Clear the cache
        cin >> M >> e >> max_query_allowed; // variabel m buat coba coba

        the_real_M = M;
        M = pow(2, ceil(log2(M))); // M is the closest power(2)

        m = log2(M);
        d = (2*e + 1);

        /* reset the distances and the minimal */
        for (int i = 0; i < M; ++i) {
            minimal[(i+1)/2] = 0;
            distances[i] = 0;
        }

        /* Make a (m,M,1) binary code */
        for (int i = 1; i < M; i <<= 1) {
            string ans = "";
            int min = 999;
            /* binary start from 0 to M */
            for (int j = 0; j < M; ++j) {
                int bitstring = i & j;
                short binary;
                /* counting bit set */
                for (binary = 0; bitstring; bitstring >>= 1) {
                    binary ^= bitstring & 1;
                }
                ans += '0' + binary;

                if (j != 0) { // update distance from the ans[0] view
                    distances[j] += (ans[0] != ans[j]);
                }
            }
            queries.push_back(ans.substr(0, the_real_M)); // only the real M
        }
        minimal[1] = m;

        /* Make a perfect (M-1,M,M/2) binary code */
        for (int i = M-1; i; --i) {
            if ((i & (i - 1)) == 0) continue; // power of two done above
            string ans = "";
            int min = 999;
            /* binary start from 0 to M */
            for (int j = 0; j < M; ++j) {
                int bitstring = i & j;
                short binary = 0;
                /* counting bit set */
                for (binary = 0; bitstring; bitstring >>= 1) {
                    binary ^= bitstring & 1;
                }
                ans += '0' + binary;

                if (j != 0) { // update distance from the ans[0] view
                    distances[j] += (ans[0] != ans[j]);
                    if (distances[j] < min) {
                        min = distances[j];
                    }
                }
            }
            queries.push_back(ans.substr(0, the_real_M)); // only the real M
            if (minimal[min] == 0) { // see above
                minimal[min] = queries.size();
            }

            if (min >= d) { // if min Hamming distance reaches d, stop
                break;
            }
        }

        /* total query needed */
        int rounds = d / (M / 2);
        int mod = d % (M / 2);
        bool new_algo = minimal[mod] < mod * m;
        int total = rounds * (M - 1) + (new_algo ? minimal[mod] : mod * m);

        cout << total << endl;
        for (int i = 0; i < rounds; ++i) { // round query
            for (int j = 0; j < queries.size(); ++j) {
                cout << queries[j] << endl;
            }
        }
        if (new_algo) {
            for (int i = 0; i < minimal[mod]; ++i) { // mod query
                cout << queries[i] << endl;
            }
        } else {
            for (int i = 0; i < mod; ++i) { // old query
                for (int j = 0; j < m; ++j) {
                    cout << queries[j] << endl;
                }
            }
        }
    }
    return 0;
}