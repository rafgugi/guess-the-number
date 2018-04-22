#include <string>
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>
using namespace std;

string buf;
vector <string> variation;
long long counter;

// Make binary combination
void make_binary(string s, int n, int cur) {
    // If there is nothing left to append, we are done. Print the buffer.
    if (n == 0) {
        variation.push_back(s);
        // cout << s << endl;
        counter++;
        return;
    }
    // Base
    if (n < 0) {
        return;
    }
    // Append a 0 and recur to print the rest.
    s += '0';
    make_binary(s, n - 1, cur + 1);
    // Now do the same with 1.
    s[cur] = '1';
    make_binary(s, n - 1, cur + 1);
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
    for (int i = 0; i < k; ++i) {
        cout << vector[i] << ",";
    }
    cout << vector[k] << "}";
}

int sum_vector(int vector[], int k) {
    int sum = 0;
    for (int i = 0; i <= k; ++i) {
        sum += vector[i];
    }
    return sum;
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
    double prcnt; // b / old_b * 100%

    vector <string*> same_b_query;
    vector <string> queries;
    int isBrute = 0;
    int v = -1; // how many turn to brute force?
    int same_b_counter; // how many query has the same berlekamp value
    int cha = 0; // character of a vector, min possible query

    vector <string*> win_set;
    vector <string*> lose_set;

    cout << "Masukkan <n> <k> <q>,\n";
    cin >> n >> k >> q;
    cout << "n\t" << n << "\nk\t" << k << "\nq\t" << q << "\n";

    /* input q queries */
    for (int i = 0; i < q; ++i) {
        string input_query;
        cin >> input_query;
        queries.push_back(input_query);
    }

    make_binary(buf, q, 0);
    for (int i = 0; i < variation.size(); ++i) {
        /* reset channel  and vector */
        for (int l = 0; l < n; ++l) {
            channel[l] = 0;
        }
        for (int l = 0; l <= n; ++l) {
            s[l] = 0;
        }

        /* process the query */
        for (int j = 0; j < q; ++j) {
            for (int l = 0; l < n; ++l) {
                channel[l] += (queries[j][l] != variation[i][l]);
            }
        }
        for (int l = 0; l < n; ++l) {
            if (channel[l] <= k) {
                s[channel[l]]++;
            }
        }

        /* check if win or lose */
        if (sum_vector(s, k) <= 1) {
            win_set.push_back(&variation[i]);
            cout << variation[i] << " WIN: ";
            print_vector(s, k);
            cout << endl;
        } else {
            lose_set.push_back(&variation[i]);
            cout << variation[i] << " LOSE: ";
            print_vector(s, k);
            cout << endl;
        }
    }

    cout << "lose set:" << endl;
    for (int i = 0; i < lose_set.size(); ++i) {
        // cout << *lose_set[i] << endl;
    }

    cout << "win set:" << endl;
    for (int i = 0; i < win_set.size(); ++i) {
        // cout << *win_set[i] << endl;
    }
}
