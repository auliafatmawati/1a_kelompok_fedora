USE posyandu_stunting;

-- =========================================================================
-- 1. IMPLEMENTASI TIPE DATA JSON PADA SKEMA EXISTING (TABEL KUNJUNGAN)
-- =========================================================================
-- Menambahkan kolom 'detail_pemeriksaan' bertipe JSON pada tabel kunjungan
-- untuk menampung data tambahan/intervensi yang bervariasi tiap balita.
ALTER TABLE kunjungan
ADD COLUMN detail_pemeriksaan JSON NULL AFTER status_gizi;


-- =========================================================================
-- 2. PENYIMPANAN DATA (INSERT) DENGAN ATRIBUT JSON BERVARIASI
-- =========================================================================

INSERT INTO posyandu (nama_posyandu, dusun, desa, kecamatan)
VALUES ('Posyandu Melati 1', 'Dusun Krajan', 'Sukamaju', 'Cikalong');

INSERT INTO pengguna (id_posyandu, nama, username, password_hash, role)
VALUES (1, 'Siti Aminah', 'siti_kader', '$2y$10$hashpasswordcontoh', 'Ketua Posyandu');

INSERT INTO balita (id_posyandu, id_pengguna, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
VALUES 
(1, 1, '3201011205240001', 'Alya Putri', '2024-05-12', 'P', 'Rina Marlina', '081234567890'),
(1, 1, '3201012408230002', 'Bima Pratama', '2023-08-24', 'L', 'Dedi Kurniawan', '081298765432');

INSERT INTO jadwal_posyandu (id_posyandu, tanggal, jam_mulai, jenis_kegiatan)
VALUES (1, '2026-11-18', '08:00:00', 'Penimbangan Rutin & Pemberian PMT');

-- INSERT ke tabel kunjungan dengan struktur JSON yang berbeda pada tiap baris
INSERT INTO kunjungan (
    id_balita, id_jadwal, id_pengguna, berat_badan, tinggi_badan, 
    lingkar_kepala, vitamin_a, obat_cacing, status_gizi, detail_pemeriksaan
)
VALUES 
(
    1, 1, 1, 8.50, 72.0, 44.5, 'Ya', 'Tidak', 'Gizi Baik',
    '{
        "imunisasi_diberikan": ["Polio 4", "DPT-HB-Hib 3"],
        "catatan_kader": "Pertumbuhan sesuai grafik KMS",
        "konseling_gizi": true
    }'
),
(
    2, 1, 1, 7.20, 68.5, 43.0, 'Ya', 'Ya', 'Berisiko Stunting',
    '{
        "keluhan": "Nafsu makan menurun sejak 2 minggu lalu",
        "riwayat_alergi": ["Susu Sapi", "Telur"],
        "intervensi_pmt": {
            "jenis_produk": "Biskuit Balita Kemenkes",
            "jumlah_bungkus": 10,
            "jadwal_evaluasi_hari": 14
        }
    }'
);


-- =========================================================================
-- 3. PEMBACAAN DATA (SELECT & EKSTRAKSI ATRIBUT JSON)
-- =========================================================================
-- Mengekstrak key spesifik di dalam kolom JSON menggunakan operator ->>
SELECT 
    k.id_kunjungan,
    b.nama AS nama_balita,
    k.berat_badan,
    k.tinggi_badan,
    k.status_gizi,
    k.detail_pemeriksaan->>'$.catatan_kader' AS catatan_kader,
    k.detail_pemeriksaan->>'$.keluhan' AS keluhan_anak,
    k.detail_pemeriksaan->>'$.intervensi_pmt.jenis_produk' AS produk_pmt,
    k.detail_pemeriksaan->>'$.intervensi_pmt.jumlah_bungkus' AS jml_bungkus
FROM kunjungan k
JOIN balita b ON k.id_balita = b.id_balita;


-- =========================================================================
-- 4. PENCARIAN DATA BERDASARKAN ATRIBUT JSON (WHERE & JSON_CONTAINS)
-- =========================================================================
-- A. Mencari balita yang menerima produk PMT tertentu (Nested JSON Object)
SELECT 
    b.nik,
    b.nama AS nama_balita,
    k.status_gizi,
    k.detail_pemeriksaan->>'$.intervensi_pmt.jenis_produk' AS jenis_pmt
FROM kunjungan k
JOIN balita b ON k.id_balita = b.id_balita
WHERE k.detail_pemeriksaan->>'$.intervensi_pmt.jenis_produk' = 'Biskuit Balita Kemenkes';

-- B. Mencari balita yang memiliki alergi 'Susu Sapi' di dalam JSON Array
SELECT 
    b.nama AS nama_balita,
    k.detail_pemeriksaan->>'$.riwayat_alergi' AS daftar_alergi
FROM kunjungan k
JOIN balita b ON k.id_balita = b.id_balita
WHERE JSON_CONTAINS(k.detail_pemeriksaan->'$.riwayat_alergi', '"Susu Sapi"');


-- =========================================================================
-- 5. PERUBAHAN & PENGHAPUSAN ATRIBUT JSON (JSON_SET & JSON_REMOVE)
-- =========================================================================
-- A. UPDATE: Mengubah jumlah bungkus PMT dan menambahkan key 'status_evaluasi'
UPDATE kunjungan
SET detail_pemeriksaan = JSON_SET(
    detail_pemeriksaan,
    '$.intervensi_pmt.jumlah_bungkus', 15,
    '$.status_evaluasi', 'Berat badan mulai naik 0.3 kg'
)
WHERE id_kunjungan = 2;

-- B. DELETE ATRIBUT: Menghapus key 'keluhan' dari JSON karena anak sudah sembuh
UPDATE kunjungan
SET detail_pemeriksaan = JSON_REMOVE(detail_pemeriksaan, '$.keluhan')
WHERE id_kunjungan = 2;

-- Verifikasi hasil akhir setelah perubahan
SELECT id_kunjungan, id_balita, detail_pemeriksaan 
FROM kunjungan 
WHERE id_kunjungan = 2;
