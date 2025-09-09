---
name: ux-audit
description: "Run comprehensive UX audit to validate loading states, error handling, responsive design, and user interaction patterns"
---

Run a comprehensive UX audit on the current implementation.

This command validates that your code follows UX best practices and the Skippr Enterprise Constitution standards.

Given the feature or component name (optional), do this:

1. Run the script `scripts/check-ux-standards.sh "{ARGS}"` from repo root and capture the output
2. Parse the generated `ux-audit-report.md` file to understand the results
3. For any failed checks, analyze the codebase to provide specific recommendations:
   - Locate files missing loading states or skeleton screens
   - Find components without proper error boundaries
   - Identify non-responsive elements
   - Check for missing animations or transitions
4. Generate actionable fix suggestions with code examples for each issue
5. Create tasks for addressing critical UX issues
6. Report the audit score and prioritized action items

The audit checks for:
- Loading states and skeleton screens
- Error boundaries and user-friendly error messages
- Responsive design and breakpoints
- Animations and micro-interactions
- User feedback mechanisms (toasts, notifications)
- Form validation and helper text
- Performance optimizations (lazy loading, memoization)

Success criteria: Score ≥ 80% with all critical checks passing