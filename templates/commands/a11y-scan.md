---
name: a11y-scan
description: "Scan for accessibility issues and validate WCAG 2.1 Level AA compliance"
---

Run a comprehensive accessibility scan to ensure WCAG 2.1 Level AA compliance.

This command validates that your implementation is accessible to all users, including those using assistive technologies.

Given the feature or component name (optional), do this:

1. Run the script `scripts/check-a11y-compliance.sh "{ARGS}"` from repo root and capture the output
2. Parse the generated `a11y-audit-report.md` file to analyze compliance status
3. For any accessibility violations, provide specific fixes:
   - Add missing ARIA labels and descriptions
   - Fix heading hierarchy issues
   - Add keyboard navigation support where missing
   - Ensure proper focus management
   - Add alt text for images
   - Fix color contrast issues
4. If available, run automated accessibility testing tools:
   - Check for axe-core in package.json and run if present
   - Look for jest-axe tests and execute them
   - Use any configured ESLint a11y plugins
5. Generate code snippets to fix each accessibility issue
6. Create a prioritized remediation plan based on WCAG severity levels

The scan validates:
- Semantic HTML usage
- ARIA implementation and landmarks
- Keyboard navigation and focus management
- Form labels and error messaging
- Images and media alternatives
- Color contrast and visual accessibility
- Screen reader compatibility

Success criteria: 0 critical failures, compliance score ≥ 90%