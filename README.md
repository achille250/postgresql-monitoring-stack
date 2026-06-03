# PostgreSQL Monitoring Stack

End-to-end observability for PostgreSQL: **Prometheus** + **postgres_exporter**, **Grafana** dashboards, **pgBadger** log reports, **pgHero** health checks, and operational SQL for workload monitoring.

**Author:** [Achille Cesar Ntwali](https://github.com/achille250) · Kigali, Rwanda

---

## Overview

Templates and scripts to deploy a standard monitoring pipeline for mission-critical PostgreSQL instances. Monitoring users should follow least privilege (`pg_monitor`, not superuser).

---

## Repository structure

```
postgresql-monitoring-stack/
├── setup-guides/
│   ├── prometheus_installation.md      # Prometheus install & systemd
│   ├── grafana_installation.md         # Grafana OSS on Linux
│   ├── postgres_exporter_setup.md      # Exporter + scrape config
│   ├── pgbadger_automated_reports.sh   # Sync logs & generate HTML reports
│   ├── pgbadger_notes.txt
│   └── pghero_overview.md              # pgHero Docker / health checks
└── sql/
    ├── connection_activity.sql         # Active/idle sessions, connection limits
    └── business_activity_monitoring.sql # Transaction volume by period/type
```

---

## Quick start

### 1. Prometheus + postgres_exporter

Follow `setup-guides/postgres_exporter_setup.md`, then add to `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: postgres_exporter
    static_configs:
      - targets: ['localhost:9187']
```

### 2. Grafana

Install per `setup-guides/grafana_installation.md`, import dashboard **9628** (PostgreSQL Database).

### 3. pgBadger (scheduled)

```bash
chmod +x setup-guides/pgbadger_automated_reports.sh
# Edit REMOTE_HOST, paths, then cron daily
```

### 4. Operational SQL

```bash
psql -f sql/connection_activity.sql
psql -f sql/business_activity_monitoring.sql
```

---

## Related repositories

| Repo | Focus |
|------|--------|
| [postgresql-ha-replication](https://github.com/achille250/postgresql-ha-replication) | Replication monitoring queries |
| [postgresql-performance-tuning](https://github.com/achille250/postgresql-performance-tuning) | Slow queries, indexes |
| [postgresql-security-rbac](https://github.com/achille250/postgresql-security-rbac) | Audit logging |