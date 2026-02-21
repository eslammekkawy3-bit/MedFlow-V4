# AI Data Policy
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO-06
**Title:** AI Data Policy
**Version:** 2.0
**Status:** ACTIVE
**Date:** 2026-02-21
**Author:** Dr. Islam Mekawy
**Reviewer:** Dr. Islam Mekawy (Lead Researcher)
**Approver:** Dr. Islam Mekawy (AI Governance Lead)
**Classification:** CONFIDENTIAL – Internal Use Only
**ISO 42001 Clause:** Clause 7.3, Annex A.6 – Data for AI Systems; PDPL Articles 6 & 9
**Supersedes:** MF-ISO42001-A6-001 v1.0 (2026-02-04)

---

## 1. Purpose

This document establishes the data governance policies for MedFlow V3, ensuring compliance with:
- ISO 42001:2023 (AI Management System)
- Saudi Personal Data Protection Law (PDPL)
- SDAIA AI Ethics Principles
- NPHIES Healthcare Data Standards

---

## 2. Data Classification

### 2.1 Data Categories

| Category | Description | Sensitivity | Handling |
|----------|-------------|-------------|----------|
| **PHI** | Protected Health Information | CRITICAL | Never leaves local environment |
| **PII** | Personally Identifiable Information | HIGH | Scrubbed before cloud processing |
| **Clinical** | Diagnoses, treatments, vitals | MEDIUM | Anonymized for analysis |
| **Operational** | Logs, metrics, configs | LOW | Standard protection |

### 2.2 PII Elements Identified

The system identifies and redacts the following PII types:

| PII Type | Detection Method | Replacement Token |
|----------|------------------|-------------------|
| Saudi National ID | Regex (10 digits, 1/2 prefix) | `[NATIONAL_ID_REDACTED]` |
| Iqama Number | Regex (10 digits, 2 prefix) | `[IQAMA_REDACTED]` |
| Phone Numbers | Regex (+966/05x patterns) | `[PHONE_REDACTED]` |
| MRN/Patient ID | Regex (MRN-xxxxx pattern) | `[MRN_REDACTED]` |
| Patient Names | LLM Extraction | `[NAME_REDACTED]` |
| Doctor Names | LLM Extraction | `[DOCTOR_NAME_REDACTED]` |
| Hospital Names | LLM Extraction | `[HOSPITAL_REDACTED]` |
| Email Addresses | Regex | `[EMAIL_REDACTED]` |
| Dates of Birth | Regex | `[DOB_REDACTED]` |

---

## 3. Data Minimization Principles

### 3.1 Extraction vs. Rewriting Strategy

**Policy:** The system uses an "Extraction" strategy rather than "Rewriting" to minimize data exposure and prevent AI hallucination.

**Implementation (pii_scrubber.py v2.1.0):**

```
OLD APPROACH (Rejected):
- Send full text to LLM
- Ask LLM to rewrite with placeholders
- Risk: LLM may hallucinate values
- Risk: High token count, slow processing

NEW APPROACH (Implemented):
- Send text to LLM
- Ask for JSON list of names/hospitals only
- Python performs replacement
- Benefit: Minimal tokens, no hallucination
- Benefit: 3-5x faster processing
```

**JSON Extraction Prompt:**
```json
{"persons": ["name1", "name2"], "hospitals": ["hospital1"]}
```

### 3.2 Strict Matching Policy

**Policy:** The Knowledge Base uses strict matching to prevent irrelevant data associations.

**Implementation (knowledge_base.py v1.4.0):**

1. **STOP_WORDS Filtering:**
   - Generic terms excluded: "acute", "chronic", "management", "protocol", "inpatient"
   - Prevents false matches on common medical modifiers

2. **Word Boundary Matching:**
   - Uses regex `\b` anchors
   - Prevents "mi" from matching "hypoglycemia"
   - Example: `\bmi\b` only matches standalone "mi"

3. **Fallback Policy:**
   - If no strict match: Return "General Clinical Reasoning"
   - Never force-match an unrelated protocol
   - Preserves citation accuracy

---

## 4. Data Localization (PDPL Compliance)

### 4.1 Local Processing Requirement

**Policy:** All PII processing MUST occur within Saudi Arabia jurisdiction.

**Implementation:**

| Processing Stage | Location | Technology |
|-----------------|----------|------------|
| PII Detection | Local | Ollama + Llama 3.2 |
| PII Scrubbing | Local | Python Regex |
| Validation | Local | Python |
| Clinical Analysis | Cloud* | Gemini API |

*Note: Only anonymized (scrubbed) data is sent to cloud services.

### 4.2 Data Flow Controls

```
[Raw Medical Data] ─── LOCAL ONLY ───► [PII Scrubber]
                                              │
                                              ▼
                                    [Scrubbed Data] ─── CLOUD OK ───► [Gemini API]
```

---

## 5. Data Quality Controls

### 5.1 Input Validation

| Check | Implementation | Action on Failure |
|-------|----------------|-------------------|
| Document length | Max 50,000 chars | Truncate with warning |
| Character encoding | UTF-8 | Convert or reject |
| File format | PDF, TXT, JSON | Reject unsupported |

### 5.2 Output Validation

| Check | Implementation | Action on Failure |
|-------|----------------|-------------------|
| PII Leak Detection | Layer 3 validation scan | Flag for review |
| Confidence threshold | Min 0.5 required | Escalate to human |
| Citation accuracy | Strict matching | Fallback to general |

---

## 6. Audit Trail Requirements

### 6.1 PII Manifest

Every scrubbing operation generates a manifest containing:

```json
{
  "document_id": "CASE-001_doc1",
  "timestamp": "2026-02-04T12:00:00",
  "total_detections": 24,
  "detections_by_category": {
    "PHONE": 3,
    "MRN": 2,
    "NAME": 19
  },
  "detection_hashes": ["a1b2c3...", "d4e5f6..."],
  "layer1_regex_count": 5,
  "layer2_llm_count": 19,
  "validation_passed": true,
  "leaked_patterns_found": 0
}
```

**Note:** Actual PII values are NOT stored. Only SHA-256 hashes for tracking.

### 6.2 Processing Logs

| Event | Logged Data |
|-------|-------------|
| Case Start | Case ID, timestamp, document count |
| PII Scrubbing | Detection counts, processing time |
| Model Switch | Old model, new model, reason |
| Decision | Recommendation, confidence, review level |
| Error | Error type, stack trace (sanitized) |

---

## 7. Data Retention

### 7.1 Retention Periods

| Data Type | Retention Period | Disposal Method |
|-----------|------------------|-----------------|
| Raw medical documents | Per source policy | N/A (not stored) |
| Scrubbed analysis | 7 years | Secure deletion |
| PII Manifests | 7 years | Secure deletion |
| Processing logs | 1 year | Automatic purge |
| Model outputs | 7 years | Secure deletion |

### 7.2 Right to Erasure

The system supports data subject rights through:
- PII hash tracking (enables identification without storage)
- Case-level deletion capability
- Audit trail preservation (anonymized)

---

## 8. Third-Party Data Sharing

### 8.1 Approved Recipients

| Recipient | Data Shared | Purpose | Controls |
|-----------|-------------|---------|----------|
| Google Gemini | Anonymized text only | Clinical analysis | API encryption, no storage |
| None | Raw PII | N/A | Prohibited |

### 8.2 Prohibited Actions

- Sharing raw PII with any external party
- Storing PII in cloud services
- Using PII for model training
- Cross-border PII transfer without PDPL authorization

---

## 9. Incident Response

### 9.1 Data Breach Protocol

1. **Detection:** PII leak detected in validation layer
2. **Containment:** Halt processing, isolate affected case
3. **Notification:** Report to Data Protection Officer within 72 hours
4. **Investigation:** Root cause analysis
5. **Remediation:** System update, revalidation

### 9.2 Escalation Contacts

| Role | Responsibility |
|------|----------------|
| Data Protection Officer | PDPL compliance, breach notification |
| AI Ethics Officer | Fairness, bias, transparency concerns |
| System Administrator | Technical remediation |

---

## 10. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Data Protection Officer | _________________ | __________ | __________ |
| AI Ethics Officer | _________________ | __________ | __________ |
| System Owner | _________________ | __________ | __________ |

---

*End of Document*
