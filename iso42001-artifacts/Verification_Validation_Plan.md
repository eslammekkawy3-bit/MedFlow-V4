# Verification and Validation Plan
## MedFlow V3 Clinical Decision Support System

**Document ID:** MF-ISO-18
**Title:** Verification and Validation Plan
**Version:** 2.1
**Status:** ACTIVE
**Date:** 2026-02-21
**Author:** Dr. Islam Mekawy
**Reviewer:** Dr. Islam Mekawy (Lead Researcher)
**Approver:** Dr. Islam Mekawy (AI Governance Lead)
**Classification:** CONFIDENTIAL – Internal Use Only
**ISO 42001 Clause:** Clause 8.5, Annex A.9 – AI System Verification and Validation
**Supersedes:** MF-ISO42001-A9-001 v2.0 (2026-02-07)

---

## 1. Purpose

This document defines the verification and validation (V&V) strategy for MedFlow V3, ensuring the AI system performs as intended, produces reliable outputs, and maintains safety and compliance standards.

---

## 2. V&V Framework Overview

### 2.1 Verification vs. Validation

| Aspect | Verification | Validation |
|--------|--------------|------------|
| Question | "Are we building it right?" | "Are we building the right thing?" |
| Focus | Technical correctness | Clinical appropriateness |
| Methods | Unit tests, integration tests | Clinical review, user acceptance |
| Frequency | Continuous (CI/CD) | Periodic (release gates) |

### 2.2 Test Pyramid

```
                    ┌─────────────────┐
                    │   End-to-End    │  ◄── Full pipeline tests
                    │     Tests       │
                    └────────┬────────┘
                             │
                    ┌────────┴────────┐
                    │  Integration    │  ◄── Component interaction
                    │     Tests       │
                    └────────┬────────┘
                             │
            ┌────────────────┴────────────────┐
            │          Unit Tests             │  ◄── Individual functions
            └─────────────────────────────────┘
```

---

## 3. Automated Test Suites

### 3.1 Knowledge Base Strict Matching Test

**Command:** `python knowledge_base.py --test-strict`

**Purpose:** Verify the Knowledge Base correctly matches diagnoses to protocols and rejects irrelevant matches.

**Test Cases:**

| Test Case | Input Diagnosis | Expected Result | Validation Criteria |
|-----------|-----------------|-----------------|---------------------|
| TC-KB-001 | Acute Ischemic Stroke | No Match / Fallback | Must NOT match Hypoglycemia |
| TC-KB-002 | Diabetic Ketoacidosis | DKA Protocol | Title contains "DKA" |
| TC-KB-003 | Community Acquired Pneumonia | No Match / Fallback | Must NOT match unrelated |
| TC-KB-004 | Septic Shock | No Match / Fallback | Must NOT match unrelated |
| TC-KB-005 | Acute Myocardial Infarction | No Match / Fallback | Must NOT match Hypoglycemia |
| TC-KB-006 | Hypoglycemia | Hypoglycemia Protocol | Title contains "Hypoglycemia" |

**Pass Criteria:** ALL test cases must pass.

**Sample Output:**
```
============================================================
STRICT MATCHING TEST SUITE
============================================================
--- Testing: 'Acute Ischemic Stroke' ---
  RESULT: No match (General Clinical Standards fallback)
  STATUS: PASS - Correctly rejected irrelevant protocols
...
============================================================
TEST SUITE: ALL PASSED
============================================================
```

---

### 3.2 System Health Check

**Command:** `python cds_brain.py --health`

**Purpose:** Verify all system components are operational.

**Checks Performed:**

| Component | Check | Pass Criteria |
|-----------|-------|---------------|
| Ollama | HTTP connection | Response within 10s |
| Llama 3.2 | Model availability | Listed in /api/tags |
| Gemini API | Key validation | Non-empty response |
| Knowledge Base | Document count | >= 1 document loaded |

**Sample Output:**
```json
{
  "overall_status": "healthy",
  "timestamp": "2026-02-04T12:00:00",
  "components": {
    "ollama": {"status": "healthy", "message": "Ollama OK, model 'llama3.2' available"},
    "gemini": {"status": "healthy", "model": "gemini-2.0-flash"},
    "knowledge_base": {"status": "healthy", "documents": 13}
  }
}
```

---

### 3.3 PII Scrubber CLI Test

**Command:** `python pii_scrubber.py --text "<test_text>"`

**Purpose:** Verify PII detection and redaction accuracy.

**Test Input:**
```
Patient Ahmed Al-Rashid, MRN-123456, phone +966 55 123 4567
```

**Expected Output:**
- All PII tokens replaced with `[*_REDACTED]` placeholders
- PII manifest generated with detection counts

---

### 3.4 Debug Mode Testing

**Command:** `python knowledge_base.py --reference "<diagnosis>" --debug`

**Purpose:** Trace matching decisions for diagnostic analysis.

**Output Includes:**
- All extracted terms
- Stop word filtering results
- PROTOCOL_KEYWORDS category matches
- Match/reject decision with reason

---

## 4. Manual Validation Procedures

### 4.1 Clinical Accuracy Review

**Frequency:** Quarterly or after major updates

**Procedure:**
1. Select 20 representative cases from each complexity tier
2. Run full pipeline analysis
3. Clinical reviewer evaluates:
   - Diagnosis accuracy
   - Recommendation appropriateness
   - Citation relevance
   - Rationale clarity
4. Document discrepancies
5. Calculate accuracy metrics

**Metrics:**

| Metric | Target | Calculation |
|--------|--------|-------------|
| Diagnosis Accuracy | >= 95% | Correct primary diagnosis / Total |
| Recommendation Alignment | >= 90% | Matches clinical judgment / Total |
| Citation Relevance | >= 85% | Relevant citations / Total citations |

---

### 4.2 PII Leak Testing

**Frequency:** After any PII scrubber update

**Procedure:**
1. Prepare test set with known PII patterns
2. Run scrubber on test set
3. Manually inspect output for leaked PII
4. Verify Layer 3 validation catches leaks

**Test Cases:**
- Arabic names (transliterated)
- Saudi ID variations
- Hospital name variations
- Address patterns

---

### 4.3 Stress Testing

**Frequency:** Before production deployment

**Procedure:**
1. Process 100 cases sequentially
2. Measure:
   - Processing time per case
   - Memory usage
   - API error rate
   - Recovery from failures
3. Verify auto-fallback mechanisms

**Pass Criteria:**
- 95% cases complete successfully
- No memory leaks
- Auto-recovery from API errors

---

## 5. Phase 4 Test Record (Feb 7, 2026)

**Test Date:** 2026-02-07
**Verified By:** Automated Test Suite + Manual End-to-End Pipeline
**Phase:** Phase 4 - Clinical DRG Validator
**Components Under Test:** `drg_validator.py` v1.0.0, `data/drg_clinical_rules.json` v1.1.0, `cds_brain.py` v1.2.0

### 5.1 DRG Validator Unit Tests

**Command:** `python drg_validator.py --test`

| Test ID | Case | Expected MDC | Actual MDC | Expected Sev | Actual Sev | Status |
|---------|------|-------------|-----------|-------------|-----------|--------|
| TC-DRG-001 | Pneumonia on Ventilator | MDC 04 | MDC 04 | A | A | **PASS** |
| TC-DRG-002 | STEMI + Cardiogenic Shock | MDC 05 | MDC 05 | A | A | **PASS** |
| TC-DRG-003 | DKA Moderate | MDC 10 | MDC 10 | B | B | **PASS** |
| TC-DRG-004 | Septic Shock | MDC 18 | MDC 18 | A | A | **PASS** |
| TC-DRG-005 | Hip Fracture Standard | MDC 08 | MDC 08 | B | B | **PASS** |
| TC-DRG-006 | Simple Cellulitis | MDC 09 | MDC 09 | B | B | **PASS** |
| TC-DRG-007 | Stroke with Coma | MDC 01 | MDC 01 | A | A | **PASS** |
| TC-DRG-008 | GI Bleed with Transfusion | MDC 06 | MDC 06 | B | B | **PASS** |

**Result: 8/8 PASSED (100%)**

### 5.2 End-to-End Pipeline Test: Complex Sepsis (COMPLEX-E2E-001)

**Input:** Synthetic case - 60yo male, septic shock secondary to CAP, ventilator, vasopressors, CRRT dialysis. Claimed DRG: E62B (Respiratory Infection / Simple).

| Pipeline Step | Result | Notes |
|---------------|--------|-------|
| PII Scrubbing | **PASS** | 4 items redacted (Name, National ID, DOB). "Fahad Al-Otaibi" removed. |
| Clinical Summary | **PASS** | Correctly identified "Septic Shock secondary to CAP" |
| Timeline Analysis | **PASS** | Detected 2-day CT scanner delay + 48h neurology consult delay |
| Guideline Lookup | **PASS** | General Clinical Reasoning fallback (no sepsis MOH protocol) |
| DRG Validation | **PASS** | Predicted MDC 04 / Level A (High). Claimed E62B = **MISMATCH** |
| Decision | **PASS** | EXTENSION at 100% confidence, AUTO_APPROVED |

**Key Finding:** System correctly detected DRG upcoding opportunity. E62B (Simple Respiratory Infection) is grossly inconsistent with a patient on ventilator + vasopressors in ICU. DRG validator flagged severity mismatch (Level B claimed vs. Level A predicted).

**Processing Time:** 42.8 seconds (1 document)

### 5.3 End-to-End Pipeline Test: Messy DKA (CASE-0020-42)

**Input:** Real synthetic case from sample_cases/complex - 63yo male, DKA, 4 documents over 10 days, DRG K60A. Contradictory documentation across reports.

| Pipeline Step | Result | Notes |
|---------------|--------|-------|
| PII Scrubbing | **PASS** | 44 items redacted across 4 documents (11/doc). "Ibrahim Qassim", MRN, phone, hospital removed. |
| Clinical Summary | **PASS** | Correctly identified "Diabetic Ketoacidosis" as primary diagnosis |
| Timeline Analysis | **PASS** | Flagged 4 critical issues (see below) |
| Guideline Lookup | **PASS** | Matched MOH DKA-HHS Protocol from knowledge base |
| DRG Validation | **PARTIAL** | Predicted MDC 04 (Respiratory) due to secondary keywords. See known limitation. |
| Decision | **PASS** | EXTENSION at 85% confidence, ESCALATE review level |

**Critical Issues Detected by Gemini AI:**
1. **Contradictory PMH:** Medical history changes between reports for the same patient (patient safety flag)
2. **DKA Diagnosis Discrepancy:** Day 1 labs (Glucose 141.9, CO2 27) inconsistent with DKA diagnosis
3. **Delayed DKA Resolution:** Still on DKA protocol Day 7 (typical resolution 24-48h)
4. **Treatment Paradox:** Aggressive IV fluids + furosemide simultaneously despite pulmonary edema

**Known Limitation Identified:** In multi-document cases with rich secondary diagnoses, the keyword-frequency DRG validator may predict an MDC based on incidental findings (respiratory keywords from imaging/PMH) rather than the true primary diagnosis. Gemini correctly identifies the primary diagnosis via contextual reasoning. Together they form a Dual-Check safety net.

**Processing Time:** 200.4 seconds (4 documents, including 138s PII scrubbing)

### 5.4 Regression: Knowledge Base Strict Matching

**Command:** `python knowledge_base.py --test-strict`
**Result:** 6/6 PASSED (unchanged from Phase 3)

### 5.5 Test Evidence

| Artifact | Location |
|----------|----------|
| Sepsis test output | `output/complex_test_result.json` |
| DKA test output | `output/random_audit.json` |
| Test input (Sepsis) | `complex_test_case.txt` |
| Test input (DKA) | `sample_cases/complex/CASE-0020-42/` |

---

## 6. Regression Testing

### 5.1 Trigger Conditions

Regression tests must run when:
- Any core module is modified
- Dependencies are updated
- Knowledge base protocols are added/removed
- Configuration changes are deployed

### 5.2 Regression Test Suite

| Test ID | Module | Test Type | Command |
|---------|--------|-----------|---------|
| REG-001 | knowledge_base.py | Unit | `--test-strict` |
| REG-002 | cds_brain.py | Integration | `--health` |
| REG-003 | pii_scrubber.py | Unit | `--check` |
| REG-004 | Full Pipeline | E2E | Process sample case |
| REG-005 | drg_validator.py | Unit | `--test` (8 cases) |

---

## 7. Acceptance Criteria

### 6.1 Release Gate Requirements

| Requirement | Threshold | Status |
|-------------|-----------|--------|
| All unit tests pass | 100% | Required |
| Integration tests pass | 100% | Required |
| No HIGH severity bugs | 0 | Required |
| PII leak rate | 0% | Required |
| Clinical accuracy | >= 90% | Required |
| Documentation complete | Yes | Required |

### 6.2 Known Limitations

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| No Stroke/ACS protocols | Fallback to general reasoning | User to add protocols |
| Gemini API dependency | Cloud availability required | Auto-fallback models |
| English only | Non-English text not processed | Future enhancement |

---

## 8. Test Evidence Repository

### 7.1 Storage Location

```
C:\Medflow Master Brain\
├── output/              # Test results
│   └── test_result_*.json
├── logs/                # Execution logs
└── tests/               # Test scripts
    └── test_pii_scrubbing.py
```

### 7.2 Retention

- Test results: 1 year
- Logs: 90 days
- Test scripts: Version controlled

---

## 9. Continuous Improvement

### 8.1 Defect Tracking

| Severity | Response Time | Resolution Time |
|----------|---------------|-----------------|
| Critical (PII leak) | 1 hour | 24 hours |
| High (wrong decision) | 4 hours | 72 hours |
| Medium (performance) | 24 hours | 1 week |
| Low (cosmetic) | 1 week | 1 month |

### 8.2 Lessons Learned

Document after each incident:
- Root cause analysis
- Test gap identification
- New test case creation
- Process improvement

---

## 10. Document Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| QA Manager | _________________ | __________ | __________ |
| Clinical Validator | _________________ | __________ | __________ |
| System Owner | _________________ | __________ | __________ |

---

*End of Document*
