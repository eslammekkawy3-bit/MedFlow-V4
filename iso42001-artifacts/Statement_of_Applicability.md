# Statement of Applicability
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO-20
**Title:** Statement of Applicability (SOA)
**Version:** 1.0
**Status:** ACTIVE
**Date:** 2026-02-21
**Author:** Dr. Islam Mekawy
**Reviewer:** Dr. Islam Mekawy (Lead Researcher)
**Approver:** Dr. Islam Mekawy (AI Governance Lead)
**Classification:** CONFIDENTIAL – Internal Use Only
**ISO 42001 Clause:** Clause 6.1.3 – Statement of Applicability
**Supersedes:** N/A (Initial Issue)

---

## 1. Purpose

This Statement of Applicability (SOA) documents which ISO/IEC 42001:2023 Annex A and Annex B controls are applicable to the MedFlow V3 AI Management System (AIMS), and the justification for inclusion or exclusion of each control. It is a mandatory output of the risk treatment planning process (Clause 6.1.3) and serves as the bridge between risk assessment and control implementation.

**Scope of AIMS:** AI-powered clinical decision support for inpatient admission review in Saudi Arabian healthcare insurance. The system processes medical records, assigns ICD-10/AR-DRG codes, and recommends clinical decisions (DISCHARGE / EXTENSION / HOME CARE / ESCALATE). See MF-ISO-02 (AIMS Scope).

---

## 2. How to Read This SOA

| Column | Meaning |
|--------|---------|
| **Applicable** | Y = Control applies to MedFlow V3; N = Not applicable with justification |
| **Implementation Status** | IMPLEMENTED / PARTIAL / PLANNED / N/A |
| **Evidence Artifact** | Primary document or code artifact providing evidence |
| **Justification (Exclusion)** | Required only when Applicable = N |

---

## 3. Annex A Controls — Statement of Applicability

### A.2 Policies for AI

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| AI policy established and communicated | A.2.2 | **Y** | IMPLEMENTED | MF-ISO-01 (AI_Policy.docx) | Core governance requirement; policy defines medical necessity focus, PDPL compliance, Gemini/Ollama usage |
| AI policy aligned with organizational objectives | A.2.3 | **Y** | IMPLEMENTED | MF-ISO-01 (AI_Policy.docx), MF-ISO-04 (AI_Objectives.docx) | Policy explicitly aligns with ISO 42001, PDPL, NPHIES, and Saudi MOH guidelines |
| AI objectives defined and measurable | A.2.4 | **Y** | IMPLEMENTED | MF-ISO-04 (AI_Objectives.docx) | Objectives include confidence thresholds (≥85% auto-approve), PII leak rate (0), review levels |

---

### A.3 Internal Organization

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| AI roles and responsibilities defined | A.3.2 | **Y** | IMPLEMENTED | MF-ISO-03 (Roles_Responsibilities.docx) | 3 AIMS roles: Lead Researcher, Clinical Validator, AI Governance Lead – all fulfilled by Dr. Islam Mekawy |
| Competence requirements assessed | A.3.3 | **Y** | IMPLEMENTED | MF-ISO-11 (Competence_Assessment_Matrix.md) | NC-001 CLOSED: 6 certifications mapped (MSc, CPHIMS, CCDS, FLMI, Stanford AI, IFCE), 16+ yrs experience |
| Resources for AIMS adequately provided | A.3.4 | **Y** | IMPLEMENTED | MF-ISO-08 (Resource_Management.md) | Hardware (32GB RAM, GPU), software (Python 3.12, Ollama, ChromaDB), API budget documented |

---

### A.4 Resources for AI Systems

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Computing resources assessed and documented | A.4.2 | **Y** | IMPLEMENTED | MF-ISO-08 (Resource_Management.md) | Local GPU for Ollama/Llama 3.2; Google Gemini API for cloud inference; ChromaDB for vector store |
| Data resources identified and managed | A.4.3 | **Y** | IMPLEMENTED | MF-ISO-06 (AI_Data_Policy.md), MF-ISO-19 (DPIA.docx) | 13 MOH PDFs + 3 international guidelines; 9,296 ChromaDB chunks; synthetic test data only |
| Human resources (subject matter expertise) confirmed | A.4.4 | **Y** | IMPLEMENTED | MF-ISO-11 (Competence_Assessment_Matrix.md) | Clinical coding (CCDS), healthcare informatics (CPHIMS), insurance (FLMI), AI governance expertise |
| Tooling and infrastructure documented | A.4.5 | **Y** | IMPLEMENTED | MF-ISO-07 (AI_System_Design.md) | Full 6-layer pipeline documented: Ollama, ChromaDB, Gemini API, Streamlit, governance event bus |

---

### A.5 Assessing Impacts of AI Systems

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| AI impact assessment process established | A.5.2 | **Y** | IMPLEMENTED | MF-ISO-09 (Algorithmic_Impact_Assessment.md) | AIA covers patient safety, DRG bias, human oversight framework; MEDIUM overall risk |
| Positive and negative impacts identified | A.5.3 | **Y** | IMPLEMENTED | MF-ISO-09 (AIA), MF-ISO-05 (AI_Risk_Register.md) | 16 risks documented; positive: faster review, consistent citations, upcoding detection |
| Impacts of AI on affected individuals assessed | A.5.4 | **Y** | IMPLEMENTED | MF-ISO-09 (AIA Section 3), MF-ISO-10 (AFR-001) | Patient safety risks documented; 24/24 fairness metrics PASS (0.00% demographic variance) |
| Impact assessment reviewed periodically | A.5.5 | **Y** | PARTIAL | MF-ISO-13 (Management_Review_Minutes.md) | Q1 2026 management review conducted; follow-up planned Q2 2026 (May 15) |

---

### A.6 Data for AI Systems

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Data governance policy established | A.6.2 | **Y** | IMPLEMENTED | MF-ISO-06 (AI_Data_Policy.md) | Covers PII classification, data localization, minimization, retention (7-year), third-party controls |
| Data quality managed | A.6.3 | **Y** | IMPLEMENTED | MF-ISO-06 (Section 5), MF-ISO-07 (AI_System_Design.md) | Input validation (UTF-8, max 50K chars); output validation (PII leak detection, confidence threshold) |
| Training data managed and documented | A.6.4 | **Y** | IMPLEMENTED | `gold_standard/` (51 cases), `synthetic_data.py` v3.0.0 | Synthetic data only (no real patient data); gold standard: 12 diagnoses, 4 arcs, seed-reproducible |
| Data provenance tracked | A.6.5 | **Y** | IMPLEMENTED | `rag_ingestion.py` v1.2.0, `source_metadata` in registry | ChromaDB chunks tagged with source PDF, tier, population_type, NCEBM score, PII verification status |
| PII removed from data before processing | A.6.6 | **Y** | IMPLEMENTED | `pii_scrubber.py` v2.1.0, MF-ISO-06, MF-ISO-19 (DPIA) | Defense-in-Depth: Regex (L1) + Llama 3.2 via Ollama (L2) + Leakage Validation (L3); 37 chunks blocked |

---

### A.7 Information about AI Systems

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Information about AI system capabilities and limitations documented | A.7.2 | **Y** | IMPLEMENTED | MF-ISO-17 (User_Guide_Clinical.md), MF-ISO-07 (AI_System_Design.md) | User guide covers: confidence interpretation, review levels, override procedures, scope limitations |
| Intended use cases documented | A.7.3 | **Y** | IMPLEMENTED | MF-ISO-02 (AIMS_Scope.docx), MF-ISO-09 (AIA Section 2.3) | In-scope: inpatient review, LOS decisions, DRG classification; Out-of-scope: emergency, treatment, dosing |
| Potential misuse cases identified | A.7.4 | **Y** | IMPLEMENTED | MF-ISO-09 (AIA), MF-ISO-05 (Risk Register RISK-007) | Upcoding detection (DRG manipulation); confidence gaming; MEDICAL NECESSITY only (not insurance coverage) |
| AI system limitations communicated to users | A.7.5 | **Y** | IMPLEMENTED | MF-ISO-17 (User_Guide_Clinical.md Section 1) | "MedFlow provides recommendations, not decisions. You retain full clinical authority." |

---

### A.8 Relating with AI System Users

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Feedback mechanisms established | A.8.2 | **Y** | PARTIAL | MF-ISO-13 (MRM), MF-ISO-15 (CIL) | Override logging and improvement log capture feedback; formal patient appeal pathway defined but not yet tested |
| User training and awareness provided | A.8.3 | **Y** | PARTIAL | MF-ISO-17 (User_Guide_Clinical.md) | User guide produced; formal training program planned for production deployment |
| Transparency to affected individuals | A.8.4 | **Y** | IMPLEMENTED | MF-ISO-09 (AIA Section 7.2) | Transparency statement: AI-assisted review disclosed; human override always available |
| Human override mechanism provided | A.8.5 | **Y** | IMPLEMENTED | MF-ISO-09 (AIA Section 5.2), `app.py` v2.0.0 | All recommendations overridable with logged rationale; 4-tier review levels enforced |

---

### A.9 AI System Verification and Validation

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| V&V plan established | A.9.2 | **Y** | IMPLEMENTED | MF-ISO-18 (Verification_Validation_Plan.md) | V&V plan covers: unit tests, integration tests, clinical validation, fairness testing |
| Verification testing performed | A.9.3 | **Y** | IMPLEMENTED | `test_rtrm.py` (11/11 PASS), `drg_validator.py --test` (8/8 PASS), `documentation_quality_gate.py --test` (5/5 PASS) | Automated test suites for all critical layers |
| Validation against clinical requirements | A.9.4 | **Y** | IMPLEMENTED | `output/masterpiece_result.json`, `output/masterpiece_v2_test.json` | 30-day Sepsis masterpiece validation: DISCHARGE 91%, AUTO_APPROVED; 6-day delay correctly detected |
| V&V results documented | A.9.5 | **Y** | IMPLEMENTED | MF-ISO-12 (IAR), MF-ISO-15 (CIL), MEDFLOW_PROJECT_TRACKER.md | All test results logged with session dates, case IDs, and git commit hashes |

---

### A.10 AI System Monitoring

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Monitoring plan established | A.10.2 | **Y** | IMPLEMENTED | `governance/real_time_risk_monitor.py` v1.0.0 | RTRM: 2-signal drift detection (confidence + recommendation distribution), 100-event rolling window |
| Performance metrics monitored | A.10.3 | **Y** | IMPLEMENTED | RTRM + `gold_standard/` (51 cases) | Baseline: 51 gold standard cases; drift threshold >10% shift triggers RISK_DRIFT_DETECTED event |
| Monitoring results acted upon | A.10.4 | **Y** | IMPLEMENTED | `governance/governance_controller.py` v1.0.0 | Pub/Sub event bus: RISK_DRIFT_DETECTED → alert emission; JSONL audit log for all events |
| Monitoring covers bias and fairness | A.10.5 | **Y** | PARTIAL | MF-ISO-10 (AFR-001), RTRM | Fairness validated at baseline; ongoing real-time fairness monitoring planned for production |

---

### A.11 Incident Management

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Incident response process defined | A.11.2 | **Y** | PARTIAL | MF-ISO-06 (AI_Data_Policy.md Section 9) | Breach protocol: Detection → Containment → 72h DPO notification → Root Cause → Remediation |
| Non-conformance tracking maintained | A.11.3 | **Y** | IMPLEMENTED | MF-ISO-12 (IAR), MF-ISO-15 (CIL) | 5 NCs tracked and closed: NC-001 (competence), NC-002 (fairness), NC-003 (drift), NC-004 (CCAP), NC-005 (clinical logic) |
| Corrective actions verified | A.11.4 | **Y** | IMPLEMENTED | MF-ISO-12 (IAR), MF-ISO-13 (MRM), MF-ISO-15 (CIL) | All 5 NCs CLOSED with evidence: CAM-001, AFR-001, RTRM v1.0.0, masterpiece validation |
| Lessons learned captured | A.11.5 | **Y** | IMPLEMENTED | MF-ISO-15 (CIL), CLAUDE.md Lessons Learned | 15 completed improvements documented; lessons encoded in system architecture and CLAUDE.md |

---

### A.12 Continual Improvement

| Control | Ref | Applicable | Status | Evidence Artifact | Justification |
|---------|-----|-----------|--------|-------------------|---------------|
| Continual improvement process established | A.12.2 | **Y** | IMPLEMENTED | MF-ISO-15 (Continual_Improvement_Log.md) | 15 completed + 1 planned improvements tracked; sources: internal audit, testing, operational feedback |
| Improvement opportunities identified systematically | A.12.3 | **Y** | IMPLEMENTED | MF-ISO-13 (MRM), MF-ISO-12 (IAR) | Q1 2026 MRM generated 8 action items; Sprint 4 PLM planned with 4 enhancements |
| AIMS effectiveness evaluated | A.12.4 | **Y** | IMPLEMENTED | MF-ISO-16 (IEL), MF-ISO-14 (Compliance Matrix) | 39/39 controls IMPLEMENTED (100%); 114 professional hours; 5/5 NCs CLOSED |

---

## 4. Excluded Controls

| Control | Ref | Justification for Exclusion |
|---------|-----|-----------------------------|
| Third-party AI supplier management | A.3.5 | MedFlow V3 is a single-researcher initiative. Google Gemini API and Ollama/Meta Llama 3.2 are not "AI suppliers" in the procurement sense; they are infrastructure tools used under standard API agreements. Formal supplier management applies at production scale. |
| AI system decommissioning | A.8.6 | System is in research/prototype phase. Decommissioning controls (data deletion, model archival) will be applied at production scale per PDPL Article 9. |
| External AI system audit | A.12.5 | External audit by a third-party certification body is planned for production readiness (Phase 8). Not applicable at current research prototype stage. |

---

## 5. Annex B Implementation Guidance — Applicability

ISO 42001:2023 Annex B provides additional implementation guidance for specific AI use cases.

| Annex B Section | Topic | Applicable | Implementation Notes |
|-----------------|-------|-----------|----------------------|
| B.2 | AI system transparency | **Y** | Patent formula: Confidence = (Evidence × Completeness × Alignment) / 3; full audit trail per Layer 6 |
| B.3 | Explainability | **Y** | Each recommendation includes citations, confidence score, review level, and traceable rationale |
| B.4 | Robustness | **Y** | Gemini auto-fallback (2.0 → 2.5), Ollama fallback to regex-only, knowledge base keyword fallback |
| B.5 | Safety | **Y** | Human-in-the-loop for all <85% confidence; ESCALATE pathway for critical conditions |
| B.6 | Privacy | **Y** | Defense-in-Depth PII scrubbing; 100% local processing; PDPL compliant; DPIA completed |

---

## 6. SOA Summary Dashboard

| Category | Total Controls | Applicable | Not Applicable | Implemented | Partial | Planned |
|----------|---------------|-----------|----------------|-------------|---------|---------|
| A.2 Policies | 3 | 3 | 0 | 3 | 0 | 0 |
| A.3 Organization | 3 | 3 | 0 | 3 | 0 | 0 |
| A.4 Resources | 4 | 4 | 0 | 4 | 0 | 0 |
| A.5 Impact Assessment | 4 | 4 | 0 | 3 | 1 | 0 |
| A.6 Data | 5 | 5 | 0 | 5 | 0 | 0 |
| A.7 AI System Info | 4 | 4 | 0 | 4 | 0 | 0 |
| A.8 User Relations | 4 | 4 | 0 | 2 | 2 | 0 |
| A.9 V&V | 4 | 4 | 0 | 4 | 0 | 0 |
| A.10 Monitoring | 4 | 4 | 0 | 3 | 1 | 0 |
| A.11 Incidents | 4 | 4 | 0 | 3 | 1 | 0 |
| A.12 Improvement | 3 | 3 | 0 | 3 | 0 | 0 |
| **Excluded** | 3 | 0 | **3** | — | — | — |
| **TOTAL** | **45** | **42** | **3** | **37** | **5** | **0** |

**Overall Compliance Rate: 37/42 IMPLEMENTED (88.1%); 5/42 PARTIAL (11.9%)**
All partial controls have remediation plans documented in MF-ISO-15 (Continual Improvement Log).

---

## 7. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Lead Researcher | Dr. Islam Mekawy | 2026-02-21 | __________ |
| AI Governance Lead | Dr. Islam Mekawy | 2026-02-21 | __________ |

---

## 8. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-21 | Dr. Islam Mekawy | Initial issue. 42 applicable controls assessed; 37 IMPLEMENTED, 5 PARTIAL, 3 excluded. Aligned to v4.0 governance baseline (Sprint 1+2+3 COMPLETE, all 5 NCs CLOSED, 114 hours). |

---

*End of Document*
