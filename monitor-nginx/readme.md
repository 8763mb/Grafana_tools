# NGINX 監控解決方案

本專案提供了一個完整的解決方案，用於使用 Prometheus、Grafana 和兩種不同的收集方法來監控 NGINX 網頁伺服器：NGINX Prometheus Exporter 和 Telegraf。

## 概述

本專案提供了兩種互補的方法來監控 NGINX 伺服器，後續有兩種面板相容的做法:

1. **NGINX Prometheus Exporter**：專注於核心 NGINX 指標，如連接數、請求數和狀態碼
2. **Telegraf**：提供更廣泛的系統指標（CPU、RAM、網路流量）以及 NGINX 資料

## 專案結構

```
monitor-nginx/
├── Nginx-exporter/
│   └── readme.md         # NGINX Prometheus Exporter 的設置說明
├── Nginx-telegraf/
│   ├── Grafana_dashboard.json       # 原始 Grafana 儀表板配置
│   ├── Grafana_dashboard_new.json   # 更新的 Grafana 儀表板，更改記憶體顯示邏輯
│   └── readme.md                    # Telegraf 的設置說明
└── readme.md             # 本文件
```

## 功能特點

### NGINX Prometheus Exporter
- 輕量級 Go 應用程式，以 Prometheus 格式匯出 NGINX 指標
- 捕獲核心 NGINX 指標：
  - 已接受的連接總數
  - 正在處理的連接
  - 已處理的請求總數
  - 回應狀態碼（2xx、3xx、4xx、5xx）
- 只需最小化配置 NGINX stub_status 模組

### Telegraf 代理
- 收集全面的系統指標以及 NGINX 資料
- 提供以下洞見：
  - CPU、RAM 和磁碟使用率
  - 網路流量和吞吐量
  - NGINX 日誌解析，獲取詳細的請求分析
  - 系統效能指標
- 以 Prometheus 格式輸出資料，用於 Grafana 視覺化

## 安裝選項

### 選項 1：NGINX Prometheus Exporter

用於基本的 NGINX 指標監控：

1. 按照 `Nginx-exporter/readme.md` 中的設置說明進行操作
2. 配置您的 Prometheus 伺服器以抓取 exporter 資料
3. 匯入相容的 Grafana 儀表板進行視覺化

此選項推薦用於：
- 主要關注 NGINX 指標的環境
- 輕量級監控需求
- 更簡單的配置需求

### 選項 2：Telegraf 代理

用於全面的系統和 NGINX 監控：

1. 按照 `Nginx-telegraf/readme.md` 中的設置說明進行操作
2. 配置您的 Prometheus 伺服器以抓取 Telegraf 的 Prometheus 端點
3. 使用提供的任一 JSON 檔案匯入 Grafana 儀表板

此選項推薦用於：
- 需要全面系統可見性的生產環境
- 跨系統組件的效能分析
- 詳細的請求日誌和分析

## Grafana 儀表板

本專案包含現成可用的 Grafana 儀表板：

1. `Nginx-telegraf/Grafana_dashboard.json` - 原始儀表板配置
2. `Nginx-telegraf/Grafana_dashboard_new.json` - 更新的儀表板，具有：
   - 改進的時間序列視覺化
   - 增強的記憶體使用率計算
   - 中文標題（"NGINX(傳統指標)"）

兩個儀表板都提供全面的面板，用於：
- CPU 和記憶體使用率
- 網路輸入/輸出指標
- HTTP 狀態碼分佈
- 連接統計
- 請求詳情和日誌

## 系統需求

- 啟用了 stub_status 模組的 NGINX
- 用於指標收集的 Prometheus 伺服器
- 用於視覺化的 Grafana
- 以下之一：
  - NGINX Prometheus Exporter（二進位檔）
  - Telegraf 代理（建議版本 1.33.1+）

## 快速入門

1. 選擇您偏好的監控方法（Exporter 或 Telegraf）
2. 按照子目錄中的相應設置指南進行操作
3. 配置 Prometheus 以抓取指標端點
4. 匯入適當的 Grafana 儀表板
5. 開始監控您的 NGINX 伺服器
