# Create a Prometheus user with no home directory and no shell
sudo useradd --no-create-home --shell /bin/false prometheus

# Create directories for Prometheus configuration and data storage
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Navigate to /U02/prometheus (or any directory you prefer to download the files)
cd /U02/prometheus

# Download the latest version of Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.31.1/prometheus-2.31.1.linux-amd64.tar.gz

# Extract the downloaded archive
tar xvf prometheus-2.31.1.linux-amd64.tar.gz

# Move the binaries to /usr/local/bin
sudo mv prometheus-2.31.1.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.31.1.linux-amd64/promtool /usr/local/bin/

# Move the console libraries and templates to /etc/prometheus
sudo mv prometheus-2.31.1.linux-amd64/consoles /etc/prometheus
sudo mv prometheus-2.31.1.linux-amd64/console_libraries /etc/prometheus

# Set ownership of the directories to the Prometheus user
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Create the Prometheus configuration file
sudo nano /etc/prometheus/prometheus.yml

global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

# Create the Prometheus systemd service file
sudo nano /etc/systemd/system/prometheus.service

[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Start Prometheus service
sudo systemctl start prometheus

# Enable Prometheus service to start on boot
sudo systemctl enable prometheus
