# Algorithmic Impact Assessment
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO42001-AIA-001
**Version:** 1.0
**Classification:** Internal
**Last Updated:** 2026-02-06
**Author:** MedFlow Development Team
**ISO 42001 Reference:** Annex A.5 - AI System Impact Assessment

---

## 1. Executive Summary

This Algorithmic Impact Assessment (AIA) evaluates the potential effects of deploying MedFlow V3's AI-assisted clinical decision support system in healthcare insurance contexts. The assessment focuses on three critical dimensions: **Patient Safety**, **Fairness**, and **Human Oversight**.

**Overall Risk Rating:** MEDIUM (with mitigations in place)

---

## 2. System Description

### 2.1 Purpose

MedFlow V3 assists medical reviewers in evaluating inpatient admission requests by:
- Analyzing clinical documentation (PDFs, DOCX, images)
- Extracting clinical timelines and key medical events
- Assigning ICD-10 codes and Saudi AR-DRG v9.0 classifications
- Generating recommendations (HOME CARE / EXTENSION / DISCHARGE)

### 2.2 Decision Authority

| Confidence Level | Action | Human Role |
|-----------------|--------|------------|
| ≥85% | Auto-approved | Post-hoc audit |
| 70-84% | Standard review | Physician validation required |
| <70% | Escalated | Senior physician mandatory review |

### 2.3 Scope

- **In-Scope:** Inpatient admission review, length-of-stay decisions, DRG classification
- **Out-of-Scope:** Emergency decisions, treatment recommendations, medication dosing

---

## 3. Patient Safety Impact Assessment

### 3.1 Risk: Delayed Care Authorization

| Attribute | Assessment |
|-----------|------------|
| **Description** | Incorrect denial or delay in authorization may result in delayed treatment |
| **Affected Stakeholders** | Patients, treating physicians, hospitals |
| **Likelihood** | Unlikely (2) |
| **Severity** | Major (4) |
| **Impact Score** | 8 (MEDIUM) |

**Mitigations:**
- Human-in-the-loop for all sub-85% confidence decisions
- Escalation pathway for time-sensitive conditions (stroke, sepsis, MI)
- 24-hour turnaround SLA for urgent cases
- Clear override mechanism for treating physicians

**Residual Risk:** LOW (3)

---

### 3.2 Risk: Missed Critical Diagnoses

| Attribute | Assessment |
|-----------|------------|
| **Description** | AI may fail to identify critical diagnoses from complex documentation |
| **Affected Stakeholders** | Patients, insurance medical reviewers |
| **Likelihood** | Possible (3) |
| **Severity** | Major (4) |
| **Impact Score** | 12 (HIGH) |

**Mitigations:**
- Multi-document analysis ensures comprehensive review
- Timeline extraction highlights clinical progression
- "General Clinical Reasoning" fallback when protocols missing
- Confidence scoring reflects diagnostic uncertainty

**Residual Risk:** MEDIUM (6)

---

### 3.3 Risk: PII Exposure

| Attribute | Assessment |
|-----------|------------|
| **Description** | Patient identifiable information leaked to cloud AI services |
| **Affected Stakeholders** | Patients, data protection authorities |
| **Likelihood** | Rare (1) |
| **Severity** | Catastrophic (5) |
| **Impact Score** | 5 (MEDIUM) |

**Mitigations:**
- Defense in Depth PII scrubbing (Regex Layer 1 + LLM Layer 2 + Validation Layer 3)
- Local-only PII processing via Ollama (data never leaves premises)
- PII Manifest generation for audit trail
- No real patient data used in current research phase

**Residual Risk:** LOW (4)

---

## 4. Fairness & Bias Impact Assessment

### 4.1 DRG Classification Bias

| Attribute | Assessment |
|-----------|------------|
| **Concern** | Systematic under- or over-classification of certain conditions may disadvantage patient populations |
| **Affected Groups** | Chronic disease patients, elderly, pediatric cases |
| **Evidence Required** | Disparate impact analysis across demographic groups |
| **Current Status** | MONITORING - Insufficient production data |

**Analysis Methodology:**
```
For each DRG category:
  1. Compare AI classification vs. human reviewer classification
  2. Stratify by: Age group, Gender, Primary diagnosis category
  3. Calculate: Selection rate, Positive predictive value, False negative rate
  4. Flag: Disparities > 10% for investigation
```

**Fairness Metrics:**
| Metric | Threshold | Status |
|--------|-----------|--------|
| Demographic Parity | <10% variance | PENDING VALIDATION |
| Equal Opportunity | <15% FNR variance | PENDING VALIDATION |
| Calibration | Within 5% across groups | PENDING VALIDATION |

---

### 4.2 Recommendation Bias

| Attribute | Assessment |
|-----------|------------|
| **Concern** | AI recommendations may systematically favor certain outcomes (e.g., DISCHARGE over EXTENSION) |
| **Evidence** | Synthetic data testing shows no systematic bias |
| **Validation Needed** | 100+ real case validation with demographic stratification |

**Bias Detection Controls:**
- Outcome distribution monitoring (expected vs. actual)
- Periodic blind comparison with human reviewers
- Appeal rate tracking by demographic category

---

### 4.3 Protocol Coverage Gaps

| Attribute | Assessment |
|-----------|------------|
| **Concern** | Knowledge base may lack protocols for conditions affecting specific populations |
| **Current Gap** | No dedicated protocols for: Stroke, ACS/STEMI, Sepsis |
| **Impact** | Cases fallback to "General Clinical Reasoning" |

**Remediation:**
- Priority protocol acquisition list maintained
- Fallback clearly labeled to prevent false confidence
- User action required to expand knowledge base

---

## 5. Human Oversight Requirements

### 5.1 Oversight Framework

| Level | Trigger | Reviewer | Response Time |
|-------|---------|----------|---------------|
| **Autonomous** | Confidence ≥85% | None (audit only) | N/A |
| **Supervised** | Confidence 70-84% | Medical Reviewer | 24 hours |
| **Escalated** | Confidence <70% | Senior Physician | 4 hours |
| **Emergency** | Time-sensitive dx | On-call Physician | 1 hour |

### 5.2 Override Mechanisms

**Reviewer Override:**
- Any AI recommendation can be overridden with documented rationale
- Override does not require supervisor approval
- Override logged for continuous improvement

**Patient/Provider Appeal:**
- Dedicated appeal pathway for AI-assisted decisions
- Human-only review for appealed cases
- 48-hour resolution target

### 5.3 Explainability Requirements

Each AI recommendation includes:
1. **Confidence Score** - Numerical certainty (0-100%)
2. **Review Level** - Human oversight category
3. **Key Factors** - Primary clinical drivers
4. **Citations** - MOH protocols or "General Clinical Reasoning"
5. **Timeline Summary** - Clinical progression highlights

---

## 6. Monitoring & Continuous Improvement

### 6.1 Key Performance Indicators

| KPI | Target | Measurement Frequency |
|-----|--------|----------------------|
| Accuracy vs. Human | ≥90% agreement | Weekly |
| Appeal Rate | <5% | Monthly |
| Override Rate | <15% | Monthly |
| Time-to-Decision | <24 hours (avg) | Weekly |
| PII Leak Incidents | 0 | Continuous |

### 6.2 Bias Audit Schedule

| Audit Type | Frequency | Owner |
|------------|-----------|-------|
| Outcome Distribution | Monthly | AI Engineer |
| Demographic Disparity | Quarterly | Clinical Validator |
| Protocol Coverage | Quarterly | Clinical Validator |
| Full Fairness Audit | Annually | External Auditor |

---

## 7. Stakeholder Notification

### 7.1 Affected Parties

| Stakeholder | Notification Method | Content |
|-------------|--------------------|---------|
| Patients | Admission documents | AI-assisted review disclosure |
| Treating Physicians | Portal notification | Decision rationale, appeal path |
| Hospitals | Contract amendment | AI system description, oversight model |
| Regulators | Annual report | AIA summary, audit results |

### 7.2 Transparency Statement

> "MedFlow V3 uses artificial intelligence to assist medical reviewers in evaluating inpatient admission requests. AI recommendations are subject to human oversight and can be overridden by qualified medical personnel. The system does not make final decisions without appropriate human validation."

---

## 8. Conclusion & Recommendations

### 8.1 Summary of Findings

| Impact Area | Inherent Risk | Residual Risk | Status |
|-------------|---------------|---------------|--------|
| Patient Safety | HIGH | MEDIUM | Controls implemented |
| Fairness (DRG Bias) | MEDIUM | LOW-MEDIUM | Monitoring required |
| Human Oversight | LOW | LOW | Framework established |

### 8.2 Recommendations

1. **Immediate:** Complete 100-case validation study with demographic stratification
2. **Short-term:** Acquire missing clinical protocols (Stroke, ACS, Sepsis)
3. **Medium-term:** Establish external fairness audit partnership
4. **Ongoing:** Monthly bias monitoring and quarterly AIA updates

---

## 9. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| AI Ethics Officer | _________________ | __________ | __________ |
| Clinical Lead | _________________ | __________ | __________ |
| Data Protection Officer | _________________ | __________ | __________ |

---

## 10. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-06 | MedFlow Team | Initial assessment |

---

*End of Document*
