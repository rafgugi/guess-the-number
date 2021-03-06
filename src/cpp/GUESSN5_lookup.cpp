#include <cmath>
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

#define MAX_M 4096
#define MAX_QUERY 86

int main(int argc, char const *argv[]) {
    int t; // test cases
    int M, e, max_query_allowed; // a test case
    int the_real_M; // trick if M isn't power of 2
    string queries[MAX_QUERY];
    short distances[MAX_M]; // only distance from 0 to 1..M
    short minimal[MAX_M / 2 + 1]; // param: d needed; return: query

    const int code_order[][MAX_QUERY] = {
        /* 0  */ {},
        /* 1  */ {1},
        /* 2  */ {1,2,3},
        /* 3  */ {1,2,4,7,3,5,6},
        /* 4  */ {1,2,4,8,15,3,5,9,14,6,10,13,7,11,12},
        /* 5  */ {1,2,4,8,16,31,7,9,19,29,10,22,12,15,17,18,20,21,24,27,30,3,5,14,25,6,11,28,13,23,26},
        /* 6  */ {1,2,4,8,16,32,63,7,25,42,52,13,22,35,56,14,19,37,11,48,28,53,26,33,31,45,54,34,5,43,50,12,59,36,3,29,10,51,20,58,6,40,15,17,44,21,55,62,24,41,49,23,30,57,38,47,61,9,18,46,27,39,60},
        /* 7  */ {1,2,4,8,16,32,64,127,15,51,85,105,27,45,71,113,58,86,29,99,38,3,65,88,46,55,74,80,117,60,12,43,67,30,100,57,81,96,5,76,59,114,23,94,41,110,6,77,49,122,37,89,52,9,82,22,121,91,61,31,112,21,97,102,107,73,14,125,18,104,19,44},
        /* 8  */ {1,2,4,8,16,32,64,128,255,15,51,85,150,232,45,78,139,116,178,192,238,23,217,103,10,225,66,123,144,188,52,185,28,3,208,106,141,18,167,65,230,33,59,237,206,26,95,170,148,98,221,216,124,17,181,24,196,61,5,76,190,195,36,69,182,199,40,89,171,75,35,189,218,68,47,176},
        /* 9  */ {1,2,4,8,16,32,64,128,256,511,31,99,165,302,470,203,344,146,288,85,153,34,460,435,283,109,113,406,220,293,25,448,164,382,43,7,502,363,138,230,295,415,119,355,139,410,79,19,269,192,418,53,343,472,217,3,490,35,123,26,140,458,260,244,358,427,150,66,298,272,120,445,44,205,464,162,361,94,504},
        /* 10 */ {1,2,4,8,16,32,64,128,256,512,1023,31,227,293,622,950,184,338,907,608,213,377,972,544,174,521,11,17,262,1019,660,115,292,419,838,239,60,569,484,597,769,977,173,665,432,42,210,860,364,550,925,90,530,487,307,710,737,347,824,130,764,276,403,635,652,251,282,470,699,629,37,45,795,874,171,81,363,758,970,303,439},
        /* 11 */ {1,2,4,8,16,32,64,128,256,512,1024,2047,63,455,585,1242,1899,238,373,583,1798,1181,419,692,1476,1684,1110,665,97,477,1907,637,1517,364,456,1844,1489,547,1093,951,283,1140,628,1362,1819,1016,377,1982,109,123,780,1172,1600,2019,491,814,1889,996,722,39,77,1351,696,1166,1148,641,1405,89,1500,1547,910,1782,167,9,443,1450,1368,643,49,1038,1614,625,190,849},
        /* 12 */ {1,2,4,8,16,32,64,128,256,512,1024,2048,4095,63,455,1609,2707,3362,1267,996,2125,3914,1624,238,2575,883,4058,978,124,1302,2094,3442,969,2832,1670,282,3233,2282,1991,907,3365,387,3663,336,1134,2489,712,1446,2169,140,3268,407,1760,285,3843,2302,1381,2121,91,4031,863,3806,521,1056,2336,799,2471,182,1032,4053,2603,994,3845,1887,685,1170,2095,2584,1701,3422,916,3424,263,2221,1091,1078},
    };

    cin >> t;
    while (t--) {
        cin >> M >> e >> max_query_allowed;

        the_real_M = M;
        M = pow(2, ceil(log2(M))); // M is the closest power(2)

        int m = log2(M); // log2(M)
        int d = (2*e + 1); // minimal distance

        /* reset the distances and the minimal */
        for (int i = 0; i < M; ++i) {
            minimal[(i+1)/2] = 0;
            distances[i] = 0;
        }

        /* Make a perfect (M-1,M,M/2) binary code */
        for (int i = 0, min = 0; i < M-1 && min < d; ++i) {
            string ans = "";
            min = 999;
            /* binary start from 0 to M */
            for (int j = 0; j < M; ++j) {
                int bitstring = code_order[m][i] & j;
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
            queries[i] = ans.substr(0, the_real_M); // only the real M
            if (minimal[min] == 0) { // see above
                minimal[min] = i+1;
            }
        }

        /* total query needed */
        int rounds = d / (M / 2);
        int mod = d % (M / 2);
        int total = rounds * (M - 1) + minimal[mod];

        cout << total << endl;
        for (int i = 0; i < rounds; ++i) { // round query
            for (int j = 0; j < M-1; ++j) {
                cout << queries[j] << endl;
            }
        }
        for (int i = 0; i < minimal[mod]; ++i) { // mod query
            cout << queries[i] << endl;
        }
    }
    return 0;
}