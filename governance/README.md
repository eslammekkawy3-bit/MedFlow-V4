# MedFlow AI — Native Governance Command Center

**ISO 42001 | NPHIES Compliance | Patent Pending (SAIP)**

A live, demonstrable AI governance command center that runs synthetic NPHIES claims through MedFlow's 6-layer pipeline, calculates 21 governance metrics, persists everything to SQLite, and generates on-demand PDF audit reports.

---

## Architecture

```
governance/
├── pipeline_simulator.py      # 3-mode simulator (FULL/FAST/BENCHMARK) + event bus wiring
├── metrics_engine.py          # 21 metric calculations + SQLite persistence
├── governance_dashboard.py    # Streamlit UI on port 8502
├── audit_export.py            # reportlab PDF audit report
├── synthetic/
│   └── test_claims.json       # 5 NPHIES-format synthetic claims
├── data/
│   └── medflow_governance.db  # SQLite DB (auto-created on first run)
└── reports/
    └── *.pdf                  # Generated audit reports
```

> **Does not modify any existing MedFlow files.** Wires into existing event bus.

---

## Quick Start

```bash
cd "C:\Medflow Master Brain"
.\venv\Scripts\activate

# Step 1: Run benchmark simulation (no API calls, ~50ms/claim)
python governance/pipeline_simulator.py --mode benchmark --batch

# Step 2: Launch governance dashboard
streamlit run governance/governance_dashboard.py --server.port 8502
# Open: http://localhost:8502

# Step 3: Generate PDF audit report
python governance/audit_export.py --days 7
```

---

## Three Simulation Modes

| Mode | PII Scrubbing | Gemini API | Ollama (Llama 3.2) | Speed |
|------|---|---|---|---|
| `BENCHMARK` | Mock | None | None | ~50ms/claim |
| `FAST` | Regex only | Real | Bypassed | ~11s/claim |
| `FULL` | Regex + Llama | Real | Required | ~14s/claim |

FAST mode uses `CDSConfig(use_llm_scrubbing=False)` — disables the Ollama HTTP call, keeps Gemini + RAG.

---

## 21 Governance Metrics

Mapped to IBM watsonx.governance commission_log.json monitor IDs.

| Group | Metrics |
|---|---|
| Clinical Quality | z960_catch_rate, severity_upcoding_psi, doc_element_gap_distribution, clinical_note_uniformity |
| Anti-Gaming | rapid_resubmission_rate, human_override_rate |
| Drift | confidence_bucket_drift, decision_type_psi, drift_v2_score |
| Sovereignty | sovereign_dependency_ratio, pii_rejection_rate, data_health_score |
| RAG/Evidence | rag_low_confidence_rate, ncebm_hit_rate, rag_below_threshold_rate |
| Pipeline Health | pipeline_success_rate, pipeline_latency_ms, fairness_score |
| Output Quality | vendor_hallucination_rate, rationale_compliance_rate, mandatory_rationale_compliance |

---

## CLI Reference

```bash
# Pipeline Simulator
python governance/pipeline_simulator.py --mode benchmark --batch
python governance/pipeline_simulator.py --mode fast --batch
python governance/pipeline_simulator.py --mode fast --claim-index 0
python governance/pipeline_simulator.py --mode full --batch

# Metrics Engine (query SQLite)
python governance/metrics_engine.py --latest 5 --summary
python governance/metrics_engine.py --metric sovereign_dependency_ratio
python governance/metrics_engine.py --alerts 24

# Audit Export
python governance/audit_export.py --days 7
python governance/audit_export.py --sessions 50

# Dashboard
streamlit run governance/governance_dashboard.py --server.port 8502
```

---

## Event Bus Integration

The simulator emits `DECISION_COMPLETE` events to the existing governance event bus after every claim in all 3 modes. This keeps the Sprint 2 Real-Time Risk Monitor (RTRM) alive with zero additional code.

```
PipelineSimulator → emit(DECISION_COMPLETE) → GovernanceController → RealTimeRiskMonitor
```

---

## SQLite Schema

Database at `governance/data/medflow_governance.db`:

- `governance_sessions` — one row per simulation batch
- `governance_metrics` — 21 rows per session (one per metric)
- `layer_telemetry` — per-layer latency per claim
- `alert_log` — threshold breaches with timestamps

---

## ISO 42001 Compliance Evidence

| Clause | Control | Evidence |
|---|---|---|
| 8.4 | PII Privacy | pii_rejection_rate monitor + 3-layer scrubbing |
| 8.5 | Knowledge Sovereignty | sovereign_dependency_ratio > 70% |
| 9.1 | Performance Evaluation | 21 monitors, SQLite audit trail, this dashboard |
| 9.3 | Management Review | PDF audit report on demand |
| 10.1 | Continual Improvement | Alert-driven investigation loop |

---

*MedFlow AI Research Initiative — Dr. Islam Mekawy*
*ISO/IEC 42001:2023 | SAIP Patent Pending (15 Claims) | CCHI / NPHIES*
