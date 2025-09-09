---
name: copy-review
description: "Review all user-facing text for clarity, consistency, and quality"
---

Review all user-facing copy and content for quality and consistency.

This command analyzes microcopy, error messages, and all user-facing text to ensure it meets content standards.

Given the feature or component name (optional), do this:

1. Run the script `scripts/check-content-quality.sh "{ARGS}"` from repo root and capture the output
2. Parse the generated `content-quality-report.md` file to understand content issues
3. Scan the codebase for all user-facing strings:
   - Error messages and validation text
   - Button labels and CTAs
   - Placeholder text and helper messages
   - Empty states and loading messages
   - Tooltips and descriptions
4. For each content issue found:
   - Rewrite unclear error messages to be actionable
   - Simplify complex language to 8th grade reading level
   - Ensure consistent terminology and tone
   - Remove jargon and technical terms
   - Add helpful context where missing
5. Check for i18n readiness:
   - Identify hardcoded strings that should be in translation files
   - Suggest extraction to i18n keys
   - Ensure proper string formatting for localization
6. Generate improved copy suggestions with clear explanations

The review validates:
- Error message quality and actionability
- Microcopy clarity and helpfulness
- Empty state messaging and CTAs
- Content consistency across the application
- Professional language and tone
- Reading level appropriateness
- Internationalization readiness

Success criteria: No hardcoded strings, consistent voice, all copy at appropriate reading level