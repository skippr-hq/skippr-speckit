---
name: quality-gate
description: "Run all quality checks to validate constitution compliance before merging"
---

Execute all quality gates to ensure constitution compliance.

This command runs every quality check defined in the Skippr Enterprise Constitution to validate your code is ready for review and merging.

Given the feature or component name (optional), do this:

1. Execute all quality validation scripts in sequence:
   - `scripts/check-ux-standards.sh "{ARGS}"`
   - `scripts/check-a11y-compliance.sh "{ARGS}"`
   - `scripts/check-content-quality.sh "{ARGS}"`
   - `scripts/production-readiness-check.sh "{ARGS}"`
2. Aggregate results from all generated reports:
   - `ux-audit-report.md`
   - `a11y-audit-report.md`
   - `content-quality-report.md`
   - `production-readiness-report.md`
3. Create a unified quality dashboard showing:
   - Overall quality score (weighted average)
   - Pass/fail status for each category
   - Critical issues blocking merge
   - Warning-level issues to address
4. Check constitution principles compliance:
   - Production-First: All critical checks passing
   - UX Excellence: Loading states, error handling verified
   - Accessibility-First: WCAG 2.1 AA compliant
   - Content Quality: Clear, actionable messaging
   - Test Coverage: >80% with E2E tests
   - Documentation: README and inline docs present
5. If any gates fail:
   - Generate a prioritized fix list
   - Create GitHub issues for each failure
   - Provide time estimates for remediation
   - Suggest which fixes can be deferred
6. Generate PR-ready summary for reviewers

Quality gates enforce:
- ✅ UX patterns (loading, errors, responsive)
- ✅ Accessibility (WCAG 2.1 AA)
- ✅ Content quality (clarity, consistency)
- ✅ Security (no secrets, input validation)
- ✅ Performance (Core Web Vitals)
- ✅ Testing (coverage, E2E)
- ✅ Documentation (complete, current)

Success criteria: All gates passing or have documented exemptions

Output format:
```
QUALITY GATE SUMMARY
====================
Overall Score: X/100
Status: PASS/FAIL

Category Results:
- UX Standards: X% [PASS/FAIL]
- Accessibility: X% [PASS/FAIL]
- Content Quality: X% [PASS/FAIL]
- Production Ready: X% [PASS/FAIL]

Critical Issues: X
Must Fix Before Merge: [list]

Ready for Review: YES/NO
```