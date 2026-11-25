-- Cabut akses default
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;

-- Buat akun
CREATE ROLE report_user   LOGIN PASSWORD 'report123';
CREATE ROLE operator_user LOGIN PASSWORD 'operator123';

-- Izin dasar koneksi
GRANT CONNECT ON DATABASE transport_db TO report_user, operator_user;
GRANT USAGE   ON SCHEMA public         TO report_user, operator_user;

-- Staf Pelaporan: HANYA baca
GRANT SELECT ON routes, trips TO report_user;

-- Operator Lapangan: baca routes, kelola trips
GRANT SELECT                         ON routes TO operator_user;
GRANT SELECT, INSERT, UPDATE         ON trips  TO operator_user;
-- sengaja tanpa DELETE, DROP, TRUNCATE


--Pengujian
-- Uji report_user
SET ROLE report_user;
SELECT trip_id, started_at FROM trips WHERE route_id = 12 LIMIT 5;      -- BERHASIL

INSERT INTO trips VALUES (999999, 12, 1, now(), NULL, 'ongoing', 0);    -- DITOLAK
UPDATE trips SET status = 'cancelled' WHERE trip_id = 1;                -- DITOLAK
DELETE FROM trips WHERE trip_id = 1;                                    -- DITOLAK
RESET ROLE;

-- Uji operator_user
SET ROLE operator_user;
UPDATE trips
SET status = 'completed'
WHERE trip_id = '1'
  AND started_at = (
    SELECT started_at
    FROM trips
    WHERE trip_id = '1'
    ORDER BY started_at DESC
    LIMIT 1
  );  -- BERHASIL
DELETE FROM trips WHERE trip_id = 1;                                    -- DITOLAK
UPDATE routes SET route_name = 'X' WHERE route_id = 1;                  -- DITOLAK
RESET ROLE;


REVOKE SELECT ON trips FROM report_user;

SET ROLE report_user;
SELECT * FROM trips LIMIT 1;     -- sekarang DITOLAK: permission denied for table trips
RESET ROLE;

-- Pulihkan
GRANT SELECT ON trips TO report_user;

--Uji Hak Akses
SELECT grantee, table_name, privilege_type
FROM   information_schema.role_table_grants
WHERE  grantee IN ('report_user','operator_user')
  AND  table_name IN ('trips','routes')
ORDER  BY grantee, table_name, privilege_type;
