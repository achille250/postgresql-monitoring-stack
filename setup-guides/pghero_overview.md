# pgHero — database health dashboard

pgHero provides a web UI for PostgreSQL insights: long-running queries, index usage, space, connections, and replication.

## Docker (remote database)

```bash
docker run -d --name pghero -p 8080:8080 \
  -e DATABASE_URL="postgres://monitor:CHANGE_ME@CHANGE_ME_HOST:5432/postgres" \
  ankane/pghero
```

## Recommended checks

- Unused indexes
- Duplicate indexes
- Connection count vs `max_connections`
- Replication lag (if applicable)

Use alongside Prometheus/Grafana for metrics and pgBadger for log analysis.
