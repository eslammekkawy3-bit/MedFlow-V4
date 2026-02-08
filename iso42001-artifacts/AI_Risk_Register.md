# AI Risk Register
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO42001-A4-001
**Version:** 4.0
**Classification:** Internal
**Last Updated:** 2026-02-07
**Author:** MedFlow Development Team
**ISO 42001 Reference:** Annex A.4 - AI System Risk Management

---

## 1. Purpose

This register documents identified AI-specific risks, their assessment, and implemented controls for MedFlow V3. It is a living document updated as risks are identified, mitigated, or realized.

---

## 2. Risk Assessment Methodology

### 2.1 Likelihood Scale

| Level | Score | Definition |
|-------|-------|------------|
| Rare | 1 | May occur only in exceptional circumstances |
| Unlikely | 2 | Could occur at some time |
| Possible | 3 | Might occur at some time |
| Likely | 4 | Will probably occur |
| Almost Certain | 5 | Expected to occur |

### 2.2 Impact Scale

| Level | Score | Definition |
|-------|-------|------------|
| Negligible | 1 | Minor inconvenience |
| Minor | 2 | Some disruption, easily recoverable |
| Moderate | 3 | Significant impact, requires intervention |
| Major | 4 | Serious harm, regulatory implications |
| Catastrophic | 5 | Patient harm, legal action, system shutdown |

### 2.3 Risk Rating

**Risk Score = Likelihood × Impact**

| Score | Rating | Action |
|-------|--------|--------|
| 1-4 | LOW | Monitor, accept |
| 5-9 | MEDIUM | Implement controls, monitor |
| 10-15 | HIGH | Priority mitigation required |
| 16-25 | CRITICAL | Immediate action, escalate |

---

## 3. Risk Register

### RISK-001: PII Data Leakage

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-001 |
| **Category** | Data Protection |
| **Description** | Personally Identifiable Information (PII) may be sent to cloud AI services, violating PDPL and patient privacy |
| **Likelihood** | Possible (3) |
| **Impact** | Major (4) |
| **Inherent Risk** | 12 (HIGH) |
| **Controls Implemented** | Defense in Depth PII scrubbing (Regex L1 + LLM L2 + Validation L3) |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Rare (1) |
| **Residual Impact** | Major (4) |
| **Residual Risk** | 4 (LOW) |
| **Owner** | Data Protection Officer |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

---

### RISK-002: AI Hallucination - Wrong Protocol Citation

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-002 |
| **Category** | AI Reliability |
| **Description** | System may cite irrelevant clinical protocols for a diagnosis (e.g., citing Hypoglycemia protocol for Stroke case) |
| **Likelihood** | Likely (4) |
| **Impact** | Moderate (3) |
| **Inherent Risk** | 12 (HIGH) |
| **Controls Implemented** | Strict Matching with Word Boundaries (v1.4.0); STOP_WORDS filtering; General Clinical Standards fallback |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Unlikely (2) |
| **Residual Impact** | Moderate (3) |
| **Residual Risk** | 6 (MEDIUM) |
| **Owner** | AI Engineer |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

**Root Cause Analysis:**
- Substring matching caused "mi" to match "hypoglycemia"
- Generic terms like "inpatient" and "acute" caused false matches

**Control Details:**
- `_variant_matches_text()` function uses `\b` word boundary regex
- STOP_WORDS set filters 40+ common medical modifiers
- `--test-strict` automated test validates 6 diagnosis scenarios

---

### RISK-003: PII Scrubbing Latency

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-003 |
| **Category** | Performance |
| **Description** | PII scrubbing via LLM takes excessive time (3.5+ minutes per case), impacting user experience and throughput |
| **Likelihood** | Almost Certain (5) |
| **Impact** | Minor (2) |
| **Inherent Risk** | 10 (HIGH) |
| **Controls Implemented** | Extraction vs. Rewriting strategy (v2.1.0); JSON output minimizes token generation |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Possible (3) |
| **Residual Impact** | Negligible (1) |
| **Residual Risk** | 3 (LOW) |
| **Owner** | AI Engineer |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-07 |

**Control Details:**
- LLM returns JSON list of names/hospitals only
- Python performs text replacement (fast, deterministic)
- Expected 3-5x speedup in LLM processing

**Residual Risk Note (Feb 7, 2026):**
- Measured processing time: ~35s/document for PII scrubbing (4-document case: 138s total)
- Full pipeline (PII + Gemini + DRG): ~50s/page average
- **Trade-off accepted:** Avg 50s/page processing time is accepted to maintain strict SDAIA Data Sovereignty compliance (all PII scrubbing runs locally via Ollama). Cloud PII processing would be 10x faster but violates PDPL data localization requirements.
- Optimization path: GPU acceleration (8GB+ VRAM) can reduce local inference to <10s/page

---

### RISK-004: Gemini API Unavailability

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-004 |
| **Category** | Availability |
| **Description** | Google Gemini API may be unavailable due to rate limiting (429), model deprecation (404), or outages |
| **Likelihood** | Possible (3) |
| **Impact** | Moderate (3) |
| **Inherent Risk** | 9 (MEDIUM) |
| **Controls Implemented** | Auto-fallback model chain (2.0 → 2.5 → 1.5); Retry with exponential backoff |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Unlikely (2) |
| **Residual Impact** | Minor (2) |
| **Residual Risk** | 4 (LOW) |
| **Owner** | System Administrator |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-03 |

---

### RISK-005: Clinical Decision Accuracy

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-005 |
| **Category** | AI Reliability |
| **Description** | AI may generate clinically inappropriate recommendations, leading to incorrect insurance decisions |
| **Likelihood** | Possible (3) |
| **Impact** | Major (4) |
| **Inherent Risk** | 12 (HIGH) |
| **Controls Implemented** | Confidence thresholds; Review level assignment; Human escalation for < 70% confidence |
| **Control Effectiveness** | Partially Effective |
| **Residual Likelihood** | Unlikely (2) |
| **Residual Impact** | Major (4) |
| **Residual Risk** | 8 (MEDIUM) |
| **Owner** | Clinical Validator |
| **Status** | MONITORING |
| **Last Review** | 2026-02-04 |

**Additional Controls Needed:**
- Clinical validation with 100+ real cases
- Periodic accuracy audits
- Feedback loop for continuous improvement

---

### RISK-006: Missing Clinical Protocols

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-006 |
| **Category** | Data Completeness |
| **Description** | Knowledge base lacks protocols for common conditions (Stroke, ACS, Sepsis), forcing fallback to general reasoning |
| **Likelihood** | Almost Certain (5) |
| **Impact** | Minor (2) |
| **Inherent Risk** | 10 (HIGH) |
| **Controls Implemented** | General Clinical Standards fallback; Clear citation as "General Clinical Reasoning" |
| **Control Effectiveness** | Partially Effective |
| **Residual Likelihood** | Likely (4) |
| **Residual Impact** | Negligible (1) |
| **Residual Risk** | 4 (LOW) |
| **Owner** | Clinical Validator |
| **Status** | ACCEPTED |
| **Last Review** | 2026-02-04 |

**Remediation Plan:**
- User to source and add MOH protocols for Stroke, ACS, Sepsis
- Monitor fallback frequency to prioritize protocol acquisition

---

### RISK-007: DRG Misclassification / Model Bias

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-007 |
| **Category** | AI Fairness / Clinical Integrity |
| **Description** | AI models may misclassify DRG categories or exhibit bias against certain demographics, conditions, or treatment approaches. LLM may accept a claimed DRG without cross-checking clinical evidence. |
| **Likelihood** | Possible (3) |
| **Impact** | Major (4) |
| **Inherent Risk** | 12 (HIGH) |
| **Controls Implemented** | Rule-based DRG Validator (Layer 4) cross-checks LLM output; Focus on medical necessity (not insurance coverage); MOH protocol enforcement; Dual-Check Architecture (LLM context + Regex rules) |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Unlikely (2) |
| **Residual Impact** | Moderate (3) |
| **Residual Risk** | 6 (MEDIUM) |
| **Owner** | AI Ethics Officer |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-07 |

**Mitigation Detail (Feb 7, 2026):**
- Implemented `drg_validator.py` v1.0.0 as independent Layer 4 cross-check
- 25 MDC categories with keyword matching and severity marker scanning
- Validated with 8 automated test cases (100% pass rate)
- E2E test confirmed detection of DRG upcoding (E62B claimed for ICU sepsis patient)
- Dual-Check: Gemini provides clinical context, DRG Validator provides rule-based verification

**Remaining Controls Needed:**
- Bias testing across demographic groups
- Regular fairness audits
- Diverse clinical validation panel

---

### RISK-008: Ollama Service Failure

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-008 |
| **Category** | Availability |
| **Description** | Local Ollama service may be unavailable, preventing PII scrubbing |
| **Likelihood** | Unlikely (2) |
| **Impact** | Major (4) |
| **Inherent Risk** | 8 (MEDIUM) |
| **Controls Implemented** | Health check before processing; Regex-only fallback mode |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Rare (1) |
| **Residual Impact** | Moderate (3) |
| **Residual Risk** | 3 (LOW) |
| **Owner** | System Administrator |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

---

## 4. Risk Summary Dashboard

### 4.1 Technical & Operational Risks

| Risk ID | Title | Inherent | Residual | Status |
|---------|-------|----------|----------|--------|
| RISK-001 | PII Data Leakage | HIGH (12) | LOW (4) | MITIGATED |
| RISK-002 | Wrong Protocol Citation | HIGH (12) | MEDIUM (6) | MITIGATED |
| RISK-003 | PII Scrubbing Latency | HIGH (10) | LOW (3) | MITIGATED |
| RISK-004 | Gemini API Unavailability | MEDIUM (9) | LOW (4) | MITIGATED |
| RISK-005 | Clinical Decision Accuracy | HIGH (12) | MEDIUM (8) | MONITORING |
| RISK-006 | Missing Clinical Protocols | HIGH (10) | LOW (4) | ACCEPTED |
| RISK-007 | DRG Misclassification / Model Bias | HIGH (12) | MEDIUM (6) | MITIGATED |
| RISK-008 | Ollama Service Failure | MEDIUM (8) | LOW (3) | MITIGATED |

### 4.2 Strategic & Governance Risks

| Risk ID | Title | Inherent | Residual | Status |
|---------|-------|----------|----------|--------|
| RISK-009 | Regulatory Non-Alignment | MEDIUM (8) | MEDIUM (6) | MONITORING |
| RISK-010 | Model Drift Over Time | MEDIUM (9) | MEDIUM (6) | DOCUMENTED |
| RISK-011 | Transparency Gaps | LOW (6) | LOW (2) | MITIGATED |
| RISK-012 | Research Methodology | LOW (6) | LOW (2) | MITIGATED |
| RISK-013 | Staffing & Knowledge Continuity | LOW (6) | LOW (2) | MITIGATED |
| RISK-014 | Reputational Risk | LOW (4) | LOW (3) | MITIGATED |
| RISK-015 | Conflicting AI Evidence | MEDIUM (8) | LOW (3) | MITIGATED |

---

## 5. Risk Trend

```
Risk Reduction Over Time (Feb 7, 2026):

INHERENT RISKS:
HIGH ████████████████ (6 technical)
MED  █████████████    (5 technical + 2 strategic)
LOW  ████████         (4 strategic)

RESIDUAL RISKS (After Controls):
HIGH ░░░░░░░░░░░░░░░░ (0 remaining)
MED  ████████         (4 remaining: RISK-002,005,009,010)
LOW  ██████████████████ (11 after controls)

Total Active Risks: 15
├── Technical/Operational: 9 (added RISK-015)
└── Strategic/Governance: 6

By Status:
├── Mitigated: 11 (was 9, added RISK-007 upgrade + RISK-015)
├── Monitoring: 2 (RISK-005, RISK-009)
├── Documented: 1
└── Accepted: 1
```

---

## 6. Strategic & Governance Risks

*These risks address organization-level concerns beyond technical implementation.*

### RISK-009: Regulatory Non-Alignment

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-009 |
| **Category** | Regulatory Compliance |
| **Description** | Non-alignment with Saudi AI regulations (SDAIA, PDPL, NPHIES) may result in legal exposure or inability to deploy |
| **Likelihood** | Unlikely (2) |
| **Impact** | Major (4) |
| **Inherent Risk** | 8 (MEDIUM) |
| **Controls Implemented** | ISO 42001 framework study; PDPL alignment documentation; CHI standard compliance |
| **Control Effectiveness** | Partially Effective |
| **Residual Likelihood** | Unlikely (2) |
| **Residual Impact** | Moderate (3) |
| **Residual Risk** | 6 (MEDIUM) |
| **Owner** | Lead Researcher |
| **Status** | MONITORING |
| **Last Review** | 2026-02-04 |

**Regulatory Framework:**
- Saudi Data & AI Authority (SDAIA) AI Ethics Principles
- Personal Data Protection Law (PDPL)
- National Platform for Health Information Exchange (NPHIES)
- Council of Health Insurance (CHI) Standards

---

### RISK-010: Model Drift Over Time

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-010 |
| **Category** | Long-Term Operations |
| **Description** | AI model performance may degrade over time as clinical guidelines, coding standards, or data patterns evolve |
| **Likelihood** | Possible (3) |
| **Impact** | Moderate (3) |
| **Inherent Risk** | 9 (MEDIUM) |
| **Controls Implemented** | Performance monitoring framework design; Drift detection methodology documented |
| **Control Effectiveness** | Planned |
| **Residual Likelihood** | Possible (3) |
| **Residual Impact** | Minor (2) |
| **Residual Risk** | 6 (MEDIUM) |
| **Owner** | System Administrator |
| **Status** | DOCUMENTED |
| **Last Review** | 2026-02-04 |

**Planned Controls:**
- Quarterly accuracy audits against new cases
- ICD-10/AR-DRG version update process
- MOH protocol refresh workflow

---

### RISK-011: Transparency & Explainability Gaps

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-011 |
| **Category** | AI Governance |
| **Description** | Insufficient explainability of AI decisions may undermine trust, regulatory compliance, and clinical acceptance |
| **Likelihood** | Unlikely (2) |
| **Impact** | Moderate (3) |
| **Inherent Risk** | 6 (LOW) |
| **Controls Implemented** | Comprehensive audit logging; Decision rationale capture; Confidence scores with review levels |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Rare (1) |
| **Residual Impact** | Minor (2) |
| **Residual Risk** | 2 (LOW) |
| **Owner** | AI Ethics Officer |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

**ISO 42001 Alignment:** Clause 9.2 - AI System Monitoring and Measurement

---

### RISK-012: Research Methodology Validation

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-012 |
| **Category** | Quality Assurance |
| **Description** | Research findings may be challenged if methodology lacks rigor, reproducibility, or proper documentation |
| **Likelihood** | Unlikely (2) |
| **Impact** | Moderate (3) |
| **Inherent Risk** | 6 (LOW) |
| **Controls Implemented** | Version control; Synthetic data only; Comprehensive audit trails; ISO 42001 artifact generation |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Rare (1) |
| **Residual Impact** | Minor (2) |
| **Residual Risk** | 2 (LOW) |
| **Owner** | Lead Researcher |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

---

### RISK-013: Staffing & Knowledge Continuity

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-013 |
| **Category** | Organizational |
| **Description** | Loss of key personnel or institutional knowledge may impact system maintenance and development continuity |
| **Likelihood** | Unlikely (2) |
| **Impact** | Moderate (3) |
| **Inherent Risk** | 6 (LOW) |
| **Controls Implemented** | Comprehensive documentation (CLAUDE.md, PROJECT_TRACKER); Modular architecture; Code comments |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Rare (1) |
| **Residual Impact** | Minor (2) |
| **Residual Risk** | 2 (LOW) |
| **Owner** | Lead Researcher |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

---

### RISK-014: Reputational Risk

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-014 |
| **Category** | Strategic |
| **Description** | Publicized failures or misuse of AI recommendations could damage institutional reputation and stakeholder trust |
| **Likelihood** | Rare (1) |
| **Impact** | Major (4) |
| **Inherent Risk** | 4 (LOW) |
| **Controls Implemented** | Human-in-the-loop validation; Confidence thresholds; Clear system limitations documentation |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Rare (1) |
| **Residual Impact** | Moderate (3) |
| **Residual Risk** | 3 (LOW) |
| **Owner** | Lead Researcher |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-04 |

---

### RISK-015: Conflicting AI Evidence (Gemini vs. DRG Validator)

| Attribute | Value |
|-----------|-------|
| **Risk ID** | RISK-015 |
| **Category** | AI Reliability |
| **Description** | AI components (Gemini LLM vs. Rule-Based DRG Validator) may disagree on diagnosis classification. Gemini uses contextual clinical reasoning while DRG Validator uses keyword frequency, leading to different MDC predictions when secondary diagnoses or incidental findings are prominent in the text. |
| **Likelihood** | Likely (4) |
| **Impact** | Minor (2) |
| **Inherent Risk** | 8 (MEDIUM) |
| **Controls Implemented** | System flags "MISMATCH" for human review (safety net); Dual-Check Architecture by design; Both predictions included in output JSON for audit; ESCALATE review level triggered on disagreement |
| **Control Effectiveness** | Effective |
| **Residual Likelihood** | Possible (3) |
| **Residual Impact** | Negligible (1) |
| **Residual Risk** | 3 (LOW) |
| **Owner** | AI Engineer |
| **Status** | MITIGATED |
| **Last Review** | 2026-02-07 |

**Root Cause (Observed Feb 7, 2026):**
- CASE-0020-42 (DKA case): Gemini correctly identified "Diabetic Ketoacidosis" as primary diagnosis
- DRG Validator predicted "Respiratory (MDC 04)" because 5 respiratory keywords (pneumonia, COPD, asthma, pleural effusion, pneumothorax) from imaging and PMH outnumbered endocrine keywords
- This is expected behavior in multi-document cases with rich secondary diagnoses

**Design Intent:**
- Disagreement between components is a **feature**, not a bug
- When LLM and rule engine disagree, it signals the case needs human clinical review
- Together they catch different failure modes: LLM misses coding rules, rules miss clinical context

---

## 7. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Risk Manager | _________________ | __________ | __________ |
| AI Ethics Officer | _________________ | __________ | __________ |
| System Owner | _________________ | __________ | __________ |

---

## 8. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-02 | MedFlow Team | Initial risk register |
| 2.0 | 2026-02-04 | MedFlow Team | Added RISK-002 (Hallucination), RISK-003 (Latency) with mitigations |
| 3.0 | 2026-02-06 | MedFlow Team | Merged Strategic & Governance Risks (RISK-009 to RISK-014) from legacy Risk_Register.xlsx |
| 4.0 | 2026-02-07 | MedFlow Team | Phase 4: RISK-007 upgraded to MITIGATED (DRG Validator); RISK-003 latency note (data sovereignty trade-off); New RISK-015 (Conflicting AI Evidence) |

---

*End of Document*
