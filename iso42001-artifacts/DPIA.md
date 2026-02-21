# Data Privacy Impact Assessment (DPIA)
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO-19
**Title:** Data Privacy Impact Assessment (DPIA)
**Version:** 1.1
**Status:** ACTIVE
**Date:** 2026-02-21
**Author:** Dr. Islam Mekawy
**Reviewer:** Dr. Islam Mekawy (Lead Researcher)
**Approver:** Dr. Islam Mekawy (AI Governance Lead)
**Classification:** CONFIDENTIAL – Internal Use Only
**ISO 42001 Clause:** Clause 8.2 – AI Risk Assessment; PDPL Articles 6 & 9
**Supersedes:** Data Privacy Impact Assessment (DPIA).docx v1.0 (2026-02-21) — converted from .docx to .md; system version reference synchronized to MedFlow V3

---

**System:** MedFlow V3 Clinical Governance Architecture
**Regulatory Framework:** Saudi Personal Data Protection Law (PDPL)
**Assessment Focus:** Layer 1 — Local Sovereignty & PII Redaction Engine

---

## 1. Executive Summary

This Data Privacy Impact Assessment (DPIA) evaluates the data processing pipeline of the MedFlow Clinical Decision Support system. MedFlow utilizes cloud-based Large Language Models (LLMs) to evaluate inpatient medical claims against AR-DRG v9.0 and NPHIES standards.

To ensure strict compliance with the Saudi Personal Data Protection Law (PDPL) regarding data localization and patient confidentiality, MedFlow employs a **"Zero-Trust Local Processing"** architecture (Layer 1). This document certifies that no Patient Personally Identifiable Information (PII) or Protected Health Information (PHI) ever leaves the local healthcare facility's network.

---

## 2. Technical Architecture: Layer 1 (Local Sovereignty Layer)

MedFlow intercepts and neutralizes sensitive data before any external API calls are made. This is achieved through a localized, three-stage Defensive Engine:

### Defensive Layer 1: Deterministic Filtering (Regex)

The system first passes the raw medical file through strict Regular Expression (Regex) filters to instantly strip structured identifiers. This includes:

- Saudi National IDs (10-digit formats)
- Phone Numbers (+966 or 05 formats)
- Medical Record Numbers (MRNs)
- Emails and exact Dates of Birth

### Defensive Layer 2: Semantic Redaction (Local LLM)

Because patient names and hospital locations are unstructured text, Regex is insufficient. MedFlow deploys a locally hosted **Llama 3.2 (3-Billion Parameter)** model via Ollama. This model runs entirely on-premise (or within the client's secure local cloud). It reads the text and semantically identifies and redacts unstructured PII, such as patient names, facility names, and employer data.

### Defensive Layer 3: Leakage Validation & The Actionability Gate

Before the de-identified clinical narrative is transmitted to the core analytical engine, a final validation scan is performed. If any residual PII is detected, the system executes a **"Hard Fail,"** rejecting the entire file and blocking transmission.

---

## 3. PDPL Article Alignment

The MedFlow architecture natively enforces the following PDPL mandates:

### Alignment with Data Localization Requirements

Because the Llama 3.2 redaction model operates locally, the actual unredacted patient file never touches a foreign cloud server. Only the anonymized, purely clinical narrative (e.g., "A 57-year-old female presents with sepsis...") is processed by the analytical engine.

### Alignment with Data Minimization

The system extracts and transmits only the precise clinical data points (vital signs, lab results, diagnoses) strictly necessary for AR-DRG clinical validation and NPHIES 960Z checks, discarding all administrative identities.

### Alignment with Security & Confidentiality

By executing destruction of PII at the point of ingestion, the system neutralizes the threat of data breaches during transmission.

---

## 4. Auditability and Governance (The PII Manifest)

To satisfy regulatory audits without compromising patient privacy, MedFlow generates an **immutable PII Manifest** for every processed case.

The manifest does not store the patient's data; rather, it logs the metadata of the redaction event (e.g., "Event: National ID detected and redacted at 10:04:22 AST. Method: Layer 1 Regex"). This allows a hospital's Data Privacy Officer (DPO) to definitively prove to a PDPL auditor that the system successfully intercepted and destroyed the identity before the clinical file was analyzed.

---

## 5. PII Categories and Replacement Tokens

| Category | Examples | Replacement Token |
|----------|----------|------------------|
| Patient Names | Ahmed Al-Rashid | `[NAME_1]` |
| National ID | 1234567890 | `[NATIONAL_ID]` |
| Medical Record Number | MRN-456789 | `[MRN_1]` |
| Phone Numbers | +966 55 123 4567 | `[PHONE_1]` |
| Email Addresses | patient@email.com | `[EMAIL_1]` |
| Dates of Birth | 15/03/1985 | `[DOB_1]` |
| Addresses | 123 King Fahd Rd | `[ADDRESS_1]` |
| Hospital/Facility Names | King Faisal Hospital | `[HOSPITAL_1]` |

---

## 6. Risk Assessment Summary

| Risk | Likelihood | Impact | Mitigation | Residual Risk |
|------|-----------|--------|-----------|---------------|
| PII leakage to cloud LLM | Low | Critical | 3-layer local scrubbing + Hard Fail gate | Very Low |
| Regex bypass by novel PII format | Medium | High | Llama 3.2 semantic layer catches unstructured PII | Low |
| Llama model unavailability | Low | High | Pipeline blocks; no fallback to cloud without scrubbing | Low |
| PII Manifest tampering | Very Low | Medium | Append-only JSONL log; audit trail | Very Low |

---

## 7. Conclusion

The MedFlow V3 Layer 1 architecture provides a technically robust, PDPL-compliant, and auditable mechanism for patient data protection. The three-stage Defensive Engine ensures that sensitive patient information is neutralized at the point of ingestion, with no pathway for PII to reach external cloud services.

This DPIA concludes that the MedFlow V3 data processing pipeline meets the requirements of:

- Saudi PDPL Articles 6 & 9 (Data Localization and Minimization)
- ISO 42001:2023 Clause 8.2 (AI Risk Assessment)
- NPHIES data sovereignty requirements

---

## 8. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-21 | Dr. Islam Mekawy | Initial issue. DPIA covering Layer 1 Local Sovereignty & PII Redaction Engine. Three-stage Defensive Engine documented. PDPL Article alignment assessed. |
| 1.1 | 2026-02-21 | Dr. Islam Mekawy | Converted from .docx to .md (MF-ISO-19). Applied standard 11-field document control header. Synchronized system version reference: "V1.0" → "V3". Added structured PII categories table and risk assessment summary section. |

---

*This document is part of the MedFlow V3 ISO 42001:2023 compliance portfolio.*

*End of Document*
