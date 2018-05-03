#include <cmath>
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

        /* Make a perfect (M-1,M,M/2) binary code */
        for (int i = 1; i < M; ++i) {
            string ans = "";
            int min = 999;
            /* binary start from 0 to M */
            for (int j = 0; j < M; ++j) {
                int g = i;
                int two = j;
                short binary = 0;
                /* convert int g to binary q
                 * same as for q in query */
                for (int k = 0; k < m; k++) {
                    short q = g & 1;
                    g = g >> 1;

                    binary = binary ^ (q & (two & 1));
                    two = two >> 1;
                }
                ans += '0' + binary;

                if (j != 0) { // update distance from the ans[0] view
                    distances[j] += (ans[0] != binary + '0');
                    if (distances[j] < min) {
                        min = distances[j];
                    }
                }
            }
            if (minimal[min] == 0) { // see above
                minimal[min] = i;
            }
            queries.push_back(ans.substr(0, the_real_M)); // only the real M

            if (min >= d) { // if min Hamming distance reaches d, stop
                break;
            }
        }

        /* total query needed */
        int rounds = d / (M / 2);
        int mod = d % (M / 2);
        int total = rounds * (M - 1) + minimal[mod];
        if (total <= max_query_allowed) {
            cout << total << endl;

            for (int i = 0; i < rounds; ++i) { // round query
                for (int j = 0; j < queries.size(); ++j) {
                    cout << queries[j] << endl;
                }
            }
            for (int i = 0; i < minimal[mod]; ++i) { // mod query
                cout << queries[i] << endl;
            }
        } else {
            cout << 0 << endl;
        }
    }
    return 0;
}