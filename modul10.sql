-- Membuat Database
CREATE DATABASE praktikum_modul10;
USE praktikum_modul10;

-- Membuat Tabel Balita
CREATE TABLE balita (
    id_balita      VARCHAR(10)   NOT NULL PRIMARY KEY,
    nik            CHAR(16)      UNIQUE,
    nama           VARCHAR(100)  NOT NULL,
    tgl_lahir      DATE          NOT NULL,
    jenis_kelamin  ENUM('L','P') NOT NULL,
    nama_ortu      VARCHAR(100)  NOT NULL,
    no_wa_ortu     VARCHAR(20)
) ENGINE=InnoDB;

-- Membuat Tabel Jadwal Posyandu
CREATE TABLE jadwal_posyandu (
    id_jadwal       VARCHAR(10)  NOT NULL PRIMARY KEY,
    tanggal         DATE         NOT NULL,
    jam_mulai       TIME         NOT NULL,
    jenis_kegiatan  VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Membuat Tabel Kunjungan
CREATE TABLE kunjungan (
    id_kunjungan    VARCHAR(10)  NOT NULL PRIMARY KEY,
    id_balita       VARCHAR(10)  NOT NULL,
    id_jadwal       VARCHAR(10)  NOT NULL,
    berat_badan     DECIMAL(5,2) NOT NULL,
    tinggi_badan    DECIMAL(5,1) NOT NULL,
    lingkar_kepala  DECIMAL(4,1),
    vitamin_a       ENUM('Ya','Tidak') NOT NULL DEFAULT 'Tidak',
    obat_cacing     ENUM('Ya','Tidak') NOT NULL DEFAULT 'Tidak',
    status_gizi     ENUM('Gizi Baik','Berisiko Stunting','Stunting'),

    UNIQUE (id_balita, id_jadwal),
    CHECK (berat_badan > 0),
    CHECK (tinggi_badan > 0),

    CONSTRAINT fk_kunjungan_balita
    FOREIGN KEY (id_balita) REFERENCES balita(id_balita)
    ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_kunjungan_jadwal
    FOREIGN KEY (id_jadwal) REFERENCES jadwal_posyandu(id_jadwal)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Memeriksa Relasi Tabel/Struktur Tabel
SHOW TABLES;
SHOW CREATE TABLE balita;
SHOW CREATE TABLE jadwal_posyandu;
SHOW CREATE TABLE kunjungan;
 4. MENGISI DATA AWAL
-- Mengisi Data Awal
INSERT INTO balita
    (id_balita, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
VALUES
    ('B01', '3519010101250001', 'Ananda Putra',   '2025-07-15', 'L', 'Budi Santoso',  '081234560001'),
    ('B02', '3519010101240002', 'Bunga Lestari',  '2024-03-10', 'P', 'Slamet Riyadi', '081234560003'),
    ('B03', '3519010101250003', 'Citra Maharani', '2025-01-20', 'P', 'Agus Prasetyo', '081234560005');

INSERT INTO jadwal_posyandu
    (id_jadwal, tanggal, jam_mulai, jenis_kegiatan)
VALUES
    ('J01', '2026-08-05', '08:00:00', 'Posyandu rutin, penimbangan, Vitamin A'),
    ('J02', '2026-09-02', '08:00:00', 'Posyandu rutin, penimbangan, obat cacing'),
    ('J03', '2026-10-07', '08:00:00', 'Posyandu rutin, penimbangan');

INSERT INTO kunjungan
    (id_kunjungan, id_balita, id_jadwal, berat_badan, tinggi_badan, lingkar_kepala, vitamin_a, obat_cacing, status_gizi)
VALUES
    ('K01', 'B01', 'J01',  9.40, 70.2, 45.0, 'Ya',    'Tidak', 'Gizi Baik'),
    ('K02', 'B01', 'J02',  9.70, 71.0, 45.5, 'Tidak', 'Ya',    'Gizi Baik'),
    ('K03', 'B02', 'J01', 10.20, 78.5, 46.0, 'Ya',    'Tidak', 'Berisiko Stunting'),
    ('K04', 'B02', 'J02', 10.40, 79.0, 46.0, 'Tidak', 'Ya',    'Berisiko Stunting');

---===Praktik Operasi Database CRUD===---

-- CREATE – Menambahkan Data
INSERT INTO balita
    (id_balita, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
VALUES
    ('B04', '3519010101250004', 'Adhinia fatmawati Khusna', '2025-11-02', 'L', 'Hendra Wijaya', '081234560007');

SELECT * FROM balita

-- READ – Membaca Data
SELECT
    id_balita,
    nama,
    tgl_lahir,
    nama_ortu
FROM balita;

SELECT *
FROM kunjungan
WHERE berat_badan > 10;

-- UPDATE – Memperbarui Data
UPDATE kunjungan
SET tinggi_badan = 79.5
WHERE id_kunjungan = 'K03';

SELECT *
FROM kunjungan
WHERE id_kunjungan = 'K03';

-- DELETE – Menghapus Data
DELETE FROM balita
WHERE nik = '3519010101250004';

SELECT * FROM balita;

-- Menguji Integritas Referensial
INSERT INTO kunjungan
    (id_kunjungan, id_balita, id_jadwal, berat_badan, tinggi_badan, lingkar_kepala, vitamin_a, obat_cacing, status_gizi)
VALUES
    ('K99', 'B99', 'J03', 9.00, 70.0, 45.0, 'Tidak', 'Tidak', 'Gizi Baik');

DELETE FROM balita
WHERE id_balita = 'B01';

---===PENGUJIAN TRANSAKSI DATABASE===---

-- Pengujian COMMIT
START TRANSACTION;
INSERT INTO balita
    (id_balita, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
VALUES
    ('B05', '3519010101250005', 'Eka Nugraha', '2025-09-12', 'L', 'Rudi Hartono', '081234560009');

INSERT INTO kunjungan
    (id_kunjungan, id_balita, id_jadwal, berat_badan, tinggi_badan, lingkar_kepala, vitamin_a, obat_cacing, status_gizi)
VALUES
    ('K05', 'B05', 'J03', 8.90, 68.5, 44.0, 'Tidak', 'Tidak', 'Gizi Baik');
COMMIT;
-- Periksa Hasil
SELECT * FROM balita    WHERE id_balita = 'B05';
SELECT * FROM kunjungan WHERE id_balita = 'B05';

-- Pengujian ROLLBACK
START TRANSACTION;
INSERT INTO balita
    (id_balita, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
VALUES
    ('B06', '3519010101250006', 'Farah Aulia', '2025-05-18', 'P', 'Dedi Kurniawan', '081234560011');
INSERT INTO kunjungan
    (id_kunjungan, id_balita, id_jadwal, berat_badan, tinggi_badan, lingkar_kepala, vitamin_a, obat_cacing, status_gizi)
VALUES
    ('K06', 'B06', 'J03', 9.10, 69.0, 44.5, 'Tidak', 'Tidak', 'Gizi Baik');
ROLLBACK;
-- Periksa Hasil
SELECT * FROM balita    WHERE id_balita = 'B06';
SELECT * FROM kunjungan WHERE id_kunjungan = 'K06';

-- Atomicity saat salah satu operasi GAGAL
START TRANSACTION;
INSERT INTO balita
    (id_balita, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
VALUES
    ('B07', '3519010101250007', 'Gilang Ramadhan', '2025-03-03', 'L', 'Yusuf Maulana', '081234560013');
INSERT INTO kunjungan
    (id_kunjungan, id_balita, id_jadwal, berat_badan, tinggi_badan, lingkar_kepala, vitamin_a, obat_cacing, status_gizi)
VALUES
    ('K07', 'B07', 'J99', 9.50, 70.0, 45.0, 'Tidak', 'Tidak', 'Gizi Baik');   
ROLLBACK;
-- Periksa Hasil
SELECT * FROM balita WHERE id_balita = 'B07'; 

---=== ANALISIS PERFORMA DATABASE ===---
-- Tabel bantu angka 0 .. 999.999
DROP TABLE IF EXISTS angka;
DROP TABLE IF EXISTS digit_bantu;
CREATE TABLE digit_bantu (d TINYINT NOT NULL);
INSERT INTO digit_bantu VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

CREATE TABLE angka (n INT NOT NULL PRIMARY KEY);
INSERT INTO angka (n)
SELECT a.d + b.d*10 + c.d*100 + e.d*1000 + f.d*10000 + g.d*100000
FROM digit_bantu a, digit_bantu b, digit_bantu c,
     digit_bantu e, digit_bantu f, digit_bantu g;
DROP TABLE digit_bantu;

SET foreign_key_checks = 0;  
SET unique_checks = 0;

-- Balita: 500.000 baris
INSERT INTO balita (id_balita, nik, nama, tgl_lahir, jenis_kelamin, nama_ortu, no_wa_ortu)
SELECT CONCAT('BL', LPAD(n, 6, '0')),
       CONCAT('35190', LPAD(n, 11, '0')),
       CONCAT('Balita ', n),
       DATE_ADD('2023-01-01', INTERVAL (n MOD 1500) DAY),
       IF(n MOD 2 = 0, 'L', 'P'),
       CONCAT('Ortu ', n),
       CONCAT('0812', LPAD(n, 8, '0'))
FROM angka
WHERE n BETWEEN 1 AND 500000;

 -- jadwal_posyandu: 1.000 baris (harian sejak 2023-01-02)
INSERT INTO jadwal_posyandu (id_jadwal, tanggal, jam_mulai, jenis_kegiatan)
SELECT CONCAT('JD', LPAD(n, 4, '0')),
       DATE_ADD('2023-01-01', INTERVAL n DAY),
       '08:00:00',
       'Posyandu rutin, penimbangan'
FROM angka
WHERE n BETWEEN 1 AND 1000;
SET unique_checks = 1;

-- Kunjungan: 2.000.000 baris (setiap balita 4 jadwal berbeda)
INSERT INTO kunjungan
    (id_kunjungan, id_balita, id_jadwal, berat_badan, tinggi_badan,
     lingkar_kepala, vitamin_a, obat_cacing, status_gizi)
SELECT CONCAT('KV', LPAD((a.n - 1) * 4 + k.n + 1, 7, '0')),
       CONCAT('BL', LPAD(a.n, 6, '0')),
       CONCAT('JD', LPAD(((a.n + k.n * 250) MOD 1000) + 1, 4, '0')),
       ROUND(6  + (a.n MOD 90)  / 10 + k.n * 0.4, 2),
       ROUND(60 + (a.n MOD 300) / 10 + k.n * 1.5, 1),
       ROUND(40 + (a.n MOD 80)  / 10, 1),
       IF(k.n MOD 2 = 0, 'Ya', 'Tidak'),
       IF(k.n MOD 2 = 0, 'Tidak', 'Ya'),
       ELT(1 + a.n MOD 3, 'Gizi Baik', 'Berisiko Stunting', 'Stunting')
FROM angka a
JOIN angka k ON k.n BETWEEN 0 AND 3
WHERE a.n BETWEEN 1 AND 500000;

SET unique_checks = 1;
SET foreign_key_checks = 1;
DROP TABLE angka;

---PERBARUI STATISTIK TABEL---
ANALYZE TABLE balita, jadwal_posyandu, kunjungan;

---CEK JUMLAH DATA---
SELECT 'balita' AS tabel, COUNT(*) AS jumlah FROM balita
UNION ALL SELECT 'jadwal_posyandu', COUNT(*) FROM jadwal_posyandu
UNION ALL SELECT 'kunjungan', COUNT(*) FROM kunjungan;

---PENGUJIAN QUERY SEBELUM INDEX---
EXPLAIN
SELECT b.nama, j.tanggal, k.berat_badan, k.status_gizi
FROM kunjungan k
JOIN balita b          ON b.id_balita = k.id_balita
JOIN jadwal_posyandu j ON j.id_jadwal = k.id_jadwal
WHERE j.tanggal BETWEEN '2024-03-01' AND '2024-03-07'
  AND k.status_gizi = 'Stunting';
-- HASIL EKSEKUSI---
EXPLAIN ANALYZE
SELECT b.nama, j.tanggal, k.berat_badan, k.status_gizi
FROM kunjungan k
JOIN balita b          ON b.id_balita = k.id_balita
JOIN jadwal_posyandu j ON j.id_jadwal = k.id_jadwal
WHERE j.tanggal BETWEEN '2024-03-01' AND '2024-03-07'
  AND k.status_gizi = 'Stunting';

-- MEMBUAT INDEX---
CREATE INDEX idx_jadwal_tanggal          ON jadwal_posyandu (tanggal);
CREATE INDEX idx_kunjungan_jadwal_status ON kunjungan (id_jadwal, status_gizi);

-- PENGUJIAN QUERY SESUDAH INDEX---
EXPLAIN
SELECT b.nama, j.tanggal, k.berat_badan, k.status_gizi
FROM kunjungan k
JOIN balita b          ON b.id_balita = k.id_balita
JOIN jadwal_posyandu j ON j.id_jadwal = k.id_jadwal
WHERE j.tanggal BETWEEN '2024-03-01' AND '2024-03-07'
  AND k.status_gizi = 'Stunting';

-- PERIKSA INDEX
SHOW INDEX FROM jadwal_posyandu;
SHOW INDEX FROM kunjungan;

-- HASIL EKSEKUSI---
EXPLAIN ANALYZE
SELECT b.nama, j.tanggal, k.berat_badan, k.status_gizi
FROM kunjungan k
JOIN balita b          ON b.id_balita = k.id_balita
JOIN jadwal_posyandu j ON j.id_jadwal = k.id_jadwal
WHERE j.tanggal BETWEEN '2024-03-01' AND '2024-03-07'
  AND k.status_gizi = 'Stunting';







