SELECT b.id_balita,
       b.nama,
       COUNT(k.id_kunjungan)                                   AS jumlah_kunjungan,
       COALESCE(SUM(CASE WHEN k.status_gizi IN ('Berisiko Stunting','Stunting')
                         THEN 1 ELSE 0 END), 0)                AS jumlah_berisiko,
       MAX(j.tanggal)                                          AS tgl_kunjungan_terakhir,
       ROUND(AVG(k.berat_badan), 2)                            AS rata_berat_badan
FROM balita b
LEFT JOIN kunjungan k        ON k.id_balita = b.id_balita
LEFT JOIN jadwal_posyandu j  ON j.id_jadwal = k.id_jadwal
GROUP BY b.id_balita, b.nama
ORDER BY b.id_balita;
