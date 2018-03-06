#include <string>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>
using namespace std;

string buf;
vector <string> variation;
long long counter;

// Print combinations of m 1's in a field of n 0/1's starting at s.
void make_combinations(string s, int n, int m, int cur) {
    /* I want only half variation of combinations, so I ensure 
     * the first char is always 0 */
    if (s[0] == '1') {
        return;
    }

    // If there is nothing left to append, we are done. Print the buffer.
    if (m == 0 && n == 0) {
        variation.push_back(s);
        counter++;
        return;
    }
    // Cut if there are more 1's than positions left or negative numbers.
    if (m > n || m < 0 || n < 0){
        return;
    }
    // Append a 0 and recur to print the rest.
    s += '0';
    make_combinations(s, n - 1, m, cur + 1);
    // Now do the same with 1.
    s[cur] = '1';
    make_combinations(s, n - 1, m - 1, cur + 1);
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

int ch(int vector[], int max_lies) {
    int q = 0;
    long long b, p;
    while ((b = berlekamp(vector, q, max_lies)) > (p = pow(2, q))) {
        q++;
    }
    return q;
}

int is_equal(int vector1[], int vector2[], int k) {
    for (int i = 0; i <= k; ++i) {
        if (vector1[i] != vector2[i]) {
            return 0;
        }
    }
    return 1;
}

void copy_vector(int src[], int dst[], int k) {
    for (int i = 0; i <= k; ++i) {
        dst[i] = src[i];
    }
}

void print_vector(int vector[], int k) {
    cout << "{";
    for (int i = 0; i <= k; ++i) {
        cout << vector[i] << ",";
    }
    cout << vector[k] << "}";
}

int main(int argc, char const *argv[])
{
    int n, k, m; // a test case

    int s[17]; // set channel of lies
    int temp_s[17]; // temporary set channel of lies
    int channel[4096]; // what is x channel now?
    char answer; // answer of query
    int q;
    long long b, old_b; // berlekamp weight
    double pow2; // 2 ^ q
    double prcnt; // b / old_b * 100%

    string query;
    vector <string*> same_b_query;
    vector <int*> possible_vector;
    int possible_vector_counter;
    int isBrute = 0;
    int v = -1; // how many turn to brute force?
    int same_b_counter; // how many query has the same berlekamp value
    int cha = 0; // character of a vector, min possible query

    cout << "Masukkan <n> <k> <q>,\n";
    cin >> n >> k >> q;
    // scanf("%d%d%d", &n, &k, &q);
    cout << "n\t" << n << "\nk\t" << k << "\nq\t" << q << "\n";

    m = q;

    /* initiate the variation */
    long long vary = c(n, n / 2) / 2;
    if (n % 2) {
        vary += c(n-1, n / 2 + 1);
    }

    possible_vector_counter = c(k + n, k);
    for (int i = 0; i < possible_vector_counter; ++i) {
        possible_vector.push_back((int*) malloc(sizeof(int*) * k + 1));
    }

    int jumlah_c = n / 2;
    make_combinations(buf, n, jumlah_c, 0);
    if (n % 2 == 1) {
        buf[0] = 0;
        jumlah_c = n / 2 + 1;
        make_combinations(buf, n, jumlah_c, 0); // ditambah jumlah c yang + 1
    }
    cout << "make " << vary << " combinations (" << counter << ")\n";

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
    cha = ch(s, k);
    cout << "q\tquery\tanswer\tvector\tberlekamp\tdelta(x,a)\t"
         << "percent\tch\tisBrute\tsame berlekamp\n"
         << q << "\t-\t-\t";
    print_vector(s, k);
    cout << "\t" << b << "\t-\t-\t"
         << cha << endl;

    // start the game
    for (int i = 0; i < m; ++i) {
        q--;

        if (!isBrute) {
            cin >> isBrute;
        }

        same_b_counter = 0;
        possible_vector_counter = 0;
        if (!isBrute) {
            cin >> query >> answer;
        } else {
            /* Brute force query */
            answer = '1';
            old_b = b;
            long long temp_b = b; // awal awal diisi b, karena pasti selisih
                                  // b (temp_b) lebih kecil daripada b
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

                    same_b_query.clear();
                    same_b_query.push_back(&variation[v]);
                    same_b_counter = 1;

                    copy_vector(s, possible_vector[0], k);
                    possible_vector_counter = 1;
                } else if (abs(selisih) == abs(temp_b)) {
                    same_b_query.push_back(&variation[v]);
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
        }

        cout << q << "\t"
             << "'" << query << "\t"
             << answer << "\t";

        /* init the vector */
        for (int j = 0; j <= k; ++j) {
            s[j] = 0;
        }

        /* make a vector state */
        for (int j = 0; j < n; ++j) {
            int lie = (query[j] != answer);
            channel[j] += lie;
            if (channel[j] <= k) {
                s[channel[j]]++;
            }
        }

        int vector_counter = 0;
        for (int j = 0; j <= k; ++j) {
            vector_counter += s[j];
        }
        print_vector(s, k);
        cout << "\t";

        b = berlekamp(s, q, k);
        cha = ch(s, k);
        prcnt = b * 100.0 / old_b;
        cout << b << "\t";
        cout << abs(2 * b - old_b) << "\t"; // selisih
        cout << prcnt << "\t";
        cout << cha << "\t";
        cout << isBrute << "\t";
        cout << same_b_counter << "\t";

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

        // for (int j = 0; j < n; ++j) {
        //     printf("%d:(%d) ", j+1, channel[j]);
        // }
        cout << endl;

        old_b = b;
        if (vector_counter <= 1) {
            break;
        }
    }
}
