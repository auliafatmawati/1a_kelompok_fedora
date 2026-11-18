-- 1. POSYANDU 
CREATE TABLE posyandu (
  id_posyandu    INT(10) AUTO_INCREMENT NOT NULL,
  nama_posyandu  VARCHAR(100) NOT NULL,
  dusun          VARCHAR(50),
  desa           VARCHAR(50),
  kecamatan      VARCHAR(50),
  CONSTRAINT pk_posyandu PRIMARY KEY (id_posyandu)
) ENGINE=InnoDB;
 
-- 2. PENGGUNA 
CREATE TABLE pengguna (
  id_pengguna    INT(10) AUTO_INCREMENT NOT NULL,
  id_posyandu    INT(10) NOT NULL,
  nama           VARCHAR(100) NOT NULL,
  username       VARCHAR(50)  NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  role           ENUM('Ketua Posyandu','Anggota BKB','Kader','Petugas Puskesmas')
                 NOT NULL DEFAULT 'Kader',
  hak_koreksi    TINYINT(1) GENERATED ALWAYS AS (role IN ('Ketua Posyandu','Anggota BKB')) STORED,
  CONSTRAINT pk_pengguna PRIMARY KEY (id_pengguna),
  CONSTRAINT uq_pengguna_username UNIQUE (username),
  CONSTRAINT fk_pengguna_posyandu FOREIGN KEY (id_posyandu) REFERENCES posyandu (id_posyandu)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
-- 3. BALITA 
CREATE TABLE balita (
  id_balita      INT(10) AUTO_INCREMENT NOT NULL,
  id_posyandu    INT(10) NOT NULL,
  id_pengguna    INT(10) NOT NULL,
  nik            CHAR(16),
  nama           VARCHAR(100) NOT NULL,
  tgl_lahir      DATE         NOT NULL,
  jenis_kelamin  ENUM('L','P') NOT NULL,
  nama_ortu      VARCHAR(100) NOT NULL,
  no_wa_ortu     VARCHAR(20),
  CONSTRAINT pk_balita PRIMARY KEY (id_balita),
  CONSTRAINT uq_balita_nik UNIQUE (nik),
  CONSTRAINT fk_balita_posyandu FOREIGN KEY (id_posyandu) REFERENCES posyandu (id_posyandu)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_balita_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
-- 4. JADWAL_POSYANDU
CREATE TABLE jadwal_posyandu (
  id_jadwal       INT(10) AUTO_INCREMENT NOT NULL,
  id_posyandu     INT(10) NOT NULL,
  tanggal         DATE         NOT NULL,
  jam_mulai       TIME         NOT NULL,
  jenis_kegiatan  VARCHAR(100) NOT NULL,
  CONSTRAINT pk_jadwal PRIMARY KEY (id_jadwal),
  CONSTRAINT uq_jadwal_posyandu_tanggal UNIQUE (id_posyandu, tanggal),
  CONSTRAINT fk_jadwal_posyandu FOREIGN KEY (id_posyandu) REFERENCES posyandu (id_posyandu)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
-- 5. KUNJUNGAN 
CREATE TABLE kunjungan (
  id_kunjungan    INT(10) AUTO_INCREMENT NOT NULL,
  id_balita       INT(10) NOT NULL,
  id_jadwal       INT(10) NOT NULL,
  id_pengguna     INT(10) NOT NULL,
  berat_badan     DECIMAL(5,2) NOT NULL,
  tinggi_badan    DECIMAL(5,1) NOT NULL,
  lingkar_kepala  DECIMAL(4,1),
  vitamin_a       ENUM('Ya','Tidak') NOT NULL DEFAULT 'Tidak',
  obat_cacing     ENUM('Ya','Tidak') NOT NULL DEFAULT 'Tidak',
  status_gizi     ENUM('Gizi Baik','Berisiko Stunting','Stunting'),
  CONSTRAINT pk_kunjungan PRIMARY KEY (id_kunjungan),
  CONSTRAINT uq_kunjungan_balita_jadwal UNIQUE (id_balita, id_jadwal),
  CONSTRAINT ck_kunjungan_bb CHECK (berat_badan > 0),
  CONSTRAINT ck_kunjungan_tb CHECK (tinggi_badan > 0),
  CONSTRAINT fk_kunjungan_balita FOREIGN KEY (id_balita) REFERENCES balita (id_balita)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_kunjungan_jadwal FOREIGN KEY (id_jadwal) REFERENCES jadwal_posyandu (id_jadwal)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_kunjungan_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
-- 6. RUJUKAN 
CREATE TABLE rujukan (
  id_rujukan            INT(10) AUTO_INCREMENT NOT NULL,
  id_kunjungan          INT(10) NOT NULL,
  tgl_rujukan           DATE         NOT NULL,
  puskesmas_tujuan      VARCHAR(100) NOT NULL,
  rekomendasi           VARCHAR(255),
  status_tindak_lanjut  ENUM('Dirujuk','Surat Terbit','Disampaikan ke Orang Tua','Selesai')
                        NOT NULL DEFAULT 'Dirujuk',
  CONSTRAINT pk_rujukan PRIMARY KEY (id_rujukan),
  CONSTRAINT uq_rujukan_kunjungan UNIQUE (id_kunjungan),
  CONSTRAINT fk_rujukan_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
 
-- 7. REKAP_BULANAN 
CREATE TABLE rekap_bulanan (
  id_rekap          INT(10) AUTO_INCREMENT NOT NULL,
  id_posyandu       INT(10) NOT NULL,
  id_pengguna       INT(10) NOT NULL,
  bulan             TINYINT     NOT NULL,
  tahun             SMALLINT    NOT NULL,
  status_serah      ENUM('Belum','Diserahkan','Diterima') NOT NULL DEFAULT 'Belum',
  jumlah_ditimbang  INT         NOT NULL DEFAULT 0,
  jumlah_berisiko   INT         NOT NULL DEFAULT 0,
  jumlah_stunting   INT         NOT NULL DEFAULT 0,
  tgl_dihitung      DATETIME,
  CONSTRAINT pk_rekap PRIMARY KEY (id_rekap),
  CONSTRAINT uq_rekap_periode UNIQUE (id_posyandu, tahun, bulan),
  CONSTRAINT ck_rekap_bulan CHECK (bulan BETWEEN 1 AND 12),
  CONSTRAINT fk_rekap_posyandu FOREIGN KEY (id_posyandu) REFERENCES posyandu (id_posyandu)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rekap_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
 
-- 8. NOTIFIKASI 
CREATE TABLE notifikasi (
  id_notif      INT(10) AUTO_INCREMENT NOT NULL,
  id_balita     INT(10) NOT NULL,
  jenis         ENUM('Jadwal','Hasil') NOT NULL,
  kanal         ENUM('WhatsApp','Push') NOT NULL,
  waktu_kirim   DATETIME    NOT NULL,
  status_kirim  ENUM('Antre','Terkirim','Gagal') NOT NULL DEFAULT 'Antre',
  CONSTRAINT pk_notifikasi PRIMARY KEY (id_notif),
  CONSTRAINT fk_notifikasi_balita FOREIGN KEY (id_balita) REFERENCES balita (id_balita)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
 

