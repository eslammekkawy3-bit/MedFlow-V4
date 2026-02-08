# AI System Design Document
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO42001-A5-001
**Version:** 2.0
**Classification:** Internal
**Last Updated:** 2026-02-07
**Author:** MedFlow Development Team
**ISO 42001 Reference:** Annex A.5 - AI System Life Cycle

---

## 1. Executive Summary

MedFlow V3 is an AI-powered Clinical Decision Support (CDS) system designed to assist healthcare insurance decision-making in Saudi Arabia. The system processes inpatient medical records, extracts clinical information, applies Saudi Ministry of Health (MOH) protocols, and provides evidence-based recommendations for continued hospitalization.

---

## 2. System Architecture Overview

### 2.1 Five-Layer Pipeline Architecture (Dual-Check Design)

```
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: PII SCRUBBING (Defense in Depth)                      │
│  Module: pii_scrubber.py v2.1.0                                 │
│  Technology: Regex (L1) + Llama 3.2 via Ollama (L2)             │
│  Purpose: Data sovereignty, PDPL compliance                     │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 2: CLINICAL ANALYSIS (Cloud AI)                         │
│  Module: gemini_client.py v1.0.0                                │
│  Technology: Google Gemini 2.0/2.5 Flash                        │
│  Purpose: Clinical summarization, timeline analysis             │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 3: GUIDELINE ENFORCEMENT (Knowledge Base)                │
│  Module: knowledge_base.py v1.4.0                               │
│  Technology: PDF extraction, keyword matching                   │
│  Purpose: MOH protocol compliance, citation generation          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 4: CLINICAL INTEGRITY ENGINE (DRG Validator)             │
│  Module: drg_validator.py v1.0.0                                │
│  Data: data/drg_clinical_rules.json v1.1.0 (25 MDCs)           │
│  Technology: Rule-based keyword matching + severity markers     │
│  Purpose: MDC prediction, severity assessment, claim validation │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 5: ORCHESTRATION (CDS Brain)                             │
│  Module: cds_brain.py v1.2.0                                    │
│  Technology: Python orchestration (8-step pipeline)             │
│  Purpose: Pipeline coordination, decision assembly              │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Dual-Check Architecture

MedFlow V3 employs a **Dual-Check Architecture** for clinical integrity:

| Check | Engine | Technique | Strength |
|-------|--------|-----------|----------|
| **Check 1: LLM (Gemini)** | Cloud AI | Contextual clinical reasoning | Understands nuance, identifies primary diagnosis from complex multi-document cases |
| **Check 2: Rules (DRG Validator)** | Local deterministic | Keyword frequency + severity markers | Catches DRG coding errors, upcoding, severity mismatches |

**Design Principle:** When Check 1 and Check 2 agree, confidence is high. When they disagree, the system flags a "MISMATCH" for human review. This creates a safety net where each component catches the failure modes of the other:
- LLM may accept a wrong DRG claim without verifying coding rules -> Validator catches it
- Validator may be fooled by secondary diagnoses -> LLM correctly identifies the primary diagnosis
- Both outputs are preserved in the audit trail for full transparency

---

## 3. Component Specifications

### 3.1 Layer 1: PII Scrubber (`pii_scrubber.py` v2.1.0)

**Purpose:** Remove all Personally Identifiable Information (PII) before cloud processing.

**Input:**
- Raw medical document text (1-50,000 characters)
- Document identifier

**Processing:**
1. **Regex Layer (L1):** Pattern matching for structured PII
   - Saudi National ID (10 digits, starts with 1 or 2)
   - Phone numbers (+966 format)
   - MRN/Patient IDs
   - Email addresses
   - Dates of birth

2. **LLM Layer (L2):** Contextual extraction via Llama 3.2
   - Patient names (Arabic/English)
   - Doctor names
   - Hospital/facility names
   - Uses JSON extraction strategy (not text rewriting)

3. **Validation Layer (L3):** Leak detection scan

**Output:**
- Scrubbed text (PII replaced with tokens like `[NAME_REDACTED]`)
- PII Manifest (audit trail with SHA-256 hashes)

**Data Flow Control:**
- All PII processing occurs locally via Ollama
- No PII leaves the local environment
- Compliant with PDPL data localization requirements

---

### 3.2 Layer 2: Clinical Analysis (`gemini_client.py` v1.0.0)

**Purpose:** Extract clinical insights from scrubbed medical text.

**Input:**
- Scrubbed medical document text
- Current date for timeline calculation

**Processing Functions:**

1. **`get_clinical_summary()`**
   - Extracts: Primary diagnosis, comorbidities, current status
   - Output: `ClinicalSummary` dataclass

2. **`get_timeline_analysis()`**
   - Calculates: Admission duration, milestones, trajectory
   - Output: `TimelineAnalysis` dataclass

3. **`get_decision()`**
   - Generates: Recommendation (DISCHARGE/EXTENSION/HOME_CARE)
   - Output: `ClinicalDecision` with confidence score

**Fault Tolerance:**
- Auto-fallback: gemini-2.0-flash → gemini-2.5-flash → gemini-1.5-flash
- Retry logic with exponential backoff
- Error 429/404 handling

**Output:**
- Structured clinical analysis objects
- Model used and processing timestamps

---

### 3.3 Layer 3: Knowledge Base (`knowledge_base.py` v1.4.0)

**Purpose:** Match clinical findings to MOH protocols and generate citations.

**Input:**
- Primary diagnosis from Layer 2
- Section hint (e.g., "discharge criteria")

**Processing:**

1. **Document Loading:**
   - Scans `knowledge-base.moh_protocols/` folder
   - Extracts text from PDF files
   - Indexes by keywords

2. **Strict Matching Algorithm:**
   - Filters STOP_WORDS (acute, chronic, management, etc.)
   - Uses word boundary matching (`\b` regex)
   - Prevents false positives (e.g., "mi" won't match "hypoglycemia")

3. **Fallback Logic:**
   - If no MOH protocol matches: Returns "General Clinical Reasoning"
   - Never returns irrelevant protocols

**Output:**
- `GuidelineReference` with source, document title, section, quote
- Citation string for audit trail

---

### 3.4 Layer 4: Clinical Integrity Engine (`drg_validator.py` v1.0.0)

**Purpose:** Validate DRG assignments by cross-checking clinical evidence against claimed codes. No financial calculations.

**Input:**
- Merged clinical text (post-PII scrubbing)
- Claimed DRG code (optional, for claim validation)

**Processing:**

1. **MDC Prediction (`predict_mdc()`):**
   - Scans clinical text for keywords matching 25 MDC categories
   - Uses word boundary matching for short keywords (<=4 chars)
   - Returns ranked MDC with confidence score and runner-up

2. **Severity Assessment (`assess_severity()`):**
   - Scans for Level A (High) markers: ICU, ventilator, shock, organ failure, etc.
   - Scans for Level B (Standard) markers: IV antibiotics, monitoring, procedures
   - Level C (Low) assigned when no markers detected

3. **Claim Validation (`validate_claim()`):**
   - Compares claimed DRG code against AI prediction
   - Extracts severity letter (A/B/C) from claim codes (e.g., "E65A" -> Level A)
   - Returns MATCH / PARTIAL / MISMATCH with discrepancy notes

**Data Source:**
- `data/drg_clinical_rules.json` v1.1.0
- 25 MDC categories aligned to Saudi AR-DRG v9.0
- Covers Top 50+ inpatient diagnoses
- Severity markers organized by Level A (High) and Level B (Standard)

**Output:**
- `ValidationResult` dataclass containing:
  - Predicted MDC name and code
  - Predicted severity level (A/B/C)
  - Matched keywords and severity markers
  - Claim comparison result (if claim provided)
  - Reasoning string for audit trail

---

### 3.5 Layer 5: Orchestration (`cds_brain.py` v1.2.0)

**Purpose:** Coordinate all layers and produce final case result.

**Input:**
- List of medical documents (text or file paths)
- Case identifier
- Current date

**Processing Pipeline (8 Steps):**
1. PII Scrubbing (for each document)
2. Document merging
3. Clinical summary generation (Gemini)
4. Timeline analysis (Gemini)
5. Guideline lookup (Knowledge Base, strict matching)
6. Decision generation (Gemini)
7. DRG clinical validation (Validator)
8. Citation and result assembly

**Output:**
- `CaseResult` dataclass containing:
  - Recommendation (DISCHARGE/EXTENSION/HOME_CARE)
  - Confidence score (0.0 - 1.0)
  - Review level (AUTO_APPROVED/STANDARD_REVIEW/SENIOR_REVIEW)
  - Clinical rationale
  - Guideline citations
  - **Clinical validation (MDC prediction, severity, matched markers)**
  - PII manifest
  - Processing metrics

---

## 4. Data Flow Diagram

```
[Medical Documents]
        │
        ▼
┌───────────────────┐
│  PII SCRUBBER     │ ◄── Local Llama 3.2 (Ollama)
│  (Layer 1)        │
└───────────────────┘
        │
        │ Scrubbed Text (No PII)
        ▼
┌───────────────────┐
│  GEMINI CLIENT    │ ◄── Cloud API (Google)
│  (Layer 2)        │     [Check 1: LLM Context]
└───────────────────┘
        │
        │ Clinical Summary + Timeline + Decision
        ▼
┌───────────────────┐
│  KNOWLEDGE BASE   │ ◄── Local PDF Protocols
│  (Layer 3)        │
└───────────────────┘
        │
        │ Guideline References
        ▼
┌───────────────────┐
│  DRG VALIDATOR    │ ◄── data/drg_clinical_rules.json
│  (Layer 4)        │     [Check 2: Rule-Based]
└───────────────────┘
        │
        │ MDC Prediction + Severity + Claim Validation
        ▼
┌───────────────────┐
│  CDS BRAIN        │
│  (Layer 5)        │
└───────────────────┘
        │
        ▼
[CaseResult + Clinical Validation + Audit Trail]
```

---

## 5. Decision Logic

### 5.1 Recommendation Categories

| Recommendation | Condition | Confidence Required |
|----------------|-----------|---------------------|
| DISCHARGE | Medically stable, discharge criteria met | >= 85% |
| HOME_CARE | Stable, can continue care at home | >= 80% |
| EXTENSION | Medical necessity for continued stay | >= 70% |
| ESCALATE | Uncertain or critical condition | Any |

### 5.2 Review Levels

| Review Level | Confidence Range | Action |
|--------------|------------------|--------|
| AUTO_APPROVED | >= 85% | Proceed without human review |
| STANDARD_REVIEW | 70-84% | Standard medical reviewer |
| SENIOR_REVIEW | < 70% | Senior physician review |
| ESCALATE | Any (flagged) | Immediate attention |

---

## 6. Integration Points

### 6.1 External APIs
- **Google Gemini API:** Clinical analysis (requires API key)
- **Ollama Local Server:** PII scrubbing (http://localhost:11434)

### 6.2 File System
- **Input:** Medical documents (PDF, TXT, JSON)
- **Knowledge Base:** `knowledge-base.moh_protocols/` (13 MOH PDFs)
- **Output:** JSON case results in `output/` directory

### 6.3 Configuration
- **`.env` file:** API keys, model selection
- **CDSConfig:** Processing thresholds, paths

---

## 7. Version Control

| Component | Version | Last Updated |
|-----------|---------|--------------|
| pii_scrubber.py | 2.1.0 | 2026-02-04 |
| gemini_client.py | 1.0.0 | 2026-02-03 |
| knowledge_base.py | 1.4.0 | 2026-02-04 |
| cds_brain.py | 1.1.0 | 2026-02-04 |

---

## 8. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| System Architect | _________________ | __________ | __________ |
| AI Ethics Officer | _________________ | __________ | __________ |
| Quality Assurance | _________________ | __________ | __________ |

---

*End of Document*
