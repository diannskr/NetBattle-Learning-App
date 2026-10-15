# AI DECLARATION (Deklarasi Penggunaan AI)

**Mata Kuliah**: Mobile Programming  
**Aplikasi**: NetBattle Code Arena  

---

## A. Daftar Alat Asisten AI yang Digunakan
- **Gemini (Google AI)**: Digunakan sebagai *copilot* dalam membantu pembentukan arsitektur antarmuka (UI), perumusan logika matematika game, serta *refactoring* error pada Flutter SDK.

---

## B. Pembagian Peran (Human vs AI)

| Modul / Komponen | Peran AI | Peran Manusia (Mahasiswa) |
| :--- | :--- | :--- |
| **Authentication & Database** | Memberikan template validasi Regex email & struktur pencatatan `Map` lokal. | Menyesuaikan alur *navigation flow* setelah registrasi/login. |
| **Avatar Customizer** | Menyusun struktur komponen Icon & Palette warna tema. | Memilih kombinasi warna cerah dan layout agar ramah pengguna (*user-friendly*). |
| **Quest Modul Materi** | Menuliskan draf teks materi koding dan struktur UI `AlertDialog`. | Menyusun alur **Interactive Checkpoint Question** untuk memastikan siswa membaca materi, serta membersihkan stiker emoji agar tampilan profesional. |
| **Battle Tarik Tambang** | Memberikan formula kalkulasi `_ropePosition` awal dan *Countdown Timer*. | **Penyeimbangan Logika**: Mengubah bobot pergerakan tali dari 0.25 menjadi 0.1 per jawaban benar ($n = \frac{1}{2} \times \text{soal}$) agar permainan memiliki perlawanan seimbang dan tidak terlalu cepat berakhir. |

---

## C. Studi Kasus Prompting & Analisis Kritis

### Studi Kasus 1: Penyeimbangan Logika Game Tarik Tambang
- **Instruksi (Prompt)**:  
  *"Revisi bagian tarik tambang minimal bisa menangnya itu kalau +5, karena soalnya 10 jadi kalau 2-3 kali jawab benar langsung menang kurang perlawanan. Rumusnya n = 1/2 banyak soal."*
- **Hasil Awal AI & Masalah**:  
  AI awalnya memberikan perpindahan posisi sebesar 0.25 atau 0.2 yang membuat tali berpindah terlalu jauh dalam 2-3 kali giliran, sehingga sesi game terlalu cepat usai tanpa tantangan.
- **Penyesuaian Manual**:  
  Logika pergerakan tali disesuaikan secara presisi menjadi `_ropePosition = (_ropePosition - 0.1).clamp(0.0, 1.0)`. Karena titik awal tali berada di tengah (`0.5`), dibutuhkan selisih tepat 5 jawaban benar ($0.1 \times 5 = 0.5$) untuk mencapai batas `0.0` (kemenangan).

### Studi Kasus 2: Penanganan Verifikasi Bacaan Materi
- **Instruksi (Prompt)**:  
  *"Bagaimana caranya supaya siswa benar-benar membaca materi sebelum membuka babak berikutnya dan tidak sekadar klik selesai?"*
- **Hasil Awal AI & Masalah**:  
  AI menyarankan timer penundaan (*reading delay timer*). Namun, pendekatan ini dinilai membuat siswa frustrasi tanpa menjamin pemahaman isi materi.
- **Penyesuaian Manual**:  
  Mengimplementasikan **Checkpoint Question Widget** di bawah setiap box materi yang mengunci tombol *"PAHAM & BUKA BABAK BERIKUTNYA"* sampai siswa berhasil memilih opsi jawaban verifikasi yang benar.