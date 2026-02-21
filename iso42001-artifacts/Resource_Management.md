# Resource Management Plan
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO-08
**Title:** Resource Management Plan
**Version:** 2.1
**Status:** ACTIVE
**Date:** 2026-02-21
**Author:** Dr. Islam Mekawy
**Reviewer:** Dr. Islam Mekawy (Lead Researcher)
**Approver:** Dr. Islam Mekawy (AI Governance Lead)
**Classification:** CONFIDENTIAL – Internal Use Only
**ISO 42001 Clause:** Clause 7.1, Annex A.7 – Resources for AI Systems
**Supersedes:** MF-ISO42001-A7-001 v2.0 (2026-02-07)

---

## 1. Purpose

This document defines the software, hardware, and human resource requirements for operating and maintaining MedFlow V3 Clinical Decision Support System.

---

## 2. Software Requirements

### 2.1 Core Runtime Environment

| Component | Requirement | Purpose |
|-----------|-------------|---------|
| Python | 3.10+ | Application runtime |
| pip | Latest | Package management |
| Virtual Environment | venv or conda | Dependency isolation |

### 2.2 Python Dependencies

**Required Packages:**

| Package | Version | Purpose |
|---------|---------|---------|
| google-generativeai | >= 0.3.0 | Gemini API client |
| pypdf | >= 3.0.0 | PDF text extraction |
| pdfplumber | >= 0.9.0 | Advanced PDF parsing |

**Installation:**
```bash
pip install google-generativeai pypdf pdfplumber
```

**Verification:**
```bash
python -c "import google.generativeai; print('Gemini OK')"
python -c "import pypdf; print('pypdf OK')"
python -c "import pdfplumber; print('pdfplumber OK')"
```

### 2.3 Local AI Infrastructure

| Component | Requirement | Purpose |
|-----------|-------------|---------|
| Ollama | Latest | Local LLM runtime |
| Llama 3.2 | 3B or 8B model | PII detection |

**Installation:**
```bash
# Install Ollama
# Windows: Run OllamaSetup.exe
# macOS: brew install ollama
# Linux: curl -fsSL https://ollama.com/install.sh | sh

# Pull Llama 3.2 model
ollama pull llama3.2
```

**Verification:**
```bash
ollama list  # Should show llama3.2
curl http://localhost:11434/api/tags  # Should return model list
```

### 2.4 Cloud API Services

| Service | Provider | Purpose | Credentials |
|---------|----------|---------|-------------|
| Gemini API | Google | Clinical analysis | API key in `.env` |

**Configuration:**
```bash
# .env file
GEMINI_API_KEY=your_api_key_here
GEMINI_MODEL=gemini-2.0-flash
```

---

## 3. Hardware Requirements

### 3.1 Minimum Specifications

| Component | Minimum | Recommended | Purpose |
|-----------|---------|-------------|---------|
| CPU | 4 cores | 8 cores | Processing |
| RAM | 16 GB | 32 GB | Llama 3.2 model loading |
| Storage | 20 GB | 50 GB | Models + knowledge base |
| Network | 10 Mbps | 100 Mbps | API communication |

### 3.2 Local Inference Requirements (SDAIA Data Sovereignty)

MedFlow V3 performs all PII scrubbing locally via Ollama + Llama 3.2 to comply with SDAIA Personal Data Protection Law (PDPL) data localization requirements. No patient-identifiable information leaves the local environment. This architectural decision imposes specific compute requirements.

| Component | Minimum | Recommended | Constraint |
|-----------|---------|-------------|------------|
| RAM | 16 GB | 32 GB | Llama 3.2 3B model requires ~4GB resident; 16GB ensures stable inference without swapping |
| CPU | 8 cores | 16 cores | Multi-threaded tokenization and inference; 4-core systems exhibit >120s/page latency |
| Storage | 10 GB | 20 GB | Model weights (~4GB) + vector index space + knowledge base PDFs |
| GPU (VRAM) | Optional (8GB+) | 12GB+ | 5-10x inference speedup; not required for compliance |

**Accepted Latency Threshold:** < 60 seconds per page of clinical text (CPU-only inference).

- **Observed Performance:** ~50 seconds/page on 8-core / 16GB RAM (CPU-only, Llama 3.2 3B)
- **4-Document Case:** ~138 seconds total PII scrubbing for 4 clinical reports (~17,700 characters)
- **Design Trade-off:** This latency is accepted as a necessary cost of SDAIA data sovereignty compliance. Sending PII to cloud APIs would reduce latency to <5s but would violate PDPL data localization requirements.
- **Mitigation:** GPU acceleration (NVIDIA 8GB+ VRAM) reduces per-page latency to <10 seconds

**Verification:**
```bash
# Verify RAM is sufficient for model loading
ollama run llama3.2 "test"  # Should respond within 30s on first load

# Benchmark PII scrubbing latency
python pii_scrubber.py --text "Patient Ahmed Al-Rashid, MRN-123456, phone +966 55 123 4567"
# Expected: < 60s processing time
```

### 3.3 GPU (Optional)

| Component | Requirement | Benefit |
|-----------|-------------|---------|
| NVIDIA GPU | 8GB+ VRAM | 5-10x faster PII scrubbing |
| CUDA | 11.0+ | GPU acceleration |

**Note:** GPU is optional. CPU-only operation is fully supported.

### 3.4 Storage Layout

```
Disk Usage Estimate:
├── Ollama models      ~4 GB (Llama 3.2 3B)
├── Knowledge base     ~50 MB (13 MOH Protocol PDFs)
├── DRG clinical rules ~50 KB (drg_clinical_rules.json, 25 MDCs)
├── Python venv        ~500 MB
├── Application code   ~5 MB (5 core modules)
├── Output/logs        ~100 MB (variable)
├── Sample cases       ~5 MB (20 synthetic test cases)
└── TOTAL             ~5 GB minimum
```

---

## 4. Network Requirements

### 4.1 External Connectivity

| Endpoint | Protocol | Port | Purpose |
|----------|----------|------|---------|
| generativelanguage.googleapis.com | HTTPS | 443 | Gemini API |
| pypi.org | HTTPS | 443 | Package installation |

### 4.2 Internal Services

| Service | Protocol | Port | Purpose |
|---------|----------|------|---------|
| Ollama | HTTP | 11434 | Local LLM inference |

### 4.3 Firewall Rules

| Direction | Allow | Deny |
|-----------|-------|------|
| Outbound | Gemini API, PyPI | All others |
| Inbound | None | All |

---

## 5. Environment Configuration

### 5.1 Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| GEMINI_API_KEY | Yes | None | Google API key |
| GEMINI_MODEL | No | gemini-2.0-flash | Model selection |
| OLLAMA_HOST | No | http://localhost:11434 | Ollama server URL |
| MEDFLOW_ENV | No | development | Environment tier |

### 5.2 Configuration Files

| File | Purpose | Location |
|------|---------|----------|
| .env | API keys, model config | Project root |
| requirements.txt | Python dependencies | Project root |

---

## 6. Human Resources

### 6.1 Roles and Responsibilities

| Role | Responsibility | Required Skills |
|------|----------------|-----------------|
| System Administrator | Infrastructure, deployment | Python, Linux/Windows, Docker |
| AI Engineer | Model tuning, prompt engineering | ML/AI, Python, API integration |
| Clinical Validator | Output review, accuracy assessment | Medical degree, clinical experience |
| Data Protection Officer | PDPL compliance, audit | Legal, data protection |
| Support Engineer | Troubleshooting, monitoring | Python, debugging |

### 6.2 Training Requirements

| Role | Training Topics |
|------|-----------------|
| All | ISO 42001 awareness, PDPL basics |
| System Administrator | Ollama setup, Gemini API |
| AI Engineer | Prompt engineering, model selection |
| Clinical Validator | System usage, output interpretation |

---

## 7. Capacity Planning

### 7.1 Processing Capacity

| Metric | Current (Phase 4) | Target |
|--------|---------|--------|
| Cases per hour (1-doc) | ~80 | 100 |
| Cases per hour (4-doc) | ~15-20 | 50 |
| Concurrent users | 1 | 5 |
| Document size | 50KB avg | 200KB max |
| PII scrub latency | ~50s/page (CPU) | <10s/page (GPU) |
| DRG validation latency | <1s | <1s |

### 7.2 Scaling Options

| Scenario | Solution |
|----------|----------|
| More cases | Parallel processing |
| Faster PII | GPU acceleration |
| Higher availability | Load balancer + replicas |

---

## 8. Backup and Recovery

### 8.1 Backup Scope

| Component | Backup Frequency | Retention |
|-----------|------------------|-----------|
| Knowledge base | Weekly | 3 months |
| Configuration | On change | 1 year |
| Logs | Daily | 90 days |
| Models | On update | 2 versions |

### 8.2 Recovery Procedures

| Scenario | RTO | RPO | Procedure |
|----------|-----|-----|-----------|
| System failure | 4 hours | 24 hours | Restore from backup |
| Model corruption | 1 hour | N/A | Re-pull from Ollama |
| API key compromise | 30 min | N/A | Rotate key in .env |

---

## 9. Monitoring and Alerting

### 9.1 Health Metrics

| Metric | Check Interval | Alert Threshold |
|--------|----------------|-----------------|
| Ollama status | 5 min | Unhealthy > 3 checks |
| Gemini API | Per request | Error rate > 10% |
| Disk space | 1 hour | < 10% free |
| Memory usage | 5 min | > 90% used |

### 9.2 Health Check Command

```bash
python cds_brain.py --health
```

---

## 10. Cost Estimation

### 10.1 Infrastructure Costs

| Component | Type | Estimated Cost |
|-----------|------|----------------|
| Server (VM) | Monthly | $50-200/month |
| Gemini API | Per 1K tokens | ~$0.001-0.002 |
| Storage | Per GB/month | ~$0.10 |

### 10.2 Per-Case Cost

| Component | Cost per Case |
|-----------|---------------|
| Gemini API (3 calls) | ~$0.01-0.02 |
| Compute (5 min) | ~$0.005 |
| **TOTAL** | ~$0.02-0.03 |

---

## 11. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Infrastructure Lead | _________________ | __________ | __________ |
| Budget Owner | _________________ | __________ | __________ |
| System Owner | _________________ | __________ | __________ |

---

*End of Document*
