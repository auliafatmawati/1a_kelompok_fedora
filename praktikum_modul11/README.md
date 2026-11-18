# Praktikum Modul 11 — Implementasi Basis Data SiPosTing
**Sistem Informasi Posyandu & Pendeteksi Stunting Dini (`posyandu_stunting`)**

Repositori ini merupakan bagian dari dokumentasi dan implementasi praktikum Basis Data oleh **Kelompok Fedora (Kelas 1A)**. Proyek **SiPosTing** dirancang untuk mendukung digitalisasi pencatatan tumbuh kembang balita, pemantauan antropometri berkala, serta deteksi dini risiko stunting pada fasilitas layanan kesehatan primer (Posyandu).

---

## 👥 Identitas Kelompok
* **Nama Kelompok:** Kelompok Fedora (1A)
* **Repository Utama:** [github.com/auliafatmawati/1a_kelompok_fedora](https://github.com/auliafatmawati/1a_kelompok_fedora/tree/main/praktikum_modul11)
* **Topik Praktikum:** Penerapan RDBMS, Perbandingan DBMS, Fitur JSON, Pemodelan Berorientasi Objek, dan Dokumentasi Git.

---

## 🛠️ Spesifikasi Teknologi & DBMS
* **DBMS Utama:** MySQL (Storage Engine: **InnoDB** untuk kepatuhan transaksi ACID)
* **Lingkungan Pengembangan:** Laragon & PHPMyAdmin
* **Model Data:** Relasional Terstruktur (8 Tabel Operasional) dengan pendekatan Hibrida **JSON** untuk atribut pemeriksaan klinis yang bervariasi.

---

## 🗄️ Ringkasan Arsitektur Basis Data (`posyandu_stunting`)

Basis data terdiri dari **8 tabel utama** yang saling berelasi dengan integritas referensial ketat (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, dan `CHECK`):
1. **`posyandu`** — Data master unit layanan Posyandu beserta wilayah administratifnya.
2. **`pengguna`** — Manajemen akun petugas (*Ketua Posyandu, Anggota BKB, Kader, Petugas Puskesmas*) dengan kolom *generated* `hak_koreksi`.
3. **`balita`** — Profil demografi anak dan orang tua dengan validasi unik pada `nik`.
4. **`jadwal_posyandu`** — Agenda pelaksanaan kegiatan penimbangan dan pelayanan bulanan.
5. **`kunjungan`** — Rekam hasil pengukuran antropometri (`berat_badan`, `tinggi_badan`, `lingkar_kepala`), pemberian suplemen, `status_gizi`, serta kolom `detail_pemeriksaan` bertipe **`JSON`**.
6. **`rujukan`** — Pencatatan tindak lanjut rujukan balita berisiko/stunting ke Puskesmas.
7. **`rekap_bulanan`** — Laporan rekapitulasi statistik penimbangan dan status gizi per bulan.
8. **`notifikasi`** — Riwayat pengiriman pesan jadwal dan hasil pemeriksaan ke orang tua (*WhatsApp/Push*).

---

## 🚀 Cara Menjalankan Script SQL

1. Pastikan layanan **MySQL** aktif (melalui Laragon, XAMPP, atau MySQL Server).
2. Buka aplikasi manajemen basis data seperti **HeidiSQL**, **DBeaver**, atau **phpMyAdmin**.
3. Jalankan file **`01_database.sql`** terlebih dahulu untuk membuat database `posyandu_stunting` beserta **`02_tabel.sql`** seluruh struktur tabel dan *constraints*-nya.
4. Jalankan file **`04_pengujian_json.sql`** untuk menguji penambahan kolom `JSON`, pengisian data (*INSERT*), ekstraksi data (*SELECT* dengan `->>`), serta pembaruan dan penghapusan atribut JSON (`JSON_SET` & `JSON_REMOVE`).

---

## 📌 Ringkasan Fitur yang Diimplementasikan
* **Evaluasi & Perbandingan DBMS:** Analisis komparatif antara **MySQL**, **MariaDB**, dan **PostgreSQL** berdasarkan kebutuhan operasional Posyandu.
* **Implementasi Tipe Data JSON:** Menangani variasi catatan keluhan klinis, riwayat alergi, dan detail paket PMT tanpa perlu mengubah struktur tabel utama.
* **Pemodelan Berorientasi Objek (OOP):** Rancangan *Class Diagram* dengan konsep *Inheritance* (`Pengguna` sebagai *Superclass* menuju `KaderPosyandu` dan `OrangTua`) serta pemetaannya ke tabel relasional (*Class Table Inheritance*).
