# Accessibility Audit: [FEATURE NAME]

**Feature**: [feature-name]
**Date**: [DATE]
**Standard**: WCAG 2.1 Level AA
**Tools**: Axe, WAVE, NVDA/JAWS

## Automated Testing Results

### Axe DevTools
- Critical Issues: [0]
- Serious Issues: [0]
- Moderate Issues: [0]
- Minor Issues: [0]

### WAVE Analysis
- Errors: [0]
- Contrast Errors: [0]
- Alerts: [0]
- Features: [0]
- Structural Elements: [0]
- ARIA: [0]

## Manual Testing

### Keyboard Navigation
- [ ] All interactive elements reachable via keyboard
- [ ] Tab order logical and predictable
- [ ] Focus indicators visible and clear
- [ ] No keyboard traps
- [ ] Skip links available
- [ ] Shortcuts documented and don't conflict

### Screen Reader Testing

#### NVDA Results
- [ ] All content announced correctly
- [ ] Form labels associated properly
- [ ] Error messages announced
- [ ] Dynamic content updates announced
- [ ] Images have appropriate alt text
- [ ] Decorative images hidden properly

#### JAWS Results
- [ ] Landmark regions properly defined
- [ ] Headings hierarchy logical
- [ ] Lists structured correctly
- [ ] Tables have proper headers
- [ ] Live regions working correctly

### Visual Accessibility

#### Color & Contrast
- [ ] Text contrast ratio ≥4.5:1 (normal text)
- [ ] Text contrast ratio ≥3:1 (large text)
- [ ] UI component contrast ≥3:1
- [ ] Color not sole indicator of information
- [ ] Focus indicators meet contrast requirements

#### Visual Presentation
- [ ] Text resizable to 200% without horizontal scroll
- [ ] Content reflows at 320px width
- [ ] Line height at least 1.5x font size
- [ ] Paragraph spacing at least 2x font size
- [ ] No images of text (except logos)

### Forms Accessibility
- [ ] All inputs have labels
- [ ] Required fields indicated (not just color)
- [ ] Error messages associated with fields
- [ ] Instructions provided before form
- [ ] Grouped fields use fieldset/legend
- [ ] Success confirmation clear

### Media Accessibility
- [ ] Videos have captions
- [ ] Audio has transcripts
- [ ] Complex images have long descriptions
- [ ] Animations can be paused
- [ ] Auto-playing content can be stopped

## Cognitive Accessibility
- [ ] Clear, simple language used
- [ ] Consistent navigation patterns
- [ ] Predictable functionality
- [ ] Sufficient time limits (adjustable)
- [ ] Help available where needed
- [ ] Error prevention built in

## Mobile Accessibility
- [ ] Touch targets ≥44x44px
- [ ] Gesture alternatives available
- [ ] Orientation not locked
- [ ] Motion not required for function
- [ ] Accessible with assistive tech

## Compliance Summary

### WCAG 2.1 Level A
- **Pass**: [X/30] criteria
- **Fail**: [List failures]
- **N/A**: [List non-applicable]

### WCAG 2.1 Level AA
- **Pass**: [X/20] criteria
- **Fail**: [List failures]
- **N/A**: [List non-applicable]

## Remediation Priority

### Critical (Block Release)
1. [Issue description and fix]

### High (Fix This Sprint)
1. [Issue description and fix]

### Medium (Fix Next Sprint)
1. [Issue description and fix]

### Low (Backlog)
1. [Issue description and fix]

## Recommendations

### Quick Wins
[List easy improvements with high impact]

### Long-term Improvements
[List strategic accessibility enhancements]

### Training Needs
[Identify team knowledge gaps]

---
**Compliance Score**: [X]%
**Certification Ready**: [Yes/No]
**Next Audit Date**: [DATE]