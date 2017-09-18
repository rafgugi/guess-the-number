<!-- # PENYELESAIAN PERMASALAHAN ULAM PADA PERMASALAHAN SPOJ TANTANGAN 17820 GUESS THE NUMBER WITH LIES V5 -->
# ALGORITMA PENCARIAN BINER NON INTERAKTIF UNTUK PENYELESAIAN PERMASALAHAN PENCARIAN ULAM DENGAN KEBOHONGAN LEBIH DARI DUA

## Abstrak

Dalam perkembangan dunia teknologi informasi selama beberapa dekade terakhir, teknologi informasi seringkali dijadikan solusi bagi permasalahan-permasalahan yang pernah ada, yang sebelumnya diselesaikan secara manual oleh manusia. Contoh permasalahan yang pernah ada adalah salah satu permasalahan klasik pencarian Rényi–Berlekamp–Ulam, atau dapat disingkat menjadi RBU. Permasalahan ini dapat diilustrasikan dengan adanya dua pemain yang disebut penanya dan penjawab.

Sudah ada beberapa variasi pada permasalahan RBU. Pelc menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong adalah satu. Mundici et all dan Min et all menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong dua. Ahlswede mengilustrasikan permasalah RBU dengan maksimal bobot bohong adalah e dengan _graph_ _bipartite_.

Salah satu variasi permasalahan RBU yang diangkat dalam penelitian ini adalah pencarian Ulam dengan m _query_ _subset_ Qi={q1,q2,...,qj} dimana qj ∈ Sn, maksimal bohong adalah e, dan penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Permasalahan ini dapat diselesaikan dengan pencarian biner non interaktif.

## Abstract

In the development of the world of information technology over the last few decades, information technology is often used as a solution to the problems that ever existed, which was previously solved manually by humans. Examples of problems that ever existed were one of the classic problems of searching Rényi-Berlekamp-Ulam, or it could be shortened to RBU. This problem can be illustrated by the presence of two players called pen and answer.

There have been several variations on RBU issues. Pelc solves the RBU problem with query range [a, b] and with a maximum number of lies is one. Mundici et all and Min et all solved the RBU problem with query range [a, b] and with a maximum of two lying numbers. Ahlswede illustrates the problem of RBU with maximum lie weight is e with bipartite graph.

One of the variations of RBU issues raised in this research is the Ulam search with m query subset Qi = {q1, q2, ..., qj} where qj ∈ Sn, max lie is e, and answerer can only answer query the asker after the asker is finished asking all query it. This problem can be solved by non-interactive binary search.

## BAB 1 Pendahuluan

### 1.1 Latar belakang

Dalam perkembangan dunia teknologi informasi selama beberapa dekade terakhir, teknologi informasi seringkali dijadikan solusi bagi permasalahan-permasalahan yang pernah ada, yang sebelumnya diselesaikan secara manual oleh manusia. Contoh permasalahan yang pernah ada adalah salah satu permasalahan klasik pencarian Rényi–Berlekamp–Ulam, atau dapat disingkat menjadi RBU. Permasalahan ini dapat diilustrasikan dengan adanya dua pemain yang disebut penanya dan penjawab. Diberikan range pertanyaan Sn = {1,2,...,n}. Penjawab menentukan sebuah bilangan x ∈ Sn. Penanya harus menemukan nilai x dengan memberikan beberapa _query_ khusus apakah "x ∈ Q?", dimana Q adalah _subset_ dari Sn, lalu penjawab menjawab "ya" atau "tidak". Permasalahan utama adalah penjawab dapat berbohong sampai e kali. Tujuan dari RBU adalah mencari jumlah _query_ minimal untuk dapat menentukan nilai x. Permasalahan ini adalah turunan dari kerangka kerja pencarian adaptif biner.

Sudah ada beberapa variasi pada permasalahan RBU. Pelc (1987) menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong adalah satu. Mundici et all (1997) dan Min et all (2016) menyelesaikan permasalahan RBU dengan _query_ rentang [a,b] dan dengan maksimal jumlah bohong dua. Ahlswede (2007) mengilustrasikan permasalah RBU dengan maksimal bobot bohong adalah e, dengan menggunakan _bipartite graph_ untuk menyimpan channel kebohongan dan memberikan batasan asimtotik yang ketat untuk jumlah _query_ yang dibutuhkan untuk memecahkan masalah ini.

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

Penelitian tentang permasalahan Ulam selama ini hanya membahas tentang _query_ yang interaktif dari penanya dan penjawab, baik dengan jumlah maksimal bohong satu, dua, tiga, dan lebih dari tiga. Namun belum ada ilmiay untuk permasalahan Ulam dengan _query_ non interaktif dengan jumlah bohong lebih dari dua. Kontribusi dari penelitian ini adalah menggunakan metode pencarian biner non interaktif untuk menyelesaikan permasalahan Ulam.

### 1.6 Batasan masalah

1. Implementasi algoritma menggunakan bahasa pemrograman C++.
2. Batas maksimum kasus uji adalah 2^7.
3. Interval bilangan yang yang dicari berada pada [1,n], dengan n maksimum 2^12.
4. Dataset yang digunakan adalah dataset pada permasalahan SPOJ GUESSN5.

## BAB 2 Tinjauan pustaka

### 2.1 Deskripsi umum permasalahan

Penjawab menentukan sebuah bilangan x pada rentang Sn=[1,n]. Penanya harus mencari nilai x dengan memberikan maksimal m _query_ khusus apakah "x ∈ Q?", lalu penjawab menjawab "ya" atau "tidak" pada setiap _query_ yang ditanyakan. Permasalahan utama adalah penjawab dapat berbohong sampai e kali. Selain itu, penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Tujuan dari RBU adalah mencari jumlah _query_ minimal untuk dapat menentukan nilai x.

Bentuk dari _query_ adalah string s1s2s3...sn dimana si bernilai '0' atau '1'. Jawaban dari penjawab adalah "Ya" jika sx='1' atau "Tidak" jika sx='0' dengan asumsi penjawab menjawab jujur.

Batasan dari permasalahan ini adalah jumlah kasus percobaan tidak lebih dari 2^7. Jumlah maksimal bohong antara 2<=e<=2^4. Jumlah n antara 2<=n<=2^12. Jumlah maksimal _query_ adalah (2w+1) * [log2(n)].

Tugas sesungguhnya dari permasalahan ini adalah bukan untuk mencari nilai x, tapi hanya menyiapkan _query_ yang dapat memeungkinkan untuk mendapatkan nilai x dari semua kemungkinan jawaban dari penjawab. Penjawab tidak akan menjawab _query_ yang diberikan penanya. Jika penjawab menemukan ada suatu set jawaban yang menyebabkan lebih dari satu kemungkinan nilai x, maka pengujian dianggap gagal. Jika berhasil, maka nilai skor bertambah q^2. Jika gagal, maka nilai skor bertambah 4m^2.

![Alt text](example.png "Example")
> Gambar XXX Contoh uji kasus permasalahan

Gambar XXX adalah contoh empat uji kasus dari permasalahan SPOJ GUESSN5. Pada uji kasus yang pertama hanya terdapat dua angka. Penjawab dapat menjawab "YYYYYY" atau "NNNNNN" jika penjawab tidak berbohong. Penjawab dapat menjawab "YYYYYN", "YYYYNY", "YYYNYY", "YYNYYY", "YNYYYY", "NYYYYY", "NNNNNY", "NNNNYN", "NNNYNN", "NNYNNN", "NYNNNN", atau "YNNNNN" jika penjawab berbohong satu kali. Penjawab dapat menjawab "NNNNYY", "NNNYNY", "NNNYYN", "NNYNNY", "NNYNYN", "NNYYNN", "NYNNNY", "NYNNYN", "NYNYNN", "NYYNNN", "YNNNNY", "YNNNYN", "YNNYNN", "YNYNNN", "YYNNNN", "NNYYYY", "NYNYYY", "NYYNYY", "NYYYNY", "NYYYYN", "YNNYYY", "YNYNYY", "YNYYNY", "YNYYYN", "YYNNYY", "YYNYNY", "YYNYYN", "YYYNNY", "YYYNYN", atau "YYYYNN" jika penjawab berbohong dua kali. Kemungkinan jawaban selain tersebut di atas tidak mungkin karena penjawab akan berbohong tiga kali. Oleh karena itu penanya mendapatkan skor 6^2=36.

Pada uji kasus yang kedua penjawab mencoba memberikan solusi namun jawabannya salah. Penanya dapat menjawab "YYYNNN" yaitu jawaban yang valid karena jumlah bohong tiga kali untuk kedua kemungkinan angka. Pada kasus ini, penanya membutuhkan _query_ tambahan. Penanya mendapatkan skor 4*8^2=256.

Pada uji kasus yang ketiga penanya tidak memberikan solusi. Penanya mendapatkan skor 4*34^2=4624.

Pada uji kasus yang keempat penanya memberikan _query_ yang lebih sedikit dari jumlah _query_ maksimal yang diperbolehkan. Dari semua kemungkinan jawaban penjawab, pasti hanya ada satu jawaban nilai x, jadi solusi penanya berhasil dan mendapatkan skor 15^5=255. Dari semua uji kasus, total skor penanya adalah 36 + 256 + 4624 + 225 = 5141.

### 2.2 Solusi pada permasalahan ULAM secara umum

Pada permasalahan RBU, penjawab menentukan sebuah angka x dimana x ∈ Sn, lalu penanya akan menanyakan _query_ untuk membantu mencari nilai x. Pada kenyataannya, penjawab tidak benar-benar memilih sebuah angka x, namun mempersiapkan n angka dengan state keboongan dari setiap angka. State kebohongan setiap angka dapat digambarkan dengan _bipartite graph channel_ untuk status kebohongan, Ci adalah status kebohongan dari bilangan i ∈ Sn, bernilai antara rentang [0,e+1] Ahlswede et all(2007).

Setiap ada _query_ Qi={q1,q2,...,qj}, dengan jawaban penjawab "ya" maka set angka yang dianggap benar pada _query_ tersebut adalah Qt=Qi sedangkan jika jawaban "tidak" maka set angka yang dianggap benar pada _query_ tersebut adalah Qt=Sn-Qi. Maka semua angka yang dianggap salah Sn-Qt={t1,t2,...,tk} akan dipindahkan ke state _channel_ setelahnya Ctk=Ctk+1.

## BAB 3 Analisis dan perancangan

### 3.1 Analisis penyelesaian masalah

Pada permasalahan pencarian Ulam non interaktif, penjawab tidak diperbolehkan menjawab sebelum penanya selesai menanyakan seluruh _query_. Pendekatan yang paling mungkin untuk menyelesaikan permasalahan ini adalah dengan mempersiapkan pencarian biner. Pencarian biner berjumlah qb=log2(n), agar setiap kemungkinan jawaban dari penjawab dapat mewakili semua kemungkinan nilai x. Lalu setiap _query_ akan diulang sebanyak qe=2*e+1 kali agar penjawab pasti menjawab dengan jujur, karena e _query_ untuk jawaban bohong, ditambah dengan e _query_ untuk mengeliminasi jawaban bohong, ditambah dengan satu _query_ jawaban pasti jujur karena kesempatan penjawab untuk berbohong sudah habis.

Misalnya jika n=4, e=1, m=6, maka _query_ pencarian biner adalah 0011 dan 0101 dengan masing-masing _query_ diulang sebanyak 3 kali, jadi total adalah enam _query_. Untuk setiap jawaban jujur penjawab NN, NY, YN, dan YY, nilai x adalah 1, 2, 3, dan 4.

### 3.2 Implementasi algoritma

Implementasi merupakan tahap untuk membangun algoritma yang akan digunakan. Pada tahap ini dilakukan implementasi dari rancangan struktur data yang akan dimodelkan sesuai dengan permasalahan. Implementasi ini dikakukan dengan menggunakan bahasa pemrograman C++.

### 3.3 Pengujian

Tahap pengujian adalah melakukan uji coba menggunakan dataset pada Online Judge SPOJ GUESSN5 untuk mengetahui hasil dan performa dari metode dan struktur data yang dibangun. Evaluasi dan perbaikan juga akan dilakukan pada Online Judge hingga perangkat lunak yang diuji mengeluarkan hasil dan performa yang sesuai dengan data uji pada Online Judge SPOJ.

### 3.4 Dokumentasi dan jadwal penelitian

Proses dokumentasi digunakan untuk penulisan laporan hasil penelitian yang dilakukan. Setiap tahapan dalam proses penelitian juga disertakan dalam laporan yang ditulis. Kegiatan dokumentasi ini akan dicantumkan pada jadwal penelitian yang direncanakan mulai bulan Agustus 2017 hingga Desember 2017 yang secara rinci terlihat pada Tabel XXX.