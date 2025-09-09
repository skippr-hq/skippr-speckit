---
name: prod-ready
description: "Comprehensive production readiness check validating all quality gates"
---

Run a comprehensive production readiness assessment.

This command validates that your implementation meets all requirements for production deployment according to the Skippr Enterprise Constitution.

Given the feature name (optional), do this:

1. Run the script `scripts/production-readiness-check.sh "{ARGS}"` from repo root and capture the output
2. Parse the generated `production-readiness-report.md` file for the overall assessment
3. Run all quality sub-checks:
   - UX standards compliance
   - WCAG 2.1 AA accessibility
   - Content and copy quality
   - Security validation (no hardcoded secrets)
   - Testing coverage analysis
   - Performance benchmarks
   - Observability setup
   - Documentation completeness
4. For any failed checks:
   - Identify the specific issues blocking deployment
   - Provide remediation steps with priority levels
   - Estimate effort required for fixes
   - Suggest temporary workarounds if applicable
5. Check for critical infrastructure requirements:
   - Error tracking integration (Sentry, Rollbar, etc.)
   - Logging configuration
   - Monitoring and alerting setup
   - Feature flags for rollback capability
6. Generate a deployment checklist with sign-off requirements

The assessment validates:
- All constitution principles compliance
- Security best practices (OWASP Top 10)
- Performance metrics (Core Web Vitals)
- Test coverage (>80% with E2E tests)
- Error handling and recovery
- Documentation and runbooks
- Rollback procedures

Success criteria: 
- 0 critical failures
- Readiness score ≥ 80%
- All stakeholder sign-offs documented

Output includes go/no-go decision with required remediation steps if not ready.