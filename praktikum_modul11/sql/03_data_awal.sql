USE posyandu_stunting1;
-- =========================================================================
--  PENYIMPANAN DATA (INSERT) DENGAN ATRIBUT JSON BERVARIASI
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


