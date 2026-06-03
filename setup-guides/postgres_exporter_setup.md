# PostgreSQL Exporter + Prometheus (template)

Sanitized setup guide for monitoring PostgreSQL with [postgres_exporter](https://github.com/prometheus-community/postgres_exporter).

## 1. Install exporter

```bash
cd /opt/postgres_exporter
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.15.0/postgres_exporter-0.15.0.linux-amd64.tar.gz
tar xvfz postgres_exporter-0.15.0.linux-amd64.tar.gz
sudo mv postgres_exporter-0.15.0.linux-amd64/postgres_exporter /usr/local/bin/
sudo useradd --no-create-home --shell /usr/sbin/nologin postgres_exporter
sudo chown postgres_exporter:postgres_exporter /usr/local/bin/postgres_exporter
```

## 2. Create least-privilege monitoring role

```sql
CREATE ROLE postgres_exporter WITH LOGIN PASSWORD 'CHANGE_ME_STRONG_PASSWORD';
GRANT pg_monitor TO postgres_exporter;
-- Avoid SUPERUSER in production; use pg_monitor + targeted grants
```

## 3. Connection string (systemd environment)

```ini
# /etc/default/postgres_exporter
DATA_SOURCE_NAME="postgresql://postgres_exporter:CHANGE_ME@127.0.0.1:5432/postgres?sslmode=disable"
```

## 4. systemd unit

```ini
[Unit]
Description=PostgreSQL Exporter
After=network.target

[Service]
User=postgres_exporter
EnvironmentFile=/etc/default/postgres_exporter
ExecStart=/usr/local/bin/postgres_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now postgres_exporter
```

## 5. Prometheus scrape config

```yaml
scrape_configs:
  - job_name: postgres_exporter
    static_configs:
      - targets: ['localhost:9187']
```

## 6. Grafana

Import dashboard ID **9628** (PostgreSQL Database) or organization-standard dashboards.

## Security checklist

- [ ] Dedicated monitoring user (not superuser)
- [ ] SCRAM password encryption on PostgreSQL 14+
- [ ] Firewall: metrics port not exposed publicly
- [ ] TLS for remote database connections where applicable
