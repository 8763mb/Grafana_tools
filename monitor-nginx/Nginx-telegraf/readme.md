# Telegraf Setup for Traditional Metrics

This guide explains how to set up Telegraf to export traditional metrics such as CPU, RAM, response times, and more.

## Overview

Telegraf is a server-based agent for collecting, processing, aggregating, and writing metrics. This setup configures it to export metrics to Prometheus format.

## Installation

Extract the Telegraf package and copy the necessary files:

```bash
# Extract Telegraf package
tar -xvf telegraf-1.33.1_linux_amd64.tar.gz

# Copy binary and configuration
cp ./telegraf-1.33.1/usr/bin/telegraf /usr/bin
mkdir -p /etc/telegraf
cp ./telegraf-1.33.1/etc/telegraf/telegraf.conf /etc/telegraf/
```

## Configuration

### 1. Create systemd service file

Create a systemd service file to manage Telegraf:

```bash
vi /etc/systemd/system/telegraf.service
```

Add the following content:

```ini
[Unit]
Description=Telegraf agent
Documentation=https://github.com/influxdata/telegraf
After=network.target

[Service]
ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
```

### 2. Configure Telegraf

Edit the Telegraf configuration file:

```bash
vi /etc/telegraf/telegraf.conf
```

Replace the content with:

```toml
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = "0s"

[[outputs.prometheus_client]]
  listen = ":9273"
  metric_version = 2

[[inputs.nginx]]
  urls = ["http://localhost:8080/stub_status"]
  response_timeout = "5s"

[[inputs.tail]]
  name_override = "nginxlog"
  files = ["/var/log/nginx/access.log"]
  from_beginning = false
  pipe = false
  data_format = "grok"
  grok_patterns = ["%{COMBINED_LOG_FORMAT}"]

[[inputs.cpu]]
  percpu = true

[[inputs.disk]]

[[inputs.diskio]]

[[inputs.mem]]

[[inputs.net]]

[[inputs.system]]
```

## Set Permissions

Ensure Telegraf has access to the Nginx log file:

```bash
chmod 644 /var/log/nginx/access.log
```

## Start and Enable the Service

```bash
# Reload systemd configuration
systemctl daemon-reload

# Start Telegraf service
systemctl start telegraf.service

# Check service status
systemctl status telegraf.service

# Enable service to start on boot
systemctl enable telegraf.service
```

## Verify Metrics

Confirm metrics are being exported correctly:

```bash
curl http://127.0.0.1:9273/metrics
```

## Troubleshooting

If you need to stop or reset the service:

```bash
# Reset failed service
systemctl reset-failed telegraf.service

# Reload daemon
systemctl daemon-reload
```

## Grafana dashboard exmaple
<img width="937" alt="image" src="https://github.com/user-attachments/assets/1fff4833-89da-4641-bd0d-9d69cf65a44c" />


## Collected Metrics

This setup collects the following metrics:

- **System Performance**: CPU, memory, disk I/O, and network statistics
- **Nginx**: Server status metrics and access log analytics
- **System**: Overall system metrics and status information

All metrics are exposed via Prometheus endpoint on port 9273.
