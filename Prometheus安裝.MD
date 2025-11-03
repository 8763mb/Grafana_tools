1. 建立使用者與群組
sudo groupadd --system prometheus
sudo useradd --system --no-create-home --shell /sbin/nologin -g prometheus prometheus

2. 下載並解壓軟體包(3.5.0)
wget https://github.com/prometheus/prometheus/releases/download/v3.5.0/prometheus-3.5.0.linux-amd64.tar.gz

tar xvfz prometheus-3.5.0.linux-amd64.tar.gz
cd prometheus-3.5.0.linux-amd64


3. 安裝二進位檔與配置檔
sudo mv prometheus promtool /usr/local/bin/
sudo mkdir -p /etc/prometheus
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mkdir -p /var/lib/prometheus

備註: 在 Prometheus 3.0開始，官方確實已經移除了 consoles/ 和 console_libraries/ 這兩個資料夾。

4. 設定權限
sudo chown -R prometheus:prometheus /etc/prometheus
sudo mkdir -p /var/lib/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
