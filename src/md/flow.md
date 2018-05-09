## This is no longer used

### Bonus paper

- _An algorithm for "Ulam's Game" and its application to error correcting codes_ by Eugene L. Lawler, Sergei Sarkissian
- _Experimental Implementation of Quantum Ulam’s Problem in A Nuclear Magnetic Resonance Quantum Information Processor_ by Avik Mitra, Anil Kumar

### Analysis

- Pada setiap test case, buat non-interactive query. Sebanyak `log2(n)` query awal adalah query biner. Selanjutnya mencari query dengan pendekatan berlekamp, yaitu mencari Δj terkecil. Δj adalah selisih nilai berlekamp jika jawaban `ya` dengan nilai berlekamp jika jawaban `tidak`.
- Langkah pertama adalah menggenerate `variation`, dimana `variation` adalah semua variasi query yang paling mungkin digunakan untuk diajukan sebagai query. Jumlah `variation` adalah `2^n`.
- Namun dapat `variation` dioptimasi dengan cara hanya menggunakan query dengan jumlah `1` dan `0` sama atau selisih satu. Lalu hapus juga query yang saling berkebalikan. Misalnya `0011` berkebalikan dengan `1100`, `0101` berkebalikan dengan `1010`, dan sebagainya. Dengan begitu jumlah `variation` adalah `c(n, n / 2) / 2` jika n genap dan `c(n, n / 2) / 2 + c(n-1, n / 2 + 1)` jika n ganjil.
- Langkah kedua adalah pada sebuah state, cari sebuah query dari `variation` dimana menghasilkan nilai berlekamp yang memiliki Δj terkecil. Asumsikan semua jawaban dari sebuah query adalah `ya`.
- Query tersebut lalu divariasikan variasi biner sebanyak `log2(n)` untuk dapat mengatasi segala kemungkinan state. Misal jika query tersebut adalah `000111`, maka akan divariasikan menjadi `00001111`, `00110011`, dan `01010101`.
- Ulangi langkah kedua sampai vector hanya berisi sebuah angka `1` dan sisanya berisi `0`. Setap melakukan langkah kedua akan menghasilkan `log2(n)` query.
- **Kelemahan** propose method ini adalah masih menggunakan combinatoric untuk menghasilkan `variation`. Dengan maksimal jumlah `n = 4096` akan menghasilkan jumlah `variation` sebanyak `c(4096, 2048) / 2`. Oleh karena itu perlu menggenerate `variation` yang lebih sedikit namun yang paling optimal.
- Sedikit mengatasi kelemahan, variasi tidak perlu digenerate dari awal program dijalankan. Kita tinggal hanya memotong setiap channel menjadi mendekati setengah dari nilai sebelumnya. Namun masalahnya adalah jika nilai pada sebuah channel ganjil, maka kita tidak dapat memotongnya menjadi setengah. Pada saat itu lah kita akan mencoba setiap nilai menjadi `floor(Ch(i) / 2)` atau `floor(Ch(i) / 2) + 1`
- ~~[Impossible]~~ Atau mungkin mencari pendekatan hubungan antara `(x, q, k)` game dengan nilai berlekamp `b(x, q, k)`

### Previous flow

 - given input `n`, `k`, `q`
 - Buat vector state `s`, dan dapatkan `chs = ch(s)`
 > `chs` adalah jumlah minimal query yang dapat menyelesaikan state s, ada pada paper Perfect fault tolerant search hal 68
 - buat `log2(n)` binary search query
 > ada pada paper Perfect fault tolerant search hal 72
 - buat perfect search query jika semua jawaban binary search `true`
 > Seperti pada paper, Pasti ada suatu `(chs-log2(n))` query yang dapat menyelesaikan `s` setelah kita tahu jawaban dari `log2(n)` query pertama. kita asumsikan semua `true`
 - buat perfect search query jika semua jawaban binary search `false`
 > Terduga (belum dibuktikan): Jika kita membuat query sisa dengan asumsi jawaban `log2(n)` query pertama adalah Hamming distance terjauh (`dH(x, y)`), maka akan menyelesaikan game.
 - berarti jumlah query adalah `chs * 2 - log2(n)`
 > didapat dari penjumlahan `log2(n) + (chs - log2(n)) * 2`
 - Isi query adalah binary search, perfect query untuk semua `true` dan semua `false`

### Previous perfect query that doesn't exist

_(masih dengan bruteforce, maksimal n=20, yang dibutuhkan n=4096, masih butuh paper pendukung tentang ini)_

 - given input `n`, `k`, `q`, `s`
 > `q` adalah sisa query, yaitu `chs - log2(n)`. `s` adalah state setelah `log2(n)` query pertama.
 - Buat sebuah array of string `variations` berukuran `T`, yaitu masing-masing `variation = {v1v2...vn}`, `vi∈{0,1}`, selisih `vi` yang bernilai `0` dan yang bernilai `1` minimal berjumlah 1 dan `v1` pasti bernilai 0. Oleh karena itu jumlah `T` adalah `c(n, n/2) / 2` jika `n` genap dan `c(n, n/2) / 2 + c(n-1, n/2 + 1)` jika `n` ganjil.
 - Tentukan nilai bobot berlekamp `wb`.
 - `queries = {}`
 - Perulangan sebanyak `q` sebagai `i`
     + Perulangan sebanyak `T` pada `variations` sebagai `j`
         * Masukkan `variations[j]` sebagai query untuk state s
         * Hitung nilai bobot berlekamp jika jawaban query `0`
         * Hitung nilai bobot berlekamp jika jawaban query `1`
         * `variations[j]` akan dipilih jika selisih jawaban `0` dan `1` adalah minimal
     + Simpan `variations[j]` ke dalam `queries`
 - return `queries`

### Coding Theory

Okay, now forget about berlekamp things. The main questions of coding theory:
1. Construct codes that can correct a maximal number of errors while using a minimal amount of redundancy
2. Construct codes (as above) with efficient encoding and decoding procedures
3. `(n, M, d)2` code is a collection of `M` bitstrings (we well call them _codewords_) of length `n`, such that any two different codewords have Hamming distance at least d.
4. It can correct up to `(d-1) / 2` errors.

Now go back to our problems. Given `U(M, k)`, is an Ulam searching game with length `M` and up to `k` answers may be erroneous. The solution is find the smallest `n` such that `(n, M, 2k+1)2` code is exist.

We obviously know that the easiest attempt to find `n` is `n = M * (2k+1)` (using repetation, Introduction to Coding Theory pg.6), which was my previous attempt to **SPOJ GUESSN5**. How to find the smallest possible `n`?

### Flow based on coding theory

 - Given input `M`, `e`, `q`.
 - Find the smallest possible `n` and generate a code `X` = `(n, M, 2e+1)2`. _(The main problem)_
 - `X` is a form of matrix `Mxn`. Then the query is transpose of `X` which is a form of matrix `nxM`.

### Greedily add some distances
_(maybe we need alpha beta pruning?)_
 - Given input `M`, `e`, `q`.
 - Initialize `distances` matrix between each `M`. (`O(M(M+1)/2)`).
 - Generate first initial `query`, fill first `M/2` with `0` and the rest with `1`.
 - while (`true`)
     + Update the `distances` from the `query`. Also save the `max` and `min` distance between all of them.
     + if `min >= d` then break.
     + add `query` to vector list `queries`.
     + initialize `query = "0xxxxxxx"` (`'x'` count is `M-1`).
     + for `i` in `0...M-1`
         * for `j` in `i...M`
             - if `distances[i][j] = max`, don't make distance
                 + if `s[i] != 'x'`
                     * `s[j] = s[i]`
                 + if `s[j] != 'x'`
                     * `s[i] = s[j]`
             - if `distances[i][j] = min`, make distance
                 + if `s[i] != 'x'`
                     * `s[j] = !s[i]`
                 + if `s[j] != 'x'`
                     * `s[i] = !s[j]`
             - if count of `'0'` or `'1'` more than `M/2` then double break
     + Replace `'x'` with the least count between `'0'` or `'1'`.