# MedFlow v4.0

## ISO 42001-Compliant AI Governance Framework for Healthcare Insurance Decisions

**Lead Architect:** Dr. Islam Mekawy, MSc, CPHIMS, CCDS, FLMI
**Jurisdiction:** Kingdom of Saudi Arabia
**Patent Status:** SAIP Application Pending
**Governance Phase:** v4.0 — Sprint 1+2+3 Complete | All 5 Non-Conformances Closed
**Professional Hours:** 114 hours across 22 sessions (IEL v2.0)

---

## Executive Summary

MedFlow v4.0 is a sovereign, ISO 42001-aligned Clinical Decision Support (CDS) system engineered for healthcare insurance prior-authorization in Saudi Arabia. It processes inpatient medical records, enforces Saudi Ministry of Health (MOH) clinical protocols, and generates audit-ready decisions with full regulatory traceability.

### Three Strategic Pillars

**1. Knowledge Sovereignty**
Saudi MOH protocols receive a 3x retrieval weight over international guidelines (WHO, NICE). The system enforces the Saudi clinical evidence hierarchy at the algorithm level, not merely at the policy level. Retrieval is powered by a local semantic engine (nomic-embed-text-v1.5) running entirely on-premises.

**2. PDPL-Compliant Privacy Architecture**
All Protected Health Information (PHI) is scrubbed locally before any data leaves the network. Llama 3.2 (via Ollama) performs name and institution extraction on-device. Regex patterns handle structured identifiers (MRN, National ID, IQAMA, phone, DOB). Zero patient data reaches external cloud APIs.

**3. Preemptive NPHIES 960Z Auditing**
Before a claim decision is issued, the system applies a six-element documentation quality gate aligned to NPHIES 960Z rejection criteria. Claims missing primary ICD-10 codes, medication dosages, lab results, or radiology interpretations receive a WARNING or FAIL grade — blocking submission before the insurer rejects it. This reduces 960Z rejection risk at the point of care.

---

## System Architecture: 6-Layer Governance Defense

```
INPUT: Inpatient Medical Records (PDF / DOCX / JSON)
       1-10 files per case, multi-day clinical episodes

+==================================================================+
| LAYER 1 — PII SCRUBBING (pii_scrubber.py v2.1.0)                |
|   Regex patterns: National ID, IQAMA, MRN, Phone, DOB, Email    |
|   Llama 3.2 (local): Names, Hospital names, Addresses           |
|   Validation pass: Leak detection before any external call       |
|   Zero patient data exits the local network                      |
+==================================================================+
                              |
+==================================================================+
| LAYER 2 — SEMANTIC RAG RETRIEVAL (knowledge_base_v2.py v2.2.0)  |
|   9,296 indexed chunks across 126 MOH protocol PDFs             |
|   Tier 1: Saudi MOH Protocols    (3.0x retrieval weight)        |
|   Tier 2: International (WHO / NICE)  (1.0x x NCEBM score)      |
|   Population filtering: pediatric/neonatal chunks excluded       |
|   for adult patients (age >= 18)                                 |
|   16,000-token hard budget | Local embeddings | Privacy-first    |
+==================================================================+
                              |
+==================================================================+
| LAYER 3 — NCEBM HIERARCHICAL JUDGE (ncebm_scorer.py v1.2.0)     |
|   6-dimension quality scoring per patent Section 3.2:            |
|     Evidence Grade (25pts) | Methodology (20pts)                 |
|     Applicability (15pts) | Governance (20pts)                   |
|     Currency (5pts) | Patient-Centeredness (15pts)               |
|   Score < 60: rejected at ingestion. Saudi Context: 0-15pts.    |
+==================================================================+
                              |
+==================================================================+
| LAYER 4 — CLINICAL ANALYSIS (gemini_client.py v2.0.0)           |
|   Gemini 2.0/2.5 Flash (auto-fallback on 429/404)               |
|   Full 1M-token context: no truncation                           |
|   5-tier confidence calibration | Few-shot gold examples         |
|   DRG context injected into decision prompt                      |
+==================================================================+
                              |
+==================================================================+
| LAYER 5 — DRG CLINICAL VALIDATION (drg_validator.py v1.1.0)     |
|   Saudi AR-DRG v9.0 MDC prediction (25 categories)              |
|   Severity Level A / B / C assessment                            |
|   Primary diagnosis 2x keyword weighting                        |
|   Upcoding & undercoding risk detection                          |
|   960Z Pre-emptive Gate: 6 mandatory documentation elements      |
+==================================================================+
                              |
+==================================================================+
| LAYER 6 — GOVERNANCE AUDIT TRAIL (cds_brain.py v1.7.0)          |
|   Patent Confidence Formula:                                     |
|     (Evidence Strength x Documentation Completeness              |
|      x Protocol Alignment) / 3                                   |
|   Structured per-layer audit: action, status, duration_ms        |
|   Regulatory Compliance: PDPL / NPHIES / ISO 42001 status       |
|   Provenance: all decisions traceable to MOH/CHI/NCEBM sources  |
+==================================================================+
                              |
OUTPUT: JSON decision record with recommendation, confidence,
        DRG classification, audit trail, regulatory status
        + Streamlit Governance Cockpit visualization
```

---

## ISO 42001 Compliance

MedFlow v4.0 was developed as a primary ISO 42001 Lead Implementer demonstration project. All development activity is documented to ISO 42001 evidence standards.

| Metric | Value |
|--------|-------|
| Controls Implemented | 39 / 39 (100%) |
| Non-Conformances | 5 / 5 CLOSED |
| Professional Hours | 114 hrs (IEL v2.0) |
| Working Days | 15 |
| Internal Audit | Passed (97% conformance, IAR v1.5) |
| Risk Register | 16 risks, RISK-010 MITIGATED |

### ISO Artifact Inventory

| Document | Version | Status |
|----------|---------|--------|
| [Statement of Applicability](iso42001-artifacts/Statement_of_Applicability.md) | v1.0 | Current |
| [AI Risk Register](iso42001-artifacts/AI_Risk_Register.md) | v5.1 | 16 risks |
| [Internal Audit Report](iso42001-artifacts/Internal_Audit_Report.md) | v1.5 | 5/5 NCs Closed |
| [ISO Compliance Matrix](iso42001-artifacts/ISO_COMPLIANCE_MATRIX.md) | v1.5 | 39/39 Implemented |
| [Algorithmic Fairness Report](iso42001-artifacts/Algorithmic_Fairness_Report.md) | v1.0 | 24/24 Metrics Pass |
| [Implementation Experience Log](iso42001-artifacts/Implementation_Experience_Log.md) | v2.0 | 114 hrs |
| [Management Review Minutes](iso42001-artifacts/Management_Review_Minutes.md) | v1.4 | Q1 2026 |
| [Continual Improvement Log](iso42001-artifacts/Continual_Improvement_Log.md) | v1.5 | 15 Completed |
| [Competence Assessment Matrix](iso42001-artifacts/Competence_Assessment_Matrix.md) | v1.3 | NC-001 Closed |
| [Algorithmic Impact Assessment](iso42001-artifacts/Algorithmic_Impact_Assessment.md) | v1.0 | Patient Safety |
| [Verification & Validation Plan](iso42001-artifacts/Verification_Validation_Plan.md) | v1.0 | Current |
| [AI Data Policy](iso42001-artifacts/AI_Data_Policy.md) | v1.0 | PDPL Aligned |

---

## v4.0 Governance Layer

The governance layer implements an event-driven pub/sub architecture replacing monolithic audit logging.

```
governance/
  governance_controller.py   # Pub/Sub event bus (25 event types, RLock, JSONL persistence)
  events.py                  # Typed event schemas + factory helpers
  real_time_risk_monitor.py  # RTRM: 2-signal drift detection, 100-event rolling window
```

**Real-Time Risk Monitor (RTRM):**
- Subscribes to DECISION_COMPLETE events via the governance event bus
- Signal 1: Confidence score distribution drift (baseline vs. rolling 100-event window)
- Signal 2: Recommendation distribution drift (EXTENSION/DISCHARGE/HOME_CARE/ESCALATE ratios)
- Threshold: >10% shift in any metric triggers RISK_DRIFT_DETECTED event
- Validated: 11/11 tests pass against 51-case gold standard dataset

---

## Algorithmic Fairness Validation

Counterfactual fairness testing per ISO 42001 Clause 8.2 (NC-002 Closed):

| Fairness Metric | Threshold | Observed Variance | Result |
|----------------|-----------|-------------------|--------|
| Demographic Parity | < 10% | 0.00% | PASS |
| Calibration Parity | < 5% | 0.00% | PASS |
| Review Level Parity | < 10% | 0.00% | PASS |
| Equal Opportunity | < 15% | 0.00% | PASS |

Test matrix: 4 diagnoses x 2 genders x 2 age groups x 2 replicas = 32 cases.
Diagnosis-held-constant, demographics varied. Evidence: [AFR-001](iso42001-artifacts/Algorithmic_Fairness_Report.md).

---

## Data Disclaimer

**All patient data used in demonstrations, testing, and validation is 100% synthetically generated.**

The `synthetic_data.py` V3.0 Clinical Simulation Engine generates clinically realistic but entirely fictitious patient cases using arc-based vitals curves, lab kinetics models, and medication state machines. No real patient records were used at any stage of development.

This design complies with the Saudi Personal Data Protection Law (PDPL) by ensuring zero exposure of identifiable health information in the research and validation pipeline.

---

## Proprietary Core

The mathematical weighting logic, 960Z extraction rules, and NCEBM dimension scoring algorithms are subject to an active SAIP patent application and are not included in this public repository.

---

## Quick Start

```bash
# Prerequisites: Python 3.10+, Ollama with Llama 3.2, Gemini API key

# 1. Clone and configure
git clone <repo>
cd medflow
cp .env.example .env      # Add GEMINI_API_KEY

# 2. Install dependencies
pip install google-generativeai pypdf pdfplumber streamlit plotly pandas python-dotenv
pip install chromadb sentence-transformers==2.7.0 tiktoken einops

# 3. Launch Governance Cockpit
streamlit run app.py

# 4. Health check
python cds_brain.py --health

# 5. Run validation suites
python drg_validator.py --test                   # 8/8
python documentation_quality_gate.py --test      # 5/5
python test_rtrm.py                              # 11/11
```

---

## Technical Stack

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Privacy Layer | Llama 3.2 via Ollama | Data sovereignty, on-premises only |
| Clinical AI | Gemini 2.0/2.5 Flash | 1M token context, auto-fallback |
| RAG Embeddings | nomic-embed-text-v1.5 | Local, privacy-preserving |
| Vector Store | ChromaDB | On-premises semantic retrieval |
| Dashboard | Streamlit | Rapid clinical UI deployment |
| Governance | Python threading (RLock) | Thread-safe event bus |
| Standards | ISO 42001, Saudi PDPL, NPHIES | Regulatory alignment |

---

*Personal Research Initiative — Dr. Islam Mekawy — Saudi Arabia, 2026*
*Built with ISO 42001 compliance from day 1*

---

## Contact & Lead Architect

* **Name:** Dr. Islam Mekawy, MSc, CPHIMS, CCDS, FLMI
* **Email:** [TYPE YOUR EMAIL HERE]
* **LinkedIn:** [TYPE YOUR LINKEDIN URL HERE]
* **Phone/WhatsApp:** [TYPE YOUR PHONE NUMBER HERE]
