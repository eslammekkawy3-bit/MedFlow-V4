# MedFlow V3

## ISO 42001-Compliant AI Governance Framework for Healthcare Insurance Decision Systems

**Current Status:** Phase 3 Complete - Clinical Decision Support Operational
**Version:** 1.5.0
**Last Updated:** 2026-02-06

---

## Overview

MedFlow V3 is an AI-powered Clinical Decision Support (CDS) system designed for healthcare insurance decision-making in Saudi Arabia. It processes inpatient medical records, extracts clinical information, applies Saudi Ministry of Health (MOH) protocols, and provides evidence-based recommendations for continued hospitalization.

### Key Capabilities

- **Four-Layer Pipeline:** PII Scrubbing -> Clinical Analysis -> Guideline Enforcement -> Decision
- **Defense in Depth PII:** Regex + Llama 3.2 (local) ensures no patient data reaches cloud
- **MOH Protocol Compliance:** 13 Saudi MOH protocols with strict matching
- **Self-Healing AI:** Auto-fallback when Gemini API encounters issues
- **ISO 42001 Compliance:** Full audit trail and governance documentation

---

## Current Status

| Component | Version | Status |
|-----------|---------|--------|
| PII Scrubber | 2.1.0 | Operational (Extraction Strategy) |
| Knowledge Base | 1.4.0 | Operational (Word Boundary Matching) |
| Gemini Client | 1.0.0 | Operational (Auto-Fallback) |
| CDS Brain | 1.1.0 | Operational (General Fallback) |
| Test Suite | All Pass | 6/6 strict matching tests |

---

## Quick Start

### Prerequisites

- Python 3.10+
- 16GB RAM (32GB recommended)
- Ollama with Llama 3.2 model
- Google Gemini API key

### Installation

```bash
# Navigate to project
cd "C:\Medflow Master Brain"

# Activate virtual environment
.\venv\Scripts\activate  # Windows
source venv/bin/activate  # Linux/Mac

# Install dependencies
pip install google-generativeai pypdf pdfplumber

# Configure API key
# Edit .env and add: GEMINI_API_KEY=your_key_here
```

### Verify Installation

```bash
# Full system health check
python cds_brain.py --health

# Run strict matching test suite
python knowledge_base.py --test-strict

# Test PII scrubber
python pii_scrubber.py --text "Patient Ahmed, MRN-123456, phone +966 55 123 4567"
```

---

## CLI Commands

### CDS Brain (Main Orchestrator)

```bash
# Health check
python cds_brain.py --health

# Analyze text
python cds_brain.py --text "Patient admitted with chest pain..."

# Analyze files
python cds_brain.py --files "report_day1.json" "report_day3.json" --output result.json

# Disable LLM PII scrubbing (regex only, faster)
python cds_brain.py --no-llm-scrub --text "..."
```

### Knowledge Base

```bash
# List all loaded protocols
python knowledge_base.py --list

# Show statistics
python knowledge_base.py --stats

# Search for protocols
python knowledge_base.py --search "Diabetic Ketoacidosis"

# Test strict matching (with reference)
python knowledge_base.py --reference "Acute Ischemic Stroke"

# Debug mode (shows matching decisions)
python knowledge_base.py --reference "Stroke" --debug

# Run automated test suite
python knowledge_base.py --test-strict
```

### PII Scrubber

```bash
# Test with text
python pii_scrubber.py --text "Patient Ahmed, MRN-123456"

# Test with file
python pii_scrubber.py --file document.txt

# Regex-only mode (faster)
python pii_scrubber.py --no-llm --text "..."

# Check Ollama status
python pii_scrubber.py --check
```

### Utilities

```bash
# List available Gemini models
python check_models.py

# Generate synthetic test cases
python synthetic_data.py --output ./sample_cases --simple 10 --medium 5 --complex 5
```

---

## Folder Structure

```
C:\Medflow Master Brain\
│
├── Core Modules
│   ├── cds_brain.py             # Main orchestrator (v1.1.0)
│   ├── knowledge_base.py        # MOH Protocol loader (v1.4.0)
│   ├── gemini_client.py         # Gemini API client (v1.0.0)
│   ├── pii_scrubber.py          # PII removal (v2.1.0)
│   └── check_models.py          # Gemini model utility
│
├── Configuration
│   ├── .env                     # API keys and settings
│   ├── config.py                # Application configuration
│   └── requirements.txt         # Python dependencies
│
├── Documentation
│   ├── README.md                # This file
│   ├── CLAUDE.md                # AI assistant instructions
│   ├── MEDFLOW_PROJECT_TRACKER.md # Development tracker
│   ├── PHASE3_ARCHITECTURE.md   # Technical blueprint
│   └── OLLAMA_SETUP.md          # Local LLM setup guide
│
├── ISO 42001 Compliance
│   └── iso42001-artifacts/
│       ├── AI_Risk_Register.md           # A.4 - Risk management (v3.0, 14 risks)
│       ├── AI_System_Design.md           # A.5 - Architecture
│       ├── Algorithmic_Impact_Assessment.md  # A.5 - Impact assessment
│       ├── AI_Data_Policy.md             # A.6 - Data governance
│       ├── Resource_Management.md        # A.7 - Resources
│       ├── Verification_Validation_Plan.md   # A.9 - V&V
│       ├── User_Guide_Clinical.md        # Clinical user guide
│       └── *.docx                        # Original ISO documents
│
├── Knowledge Base
│   └── knowledge-base.moh_protocols/  # 13 MOH Protocol PDFs
│
├── Test Data
│   └── sample_cases/            # 20 synthetic test cases
│       ├── simple/
│       ├── medium/
│       └── complex/
│
├── Output & Logs
│   ├── output/                  # Case analysis results
│   ├── logs/                    # Execution logs
│   └── backups/                 # Configuration backups
│
└── Development
    ├── tests/                   # Unit test files
    ├── data/                    # Static data files
    └── venv/                    # Python virtual environment
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: PII SCRUBBING (pii_scrubber.py v2.1.0)               │
│  Regex (L1) + Llama 3.2 JSON Extraction (L2) + Validation (L3) │
│  All processing LOCAL - PDPL compliant                          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 2: CLINICAL ANALYSIS (gemini_client.py v1.0.0)          │
│  Gemini 2.0/2.5 Flash with auto-fallback                        │
│  Summary → Timeline → Decision                                  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 3: GUIDELINE ENFORCEMENT (knowledge_base.py v1.4.0)     │
│  13 MOH Protocols + Strict Word Boundary Matching               │
│  Fallback: General Clinical Standards                           │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 4: ORCHESTRATION (cds_brain.py v1.1.0)                  │
│  Pipeline coordination + Confidence scoring + Review levels     │
└─────────────────────────────────────────────────────────────────┘
```

---

## ISO 42001 Compliance

MedFlow implements ISO 42001 controls with full documentation:

| Control | Document | Status |
|---------|----------|--------|
| A.4 | AI_Risk_Register.md (v3.0) | 14 risks (8 technical + 6 strategic), 9 mitigated |
| A.5 | AI_System_Design.md | 4-layer architecture documented |
| A.5 | Algorithmic_Impact_Assessment.md | Patient safety, fairness, human oversight |
| A.6 | AI_Data_Policy.md | PDPL, data minimization |
| A.7 | Resource_Management.md | HW/SW requirements |
| A.9 | Verification_Validation_Plan.md | Automated test suites |
| UG | User_Guide_Clinical.md | Doctor instructions, confidence scores |

---

## Saudi Healthcare Standards

- **MOH Protocols:** 13 Ministry of Health clinical guidelines
- **PDPL Compliance:** All PII processed locally via Ollama
- **NPHIES Ready:** Designed for integration
- **Guideline Hierarchy:** MOH -> UpToDate -> General Clinical Reasoning

---

## Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Local LLM | Llama 3.2 via Ollama | Data sovereignty, PDPL compliance |
| Cloud LLM | Gemini 2.0 Flash | Fast, reliable API |
| PII Strategy | Extraction (not Rewriting) | Prevents hallucination, 3-5x faster |
| Protocol Matching | Word Boundary Regex | Prevents "mi" matching "hypoglycemia" |
| Medical Focus | Medical Necessity | NOT insurance coverage |

---

## Known Limitations

- No Stroke/ACS/Sepsis protocols in knowledge base (user to add)
- English language only
- Requires Ollama running locally for PII scrubbing
- Internet connection required for Gemini API

---

## Performance

| Metric | Current | Target |
|--------|---------|--------|
| PII Scrubbing | ~1-2 min/case | < 30 sec (with optimization) |
| Full Pipeline | ~2-3 min/case | < 1 min |
| Strict Match Accuracy | 100% (6/6 tests) | 100% |

---

## Contact

**Lead Researcher & Architect:** Dr. Islam Mekawy
**Project Type:** Personal Research Initiative (Non-Commercial)
**Location:** Saudi Arabia

---

*Built with ISO 42001 compliance from day 1*
