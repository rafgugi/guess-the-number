## BAB 1 Pendahuluan

### Latar belakang

Dalam perkembangan dunia teknologi informasi selama beberapa dekade terakhir, teknologi informasi seringkali dijadikan solusi bagi permasalahan-permasalahan yang pernah ada, yang sebelumnya diselesaikan secara manual oleh manusia. Contoh permasalahan yang pernah ada adalah salah satu permasalahan klasik pencarian Rényi–Berlekamp–Ulam, atau dapat disingkat menjadi RBU. Permasalahan ini dapat diilustrasikan dengan adanya dua pemain yang disebut penanya dan penjawab. Diberikan range pertanyaan Sn = {1,2,...,n}. Penjawab menentukan sebuah bilangan x ∈ Sn. Penanya harus menemukan nilai x dengan memberikan beberapa _query_ khusus apakah "x ∈ Q?", dimana Q adalah _subset_ dari Sn, lalu penjawab menjawab "ya" atau "tidak". Permasalahan utama adalah penjawab dapat berbohong sampai e kali. Tujuan dari RBU adalah mencari jumlah _query_ minimal untuk dapat menentukan nilai x. Permasalahan ini adalah turunan dari kerangka kerja pencarian adaptif biner.

Sudah ada beberapa variasi pada permasalahan RBU. Pelc (1987) menyelesaikan permasalahan RBU dengan _query_ rentang a dan b dan dengan maksimal jumlah bohong adalah satu. Mundici et all (1997) dan Min et all (2016) menyelesaikan permasalahan RBU dengan _query_ rentang a dan b dan dengan maksimal jumlah bohong dua. Ahlswede (2007) mengilustrasikan permasalah RBU dengan maksimal bobot bohong adalah e, dengan menggunakan bipartite graph untuk menyimpan channel kebohongan dan memberikan batasan asimtotik yang ketat untuk jumlah _query_ yang dibutuhkan untuk memecahkan masalah ini.

Permasalahan RBU yang diangkat dalam penelitian ini adalah variasi permasalahan dengan m _query_ _subset_ Qi = {q1,q2,...,qj} dimana qj ∈ Sn, maksimal bohong adalah e, dan penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Minimal jumlah _query_ yang dapat ditanyakan penanya adalah (2e + 1) * log2(n). Permasalahan ini ada pada SPOJ Challenge, Guess The Number With Lies v5 (GUESSN5).

### Perumusan masalah

1. Bagaimana merumuskan pertanyaan untuk mencari bilangan diskrit pada interval yang diberikan pada permasalahan SPOJ GUESSN5 dengan pertanyaan seminimal mungkin?
2. Bagaimana implementasi struktur data yang efisien dan optimal untuk menyelesaikan permasalahan SPOJ GUESSN5?

### Tujuan penelitian

1. Melakukan analisis dan mendesain algoritma dan struktur data untuk mencari bilangan dengan kebohongan dalam studi kasus permasalahan SPOJ GUESSN5.
2. Mengevaluasi hasil dan kinerja algoritma dan struktur data yang telah dirancang untuk permasalahan SPOJ GUESSN5.

### Manfaat penelitian

Penelitian tesis ini diharapkan dapat mengimplementasi solusi dari permasalahan Ulam sehingga dapat memberikan kontribusi pada perkembangan ilmu pengetahuan dan teknologi informasi.

### Kontribusi penelitian

Kondisi terkini adalah metode data hiding yang diusulkan sebelumnya masih belum optimal dalam memanfaatkan blok bertipe smooth sehingga tingkat kerusakan objek stego masih cukup tinggi. Penelitian ini mengembangkan metode baru untuk mengurangi permasalahan tersebut. Kontribusi dari penelitian ini adalah mengembangkan metode baru untuk mengelompokkan piksel bernilai mirip serta mereduksi nilai expanded prediction error setelah dilakukan penyisipan data lebih dari 1 bit.

### Batasan masalah

1. Implementasi algoritma menggunakan bahasa pemrograman C++.
2. Batas maksimum kasus uji adalah 2^7.
3. Interval bilangan yang yang dicari berada pada [1,n], dengan n maksimum 2^12.
4. Dataset yang digunakan adalah dataset pada permasalahan SPOJ GUESSN5.

## BAB 2 Tinjauan pustaka

### Permasalahan SPOJ GUESSN5

Penjawab menentukan sebuah bilangan x pada rentang Sn=[1,n]. Penanya harus mencari nilai x dengan memberikan maksimal m _query_ khusus apakah "x ∈ Q?", lalu penjawab menjawab "ya" atau "tidak" pada setiap _query_ yang ditanyakan. Permasalahan utama adalah penjawab dapat berbohong sampai e kali. Selain itu, penjawab hanya boleh menjawab _query_ penanya setelah penanya selesai menanyakan semua _query_-nya. Tujuan dari RBU adalah mencari jumlah _query_ minimal untuk dapat menentukan nilai x.

Bentuk dari _query_ adalah string s1s2s3...sn dimana si bernilai '0' atau '1'. Jawaban dari penjawab adalah "Ya" jika sx='1' atau "Tidak" jika sx='0' dengan asumsi penjawab menjawab jujur.

Batasan dari permasalahan ini adalah jumlah kasus percobaan tidak lebih dari 2^7. Jumlah maksimal bohong antara 2<=e<=2^4. Jumlah n antara 2<=n<=2^12. Jumlah maksimal _query_ adalah (2w+1) * [log2(n)].

Tugas sesungguhnya dari permasalahan ini adalah bukan untuk mencari nilai x, tapi hanya menyiapkan _query_ yang dapat memeungkinkan untuk mendapatkan nilai x dari semua kemungkinan jawaban dari penjawab. Penjawab tidak akan menjawab _query_ yang diberikan penanya. Jika penjawab menemukan ada suatu set jawaban yang menyebabkan lebih dari satu kemungkinan nilai x, maka pengujian dianggap gagal. Jika berhasil, maka nilai skor bertambah q^2. Jika gagal, maka nilai skor bertambah 4m^2.

![Alt text](example.png "Example")
Gambar XXX Contoh uji kasus permasalahan SPOJ GUESSN5

Gambar XXX adalah contoh empat uji kasus dari permasalahan SPOJ GUESSN5. Pada uji kasus yang pertama hanya terdapat dua angka. Penjawab dapat menjawab "YYYYYY" atau "NNNNNN" jika penjawab tidak berbohong. Penjawab dapat menjawab "YYYYYN", "YYYYNY", "YYYNYY", "YYNYYY", "YNYYYY", "NYYYYY", "NNNNNY", "NNNNYN", "NNNYNN", "NNYNNN", "NYNNNN", atau "YNNNNN" jika penjawab berbohong satu kali. Penjawab dapat menjawab "NNNNYY", "NNNYNY", "NNNYYN", "NNYNNY", "NNYNYN", "NNYYNN", "NYNNNY", "NYNNYN", "NYNYNN", "NYYNNN", "YNNNNY", "YNNNYN", "YNNYNN", "YNYNNN", "YYNNNN", "NNYYYY", "NYNYYY", "NYYNYY", "NYYYNY", "NYYYYN", "YNNYYY", "YNYNYY", "YNYYNY", "YNYYYN", "YYNNYY", "YYNYNY", "YYNYYN", "YYYNNY", "YYYNYN", atau "YYYYNN" jika penjawab berbohong dua kali. Kemungkinan jawaban selain tersebut di atas tidak mungkin karena penjawab akan berbohong tiga kali. Oleh karena itu penanya mendapatkan skor 6^2=36.

Pada uji kasus yang kedua penjawab mencoba memberikan solusi namun jawabannya salah. Penanya dapat menjawab "YYYNNN" yaitu jawaban yang valid karena jumlah bohong tiga kali untuk kedua kemungkinan angka. Pada kasus ini, penanya membutuhkan _query_ tambahan. Penanya mendapatkan skor 4*8^2=256.

Pada uji kasus yang ketiga penanya tidak memberikan solusi. Penanya mendapatkan skor 4*34^2=4624.

Pada uji kasus yang keempat penanya memberikan _query_ yang lebih sedikit dari jumlah _query_ maksimal yang diperbolehkan. Dari semua kemungkinan jawaban penjawab, pasti hanya ada satu jawaban nilai x, jadi solusi penanya berhasil dan mendapatkan skor 15^5=255. Dari semua uji kasus, total skor penanya adalah 36 + 256 + 4624 + 225 = 5141.

## BAB 3 Analisis dan perancangan

### 

#### 

### Implementasi algoritma

Implementasi merupakan tahap untuk membangun algoritma yang akan digunakan. Pada tahap ini dilakukan implementasi dari rancangan struktur data yang akan dimodelkan sesuai dengan permasalahan. Implementasi ini dikakukan dengan menggunakan bahasa pemrograman C++.

### Pengujian

Tahap pengujian adalah melakukan uji coba menggunakan dataset pada Online Judge SPOJ GUESSN5 untuk mengetahui hasil dan performa dari metode dan struktur data yang dibangun. Evaluasi dan perbaikan juga akan dilakukan pada Online Judge hingga perangkat lunak yang diuji mengeluarkan hasil dan performa yang sesuai dengan data uji pada Online Judge SPOJ.

### Dokumentasi dan jadwal penelitian

Proses dokumentasi digunakan untuk penulisan laporan hasil penelitian yang dilakukan. Setiap tahapan dalam proses penelitian juga disertakan dalam laporan yang ditulis. Kegiatan dokumentasi ini akan dicantumkan pada jadwal penelitian yang direncanakan mulai bulan Agustus 2017 hingga Desember 2017 yang secara rinci terlihat pada Tabel XXX.