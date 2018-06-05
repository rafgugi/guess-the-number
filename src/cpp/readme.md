### Program source
 - `GUESSN5.cpp` Algoritma menggunakan repetisi pencarian biner
 - `GUESSN5_brute.cpp` Algoritma menggunakan kode biner dan generator
 - `GUESSN5_lookup.cpp` Algoritma menggunakan lookuptable kode biner
 - `guessn5_judge_hamming.cpp` untuk mengecek keabsahan algo
 - ~`GUESSN5_hamming.cpp`~
 - ~`guessn5_judge.cpp`~
 - ~`guessn5_learning.cpp` untuk melakukan permutasi, cari urutan yg pas~
 - ~`pathological_brute_modern.cpp`~

#### Detail pengujian
 - Jumlah query
     + Untuk setiap `M` = {2,4,8,...,4096}
         * x-axis untuk `d` = {2,3,4,...,16}
         * y-axis untuk jumlah query pada 3 metode
 - Waktu eksekusi
     + x-axis untuk `M` = {2,4,8,...,4096}
     + y-axis untuk waktu pada 3 metode

#### Command pengujian
```
# Repetisi biner
env time -v ./GUESSN5 < test/2.in > test/R2.out 2> test/R2.env
env time -v ./GUESSN5 < test/4.in > test/R4.out 2> test/R4.env
env time -v ./GUESSN5 < test/8.in > test/R8.out 2> test/R8.env
env time -v ./GUESSN5 < test/16.in > test/R16.out 2> test/R16.env
env time -v ./GUESSN5 < test/32.in > test/R32.out 2> test/R32.env
env time -v ./GUESSN5 < test/64.in > test/R64.out 2> test/R64.env
env time -v ./GUESSN5 < test/128.in > test/R128.out 2> test/R128.env
env time -v ./GUESSN5 < test/256.in > test/R256.out 2> test/R256.env
env time -v ./GUESSN5 < test/512.in > test/R512.out 2> test/R512.env
env time -v ./GUESSN5 < test/1024.in > test/R1024.out 2> test/R1024.env
env time -v ./GUESSN5 < test/2048.in > test/R2048.out 2> test/R2048.env
env time -v ./GUESSN5 < test/4096.in > test/R4096.out 2> test/R4096.env

# Kode biner
env time -v ./GUESSN5_brute < test/2.in > test/B2.out 2> test/B2.env
env time -v ./GUESSN5_brute < test/4.in > test/B4.out 2> test/B4.env
env time -v ./GUESSN5_brute < test/8.in > test/B8.out 2> test/B8.env
env time -v ./GUESSN5_brute < test/16.in > test/B16.out 2> test/B16.env
env time -v ./GUESSN5_brute < test/32.in > test/B32.out 2> test/B32.env
env time -v ./GUESSN5_brute < test/64.in > test/B64.out 2> test/B64.env
env time -v ./GUESSN5_brute < test/128.in > test/B128.out 2> test/B128.env
env time -v ./GUESSN5_brute < test/256.in > test/B256.out 2> test/B256.env
env time -v ./GUESSN5_brute < test/512.in > test/B512.out 2> test/B512.env
env time -v ./GUESSN5_brute < test/1024.in > test/B1024.test/out 2> B1024.env
env time -v ./GUESSN5_brute < test/2048.in > test/B2048.test/out 2> B2048.env
env time -v ./GUESSN5_brute < test/4096.in > test/B4096.test/out 2> B4096.env

# Kode biner dengan lookup table
env time -v ./GUESSN5_lookup < test/2.in > test/L2.out 2> test/L2.env
env time -v ./GUESSN5_lookup < test/4.in > test/L4.out 2> test/L4.env
env time -v ./GUESSN5_lookup < test/8.in > test/L8.out 2> test/L8.env
env time -v ./GUESSN5_lookup < test/16.in > test/L16.out 2> test/L16.env
env time -v ./GUESSN5_lookup < test/32.in > test/L32.out 2> test/L32.env
env time -v ./GUESSN5_lookup < test/64.in > test/L64.out 2> test/L64.env
env time -v ./GUESSN5_lookup < test/128.in > test/L128.test/out 2> L128.env
env time -v ./GUESSN5_lookup < test/256.in > test/L256.test/out 2> L256.env
env time -v ./GUESSN5_lookup < test/512.in > test/L512.test/out 2> L512.env
env time -v ./GUESSN5_lookup < test/1024.in > test/L1024.test/out 2> L1024.env
env time -v ./GUESSN5_lookup < test/2048.in > test/L2048.test/out 2> L2048.env
env time -v ./GUESSN5_lookup < test/4096.in > test/L4096.test/out 2> L4096.env
```
