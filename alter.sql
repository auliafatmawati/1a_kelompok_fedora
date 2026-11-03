ALTER TABLE balita ADD COLUMN jumlah_kunjungan       INT          NOT NULL DEFAULT 0;
ALTER TABLE balita ADD COLUMN jumlah_berisiko        INT          NOT NULL DEFAULT 0;
ALTER TABLE balita ADD COLUMN tgl_kunjungan_terakhir DATE         NULL;
ALTER TABLE balita ADD COLUMN rata_berat_badan       DECIMAL(5,2) NULL;

UPDATE balita SET
  jumlah_kunjungan = (SELECT COUNT(*) FROM kunjungan k
                      WHERE k.id_balita = balita.id_balita),
  jumlah_berisiko  = (SELECT COUNT(*) FROM kunjungan k
                      WHERE k.id_balita = balita.id_balita
                        AND k.status_gizi IN ('Berisiko Stunting','Stunting')),
  tgl_kunjungan_terakhir = (SELECT MAX(j.tanggal) FROM kunjungan k
                            JOIN jadwal_posyandu j ON j.id_jadwal = k.id_jadwal
                            WHERE k.id_balita = balita.id_balita),
  rata_berat_badan = (SELECT ROUND(AVG(k.berat_badan), 2) FROM kunjungan k
                      WHERE k.id_balita = balita.id_balita);
