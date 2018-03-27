## Guessn5

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


### Perfect query 

_(masih dengan bruteforce, maksimal n=20, yang dibutuhkan n=4096, masih butuh paper pendukung tentang ini)_

 - given input `n`, `k`, `q`, `s`
 > `q` adalah sisa query, yaitu `chs - log2(n)`. `s` adalah state setelah `log2(n)` query pertama.
 - Buat sebuah array of string `variations` berukuran `T`, yaitu masing-masing `variation = {v1v2...vn}`, `vi∈{0,1}`, selisih `vi` yang bernilai `0` dan yang bernilai `1` minimal berjumlah 1 dan `v1` pasti bernilai 0. Oleh karena itu jumlah `T` adalah `c(n, n/2) / 2` jika n genap dan `c(n, n/2) / 2 + c(n-1, n/2 + 1)` jika n ganjil.
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

 - Given input `M`, `k`, `q`.
 - Find the smallest possible `n` and generate a code `X` = `(n, M, 2k+1)2`. _(The main problem)_
 - `X` is a form of matrix `Mxn`. Then the query is transpose of `X` which is a form of matrix `nxM`.