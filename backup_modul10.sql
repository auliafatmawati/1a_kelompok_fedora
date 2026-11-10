-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 10, 2026 at 03:48 AM
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
-- Database: `praktikum_modul10`
--

-- --------------------------------------------------------

--
-- Table structure for table `balita`
--

CREATE TABLE `balita` (
  `id_balita` varchar(10) NOT NULL,
  `nik` char(16) DEFAULT NULL,
  `nama` varchar(100) NOT NULL,
  `tgl_lahir` date NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `nama_ortu` varchar(100) NOT NULL,
  `no_wa_ortu` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_posyandu`
--

CREATE TABLE `jadwal_posyandu` (
  `id_jadwal` varchar(10) NOT NULL,
  `tanggal` date NOT NULL,
  `jam_mulai` time NOT NULL,
  `jenis_kegiatan` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kunjungan`
--

CREATE TABLE `kunjungan` (
  `id_kunjungan` varchar(10) NOT NULL,
  `id_balita` varchar(10) NOT NULL,
  `id_jadwal` varchar(10) NOT NULL,
  `berat_badan` decimal(5,2) NOT NULL,
  `tinggi_badan` decimal(5,1) NOT NULL,
  `lingkar_kepala` decimal(4,1) DEFAULT NULL,
  `vitamin_a` enum('Ya','Tidak') NOT NULL DEFAULT 'Tidak',
  `obat_cacing` enum('Ya','Tidak') NOT NULL DEFAULT 'Tidak',
  `status_gizi` enum('Gizi Baik','Berisiko Stunting','Stunting') DEFAULT NULL
) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `balita`
--
ALTER TABLE `balita`
  ADD PRIMARY KEY (`id_balita`),
  ADD UNIQUE KEY `nik` (`nik`),
  ADD KEY `idx_balita_tgl_lahir` (`tgl_lahir`);

--
-- Indexes for table `jadwal_posyandu`
--
ALTER TABLE `jadwal_posyandu`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD KEY `idx_jadwal_tanggal` (`tanggal`);

--
-- Indexes for table `kunjungan`
--
ALTER TABLE `kunjungan`
  ADD PRIMARY KEY (`id_kunjungan`),
  ADD UNIQUE KEY `id_balita` (`id_balita`,`id_jadwal`),
  ADD KEY `idx_kunjungan_jadwal_status` (`id_jadwal`,`status_gizi`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kunjungan`
--
ALTER TABLE `kunjungan`
  ADD CONSTRAINT `fk_kunjungan_balita` FOREIGN KEY (`id_balita`) REFERENCES `balita` (`id_balita`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_kunjungan_jadwal` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_posyandu` (`id_jadwal`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
