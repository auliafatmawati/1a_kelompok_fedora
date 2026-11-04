-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 04, 2026 at 06:29 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `posyandu_stunting`
--
CREATE DATABASE IF NOT EXISTS `posyandu_stunting` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `posyandu_stunting`;

-- --------------------------------------------------------

--
-- Table structure for table `balita`
--

CREATE TABLE `balita` (
  `id_balita` int NOT NULL,
  `id_posyandu` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `nik` char(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tgl_lahir` date NOT NULL,
  `jenis_kelamin` enum('L','P') COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_ortu` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_wa_ortu` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jumlah_kunjungan` int NOT NULL DEFAULT '0',
  `jumlah_berisiko` int NOT NULL DEFAULT '0',
  `tgl_kunjungan_terakhir` date DEFAULT NULL,
  `rata_berat_badan` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `balita`
--

INSERT INTO `balita` (`id_balita`, `id_posyandu`, `id_pengguna`, `nik`, `nama`, `tgl_lahir`, `jenis_kelamin`, `nama_ortu`, `no_wa_ortu`, `jumlah_kunjungan`, `jumlah_berisiko`, `tgl_kunjungan_terakhir`, `rata_berat_badan`) VALUES
(1, 1, 1, '3519010101250001', 'Ananda Putra', '2025-07-15', 'L', 'Budi Santoso', '081234560001', 6, 0, '2026-10-07', 8.88),
(2, 1, 3, '3519010101240002', 'Bunga Lestari', '2024-03-10', 'P', 'Slamet Riyadi', '081234560003', 6, 4, '2026-10-07', 10.12),
(3, 1, 3, '3519010101250003', 'Citra Maharani', '2025-01-20', 'P', 'Agus Prasetyo', '081234560005', 5, 3, '2026-10-07', 8.50),
(4, 1, 3, '3519010101240004', 'Dimas Pratama', '2024-11-02', 'L', 'Eko Pratama', '081234560007', 4, 0, '2026-10-07', 11.08),
(5, 1, 2, '3519010101250005', 'Eka Safitri', '2025-04-08', 'P', 'Sri Wahyuni', '081234560009', 3, 2, '2026-10-07', 7.27),
(6, 1, 3, '3519010101260006', 'Farhan Alfarizi', '2026-09-20', 'L', 'Hendra Wijaya', '081234560011', 0, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_posyandu`
--

CREATE TABLE `jadwal_posyandu` (
  `id_jadwal` int NOT NULL,
  `id_posyandu` int NOT NULL,
  `tanggal` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jenis_kegiatan` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jadwal_posyandu`
--

INSERT INTO `jadwal_posyandu` (`id_jadwal`, `id_posyandu`, `tanggal`, `jam_mulai`, `jenis_kegiatan`) VALUES
(1, 1, '2026-05-06', '08:00:00', 'Posyandu rutin'),
(2, 1, '2026-06-03', '08:00:00', 'Posyandu rutin'),
(3, 1, '2026-07-01', '08:00:00', 'Posyandu rutin'),
(4, 1, '2026-08-05', '08:00:00', 'Posyandu rutin'),
(5, 1, '2026-09-02', '08:00:00', 'Posyandu rutin'),
(6, 1, '2026-10-07', '08:00:00', 'Posyandu rutin');

-- --------------------------------------------------------

--
-- Table structure for table `kunjungan`
--

CREATE TABLE `kunjungan` (
  `id_kunjungan` int NOT NULL,
  `id_balita` int NOT NULL,
  `id_jadwal` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `berat_badan` decimal(5,2) NOT NULL,
  `tinggi_badan` decimal(5,1) NOT NULL,
  `lingkar_kepala` decimal(4,1) DEFAULT NULL,
  `vitamin_a` enum('Ya','Tidak') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Tidak',
  `obat_cacing` enum('Ya','Tidak') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Tidak',
  `status_gizi` enum('Gizi Baik','Berisiko Stunting','Stunting') COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ;

--
-- Dumping data for table `kunjungan`
--

INSERT INTO `kunjungan` (`id_kunjungan`, `id_balita`, `id_jadwal`, `id_pengguna`, `berat_badan`, `tinggi_badan`, `lingkar_kepala`, `vitamin_a`, `obat_cacing`, `status_gizi`) VALUES
(1, 1, 1, 2, 8.10, 66.0, 44.0, 'Tidak', 'Tidak', 'Gizi Baik'),
(2, 1, 2, 2, 8.40, 67.2, 44.3, 'Tidak', 'Tidak', 'Gizi Baik'),
(3, 1, 3, 2, 8.70, 68.4, 44.6, 'Tidak', 'Tidak', 'Gizi Baik'),
(4, 1, 4, 2, 9.00, 69.5, 44.9, 'Tidak', 'Tidak', 'Gizi Baik'),
(5, 1, 5, 2, 9.40, 70.2, 45.2, 'Tidak', 'Tidak', 'Gizi Baik'),
(6, 1, 6, 2, 9.70, 71.0, 44.0, 'Tidak', 'Tidak', 'Gizi Baik'),
(7, 2, 1, 2, 9.60, 76.0, 44.3, 'Tidak', 'Tidak', 'Gizi Baik'),
(8, 2, 2, 2, 9.80, 76.8, 44.6, 'Tidak', 'Tidak', 'Gizi Baik'),
(9, 2, 3, 2, 10.00, 77.6, 44.9, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(10, 2, 4, 2, 10.20, 78.5, 45.2, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(11, 2, 5, 2, 10.40, 79.0, 44.0, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(12, 2, 6, 2, 10.70, 79.8, 44.3, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(13, 3, 2, 3, 8.20, 70.0, 44.6, 'Tidak', 'Tidak', 'Gizi Baik'),
(14, 3, 3, 3, 8.40, 70.6, 44.9, 'Tidak', 'Tidak', 'Gizi Baik'),
(15, 3, 4, 3, 8.50, 71.0, 45.2, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(16, 3, 5, 3, 8.60, 71.5, 44.0, 'Tidak', 'Tidak', 'Stunting'),
(17, 3, 6, 3, 8.80, 72.0, 44.3, 'Tidak', 'Tidak', 'Stunting'),
(18, 4, 1, 3, 10.40, 80.0, 44.6, 'Tidak', 'Tidak', 'Gizi Baik'),
(19, 4, 3, 3, 10.90, 81.5, 44.9, 'Tidak', 'Tidak', 'Gizi Baik'),
(20, 4, 4, 3, 11.20, 82.2, 45.2, 'Tidak', 'Tidak', 'Gizi Baik'),
(21, 4, 6, 3, 11.80, 83.4, 44.0, 'Tidak', 'Tidak', 'Gizi Baik'),
(22, 5, 4, 2, 7.00, 64.0, 44.3, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(23, 5, 5, 2, 7.20, 64.5, 44.6, 'Tidak', 'Tidak', 'Berisiko Stunting'),
(24, 5, 6, 2, 7.60, 65.4, 44.9, 'Tidak', 'Tidak', 'Gizi Baik');

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id_notif` int NOT NULL,
  `id_balita` int NOT NULL,
  `jenis` enum('Jadwal','Hasil') COLLATE utf8mb4_unicode_ci NOT NULL,
  `kanal` enum('WhatsApp','Push') COLLATE utf8mb4_unicode_ci NOT NULL,
  `waktu_kirim` datetime NOT NULL,
  `status_kirim` enum('Antre','Terkirim','Gagal') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Antre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `id_posyandu` int NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('Ketua Posyandu','Anggota BKB','Kader','Petugas Puskesmas') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Kader',
  `hak_koreksi` tinyint(1) GENERATED ALWAYS AS ((`role` in (_utf8mb4'Ketua Posyandu',_utf8mb4'Anggota BKB'))) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `id_posyandu`, `nama`, `username`, `password_hash`, `role`) VALUES
(1, 1, 'Siti Aminah', 'siti.aminah', '123456', 'Ketua Posyandu'),
(2, 1, 'Dewi Lestari', 'dewi.lestari', '654321', 'Kader'),
(3, 1, 'Nur Hidayati', 'nur.hidayati', '678910', 'Kader');

-- --------------------------------------------------------

--
-- Table structure for table `posyandu`
--

CREATE TABLE `posyandu` (
  `id_posyandu` int NOT NULL,
  `nama_posyandu` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dusun` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `desa` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kecamatan` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posyandu`
--

INSERT INTO `posyandu` (`id_posyandu`, `nama_posyandu`, `dusun`, `desa`, `kecamatan`) VALUES
(1, 'Posyandu ILP Dukuh Mranggen', 'Mranggen', 'Joho', 'Dagangan');

-- --------------------------------------------------------

--
-- Table structure for table `rekap_bulanan`
--

CREATE TABLE `rekap_bulanan` (
  `id_rekap` int NOT NULL,
  `id_posyandu` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `bulan` tinyint NOT NULL,
  `tahun` smallint NOT NULL,
  `status_serah` enum('Belum','Diserahkan','Diterima') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Belum',
  `jumlah_ditimbang` int NOT NULL DEFAULT '0',
  `jumlah_berisiko` int NOT NULL DEFAULT '0',
  `jumlah_stunting` int NOT NULL DEFAULT '0',
  `tgl_dihitung` datetime DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `rujukan`
--

CREATE TABLE `rujukan` (
  `id_rujukan` int NOT NULL,
  `id_kunjungan` int NOT NULL,
  `tgl_rujukan` date NOT NULL,
  `puskesmas_tujuan` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rekomendasi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_tindak_lanjut` enum('Dirujuk','Surat Terbit','Disampaikan ke Orang Tua','Selesai') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Dirujuk'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `balita`
--
ALTER TABLE `balita`
  ADD PRIMARY KEY (`id_balita`),
  ADD UNIQUE KEY `uq_balita_nik` (`nik`),
  ADD KEY `fk_balita_posyandu` (`id_posyandu`),
  ADD KEY `fk_balita_pengguna` (`id_pengguna`),
  ADD KEY `idx_balita_nama` (`nama`);

--
-- Indexes for table `jadwal_posyandu`
--
ALTER TABLE `jadwal_posyandu`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD UNIQUE KEY `uq_jadwal_posyandu_tanggal` (`id_posyandu`,`tanggal`);

--
-- Indexes for table `kunjungan`
--
ALTER TABLE `kunjungan`
  ADD PRIMARY KEY (`id_kunjungan`),
  ADD UNIQUE KEY `uq_kunjungan_balita_jadwal` (`id_balita`,`id_jadwal`),
  ADD KEY `fk_kunjungan_jadwal` (`id_jadwal`),
  ADD KEY `fk_kunjungan_pengguna` (`id_pengguna`),
  ADD KEY `idx_kunjungan_status` (`status_gizi`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id_notif`),
  ADD KEY `fk_notifikasi_balita` (`id_balita`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `uq_pengguna_username` (`username`),
  ADD KEY `fk_pengguna_posyandu` (`id_posyandu`);

--
-- Indexes for table `posyandu`
--
ALTER TABLE `posyandu`
  ADD PRIMARY KEY (`id_posyandu`);

--
-- Indexes for table `rekap_bulanan`
--
ALTER TABLE `rekap_bulanan`
  ADD PRIMARY KEY (`id_rekap`),
  ADD UNIQUE KEY `uq_rekap_periode` (`id_posyandu`,`tahun`,`bulan`),
  ADD KEY `fk_rekap_pengguna` (`id_pengguna`);

--
-- Indexes for table `rujukan`
--
ALTER TABLE `rujukan`
  ADD PRIMARY KEY (`id_rujukan`),
  ADD UNIQUE KEY `uq_rujukan_kunjungan` (`id_kunjungan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `balita`
--
ALTER TABLE `balita`
  MODIFY `id_balita` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `jadwal_posyandu`
--
ALTER TABLE `jadwal_posyandu`
  MODIFY `id_jadwal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `kunjungan`
--
ALTER TABLE `kunjungan`
  MODIFY `id_kunjungan` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id_notif` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `posyandu`
--
ALTER TABLE `posyandu`
  MODIFY `id_posyandu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `rekap_bulanan`
--
ALTER TABLE `rekap_bulanan`
  MODIFY `id_rekap` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rujukan`
--
ALTER TABLE `rujukan`
  MODIFY `id_rujukan` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `balita`
--
ALTER TABLE `balita`
  ADD CONSTRAINT `fk_balita_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_balita_posyandu` FOREIGN KEY (`id_posyandu`) REFERENCES `posyandu` (`id_posyandu`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `jadwal_posyandu`
--
ALTER TABLE `jadwal_posyandu`
  ADD CONSTRAINT `fk_jadwal_posyandu` FOREIGN KEY (`id_posyandu`) REFERENCES `posyandu` (`id_posyandu`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `kunjungan`
--
ALTER TABLE `kunjungan`
  ADD CONSTRAINT `fk_kunjungan_balita` FOREIGN KEY (`id_balita`) REFERENCES `balita` (`id_balita`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_kunjungan_jadwal` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_posyandu` (`id_jadwal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_kunjungan_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `fk_notifikasi_balita` FOREIGN KEY (`id_balita`) REFERENCES `balita` (`id_balita`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD CONSTRAINT `fk_pengguna_posyandu` FOREIGN KEY (`id_posyandu`) REFERENCES `posyandu` (`id_posyandu`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `rekap_bulanan`
--
ALTER TABLE `rekap_bulanan`
  ADD CONSTRAINT `fk_rekap_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rekap_posyandu` FOREIGN KEY (`id_posyandu`) REFERENCES `posyandu` (`id_posyandu`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `rujukan`
--
ALTER TABLE `rujukan`
  ADD CONSTRAINT `fk_rujukan_kunjungan` FOREIGN KEY (`id_kunjungan`) REFERENCES `kunjungan` (`id_kunjungan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
