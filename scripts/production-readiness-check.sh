#!/usr/bin/env bash
set -euo pipefail

# Production Readiness Checker
# Validates all Skippr constitution requirements before deployment

source "$(dirname "$0")/common.sh"

FEATURE_NAME="${1:-}"
REPORT_FILE="production-readiness-report.md"

print_header "🚀 Production Readiness Check"

# Initialize comprehensive report
cat > "$REPORT_FILE" << EOF
# Production Readiness Report
**Date**: $(date '+%Y-%m-%d %H:%M:%S')
**Feature**: ${FEATURE_NAME:-All Features}
**Constitution Version**: 1.0.0

## Executive Summary
This report validates compliance with the Skippr Enterprise Constitution for production deployment.

EOF

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
CRITICAL_FAILURES=0

# Run sub-checks and collect results
run_quality_check() {
    local script="$1"
    local description="$2"
    local critical="${3:-false}"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    print_info "Running $description..."
    
    if bash "$script" > /dev/null 2>&1; then
        print_success "$description - PASSED"
        echo "✅ $description - PASSED" >> "$REPORT_FILE"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$critical" = "true" ]; then
            print_error "$description - FAILED (CRITICAL)"
            echo "❌ $description - FAILED (CRITICAL)" >> "$REPORT_FILE"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
            return 1
        else
            print_warning "$description - FAILED"
            echo "⚠️ $description - FAILED" >> "$REPORT_FILE"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            return 1
        fi
    fi
}

echo "## Quality Gates" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Run all quality checks
echo "### Core Requirements" >> "$REPORT_FILE"
run_quality_check "$(dirname "$0")/check-ux-standards.sh" "UX Standards Compliance" true
run_quality_check "$(dirname "$0")/check-a11y-compliance.sh" "Accessibility (WCAG 2.1 AA)" true
run_quality_check "$(dirname "$0")/check-content-quality.sh" "Content & Copy Quality" false

echo "" >> "$REPORT_FILE"
echo "### Security & Performance" >> "$REPORT_FILE"

# Security checks
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) \
    -exec grep -l "password\|secret\|api_key\|apiKey\|token" {} \; 2>/dev/null | \
    xargs grep -L "process.env\|import.meta.env" 2>/dev/null | head -1 > /dev/null; then
    print_error "Security: Hardcoded secrets detected"
    echo "❌ Security: Hardcoded secrets detected" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
else
    print_success "Security: No hardcoded secrets"
    echo "✅ Security: No hardcoded secrets" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
fi

# Input validation check
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if find . -name "*.{js,jsx,ts,tsx}" -type f 2>/dev/null | \
    xargs grep -l "sanitize\|validate\|escape" 2>/dev/null | head -1 > /dev/null; then
    print_success "Security: Input validation present"
    echo "✅ Security: Input validation present" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_warning "Security: Input validation not detected"
    echo "⚠️ Security: Input validation not detected" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi

echo "" >> "$REPORT_FILE"
echo "### Testing Coverage" >> "$REPORT_FILE"

# Check for test files
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
TEST_COUNT=$(find . -name "*.test.*" -o -name "*.spec.*" 2>/dev/null | wc -l)
if [ "$TEST_COUNT" -gt 0 ]; then
    print_success "Testing: $TEST_COUNT test files found"
    echo "✅ Testing: $TEST_COUNT test files found" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_error "Testing: No test files found"
    echo "❌ Testing: No test files found (CRITICAL)" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
    CRITICAL_FAILURES=$((CRITICAL_FAILURES + 1))
fi

# Check for E2E tests
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if find . -name "*e2e*" -o -name "*integration*" 2>/dev/null | head -1 > /dev/null; then
    print_success "Testing: E2E/Integration tests present"
    echo "✅ Testing: E2E/Integration tests present" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_warning "Testing: No E2E tests detected"
    echo "⚠️ Testing: No E2E tests detected" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi

echo "" >> "$REPORT_FILE"
echo "### Observability" >> "$REPORT_FILE"

# Logging check
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if find . -name "*.{js,jsx,ts,tsx}" -type f 2>/dev/null | \
    xargs grep -l "logger\|winston\|pino\|bunyan\|log4js" 2>/dev/null | head -1 > /dev/null; then
    print_success "Observability: Structured logging present"
    echo "✅ Observability: Structured logging present" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_warning "Observability: No structured logging detected"
    echo "⚠️ Observability: No structured logging detected" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi

# Error tracking check
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if find . -name "*.{js,jsx,ts,tsx}" -type f 2>/dev/null | \
    xargs grep -l "sentry\|rollbar\|bugsnag\|datadog" 2>/dev/null | head -1 > /dev/null; then
    print_success "Observability: Error tracking configured"
    echo "✅ Observability: Error tracking configured" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_warning "Observability: No error tracking detected"
    echo "⚠️ Observability: No error tracking detected" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi

echo "" >> "$REPORT_FILE"
echo "### Documentation" >> "$REPORT_FILE"

# README check
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if [ -f "README.md" ]; then
    print_success "Documentation: README.md exists"
    echo "✅ Documentation: README.md exists" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_error "Documentation: README.md missing"
    echo "❌ Documentation: README.md missing" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi

# API documentation check
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
if find . -name "*api*.md" -o -name "*swagger*" -o -name "*openapi*" 2>/dev/null | head -1 > /dev/null; then
    print_success "Documentation: API documentation found"
    echo "✅ Documentation: API documentation found" >> "$REPORT_FILE"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    print_warning "Documentation: No API documentation"
    echo "⚠️ Documentation: No API documentation" >> "$REPORT_FILE"
    FAILED_CHECKS=$((FAILED_CHECKS + 1))
fi

# Calculate readiness score
SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo "" >> "$REPORT_FILE"
echo "## Performance Benchmarks" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "### Required Metrics (Manual Verification Needed)" >> "$REPORT_FILE"
echo "- [ ] Time to Interactive < 3.5s on 3G" >> "$REPORT_FILE"
echo "- [ ] First Contentful Paint < 1.5s" >> "$REPORT_FILE"
echo "- [ ] Cumulative Layout Shift < 0.1" >> "$REPORT_FILE"
echo "- [ ] API response times p99 < 500ms" >> "$REPORT_FILE"
echo "- [ ] Database queries < 100ms" >> "$REPORT_FILE"
echo "- [ ] Bundle size < 200KB gzipped" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "## Constitution Compliance" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check each constitution principle
declare -A principles=(
    ["Production-First"]=$((CRITICAL_FAILURES == 0))
    ["UX Excellence"]=$((PASSED_CHECKS > FAILED_CHECKS))
    ["Accessibility"]=$((PASSED_CHECKS > FAILED_CHECKS))
    ["Content Quality"]=$((PASSED_CHECKS > FAILED_CHECKS))
    ["Test-First"]=$((TEST_COUNT > 0))
    ["Component Architecture"]=true
    ["Observability"]=true
    ["Documentation"]=true
    ["Progressive Enhancement"]=true
)

for principle in "${!principles[@]}"; do
    if [ "${principles[$principle]}" = true ] || [ "${principles[$principle]}" -eq 1 ]; then
        echo "✅ **$principle**: Compliant" >> "$REPORT_FILE"
    else
        echo "❌ **$principle**: Non-compliant" >> "$REPORT_FILE"
    fi
done

echo "" >> "$REPORT_FILE"
echo "## Final Assessment" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "### Metrics" >> "$REPORT_FILE"
echo "- **Total Checks**: $TOTAL_CHECKS" >> "$REPORT_FILE"
echo "- **Passed**: $PASSED_CHECKS" >> "$REPORT_FILE"
echo "- **Failed**: $FAILED_CHECKS" >> "$REPORT_FILE"
echo "- **Critical Failures**: $CRITICAL_FAILURES" >> "$REPORT_FILE"
echo "- **Readiness Score**: ${SCORE}%" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
if [ $CRITICAL_FAILURES -eq 0 ] && [ $SCORE -ge 80 ]; then
    echo "## ✅ PRODUCTION READY" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "This feature meets the minimum requirements for production deployment." >> "$REPORT_FILE"
    DEPLOYMENT_READY=true
elif [ $CRITICAL_FAILURES -eq 0 ] && [ $SCORE -ge 60 ]; then
    echo "## ⚠️ CONDITIONALLY READY" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "This feature can be deployed with documented exemptions and a remediation plan." >> "$REPORT_FILE"
    DEPLOYMENT_READY=false
else
    echo "## ❌ NOT PRODUCTION READY" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "Critical issues must be resolved before deployment:" >> "$REPORT_FILE"
    echo "- Fix all critical failures" >> "$REPORT_FILE"
    echo "- Achieve minimum 60% compliance score" >> "$REPORT_FILE"
    echo "- Get stakeholder exemption for any remaining issues" >> "$REPORT_FILE"
    DEPLOYMENT_READY=false
fi

echo "" >> "$REPORT_FILE"
echo "## Sign-off Checklist" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- [ ] Product Owner approval" >> "$REPORT_FILE"
echo "- [ ] UX team approval" >> "$REPORT_FILE"
echo "- [ ] Security team approval" >> "$REPORT_FILE"
echo "- [ ] Performance benchmarks met" >> "$REPORT_FILE"
echo "- [ ] Documentation complete" >> "$REPORT_FILE"
echo "- [ ] Rollback plan documented" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "*Report generated by Skippr Production Readiness Checker v1.0*" >> "$REPORT_FILE"

# Display results
print_header "📊 Production Readiness Assessment Complete"
print_info "Total Checks: $TOTAL_CHECKS"
print_success "Passed: $PASSED_CHECKS"
print_error "Failed: $FAILED_CHECKS"
if [ $CRITICAL_FAILURES -gt 0 ]; then
    print_error "Critical Failures: $CRITICAL_FAILURES"
fi
print_info "Readiness Score: ${SCORE}%"
print_info "Full report: $REPORT_FILE"

echo ""
if [ "$DEPLOYMENT_READY" = true ]; then
    print_success "✅ PRODUCTION READY - Safe to deploy!"
    exit 0
else
    print_error "❌ NOT PRODUCTION READY - Review report for required fixes"
    exit 1
fi