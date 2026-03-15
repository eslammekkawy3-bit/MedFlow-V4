# MedFlow AI — Governance Analyst (analyst.py)

**Module:** `governance/analytics/analyst.py`
**Author:** Dr. Islam Mekawy, MedFlow AI Research Initiative
**ISO 42001:** Clause 9.1 (Monitoring, Measurement, Analysis)
**Requires:** Ollama running locally | Python 3.8+

---

## What Is This?

A local AI analyst that answers natural language questions about MedFlow governance metrics. It uses Ollama (running on your machine) to:

1. Convert natural language questions → SQLite SQL queries
2. Execute queries against `medflow_governance.db`
3. Generate clinical governance insights with ISO 42001 references and NPHIES regulatory context

**Zero cloud dependency. Zero API costs. Completely private.**

---

## Prerequisites

1. **Ollama running** — https://ollama.com
2. **At least one model installed:**
   ```bash
   ollama pull llama3.2     # Recommended (best reasoning)
   ollama pull mistral      # Good alternative
   ollama pull phi3         # Lightweight, fast
   ```
3. **Database has data** — run setup first:
   ```bash
   python governance/analytics/setup_metabase.py
   ```

---

## Usage

```bash
# Activate venv first
.\venv\Scripts\activate

# Health check — verify everything is working
python governance/analytics/analyst.py --health

# Interactive menu (recommended for exploration)
python governance/analytics/analyst.py

# Run a specific smart query (1-8)
python governance/analytics/analyst.py --query 5

# Ask a natural language question
python governance/analytics/analyst.py --ask "Which metrics are critical?"
python governance/analytics/analyst.py --ask "What is the average pipeline latency?"
python governance/analytics/analyst.py --ask "How many sessions had a CRITICAL alert?"

# Full report — all 8 smart queries saved to file
python governance/analytics/analyst.py --report

# HTML report — open in browser (no Java needed)
python governance/analytics/analyst.py --html-report

# Save a single query output to file
python governance/analytics/analyst.py --query 1 --save
python governance/analytics/analyst.py --ask "..." --save
```

---

## Smart Queries (1-8)

| # | Query | Key Metric |
|---|---|---|
| 1 | Which metrics are trending toward breach? | critical_count, alert_count |
| 2 | Which sessions had the worst governance scores? | alert_count, pass_rate |
| 3 | Is Saudi knowledge sovereignty at risk? | sovereign_dependency_ratio |
| 4 | Which pipeline layer is the bottleneck? | avg_ms, over_target_pct |
| 5 | Governance health summary | pass_rate_pct, total_sessions |
| 6 | Top 5 most recent critical alerts | alert_level, alert_message |
| 7 | FAST vs BENCHMARK mode comparison | avg_latency_ms, avg_pass_rate |
| 8 | Metric breach frequency ranking | breach_pct |

---

## Architecture

```
User question (natural language or menu selection)
       |
       v
[Smart Query] --> Pre-built SQL (8 options)
[NL Query]    --> Stage 1: Ollama text-to-SQL (temperature=0.0)
       |
       v
SQLite execute against medflow_governance.db (read-only)
       |
       v
Stage 2: Ollama insight generation (temperature=0.3)
  - Clinical operations explanation
  - ISO 42001 clause reference
  - NPHIES/CCHI regulatory note
  - Specific recommended action
       |
       v
Terminal output OR saved report
```

---

## Output Format

```
==================================================================
  QUERY: [Query label]
==================================================================

  DATA:
  [tabulated results]

  AI ANALYST (llama3.2:latest):

  ANALYST INSIGHT  [Clinical explanation of what the data means]

  RECOMMENDED ACTION  [One specific next step]

  ISO 42001  [Clause X.Y — description]

  NPHIES/CCHI  [Saudi regulatory note]

------------------------------------------------------------------
```

---

## Model Selection Logic

The analyst auto-selects the best available Ollama model in this preference order:

1. `llama3.2` (best reasoning for structured output)
2. `llama3.1`
3. `llama3`
4. `mistral`
5. `phi3`
6. `gemma2`

If none of these are installed, it uses whatever is available. Model name matching handles full names like `llama3.2:latest`.

---

## NL Query Fallback

If Ollama generates an invalid SQL query from your natural language question, `analyst.py` automatically:
1. Detects the `sqlite3.OperationalError`
2. Finds the closest matching smart query by keyword
3. Returns that result instead of failing

---

## Reports

**Text report** (`--report`):
```
governance/analytics/reports/governance_report_YYYYMMDD_HHMMSS.txt
```

**HTML report** (`--html-report`):
```
governance/analytics/reports/governance_report_YYYYMMDD_HHMMSS.html
```
The HTML report uses dark-mode styling with all 8 smart queries and AI insights embedded. Opens automatically in your default browser.

---

## Error Messages

**"Ollama not running":**
```
Start Ollama: open Ollama from system tray, or run 'ollama serve'
```

**"No models installed":**
```
ollama pull llama3.2
```

**"Database not found":**
```
python governance/analytics/setup_metabase.py
```

**"Ollama timeout":**
- The model may be loading for the first time (cold start)
- Retry after 30 seconds

---

## What You Can Demonstrate

With `analyst.py` running, you can show:

1. **"Is Saudi knowledge sovereignty at risk?"** → Instant clinical AI governance answer with NPHIES regulatory note
2. **"Which pipeline layer is the bottleneck?"** → Layer-by-layer latency analysis across 21+ simulation runs
3. **"Generate a governance health summary"** → ISO 42001-aligned health score with recommended actions
4. **A full governance intelligence report** generated in ~2 minutes from the terminal

---

*MedFlow AI Research Initiative | Dr. Islam Mekawy | SAIP Patent Pending*
