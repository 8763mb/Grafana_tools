# NGINX Prometheus Exporter Setup Guide

This guide provides step-by-step instructions for setting up the NGINX Prometheus Exporter to monitor your NGINX instances.

## Installation

```bash
# Move the exporter binary to the proper location
sudo mv nginx-prometheus-exporter /usr/local/bin/

# Make the exporter executable
sudo chmod +x /usr/local/bin/nginx-prometheus-exporter
```

## Verification

Check that the exporter is properly installed:

```bash
nginx-prometheus-exporter -version
```

Expected output:
```
the flag format is deprecated and will be removed in a future release, please use the new format: --version
nginx_exporter, version 1.4.0 (branch: HEAD, revision: eb921f6062ff814acf8913cade92def952dfbe2e)
  build user:       goreleaser
  build date:       2024-12-04T11:55:36Z
  go version:       go1.23.3
  platform:         linux/amd64
  tags:             unknown
```

## NGINX Configuration

### Verify NGINX Stub Status Module

First, verify that NGINX was built with the required `stub_status` module:

```bash
nginx -V 2>&1 | grep -o with-http_stub_status_module
```

### Configure NGINX Stub Status Endpoint

Create a new configuration file:

```bash
sudo vi /etc/nginx/conf.d/status.conf
```

Add the following content:

```nginx
server {
    listen 8080;
    
    location /stub_status {
        stub_status;
        allow 127.0.0.1;  # Only allow local access, or add Prometheus server IP
        deny all;
    }
}
```

Remember to reload NGINX after making these changes:

```bash
sudo systemctl reload nginx
```

## Exporter Service Configuration

Create a systemd service file for the exporter:

```bash
sudo vi /etc/systemd/system/nginx-prometheus-exporter.service
```

Add the following content:

```ini
[Unit]
Description=NGINX Prometheus Exporter
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/nginx-prometheus-exporter -nginx.scrape-uri=http://localhost:8080/stub_status
Restart=always

[Install]
WantedBy=multi-user.target
```

## Start and Enable the Service

```bash
# Reload systemd configuration
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable nginx-prometheus-exporter

# Start the service
sudo systemctl start nginx-prometheus-exporter
```

## Test the Exporter

Verify that the exporter is serving metrics:

```bash
curl http://localhost:9113/metrics
```

## Prometheus Configuration

Add the following job to your Prometheus configuration:

```yaml
- job_name: 'nginx'
  static_configs:
  - targets: ['IP:PORT', 'IP:PORT', 'IP:PORT']
```

Replace `IP:PORT` with the actual IP addresses and ports of your NGINX exporter instances.

After updating the configuration, reload Prometheus:

```bash
sudo systemctl reload prometheus
```

## Summary

This setup enables monitoring of NGINX instances using Prometheus. Key components include:

1. NGINX with stub_status module enabled
2. NGINX Prometheus Exporter
3. Prometheus configuration to scrape metrics

Once configured, metrics will be available in Prometheus and can be visualized using Grafana or other compatible dashboarding tools.