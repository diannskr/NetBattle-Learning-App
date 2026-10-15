# NetBattle Code Arena 🚀
**Platform Pembelajaran Logika Pemrograman & Koding Interaktif Berbasis Mobile**

NetBattle Code Arena adalah aplikasi mobile edukasi berbasis Flutter yang dirancang untuk membantu siswa SMK dan mahasiswa tingkat awal memahami konsep dasar algoritma, struktur data, dan logika koding melalui pendekatan *gamification*.

---

## 🌟 Fitur Utama

1. **Authentication & Profile Management**
   - Registrasi & Login berbasis email lokal.
   - Maskot & Avatar Customizer (kustomisasi aksesori kepala, ekspresi wajah, pakaian, dan warna tema aplikasi).
   - Profil siswa dengan sistem **XP (Experience Points)** dan **Leveling** dinamis yang dimulai dari `0 XP`.

2. **Quest Modul Pembelajaran (8 Babak)**
   - Materi komprehensif mulai dari Konsep Algoritma, Tipe Data, Percabangan (If-Else), Perulangan (For/While), Fungsi, hingga Struktur Data List/Array.
   - Penyajian materi dalam **Single Box Document** yang bersih dan terstruktur.
   - **Interactive Checkpoint Verification**: Soal verifikasi pemahaman di akhir setiap babak yang wajib dijawab dengan benar untuk memastikan siswa benar-benar membaca materi sebelum babak berikutnya terbuka.

3. **Battle Tarik Tambang 1v1 (Real-Time Simulation Engine)**
   - Game interaktif adu kecepatan dan ketepatan melengkapi koding rumpang.
   - Fitur **Room Code Lobby** (*Host & Guest Session*).
   - Rumus pergerakan tali seimbang ($n = \frac{1}{2} \times \text{banyak soal} = 5$), sehingga pemain membutuhkan selisih minimal 5 jawaban benar untuk memenangkan pertandingan.
   - Timer soal otomatis (10 detik per soal).

4. **Battle Kuis Solo (Evaluasi Mandiri)**
   - Kuis evaluasi cepat berisi 10 soal logika koding dengan penghitungan skor akhir dan akumulasi bonus XP.

---

## 🛠️ Teknologi & Environment

- **Framework**: Flutter (Dart)
- **State Management**: Stateful Widgets & Inherited Widget (Theme Controller)
- **Local Database**: In-Memory State & Local Mock Database
- **UI Architecture**: Material Design 3 (Responsive & Custom Styled)

---

## 🚀 Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK sudah terinstal di komputer Anda.
2. Clone repositori ini:
   ```bash
   git clone [https://github.com/diannskr/NetBattle-Learning-App.git](https://github.com/diannskr/NetBattle-Learning-App.git)