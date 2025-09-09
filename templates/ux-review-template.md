# UX Review Checklist: [FEATURE NAME]

**Feature**: [feature-name]
**Date**: [DATE]
**Reviewer**: AI Agent + Human Validation

## Visual Design Review

### Loading States
- [ ] All async operations have loading indicators
- [ ] Skeleton screens for content >500ms load time
- [ ] Progressive content revelation implemented
- [ ] Loading states match brand design system

### Responsive Design
- [ ] Mobile (320px - 768px) tested
- [ ] Tablet (768px - 1024px) tested  
- [ ] Desktop (1024px - 1440px) tested
- [ ] Wide screen (1440px+) tested
- [ ] Touch targets minimum 44x44px on mobile

### Animations & Transitions
- [ ] Page transitions smooth (<300ms)
- [ ] Micro-interactions on all interactive elements
- [ ] Animation timing follows easing curves
- [ ] Reduced motion preference respected

## Interaction Design

### User Feedback
- [ ] Immediate feedback for all actions
- [ ] Success states clearly indicated
- [ ] Error states with recovery options
- [ ] Progress indicators for multi-step processes

### Navigation
- [ ] Clear navigation hierarchy
- [ ] Breadcrumbs where appropriate
- [ ] Back button behavior predictable
- [ ] Deep linking supported

### Forms & Input
- [ ] Inline validation with helpful messages
- [ ] Auto-save for long forms
- [ ] Clear field labels and placeholders
- [ ] Smart defaults and auto-complete

## Error Handling

### Error States
- [ ] 404 pages helpful and branded
- [ ] Network error handling graceful
- [ ] Form validation errors clear
- [ ] System errors with user-friendly messages

### Recovery
- [ ] Clear next steps provided
- [ ] Retry mechanisms available
- [ ] Data preservation on errors
- [ ] Support contact information visible

## Performance Perception

### Perceived Performance
- [ ] Optimistic updates where safe
- [ ] Instant visual feedback
- [ ] Progressive enhancement used
- [ ] Critical content prioritized

### Actual Performance
- [ ] Time to Interactive <3.5s
- [ ] First Contentful Paint <1.5s
- [ ] Cumulative Layout Shift <0.1
- [ ] All interactions <100ms response

## Recommendations

### Critical Issues
[List any blocking UX issues]

### Improvements
[List enhancement opportunities]

### Best Practices
[Note exemplary implementations]

---
**Score**: [X]/100
**Status**: [Pass/Fail/Needs Improvement]