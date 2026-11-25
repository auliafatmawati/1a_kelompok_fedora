create database transport_db;
CREATE TABLE routes (route_id INT PRIMARY KEY, route_name TEXT);
CREATE TABLE trips (trip_id TEXT, route_id INT, started_at TIMESTAMPTZ NOT NULL, status TEXT);
SELECT create_hypertable('trips', 'started_at');
INSERT INTO routes VALUES
	(12, 'Koridor Pusat–Terminal'),
	(15, 'Koridor Kampus–Stasiun'),
	(18, 'Koridor Pasar–Kota');
INSERT INTO trips VALUES
 ('T001', 12, '2026-11-02 07:10:00+07', 'completed'),
 ('T003', 12, '2026-11-03 08:05:00+07', 'delayed'),
 ('T004', 18, '2026-10-29 06:50:00+07', 'completed'),
 ('T005', 12, '2026-11-05 17:20:00+07', 'completed');
Pengujian :
SELECT t.trip_id, t.started_at, r.route_name
FROM trips t JOIN routes r ON t.route_id = r.route_id
WHERE t.route_id = 12 AND t.started_at >= '2026-11-01';

