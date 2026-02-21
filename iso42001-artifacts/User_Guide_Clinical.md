# Clinical User Guide
## MedFlow V3 - For Medical Reviewers

**Document ID:** MF-ISO-17
**Title:** Clinical User Guide
**Version:** 1.1
**Status:** ACTIVE
**Date:** 2026-02-21
**Author:** Dr. Islam Mekawy
**Reviewer:** Dr. Islam Mekawy (Lead Researcher)
**Approver:** Dr. Islam Mekawy (AI Governance Lead)
**Classification:** CONFIDENTIAL – Internal Use Only
**ISO 42001 Clause:** Clause 7.3, Clause 8.3 – Awareness & AI System Operations
**Audience:** Medical Reviewers, Physicians, Clinical Validators
**Supersedes:** MF-UG-CLINICAL-001 v1.0 (2026-02-06)

---

## 1. Introduction

MedFlow V3 is an AI-assisted clinical decision support system designed to help medical reviewers evaluate inpatient admission requests efficiently and consistently. This guide explains how to interpret AI outputs, understand confidence scores, and exercise appropriate clinical oversight.

**Important:** MedFlow provides recommendations, not decisions. You retain full clinical authority to accept, modify, or reject any AI-generated recommendation.

---

## 2. Quick Reference Card

| Confidence Score | Review Level | Your Action |
|-----------------|--------------|-------------|
| **85-100%** | Autonomous | Audit only (spot-check recommended) |
| **70-84%** | Standard Review | Validate recommendation before approval |
| **Below 70%** | Escalated | Mandatory review; consult senior physician if needed |

| Recommendation | Meaning |
|---------------|---------|
| **HOME CARE** | Patient meets criteria for discharge with home-based care |
| **EXTENSION** | Continued inpatient stay is medically necessary |
| **DISCHARGE** | Patient meets discharge criteria; inpatient stay not justified |

---

## 3. Understanding the Output Report

### 3.1 Case Summary

The AI extracts key clinical information from all submitted documents:

```
CASE SUMMARY
============
Primary Diagnosis: Acute Myocardial Infarction (I21.0)
Secondary Diagnoses: Type 2 Diabetes (E11.9), Hypertension (I10)
Admission Date: 2026-01-15
Current LOS: 7 days
DRG Classification: E65A (Major Cardiovascular Procedures)
```

**What to verify:**
- Are the diagnoses correctly identified?
- Is the ICD-10 coding accurate?
- Does the DRG reflect the clinical picture?

---

### 3.2 Clinical Timeline

The AI reconstructs the clinical progression from multiple documents:

```
CLINICAL TIMELINE
=================
Day 1: Presented with chest pain, troponin elevated (523 ng/L)
Day 2: Cardiac catheterization - 3-vessel disease identified
Day 3: CABG performed, transferred to ICU
Day 5: Extubated, hemodynamically stable
Day 7: Mobilizing, wound healing well
```

**What to verify:**
- Is the timeline accurate and complete?
- Are critical events captured?
- Does progression support the recommendation?

---

### 3.3 Confidence Score

The confidence score (0-100%) reflects the AI's certainty in its recommendation.

```
RECOMMENDATION: EXTENSION
CONFIDENCE: 78%
REVIEW LEVEL: STANDARD REVIEW
```

**How confidence is calculated:**
- Documentation completeness
- Guideline alignment clarity
- Diagnostic certainty
- Timeline consistency

**Interpreting low confidence:**
| Score Range | Common Reasons | Your Response |
|-------------|----------------|---------------|
| 60-69% | Mixed clinical indicators | Examine conflicting factors |
| 50-59% | Incomplete documentation | Request additional records |
| Below 50% | Complex/unclear case | Full manual review required |

---

### 3.4 Guideline Citations

Each recommendation cites the clinical guideline basis:

```
GUIDELINE BASIS
===============
Source: MOH Protocol - Diabetes Management
Citation: "For patients with HbA1c >9%, insulin optimization
          requires minimum 3-day inpatient monitoring..."
Reference: MOH-DM-2024, Section 4.2.1
```

**Citation Types:**

| Source | Reliability | Notes |
|--------|-------------|-------|
| **MOH Protocol** | Highest | Saudi Ministry of Health official guidelines |
| **UpToDate** | High | International clinical evidence |
| **General Clinical Reasoning** | Moderate | No specific protocol matched; AI applied general principles |

**When you see "General Clinical Reasoning":**
- No MOH protocol matched the diagnosis
- AI applied international standards and clinical logic
- Exercise additional scrutiny
- Consider whether a protocol SHOULD exist

---

## 4. Privacy Protection (PII Redaction)

### 4.1 What is Redacted

Before any clinical document reaches the AI analysis engine, sensitive information is automatically removed:

| Category | Examples | Replacement |
|----------|----------|-------------|
| Names | Ahmed Al-Rashid | [NAME_1] |
| National ID | 1234567890 | [NATIONAL_ID] |
| MRN | MRN-456789 | [MRN_1] |
| Phone | +966 55 123 4567 | [PHONE_1] |
| Email | patient@email.com | [EMAIL_1] |
| Dates of Birth | 15/03/1985 | [DOB_1] |
| Addresses | 123 King Fahd Rd | [ADDRESS_1] |
| Hospital Names | King Faisal Hospital | [HOSPITAL_1] |

### 4.2 Why This Matters

- **Regulatory Compliance:** Saudi PDPL requires PII protection
- **Data Sovereignty:** Sensitive data never leaves local processing
- **Cloud Safety:** Only de-identified data reaches cloud AI services

### 4.3 PII Manifest

Each case includes a PII Manifest for audit purposes:

```
PII MANIFEST
============
Items Redacted: 24
Categories: Names (4), MRN (2), Phone (3), DOB (2), Hospital (13)
Processing: Local (Ollama/Llama 3.2)
Verification: PASSED (no leakage detected)
```

**Your role:** The manifest confirms PII scrubbing occurred. You do not need to take action unless "Verification: FAILED" appears.

---

## 5. How to Review a Case

### 5.1 Standard Review Workflow (70-84% Confidence)

1. **Read the Case Summary**
   - Verify diagnosis accuracy
   - Confirm ICD-10 codes match clinical picture

2. **Review the Timeline**
   - Check for completeness
   - Identify any gaps in clinical progression

3. **Examine the Recommendation**
   - Does it align with your clinical judgment?
   - Review the guideline citation

4. **Make Your Decision**
   - APPROVE: Accept AI recommendation as-is
   - MODIFY: Accept with changes (document rationale)
   - REJECT: Override with different recommendation (document rationale)

### 5.2 Escalated Review Workflow (Below 70%)

1. Complete Standard Review steps above
2. Identify WHY confidence is low (check "Confidence Factors" section)
3. Request additional documentation if needed
4. Consult senior physician for complex cases
5. Document your reasoning thoroughly

---

## 6. Overriding AI Recommendations

You can always override the AI. Here's how:

### 6.1 When to Override

| Situation | Action |
|-----------|--------|
| AI missed critical clinical factor | Override with explanation |
| Patient has unique circumstances | Override with context |
| AI cited wrong guideline | Override and report issue |
| Your clinical judgment differs | Override with rationale |

### 6.2 Documenting Overrides

Required fields for any override:
- Original AI recommendation
- Your recommendation
- Clinical rationale (2-3 sentences minimum)
- Relevant clinical factors AI may have missed

**Good override documentation:**
> "AI recommended DISCHARGE based on stable vitals. Override to EXTENSION due to ongoing wound infection (culture positive for MRSA, Day 6) requiring IV antibiotics. Patient requires minimum 48 more hours for antibiotic completion per infectious disease consult."

**Poor override documentation:**
> "I disagree with the AI."

---

## 7. Reporting Issues

### 7.1 When to Report

Report to system administrators if you observe:
- Repeated incorrect guideline citations
- Systematic bias in recommendations
- PII appearing in AI output (Verification: FAILED)
- Confidence scores that don't match case complexity

### 7.2 How to Report

1. Document the Case ID
2. Screenshot the problematic output
3. Submit via [internal reporting system]
4. Include your clinical assessment of what went wrong

---

## 8. Frequently Asked Questions

**Q: Can I trust high-confidence (85%+) recommendations without review?**
A: The system allows autonomous processing for high-confidence cases, but periodic spot-checks are recommended. You retain responsibility for cases in your queue.

**Q: What if the AI cites a guideline I'm unfamiliar with?**
A: All MOH protocols are available in the knowledge base. Request access to the source document if needed.

**Q: Why does the AI sometimes say "General Clinical Reasoning"?**
A: This means no specific MOH protocol matched the diagnosis. The AI applied general clinical principles. Exercise additional scrutiny for these cases.

**Q: Can patients see the AI output?**
A: No. The AI analysis is internal. Patients receive standard authorization communications without AI-specific details.

**Q: What happens to my feedback when I override?**
A: Override data feeds into continuous improvement. Patterns of overrides help identify where the AI needs refinement.

---

## 9. Quick Commands Reference

| Task | Command |
|------|---------|
| Run health check | `python cds_brain.py --health` |
| Process single case | `python cds_brain.py --files "path/to/file.json"` |
| Check knowledge base | `python knowledge_base.py --list` |
| Test PII scrubber | `python pii_scrubber.py --text "test text"` |

---

## 10. Support Contacts

| Issue | Contact |
|-------|---------|
| Technical problems | IT Support |
| Clinical questions | Medical Director |
| System feedback | AI Governance Team |
| Privacy concerns | Data Protection Officer |

---

## 11. Document History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-06 | Initial release |

---

*This guide is part of the MedFlow V3 ISO 42001 compliance documentation.*

*End of Document*
