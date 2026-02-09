# Competence Assessment Matrix
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO42001-CAM-001
**Version:** 1.0
**Classification:** Internal
**Last Updated:** 2026-02-09
**Author:** Dr. Islam Mekawy, Lead Implementer
**ISO 42001 Reference:** Clause 7.2 - Competence
**NC Reference:** NC-001 (Internal Audit Report MF-ISO42001-IAR-001)

---

## 1. Purpose

This document provides formal competence assessment records for all personnel involved in the MedFlow V3 AI Management System (AIMS), in accordance with ISO 42001:2023 Clause 7.2. It maps documented qualifications, certifications, and professional experience to the competency requirements of each AIMS role, closing Non-Conformance NC-001 raised during the internal audit (2026-02-09).

---

## 2. Personnel Register

| ID | Name | Current Roles in AIMS | Employment | Location |
|----|------|----------------------|------------|----------|
| P-001 | Dr. Islam Mekawy, MSc, IFCE, CPHIMS, CCDS, FLMI | Lead Researcher & Architect, Clinical Validator, AI Governance Lead | Pre-Authorization Manager, Tawuniya Insurance Company (2019-Present) | Riyadh, Saudi Arabia |

**Note:** MedFlow V3 is a personal research initiative. Dr. Mekawy fulfills all three AIMS roles as defined in `iso42001-artifacts/Roles_Responsibilities.docx` (AIMS-5-3-001).

---

## 3. Qualifications Evidence

### 3.1 Academic Qualifications

| Qualification | Institution | Country | Relevance to AIMS |
|---------------|------------|---------|-------------------|
| MSc, Orthopedic Surgery | Zagazig University | Egypt | Clinical domain expertise; medical degree provides foundation for clinical validation of AI outputs |

### 3.2 Professional Certifications

| Certification | Issuing Body | Status | Relevance to AIMS |
|--------------|-------------|--------|-------------------|
| CPHIMS (Certified Professional in Health Information and Management Systems) | HIMSS | Active | Health informatics systems design, implementation, and management |
| CCDS (Certified Clinical Documentation Specialist) | CDIA Australia | Completed | Clinical documentation standards, coding accuracy, documentation improvement methodology |
| FLMI Level 1 (Fellow, Life Management Institute) | LOMA | Completed | Insurance operations, underwriting principles, claims management |
| AI in Healthcare Specialization | Stanford University | Completed | AI/ML applications in clinical settings, responsible AI, healthcare data science |
| IFCE (Insurance Foundation Certificate) | Saudi Central Bank (SAMA) | Active | Saudi insurance regulatory framework, market compliance |

### 3.3 Professional Memberships

| Organization | Membership Type | Relevance |
|-------------|----------------|-----------|
| HIMSS (Healthcare Information and Management Systems Society) | Member | Global health IT standards, informatics best practices |

---

## 4. Competence Matrix

### 4.1 Role: Lead Researcher & Architect

| Competency Area | Required | Evidence | Assessment |
|----------------|----------|----------|------------|
| **AI/ML Knowledge** | Understanding of AI system design, model selection, prompt engineering | Stanford AI in Healthcare Specialization; 64 hrs ISO 42001 implementation (Phases 1-6); designed 6-layer CDS pipeline | COMPETENT |
| **Clinical Domain Expertise** | Medical knowledge sufficient to design clinical decision rules | MSc Orthopedic Surgery; 10 yrs clinical practice (MOH Egypt); 6+ yrs medical review (Tawuniya) | COMPETENT |
| **Health Informatics** | Systems design, data standards, interoperability concepts | CPHIMS certification (HIMSS); HIMSS membership | COMPETENT |
| **System Architecture** | Software design, API integration, pipeline orchestration | Designed and implemented: PII scrubber, Knowledge Base, Gemini Client, CDS Brain, DRG Validator, Streamlit Dashboard | COMPETENT |
| **ISO 42001 Awareness** | Understanding of AIMS requirements, controls, and governance | 64 professional hours implementing ISO 42001 across 6 phases; produced 12 compliance artifacts; conducted internal audit | COMPETENT |

**Overall Assessment: COMPETENT**

### 4.2 Role: Clinical Validator (Self-Review)

| Competency Area | Required | Evidence | Assessment |
|----------------|----------|----------|------------|
| **Medical Degree** | Clinical training to evaluate AI medical outputs | MSc Orthopedic Surgery (Zagazig University) | COMPETENT |
| **Clinical Coding** | ICD-10, DRG classification understanding | CCDS (CDIA Australia); daily DRG documentation work at Tawuniya | COMPETENT |
| **Documentation Standards** | Clinical documentation quality and improvement methodology | CCDS certification; Pre-Authorization Manager role involves daily documentation review | COMPETENT |
| **Medical Review Experience** | Ability to assess medical necessity and clinical justification | 6+ yrs as Pre-Authorization Manager / Roving Doctor at Tawuniya; evaluate clinical justifications daily | COMPETENT |
| **Saudi Healthcare Context** | MOH protocols, CHI guidelines, Saudi regulatory landscape | IFCE (Saudi Central Bank); working under CHI guidelines at Tawuniya since 2019 | COMPETENT |

**Overall Assessment: COMPETENT**

### 4.3 Role: AI Governance Lead (Self-Governance)

| Competency Area | Required | Evidence | Assessment |
|----------------|----------|----------|------------|
| **ISO 42001 Framework** | Ability to implement and maintain AIMS governance | 64 hrs implementation experience; 12 ISO artifacts produced; internal audit conducted; management review held | COMPETENT |
| **Risk Management** | Identify, assess, and treat AI-specific risks | AI Risk Register v3.0 with 14 risks (8 technical + 6 strategic); likelihood x impact scoring; residual risk tracking | COMPETENT |
| **Audit Methodology** | Plan and execute internal audits, document findings | Internal Audit Report (MF-ISO42001-IAR-001): 39 controls audited, 9 conformance findings, 3 NCs, 3 observations | COMPETENT |
| **Data Protection Awareness** | PDPL, data sovereignty, PII handling principles | Designed Defense-in-Depth PII scrubbing (local processing via Ollama); AI Data Policy created; PDPL alignment documented | COMPETENT |
| **Insurance Domain** | Healthcare insurance operations, pre-authorization workflows | FLMI Level 1 (LOMA); IFCE (SAMA); 6+ yrs Tawuniya pre-authorization management | COMPETENT |

**Overall Assessment: COMPETENT**

---

## 5. Professional Experience Summary

### 5.1 Tawuniya Insurance Company, Riyadh, Saudi Arabia (2019 - Present)
**Position:** Pre-Authorization Manager / Roving Doctor

| Responsibility | Relevance to AIMS |
|---------------|-------------------|
| Manage medical review and pre-authorization for inpatient and high-cost procedures | Direct domain experience for CDS system design |
| Evaluate clinical justifications, ensure alignment with policy, verify medical necessity | Core competency for Clinical Validator role |
| Coordinate with audit and contracting teams for claim integrity | Audit methodology and governance experience |
| Support DRG transition through documentation and clinical coding alignment | DRG Validator design competency |
| Monitor denial trends and propose improvement strategies | Continual improvement methodology |

### 5.2 Ministry of Health, Egypt (2008 - 2018)
**Position:** Specialist, Orthopedic Surgery

| Responsibility | Relevance to AIMS |
|---------------|-------------------|
| Managed orthopedic and trauma cases, performed surgeries and post-operative care | Clinical domain expertise for medical output validation |
| Led ward teams and contributed to training programs | Leadership and clinical education competency |

---

## 6. Languages

| Language | Proficiency | Relevance |
|----------|------------|-----------|
| Arabic | Native | Saudi regulatory documents, MOH protocols, patient records |
| English | Fluent | Technical documentation, ISO standards, international guidelines |

---

## 7. Training Log (ISO 42001 Implementation)

Reference: `iso42001-artifacts/Implementation_Experience_Log.md` (MF-ISO42001-IEL-001)

| Phase | Activity | Hours | ISO Clauses Covered |
|-------|----------|-------|-------------------|
| 1 - Foundation | Gap analysis, project planning, environment setup | 8 | 4.1, 4.3, 6.3 |
| 2 - Risk Assessment | Risk identification, impact assessment, control mapping | 10 | 6.1, 6.1.2, 6.1.3 |
| 3 - Policy Development | AI Policy, Data Policy, roles, resource management | 12 | 5.2, 5.3, 7.1, 7.3 |
| 4 - Technical Implementation | Pipeline development, testing, validation | 18 | 8.1-8.6, A.5-A.7 |
| 5 - Monitoring & Measurement | Dashboard, audit trails, performance monitoring | 8 | 9.1, A.8, A.9 |
| 6 - Audit & Review | Internal audit, management review, improvement log | 8 | 9.2, 9.3, 10.1, 10.2 |
| **Total** | | **64** | **Clauses 4-10, Annex A, Annex B** |

---

## 8. Competence Gap Analysis

### 8.1 Current State (Research Prototype)

| Gap Area | Description | Risk Level | Mitigation |
|----------|-------------|------------|------------|
| None identified | All 3 current AIMS roles are assessed as COMPETENT based on documented qualifications and experience | N/A | N/A |

### 8.2 Future State (Enterprise Deployment)

| Gap Area | Required Competency | Current Status | Recommended Action |
|----------|-------------------|----------------|-------------------|
| Data Protection Officer | CIPP/M or equivalent DPO certification | Not held | Obtain certification if DPO role is assigned |
| AR-DRG v9.0 Formal Training | Certified AR-DRG coder credentials | Practical experience only | Pursue formal CCHI coding certification |
| ISO 42001 Lead Auditor | Formal auditor certification for independent assessments | Implementation experience only | Consider Lead Auditor training for enterprise governance |

---

## 9. Assessment Conclusion

### 9.1 Summary

| Role | Assessment | Confidence |
|------|-----------|------------|
| Lead Researcher & Architect | COMPETENT | High - 5/5 competency areas evidenced |
| Clinical Validator (Self-Review) | COMPETENT | High - 5/5 competency areas evidenced |
| AI Governance Lead (Self-Governance) | COMPETENT | High - 5/5 competency areas evidenced |

### 9.2 NC-001 Disposition

| Attribute | Detail |
|-----------|--------|
| **Non-Conformance** | NC-001: Competence Assessment Records Missing (Clause 7.2) |
| **Original Finding** | Roles defined but no formal competence evidence documented |
| **Corrective Action Taken** | This Competence Assessment Matrix (CAM-001) created with CV-sourced evidence |
| **Result** | All 3 AIMS roles assessed as COMPETENT with full evidence trail |
| **Status** | **CLOSED** |

---

## 10. Corrective Action Traceability

| Step | Action | Date | Evidence |
|------|--------|------|----------|
| 1. Finding Raised | NC-001 identified during internal audit: competence records missing (Cl. 7.2) | 2026-02-09 | `iso42001-artifacts/Internal_Audit_Report.md` (NC-001) |
| 2. Root Cause Identified | Single-researcher project; formal HR documentation not prioritized during build phases | 2026-02-09 | `iso42001-artifacts/Internal_Audit_Report.md` (NC-001, Root Cause) |
| 3. Corrective Action Planned | Create competence matrix mapping roles to qualifications; document Lead Implementer credentials | 2026-02-09 | Management Review MRA-001, Improvement Log IMP-011 |
| 4. Corrective Action Executed | Competence Assessment Matrix (CAM-001) created using verified CV data and certification records | 2026-02-09 | This document (all sections) |
| 5. Verification | All 3 roles assessed COMPETENT; 6 certifications mapped; 16+ yrs professional experience documented | 2026-02-09 | This document (Sections 4, 9) |
| 6. Closure | NC-001 closed; MRA-001 closed; IMP-011 completed; Clause 7.2 status updated to IMPLEMENTED | 2026-02-09 | IAR, MRM, CIL, Compliance Matrix updated |

---

## Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Lead Implementer | Dr. Islam Mekawy | 2026-02-09 | __________ |
| Management Representative | Dr. Islam Mekawy | 2026-02-09 | __________ |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-09 | Dr. Islam Mekawy | Initial competence assessment matrix; NC-001 closure evidence |

---

*End of Document*
