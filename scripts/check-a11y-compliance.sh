#!/usr/bin/env bash
set -euo pipefail

# Accessibility Compliance Checker
# Validates WCAG 2.1 AA compliance for Skippr projects

source "$(dirname "$0")/common.sh"

FEATURE_NAME="${1:-}"
REPORT_FILE="a11y-audit-report.md"

print_header "♿ Accessibility Compliance Check"

# Initialize report
cat > "$REPORT_FILE" << EOF
# Accessibility Compliance Report
**Date**: $(date '+%Y-%m-%d %H:%M:%S')
**Feature**: ${FEATURE_NAME:-All Features}
**Standard**: WCAG 2.1 Level AA

## Summary
EOF

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS=0

# Function to run accessibility checks
run_a11y_check() {
    local description="$1"
    local check_command="$2"
    local critical="${3:-true}"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if eval "$check_command" > /dev/null 2>&1; then
        print_success "$description"
        echo "✅ $description" >> "$REPORT_FILE"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$critical" = "true" ]; then
            print_error "$description - FAILED"
            echo "❌ $description - FAILED" >> "$REPORT_FILE"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            return 1
        else
            print_warning "$description - Warning"
            echo "⚠️ $description - Warning" >> "$REPORT_FILE"
            WARNINGS=$((WARNINGS + 1))
            return 0
        fi
    fi
}

# Function to check for ARIA patterns
check_aria_pattern() {
    local pattern="$1"
    local description="$2"
    local file_glob="${3:-*.{js,jsx,ts,tsx,html}}"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if find . -name "$file_glob" -type f 2>/dev/null | xargs grep -l "$pattern" 2>/dev/null | head -1 > /dev/null; then
        print_success "$description"
        echo "✅ $description" >> "$REPORT_FILE"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        print_warning "$description - Not found"
        echo "⚠️ $description - Not found" >> "$REPORT_FILE"
        WARNINGS=$((WARNINGS + 1))
        return 0
    fi
}

echo "" >> "$REPORT_FILE"
echo "## Semantic HTML" >> "$REPORT_FILE"

print_info "Checking semantic HTML usage..."
check_aria_pattern "<main\|<nav\|<header\|<footer\|<section\|<article" "Semantic HTML5 elements"
check_aria_pattern "<h[1-6]" "Heading hierarchy"
check_aria_pattern "<ul\|<ol\|<dl" "Proper list structures"
check_aria_pattern "role=" "ARIA roles defined"

echo "" >> "$REPORT_FILE"
echo "## ARIA Implementation" >> "$REPORT_FILE"

print_info "Checking ARIA attributes..."
check_aria_pattern "aria-label\|aria-labelledby" "ARIA labels"
check_aria_pattern "aria-describedby\|aria-description" "ARIA descriptions"
check_aria_pattern "aria-live\|aria-atomic" "Live regions for dynamic content"
check_aria_pattern "aria-hidden" "Hidden decorative elements"
check_aria_pattern "aria-expanded\|aria-controls" "Interactive ARIA states"
check_aria_pattern "aria-current" "Current page/step indicators"

echo "" >> "$REPORT_FILE"
echo "## Keyboard Navigation" >> "$REPORT_FILE"

print_info "Checking keyboard accessibility..."
check_aria_pattern "tabIndex\|tabindex" "Tab index management"
check_aria_pattern "onKeyDown\|onKeyPress\|onKeyUp\|addEventListener.*key" "Keyboard event handlers"
check_aria_pattern "focus\|Focus" "Focus management"
check_aria_pattern "outline:\|:focus" "Focus indicators"

echo "" >> "$REPORT_FILE"
echo "## Forms Accessibility" >> "$REPORT_FILE"

print_info "Checking form accessibility..."
check_aria_pattern "<label\|htmlFor\|for=" "Form labels"
check_aria_pattern "fieldset\|legend" "Grouped form fields"
check_aria_pattern "aria-invalid\|aria-errormessage" "Error messaging"
check_aria_pattern "aria-required\|required" "Required field indicators"

echo "" >> "$REPORT_FILE"
echo "## Images & Media" >> "$REPORT_FILE"

print_info "Checking media accessibility..."
check_aria_pattern "alt=" "Alt text for images"
check_aria_pattern "figcaption\|<caption" "Media captions"
check_aria_pattern "track\|subtitle\|captions" "Video captions/subtitles"

echo "" >> "$REPORT_FILE"
echo "## Color & Contrast" >> "$REPORT_FILE"

print_info "Checking color accessibility patterns..."
check_aria_pattern "currentColor\|inherit" "Color inheritance for flexibility"
check_aria_pattern "prefers-color-scheme" "Dark mode support"
check_aria_pattern "not.*:hover\):not.*:focus" "Non-hover alternatives"

echo "" >> "$REPORT_FILE"
echo "## Skip Links & Landmarks" >> "$REPORT_FILE"

print_info "Checking navigation aids..."
check_aria_pattern "skip.*link\|skip.*navigation\|skip.*content" "Skip links"
check_aria_pattern "role.*navigation\|role.*main\|role.*banner" "ARIA landmarks"
check_aria_pattern "breadcrumb" "Breadcrumb navigation"

echo "" >> "$REPORT_FILE"
echo "## Testing & Tools" >> "$REPORT_FILE"

print_info "Checking for a11y testing setup..."

# Check for accessibility testing tools in package.json
if [ -f "package.json" ]; then
    run_a11y_check "Axe-core or similar a11y testing library" "grep -E 'axe-core|pa11y|jest-axe' package.json" false
    run_a11y_check "ESLint a11y plugin" "grep 'eslint-plugin-jsx-a11y\|eslint-plugin-vuejs-accessibility' package.json" false
fi

# Check for accessibility tests
run_a11y_check "Accessibility test files" "find . -name '*a11y*test*' -o -name '*accessibility*test*' | head -1" false

# Calculate compliance score
SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo "" >> "$REPORT_FILE"
echo "## Automated Testing Commands" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo '```bash' >> "$REPORT_FILE"
echo "# Install axe-core for automated testing" >> "$REPORT_FILE"
echo "npm install --save-dev @axe-core/react axe-core jest-axe" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "# Run accessibility tests" >> "$REPORT_FILE"
echo "npx axe --dir ./build" >> "$REPORT_FILE"
echo '```' >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "## Results" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- **Total Checks**: $TOTAL_CHECKS" >> "$REPORT_FILE"
echo "- **Passed**: $PASSED_CHECKS" >> "$REPORT_FILE"
echo "- **Failed**: $FAILED_CHECKS" >> "$REPORT_FILE"
echo "- **Warnings**: $WARNINGS" >> "$REPORT_FILE"
echo "- **Compliance Score**: ${SCORE}%" >> "$REPORT_FILE"

if [ $FAILED_CHECKS -eq 0 ]; then
    echo "- **WCAG 2.1 AA Ready**: ✅ Yes" >> "$REPORT_FILE"
else
    echo "- **WCAG 2.1 AA Ready**: ❌ No" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "## Next Steps" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if [ $FAILED_CHECKS -gt 0 ] || [ $WARNINGS -gt 0 ]; then
    echo "### Required Fixes:" >> "$REPORT_FILE"
    echo "1. Address all failed checks (❌) immediately" >> "$REPORT_FILE"
    echo "2. Review warnings (⚠️) for potential issues" >> "$REPORT_FILE"
    echo "3. Run manual screen reader testing with NVDA/JAWS" >> "$REPORT_FILE"
    echo "4. Validate color contrast ratios meet WCAG standards" >> "$REPORT_FILE"
    echo "5. Test keyboard navigation flow" >> "$REPORT_FILE"
else
    echo "✅ All automated checks passed!" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "### Recommended Manual Testing:" >> "$REPORT_FILE"
    echo "1. Screen reader testing with NVDA and JAWS" >> "$REPORT_FILE"
    echo "2. Keyboard-only navigation testing" >> "$REPORT_FILE"
    echo "3. Color contrast validation with tools" >> "$REPORT_FILE"
    echo "4. Cognitive load assessment" >> "$REPORT_FILE"
fi

print_header "📊 Accessibility Audit Complete"
print_info "Total Checks: $TOTAL_CHECKS"
print_success "Passed: $PASSED_CHECKS"
if [ $FAILED_CHECKS -gt 0 ]; then
    print_error "Failed: $FAILED_CHECKS"
fi
if [ $WARNINGS -gt 0 ]; then
    print_warning "Warnings: $WARNINGS"
fi
print_info "Compliance Score: ${SCORE}%"
print_info "Report saved to: $REPORT_FILE"

# Exit with error if critical checks failed
if [ $FAILED_CHECKS -gt 0 ]; then
    print_error "❌ WCAG 2.1 AA compliance not met"
    exit 1
else
    print_success "✅ Ready for manual accessibility testing"
fi