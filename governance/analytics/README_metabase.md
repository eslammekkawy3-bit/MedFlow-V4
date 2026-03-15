# MedFlow AI — Metabase Analytics Setup Guide

**Module:** `governance/analytics/setup_metabase.py`
**Author:** Dr. Islam Mekawy, MedFlow AI Research Initiative
**ISO 42001:** Clause 9.1 (Monitoring, Measurement, Analysis)

---

## What Is Metabase?

Metabase is a free, open-source BI tool that connects directly to your SQLite database, auto-generates charts, and lets you ask questions about your data through a web interface — no coding required. It runs entirely locally at `http://localhost:3000`.

**No data leaves your machine. No cloud dependency.**

---

## Prerequisites

- **Java 17 (JRE)** — Required by Metabase
  - Windows: https://adoptium.net/temurin/releases/ → choose "JRE 17 (LTS) Windows x64"
  - After install, restart your terminal
- **Internet connection** — for the one-time 300MB download
- **Python 3.8+** with `requests` installed

---

## Quick Start

```bash
cd "C:\Medflow Master Brain"
.\venv\Scripts\activate
python governance/analytics/setup_metabase.py
```

This script will:
1. Verify Java is installed
2. Download `metabase.jar` (~300 MB, one-time)
3. Generate startup scripts
4. **Seed 20 additional BENCHMARK sessions** into the governance database
5. Print connection instructions

---

## Launch Metabase

**Windows:**
```
Double-click: governance\analytics\start_metabase.bat
```

**Or from terminal:**
```bash
java -jar "governance/analytics/metabase.jar"
```

Then open: http://localhost:3000

**First startup takes 1-2 minutes** (Metabase initializes its internal H2 database).

---

## Connect Metabase to MedFlow SQLite

After the setup wizard opens:

1. Create an admin account (local only — never sent anywhere)
2. When asked **"Add your data"**, select: **SQLite**
3. Enter the database file path:
   ```
   C:\Medflow Master Brain\governance\data\medflow_governance.db
   ```
4. Database name: `MedFlow Governance`
5. Click **Save**

---

## Tables Available in Metabase

| Table | Description | Primary Use |
|---|---|---|
| `governance_metrics` | 21 metric values per session | **Use this most** — trend analysis |
| `governance_sessions` | One row per simulation run | Mode comparison, session counts |
| `layer_telemetry` | Per-layer latency per claim | Bottleneck identification |
| `alert_log` | All threshold breaches | Critical alert tracking |

---

## Suggested First Questions (paste into Metabase "Ask a question")

- "Show the trend of z960_catch_rate over all sessions"
- "Which metric_id has the most CRITICAL status?"
- "Average avg_latency_ms grouped by mode"
- "Count of sessions by alert_count"
- "Show all alert_log entries where alert_level = CRITICAL"
- "Average metric_value for sovereign_dependency_ratio over time"

---

## Schema Reference

```sql
-- governance_sessions
session_id TEXT, timestamp TEXT, mode TEXT,
claim_count INTEGER, pass_rate REAL,
alert_count INTEGER, avg_latency_ms REAL, created_at TEXT

-- governance_metrics
id INTEGER, session_id TEXT, timestamp TEXT,
metric_id TEXT, metric_value REAL, threshold_value REAL,
threshold_type TEXT,  -- 'upper_limit' or 'lower_limit'
status TEXT           -- 'PASS', 'ALERT', 'CRITICAL'

-- layer_telemetry
id INTEGER, session_id TEXT, claim_id TEXT,
layer_name TEXT, layer_number INTEGER,
duration_ms INTEGER, status TEXT  -- 'PASS' or 'OVER_TARGET'

-- alert_log
id INTEGER, session_id TEXT, timestamp TEXT,
metric_id TEXT, metric_value REAL, threshold_value REAL,
threshold_type TEXT, alert_level TEXT, alert_message TEXT
```

---

## Troubleshooting

**"Java not found" error:**
- Install from https://adoptium.net/temurin/releases/
- Restart your terminal after install
- Verify: `java -version` should show version 17+

**Metabase won't start:**
- Ensure port 3000 is free: `netstat -an | findstr 3000`
- Check that `metabase.jar` is >10 MB (not a partial download)
- Delete `metabase.jar` and re-run `setup_metabase.py` to redownload

**Can't find SQLite as a database option:**
- Metabase added native SQLite support in v0.48+
- The download script fetches the latest version which includes SQLite
- If using an older jar, download latest from https://www.metabase.com/start/oss/

**Database has no data:**
```bash
python governance/analytics/setup_metabase.py  # runs seeding automatically
```

---

## No Java? Use analyst.py Instead

`analyst.py` has zero Java dependency and provides AI-powered governance analysis:

```bash
python governance/analytics/analyst.py --html-report  # Browser-based HTML report
python governance/analytics/analyst.py --query 5      # Terminal query
python governance/analytics/analyst.py --report       # Full text report
```

---

*MedFlow AI Research Initiative | Dr. Islam Mekawy | SAIP Patent Pending*
