#include <cstdio>

using namespace std;

int main(int argc, char const *argv[])
{
    int T, M[128], e[128], m[128], q;
    int dist[4096];
    char queries[396][4097];

    scanf("%d", &T);
    for (int t = 0; t < T; ++t) {
        scanf("%d%d%d", &M[t], &e[t], &m[t]);
    }

    for (int t = 0; t < T; ++t) {
        scanf("%d", &q);
        for (int i = 0; i < M[t]; ++i) {
            dist[i] = 0;
        }

        for (int i = 0; i < q; ++i) {
            scanf("%s", queries[i]);
            for (int j = 1; j < M[t]; ++j) {
                dist[j] += (queries[i][0] != queries[i][j]);
            }
        }

        int min = dist[1];
        for (int i = 2; i < M[t]; ++i) {
            if (dist[i] < min) {
                min = dist[i];
            }
        }
        printf("M:%d e:%d min:%d q:%d: ", M[t], e[t], min, q);
        if (min < 2*e[t] + 1) {
            printf("FAIL\n");
        } else {
            printf("SUCCESS\n");
        }
    }

    return 0;
}

/*
./GUESSN5_brute < input > output
cat input > judge
cat output >> judge
./guessn5_judge_hamming < judge
*/