# Skippr Enterprise Constitution
<!-- Enterprise-Grade Specification-Driven Development -->

## Core Principles

### I. Production-First Development
<!-- Enterprise-ready from day one -->
Every feature must be production-ready from inception:
- Security-by-design: Input validation, authentication, authorization
- Error handling: Graceful degradation, user-friendly error messages
- Performance: Sub-3s page loads, optimized queries, lazy loading
- Monitoring: Structured logging, metrics, health checks
- NO prototypes in production - every line ships enterprise-ready

### II. User Experience Excellence (NON-NEGOTIABLE)
<!-- Superior UX is not optional -->
Every implementation MUST include:
- Loading states for all async operations
- Skeleton screens for content that takes >500ms
- Error boundaries with actionable recovery options
- Responsive design (mobile-first, tested on 5+ viewports)
- Micro-interactions and feedback for all user actions
- Page transitions and animations following Material/HIG guidelines

### III. Accessibility Standards (WCAG 2.1 AA)
<!-- Every user matters -->
Every interface must be accessible:
- Semantic HTML, proper ARIA labels
- Keyboard navigation for all interactive elements
- Screen reader compatibility tested with NVDA/JAWS
- Color contrast ratios meeting AA standards (4.5:1 normal, 3:1 large)
- Focus indicators visible and consistent
- Form validation with clear, actionable error messages

### IV. Content & Copy Excellence
<!-- Professional communication throughout -->
Professional, clear, helpful content:
- Microcopy reviewed for clarity, tone, and brand consistency
- Error messages that explain what happened and how to fix it
- Empty states with helpful guidance and next actions
- Tooltips and help text where context is needed
- Internationalization-ready (i18n keys, not hardcoded strings)
- Content follows readability standards (8th grade level)

### V. Test-First with Production Scenarios (NON-NEGOTIABLE)
<!-- Testing that reflects real-world usage -->
TDD with production-grade testing:
- E2E tests for critical user journeys
- Visual regression testing for UI consistency
- Performance testing under load
- Accessibility testing automated in CI/CD
- Cross-browser testing (Chrome, Safari, Firefox, Edge)
- RED-GREEN-Refactor cycle strictly enforced

### VI. Component Architecture
<!-- Reusable, maintainable, scalable -->
Build with composability in mind:
- Design system compliance (use existing components first)
- Single responsibility principle for all components
- Props validation and TypeScript interfaces
- Storybook documentation for all UI components
- Consistent naming conventions and file structure
- CSS-in-JS or CSS modules (no global styles)

### VII. Observability & Monitoring
<!-- If it's not measured, it doesn't exist -->
Complete visibility into system behavior:
- Structured logging with correlation IDs
- User journey tracking (privacy-compliant)
- Error tracking with Sentry/Rollbar integration
- Performance metrics (Core Web Vitals)
- Custom business metrics and KPIs
- Real User Monitoring (RUM) data

### VIII. Documentation as Code
<!-- Self-documenting systems -->
Documentation that stays current:
- README with quick start in every module
- API documentation auto-generated from code
- Architecture Decision Records (ADRs) for major choices
- Inline comments for complex logic only
- Examples for every public API
- Runbooks for common operational tasks

### IX. Progressive Enhancement
<!-- Works for everyone, delights power users -->
Build resilient experiences:
- Core functionality works without JavaScript
- Features enhance based on capabilities
- Offline-first with service workers
- Graceful degradation for older browsers
- Network-aware loading strategies
- Adaptive quality based on connection speed

## Technical Standards
<!-- Minimum requirements for enterprise deployment -->

### Security Requirements
- OWASP Top 10 compliance
- CSP headers configured
- Secrets management (no hardcoded credentials)
- Rate limiting on all endpoints
- SQL injection prevention
- XSS protection

### Performance Benchmarks
- Time to Interactive: <3.5s on 3G
- First Contentful Paint: <1.5s
- Cumulative Layout Shift: <0.1
- API response times: p99 <500ms
- Database queries: <100ms
- Bundle size: <200KB gzipped initial load

## Quality Gates
<!-- Automated enforcement of standards -->

### Pre-Commit Checks
- Linting passes (ESLint/Prettier/Black)
- Type checking passes (TypeScript/mypy)
- Unit test coverage >80%
- No console.logs or debug statements
- Accessibility audit passes
- Bundle size within limits

### Pre-Deploy Requirements
- All quality gates green
- Visual regression tests pass
- Performance budget met
- Security scan clean
- Documentation updated
- Stakeholder sign-off on UX

## Governance
<!-- Example: Constitution supersedes all other practices; Amendments require documentation, approval, migration plan -->

### Enforcement
- All code must pass automated quality gates
- UX/Copy/A11y review required before merge
- Violations require documented exemption with expiration date
- Quarterly audits of production code against these standards
- Agent performance measured by adherence to constitution

**Version**: 1.0.0 | **Ratified**: 2025-09-09 | **Last Amended**: 2025-09-09
<!-- Skippr Enterprise Standards for Production Excellence -->