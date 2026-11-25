--Plan A
EXPLAIN (ANALYZE, BUFFERS)
WITH j AS MATERIALIZED (
    SELECT t.trip_id, t.started_at, t.route_id, r.route_name
    FROM   trips t JOIN routes r ON r.route_id = t.route_id
)
SELECT trip_id, started_at, route_name
FROM   j
WHERE  route_id = 12 AND started_at >= '2026-11-01';

--Plan B
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT t.trip_id, t.started_at, r.route_name
FROM   trips t JOIN routes r ON r.route_id = t.route_id
WHERE  t.route_id = 12 AND t.started_at >= '2026-11-01';

-- tanpa indeks tambahan (selain indeks otomatis hypertable pada started_at)
EXPLAIN (ANALYZE, BUFFERS) SELECT ... ;   -- query 1.5

CREATE INDEX idx_trips_route_time ON trips (route_id, started_at DESC);
ANALYZE trips;

EXPLAIN (ANALYZE, BUFFERS) SELECT ... ;   -- ulangi query yang sama
