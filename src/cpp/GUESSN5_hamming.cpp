#include <cmath>
#include <iostream>
#include <map>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char const *argv[]) {
    int t; // test cases
    int M, e, q; // a test case
    int max, min;

    string s;
    char flag = 0;
    vector <string> queries;
    map <int, int> distances[4096];
    map <char, int> counter;

    // scanf("%d", &t);
    cin >> t;
    while (t--) {
        /* Clear the cache */
        queries.clear();
        //*/
        // scanf("%d%d%d", &n, &w, &m);
        cin >> M >> e;

        for (int i = 0; i < M; ++i) {
            for (int j = i+1; j < M; ++j) {
                distances[i][j] = 0;
            }
        }

        /* Generate the initial binary */
        // int ceilog2 = ceil(log2(n));
        // for (int i = 0, pow2 = 1; i < ceilog2; ++i, pow2 *= 2) {
        //     s = "";
        //     flag = 1;
        //     int j;
        //     for (j = 0; j < n; ++j) {
        //         if (j % pow2 == 0) {
        //             flag = !flag; // reverse flag
        //         }
        //         s += flag + '0';
        //     }
        // }
        if (queries.empty()) {
            s = "";
            for (int i = 0; i < M; ++i) {
                s += '0' + (i >= M/2);
            }
            queries.push_back(s);
        }

        while (1) {
            /* update the distance based on query */
            max = -1;
            min = 1000;
            for (int i = 0; i < M; ++i) {
                for (int j = i+1; j < M; ++j) {
                    distances[i][j] += (s[i] != s[j]);
                    if (distances[i][j] < min) {
                        min = distances[i][j];
                    }
                    if (distances[i][j] > max) {
                        max = distances[i][j];
                    }
                }
            }
            cout << s << endl;
            queries.push_back(s);

            if (min >= 2*e + 1) {
                break;
            }

            /* generate query */
            s = "0";
            for (int i = 1; i < M; ++i) {
                s += "x";
            }
            counter['0'] = 1;
            counter['1'] = 0;
            for (int i = 0; i < M; ++i) {
                for (int j = i+1; j < M; ++j) {
                    cout << s << endl;
                    if (distances[i][j] == min) { // brarti dibedain
                        if (s[i] != 'x') {
                            s[j] = s[i] == '0' ? '1' : '0';
                            counter[s[j]]++;
                        } else if (s[j] != 'x') {
                            s[i] = s[j] == '0' ? '1' : '0';
                            counter[s[i]]++;
                        }
                    } else if (distances[i][j] == max) { // brarti disamain
                        if (s[i] != 'x') {
                            s[j] = s[i] == '1' ? '1' : '0';
                            counter[s[j]]++;
                        } else if (s[j] != 'x') {
                            s[i] = s[j] == '1' ? '1' : '0';
                            counter[s[i]]++;
                        }
                    }
                    if (counter['0'] > M/2 || counter['1'] > M/2) { // ini harusnya pake >=, tapi jadinya loop forever
                        break;
                    }
                }
                if (counter['0'] > M/2 || counter['1'] > M/2) { // ini harusnya pake >=, tapi jadinya loop forever
                    break;
                }
            }

            /* Fill the rest x with the loser */
            cout << s << ": ";
            char filler = counter['0'] > counter['1'] ? '1' : '0';
            for (int i = 0; i < M; ++i) {
                if (s[i] == 'x') {
                    s[i] = filler;
                }
            }
        }

        cout << queries.size() << endl;
        for (int i = 0; i < queries.size(); ++i) {
            // cout << queries[i] << endl;
        }

    }
    return 0;
}