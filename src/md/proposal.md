## Abstrak - Pengembangan Algoritma Pencarian Non Interaktif untuk Penyelesaian Permasalahan Pencarian Ulam dengan Kebohongan Jamak

Dalam perkembangan dunia teknologi informasi selama beberapa dekade terakhir, teknologi informasi seringkali dijadikan solusi bagi permasalahan-permasalahan yang pernah ada, yang sebelumnya diselesaikan secara manual oleh manusia. Contoh permasalahan yang pernah ada adalah salah satu permasalahan klasik pencarian Rényi–Berlekamp–Ulam, atau dapat disingkat menjadi RBU. Permasalahan ini dapat diilustrasikan dengan adanya dua pemain yang disebut penanya dan penjawab.

Sudah ada beberapa variasi pada permasalahan RBU. Pelc menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong adalah satu. Mundici et all dan Min et all menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong dua. Ahlswede mengilustrasikan permasalah RBU dengan maksimal bobot bohong adalah e dengan _graph_ _bipartite_.

Salah satu variasi permasalahan RBU yang diangkat dalam penelitian ini adalah pencarian Ulam dengan m _query_ _subset_ Qi={q1,q2,...,qj} dimana qj ∈ Sn, maksimal bohong adalah e, dan penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Permasalahan ini dapat diselesaikan dengan pencarian biner non interaktif.

## Abstract - Development of Non-Interactive Searching Algorithm for Solving Ulam's Searching Problem with Many Lies

In the development of the world of information technology over the last few decades, information technology is often used as a solution to the problems that ever existed, which was previously solved manually by humans. Example of problems that ever existed were one of the classic problems, Rényi-Berlekamp-Ulam searching game, abbreviated by RBU. This problem can be illustrated by the presence of two players called asker and responder.

There have been several variations on RBU issues. Pelc solved the RBU problem with query range [a, b] and with a maximum number of lies is one. Mundici et all and Min et all solved the RBU problem with query range [a, b] and with a maximum of two lies. Ahlswede illustrated the RBU problem with maximum lie weight is e with bipartite graph.

One of the RBU problem variations raised in this research is the RBU search with m query subset Qi = {q1, q2, ..., qh} where qj ∈ Sn, max lie is e, and responder can only answer all queries after the asker has finished asking all queries. This problem can be solved by non-interactive binary search.

## BAB 1 Pendahuluan

### 1.1 Latar belakang

Dalam perkembangan dunia teknologi informasi selama beberapa dekade terakhir, teknologi informasi seringkali dijadikan solusi bagi permasalahan-permasalahan yang pernah ada, yang sebelumnya diselesaikan secara manual oleh manusia. Contoh permasalahan yang pernah ada adalah salah satu permasalahan klasik pencarian Rényi–Berlekamp–Ulam, atau dapat disingkat menjadi RBU. Permasalahan ini dapat diilustrasikan dengan adanya dua pemain yang disebut penanya dan penjawab. Diberikan range pertanyaan Sn = {1,2,...,n}. Penjawab menentukan sebuah bilangan x ∈ Sn. Penanya harus menemukan nilai x dengan memberikan beberapa _query_ khusus apakah "x ∈ Q?", dimana Q adalah _subset_ dari Sn, lalu penjawab menjawab "ya" atau "tidak". Permasalahan utama adalah penjawab dapat berbohong sampai e kali. Tujuan dari RBU adalah mencari jumlah _query_ minimal untuk dapat menentukan nilai x. Permasalahan ini adalah turunan dari kerangka kerja pencarian adaptif biner.

Sudah ada beberapa variasi pada permasalahan RBU. Pelc (1987) menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong adalah satu. Mundici et all (1997) dan Min et all (2016) menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong dua. Ahlswede (2008) mengilustrasikan permasalah RBU dengan maksimal bobot bohong adalah e, dengan menggunakan _bipartite graph_ untuk menyimpan kanal kebohongan dan memberikan batasan asimtotik yang ketat untuk jumlah _query_ yang dibutuhkan untuk memecahkan masalah ini.

Salah satu variasi permasalahan RBU yang diangkat dalam penelitian ini adalah pencarian Ulam dengan m _query_ _subset_ Qi={q1,q2,...,qj} dimana qj ∈ Sn, maksimal bohong adalah e, dan penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Minimal jumlah _query_ yang dapat ditanyakan penanya adalah (2e + 1) * log2(n). Belum ada penelitian yang menyelesaikan permasalahan ini. Oleh karena itu penelitian ini bertujuan untuk memberikan solusi pada permasalahan ini.

### 1.2 Perumusan masalah

1. Bagaimana merumuskan _query_ untuk mencari bilangan diskrit pada interval yang diberikan pada permasalahan pencarian Ulam dengan pertanyaan seminimal mungkin?
2. Bagaimana implementasi struktur data yang efisien dan optimal untuk menyelesaikan permasalahan pencarian Ulam?

### 1.3 Tujuan penelitian

1. Melakukan analisis dan mendesain algoritma dan struktur data untuk mencari bilangan dengan kebohongan dalam studi kasus permasalahan pencarian Ulam non interaktif dengan kebohongan.
2. Mengevaluasi hasil dan kinerja algoritma dan struktur data yang telah dirancang untuk permasalahan pencarian Ulam non interaktif dengan kebohongan.

### 1.4 Manfaat penelitian

Penelitian tesis ini diharapkan dapat mengimplementasi solusi dari permasalahan Ulam sehingga dapat memberikan kontribusi pada perkembangan ilmu pengetahuan dan teknologi informasi.

### 1.5 Kontribusi penelitian

Penelitian tentang permasalahan Ulam selama ini hanya membahas tentang _query_ yang interaktif dari penanya dan penjawab, baik dengan jumlah maksimal bohong satu, dua, tiga, dan lebih dari tiga. Namun belum ada jurnal ilmiah yang membahas permasalahan Ulam dengan _query_ non interaktif dengan jumlah bohong lebih dari dua. Kontribusi dari penelitian ini adalah menggunakan metode pencarian biner non interaktif untuk menyelesaikan permasalahan Ulam.

### 1.6 Batasan masalah

1. Implementasi algoritma menggunakan bahasa pemrograman C++.
2. Batas maksimum kasus uji adalah 2^7.
3. Interval bilangan yang yang dicari berada pada [1,n], dengan n maksimum 2^12.
4. Dataset yang digunakan adalah dataset pada permasalahan SPOJ GUESSN5.

## BAB 2 Tinjauan pustaka

### 2.1 Deskripsi umum permasalahan

Penjawab menentukan sebuah bilangan x pada rentang Sn=[1,n]. Penanya harus mencari nilai x dengan memberikan maksimal m _query_ khusus apakah "x ∈ Q?", lalu penjawab menjawab "ya" atau "tidak" pada setiap _query_ yang ditanyakan. Permasalahan utama adalah penjawab dapat berbohong sampai e kali. Selain itu, penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Tujuan dari RBU adalah mencari jumlah _query_ minimal untuk dapat menentukan nilai x.

Bentuk dari _query_ adalah string `s1s2s3...sn` dimana si bernilai '0' atau '1'. Jawaban dari penjawab adalah "Ya" jika `sx='1'` atau "Tidak" jika `sx='0'` dengan asumsi penjawab menjawab jujur.

Tugas sesungguhnya dari permasalahan ini adalah bukan untuk mencari nilai `x`, tapi hanya menyiapkan _query_ yang dapat memeungkinkan untuk mendapatkan nilai `x` dari semua kemungkinan jawaban dari penjawab. Penjawab tidak akan menjawab _query_ yang diberikan penanya. Jika penjawab menemukan ada suatu set jawaban yang menyebabkan lebih dari satu kemungkinan nilai `x`, maka pengujian dianggap gagal.

![Alt text](../img/example.png "Example")

> Gambar XXX Contoh uji kasus permasalahan

**Gambar XXX** adalah contoh empat uji kasus dari permasalahan SPOJ GUESSN5. Pada uji kasus yang pertama hanya terdapat dua angka. Penjawab dapat menjawab "YYYYYY" atau "NNNNNN" jika penjawab tidak berbohong. Penjawab dapat menjawab "YYYYYN", "YYYYNY", "YYYNYY", "YYNYYY", "YNYYYY", "NYYYYY", "NNNNNY", "NNNNYN", "NNNYNN", "NNYNNN", "NYNNNN", atau "YNNNNN" jika penjawab berbohong satu kali. Penjawab dapat menjawab "NNNNYY", "NNNYNY", "NNNYYN", "NNYNNY", "NNYNYN", "NNYYNN", "NYNNNY", "NYNNYN", "NYNYNN", "NYYNNN", "YNNNNY", "YNNNYN", "YNNYNN", "YNYNNN", "YYNNNN", "NNYYYY", "NYNYYY", "NYYNYY", "NYYYNY", "NYYYYN", "YNNYYY", "YNYNYY", "YNYYNY", "YNYYYN", "YYNNYY", "YYNYNY", "YYNYYN", "YYYNNY", "YYYNYN", atau "YYYYNN" jika penjawab berbohong dua kali. Kemungkinan jawaban selain tersebut di atas tidak mungkin karena penjawab akan berbohong tiga kali. Oleh karena itu penanya mendapatkan skor 6^2=36.

Pada uji kasus yang kedua penjawab mencoba memberikan solusi namun jawabannya salah. Penanya dapat menjawab "YYYNNN" yaitu jawaban yang valid karena jumlah bohong tiga kali untuk kedua kemungkinan angka. Pada kasus ini, penanya membutuhkan _query_ tambahan. Penanya mendapatkan skor 4*8^2=256.

Pada uji kasus yang ketiga penanya tidak memberikan solusi. Penanya mendapatkan skor 4*34^2=4624.

Pada uji kasus yang keempat penanya memberikan _query_ yang lebih sedikit dari jumlah _query_ maksimal yang diperbolehkan. Dari semua kemungkinan jawaban penjawab, pasti hanya ada satu jawaban nilai x, jadi solusi penanya berhasil dan mendapatkan skor 15^5=255. Dari semua uji kasus, total skor penanya adalah 36 + 256 + 4624 + 225 = 5141.

### 2.2 Teori pengkodean

Tujuan utama dari teori pengkodean (_coding theory_) adalah bagaimana mengirimkan pesan pada kanal yang mengandung derau (_noisy channel_) **[1]**. Misal jika ada delapan macam kata pesan yang akan dikirim, maka kita akan merepresentasikan pesan tersebut menjadi bitstring dengan panjang 3. Namun jika pesan tersebut dikirm langsung melewati kanal yang mengandung derau, bisa jadi misalkan ada 1 bit akan tertukar, misal `001` menjadi `011`. Jika terjadi seperti itu, maka sebuah kata dapat tertukar menjadi kata yang lain.

Kita tahu bahwa jika kode biner sepanjang `n` digunakan untuk membuat `2^n` bitstring tidak akan dapat mendeteksi eror. Ide yang paling mungkin adalah pengirim dan penerima menyetujui sebuah metode enkripsi bitstring menjadi bitstring yang lebih panjang dan dapat mendeteksi maksimal sebanyak `e` error.

Jarak Hamming dari bitstring `x` dan `y` dengan panjang `n` didefinisikan dengan `dH(x,y) = |{i∈{1,...,n} | xi≠yi}|` **[2]**. Sebagai contohnya `dH(0000,1111)= 4` dan `dH(00110,00101)= 2`. `dH(x,y)` juga dapat dikatakan jumlah minimal untuk mentransformasi dari `x` ke `y`. Contoh `x=00110` dan `y=00101` memiliki perbedaan pada 2 bit terakhir dengan jarak Hamming 2, dapat dikatakan `x+00011 = y`.

Kode biner (_binary code_) adalah sejumlah `M` bitstring biner dengan panjang masing-masing bitstring adalah `n` dan jarak Hamming pada masing masing bitstring adalah `d`. Mari kita ambil contoh `M=8`, `n=6`, dan `d=3` pada **Kode sumber XXX**. Parameter pada kode ini adalah `(6,8,3)2`, yaitu kode biner yang ditunjukkan pada angka 2, panjang bitstring 6, berisi 8 bitstring, dengan jarak Hamming minimal 3. Bitstring pada kode biner selanjutnya disebut kata kode (_codeword_).

> `000000 100110`  
> `001011 101101`  
> `010101 110011`  
> `011110 111000`.

> Kode sumber XXX Kode biner `(6,8,3)2`.

Dengan kode biner `(6,8,3)2`, pengirim dan penerima menyepakati hanya kata kode yang akan dikirim dan diterima. Dengan asumsi hanya ada satu bit yang dapat error, pesan error tetap dapat dikembalikan ke bentuk semula. Misal `111100` akan menjadi `111000`, `000011` akan menjadi `001011`, dan seterusnya. Jarak Hamming antara setiap dua kata kode yang berbeda adalah 3, berarti dari setiap kata kode, terdapat sejumlah bitstring selain kata kode berjarak 1.

![Alt text](../img/codewordsball.png "Codeword balls")

> Gambar XXX bola codeword yang tidak saling overlap

Notasi umum kode biner adalah `(n,M,d)2`. Kita bisa asumsikan ada `M` bola yang tidak saling bersinggungan atau berpotongan, dengan radius bola `e=(d-1)/2` seperti pada **Gambar XXX**. Dari ilustrasi bola-bola tersebut dapat disimpulkan bahwa jika dikirimkan sebuah kata kode, bitstring setelah terjadi maksimal `e` pertukaran bit, hasil akan tetap hanya dekat dengan satu kata kode saja. **Duh intinya aku pingin ngasih  tau kenapa kok `d=2*e+1`. Apa sudah cukup ya?**

### 2.3 Kode biner untuk solusi permasalahan pencarian Ulam non-interaktif

<!-- Given matrix `L` with size `nxM` contains `n` queries `Q={q1,q2,...,qn} | qi={s1,s2,...,sM} | si={0,1}`. Given vector `z = {z1,z2,...,zn} | zi={0,1}` an answer to each query, where `0` means 'no' and `1` means 'yes'. If `zi=0` then inverse all `s` in `qi`. Transpose matrix `L`, become `L'`. Then the answer of Ulam game is the index of a row `r` which has `wt(r) > n-e`. -->

Diberikan sebuah matriks `L` berukuran `nxM` berisi `n` query `Q={q1,q2,...,qn} | qi={s1,s2,...,sM} | si={0,1}`. Diberikan sebuah vektor `z = {z1,z2,...,zn} | zi={0,1}` berisi jawaban dari seluruh query secara berurutan, `zi` adalah jawaban dari `qi`, dimana `0` berarti 'tidak' dan `1` berarti 'ya'. Jika `zi=0` maka balik seluruh `s` pada `qi`, `1` menjadi `0` dan sebaliknya. Matriks `L'` berukuran `Mxn` adalah hasil transpose dari matriks `L`. Maka jawaban dari permainan Ulam non-interaktif adalah index dari baris `r` pada `L'` yang memiliki bobot `wt(r) > n-e`.

Untuk meyakinkan bahwa setelah seluruh jawaban `z` diberikan dan diaplikasikan ke matrix `L` dan tidak pasti hanya ada 1 baris yang memiliki nilai `1` antara `n-e <= wt(r) <= n`, adalah dengan memastikan bahwa jarak Hamming setiap row yang berbeda pada `L'` adalah minimal `2*e+1`.

**Given integer n, M, dan d. Buktikan bahwa jika `L'` adalah kode biner `(n,M,d)2` yang valid, maka operasi inverse untuk satu kolom pada `(n,M,d)2` akan tetap menjadi kode biner `(n,M,d)2` yang valid.**

Penanya memenangkan game jika `L'` memiliki at most satu row dengan `wt(x) >= n-e`. Jika hanya ada satu row, maka row tersebut adalah jawaban permainan. Jika tidak ada satu row pun, maka penjawab melakukan kecurangan, melakukan bohong untuk semua angka lebih dari batas yang ditetapkan.

Jika ada satu codeword dengan `wt(x) = n`, maka tidak akan ada codeword lain yang weightnya antara `n-d+1 <= wt(x) <= n`. Jika ada satu codeword dengan `wt(x)=n-i | 0<=i<=e`, maka tidak akan ada codeword lain yang weightnya antara blablabal. **Prove this!**

## BAB 3 Analisis dan perancangan

### 3.1 Analisis penyelesaian masalah

Pada permasalahan pencarian Ulam non interaktif, penjawab tidak diperbolehkan menjawab sebelum penanya selesai menanyakan seluruh _query_. Pendekatan yang paling mungkin untuk menyelesaikan permasalahan ini adalah dengan mempersiapkan pencarian biner. Pencarian biner berjumlah `qb=ceil(log2(n))`, yaitu bilangan bulat minimal yang jika dipangkat dua akan bernilai minimal `n`, agar setiap kemungkinan jawaban dari penjawab dapat mewakili semua kemungkinan nilai `x`. Lalu setiap _query_ akan diulang sebanyak `qe=2*e+1` kali agar penjawab pasti menjawab dengan jujur, karena e _query_ untuk jawaban bohong, ditambah dengan e _query_ untuk mengeliminasi jawaban bohong, ditambah dengan satu _query_ jawaban pasti jujur karena kesempatan penjawab untuk berbohong sudah habis. Total jumlah _query_ `q=qb*qe`.

> Tabel XXX Contoh pada masalah n=8

| x | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-:
| q1 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1
| q2 | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1
| q3 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1
| jawab | NNN | NNY | NYN | NYY | YNN | YNY | YYN | YYY

Misalnya jika `n=8` dan `e=2`, maka jumlah `qb` untuk pencarian biner adalah tiga yaitu `00001111`, `00110011` dan `01010101` seperti pada **Tabel XXX**. Dari tiga _query_ tersebut, semua jawaban penjawab mulai dari "NNN" sampai "YYY" dapat mewakili semua nilai `x` dalam `Sn={1,2,...,8}` sehingga nilai `qb=3`. Lalu masing-masing _query_ diulang sebanyak `qe=e*2+1=5` kali. Maka total dari `q=qb*qe=9`.

### 3.2 Implementasi algoritma

Implementasi merupakan tahap untuk membangun algoritma yang akan digunakan. Pada tahap ini dilakukan implementasi dari rancangan struktur data yang akan dimodelkan sesuai dengan permasalahan. Implementasi ini dikakukan dengan menggunakan bahasa pemrograman C++.

### 3.3 Pengujian

Tahap pengujian adalah melakukan uji coba menggunakan dataset pada Online Judge SPOJ GUESSN5 untuk mengetahui hasil dan performa dari metode dan struktur data yang dibangun. Hal yang dinilai pada pengujian adalah skor, penggunaan memory, dan waktu yang dibutuhkan. Pembobotan skor adalah jika penjawab menemukan ada suatu set jawaban yang menyebabkan lebih dari satu kemungkinan nilai `x`, maka pengujian dianggap gagal. Jika berhasil, maka nilai skor bertambah `q^2`. Jika gagal, maka nilai skor bertambah `4m^2`. Total skor adalah jumlah skor setiap kasus uji.

Evaluasi dan perbaikan juga akan dilakukan pada Online Judge hingga perangkat lunak yang diuji mengeluarkan hasil dan performa yang sesuai dengan data uji pada Online Judge SPOJ.

### 3.4 Dokumentasi dan jadwal penelitian

Proses dokumentasi digunakan untuk penulisan laporan hasil penelitian yang dilakukan. Setiap tahapan dalam proses penelitian juga disertakan dalam laporan yang ditulis. Kegiatan dokumentasi ini akan dicantumkan pada jadwal penelitian yang direncanakan mulai bulan Agustus 2017 hingga Desember 2017 yang secara rinci terlihat pada **Tabel XXX**.

#### References

1. [Introduction to coding theory](drive.google.com)
2. [Perfect two-fault tolerant with minimum adaptiveness](drive.google.com)