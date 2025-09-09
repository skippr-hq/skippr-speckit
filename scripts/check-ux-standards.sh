#!/usr/bin/env bash
set -euo pipefail

# UX Standards Checker
# Validates implementation against Skippr UX constitution requirements

source "$(dirname "$0")/common.sh"

FEATURE_NAME="${1:-}"
REPORT_FILE="ux-audit-report.md"

print_header "🎨 UX Standards Check"

# Initialize report
cat > "$REPORT_FILE" << EOF
# UX Standards Audit Report
**Date**: $(date '+%Y-%m-%d %H:%M:%S')
**Feature**: ${FEATURE_NAME:-All Features}

## Summary
EOF

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# Function to check for pattern in files
check_pattern() {
    local pattern="$1"
    local file_glob="$2"
    local description="$3"
    local required="${4:-true}"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if find . -name "$file_glob" -type f 2>/dev/null | xargs grep -l "$pattern" 2>/dev/null | head -1 > /dev/null; then
        print_success "$description"
        echo "✅ $description" >> "$REPORT_FILE"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$required" = "true" ]; then
            print_error "$description - MISSING"
            echo "❌ $description - MISSING" >> "$REPORT_FILE"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            return 1
        else
            print_warning "$description - Not found (optional)"
            echo "⚠️ $description - Not found (optional)" >> "$REPORT_FILE"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            return 0
        fi
    fi
}

# Function to check file existence
check_component_exists() {
    local component_type="$1"
    local pattern="$2"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if find . -name "$pattern" -type f 2>/dev/null | head -1 > /dev/null; then
        print_success "$component_type component found"
        echo "✅ $component_type component exists" >> "$REPORT_FILE"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        print_error "$component_type component missing"
        echo "❌ $component_type component missing" >> "$REPORT_FILE"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

echo "" >> "$REPORT_FILE"
echo "## Loading States & Skeleton Screens" >> "$REPORT_FILE"

print_info "Checking loading states..."
check_pattern "loading\|isLoading\|isPending" "*.{js,jsx,ts,tsx}" "Loading state implementation"
check_pattern "Skeleton\|skeleton" "*.{js,jsx,ts,tsx}" "Skeleton screen components"
check_component_exists "LoadingSpinner" "*[Ll]oading*"
check_component_exists "Skeleton" "*[Ss]keleton*"

echo "" >> "$REPORT_FILE"
echo "## Error Handling" >> "$REPORT_FILE"

print_info "Checking error boundaries and handling..."
check_pattern "ErrorBoundary\|errorBoundary" "*.{js,jsx,ts,tsx}" "Error boundary implementation"
check_pattern "catch\|onError\|handleError" "*.{js,jsx,ts,tsx}" "Error handling logic"
check_pattern "error.*message\|errorMessage" "*.{js,jsx,ts,tsx}" "User-friendly error messages"
check_component_exists "ErrorBoundary" "*[Ee]rror[Bb]oundary*"

echo "" >> "$REPORT_FILE"
echo "## Responsive Design" >> "$REPORT_FILE"

print_info "Checking responsive design..."
check_pattern "@media\|breakpoint\|responsive" "*.{css,scss,js,jsx,ts,tsx}" "Media queries/breakpoints"
check_pattern "viewport" "*.html" "Viewport meta tag"
check_pattern "grid\|flex" "*.{css,scss,js,jsx,ts,tsx}" "Flexible layout systems"

echo "" >> "$REPORT_FILE"
echo "## Animations & Transitions" >> "$REPORT_FILE"

print_info "Checking animations and micro-interactions..."
check_pattern "transition\|animation\|transform" "*.{css,scss,js,jsx,ts,tsx}" "CSS transitions/animations"
check_pattern "framer-motion\|react-spring\|gsap" "package.json" "Animation library" false
check_pattern "prefers-reduced-motion" "*.{css,scss,js,jsx,ts,tsx}" "Reduced motion support"

echo "" >> "$REPORT_FILE"
echo "## User Feedback" >> "$REPORT_FILE"

print_info "Checking user feedback mechanisms..."
check_pattern "toast\|notification\|alert\|snackbar" "*.{js,jsx,ts,tsx}" "User notification system"
check_pattern "disabled\|isDisabled" "*.{js,jsx,ts,tsx}" "Disabled state handling"
check_pattern "hover\|focus\|active" "*.{css,scss,js,jsx,ts,tsx}" "Interactive states"

echo "" >> "$REPORT_FILE"
echo "## Forms & Validation" >> "$REPORT_FILE"

print_info "Checking form handling..."
check_pattern "validation\|validate\|validator" "*.{js,jsx,ts,tsx}" "Form validation"
check_pattern "required\|isRequired" "*.{js,jsx,ts,tsx}" "Required field handling"
check_pattern "placeholder\|label" "*.{js,jsx,ts,tsx}" "Form labels and placeholders"

echo "" >> "$REPORT_FILE"
echo "## Performance" >> "$REPORT_FILE"

print_info "Checking performance optimizations..."
check_pattern "lazy\|Lazy\|Suspense" "*.{js,jsx,ts,tsx}" "Lazy loading implementation"
check_pattern "memo\|useMemo\|useCallback" "*.{js,jsx,ts,tsx}" "React optimization hooks" false
check_pattern "virtualize\|windowing" "*.{js,jsx,ts,tsx}" "List virtualization" false

# Calculate score
SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo "" >> "$REPORT_FILE"
echo "## Results" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- **Total Checks**: $TOTAL_CHECKS" >> "$REPORT_FILE"
echo "- **Passed**: $PASSED_CHECKS" >> "$REPORT_FILE"
echo "- **Failed**: $FAILED_CHECKS" >> "$REPORT_FILE"
echo "- **Score**: ${SCORE}%" >> "$REPORT_FILE"

if [ $FAILED_CHECKS -gt 0 ]; then
    echo "- **Status**: ❌ Failed" >> "$REPORT_FILE"
else
    echo "- **Status**: ✅ Passed" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "## Recommendations" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if [ $FAILED_CHECKS -gt 0 ]; then
    echo "### Critical Issues to Address:" >> "$REPORT_FILE"
    echo "Review failed checks above and implement missing UX patterns." >> "$REPORT_FILE"
fi

print_header "📊 UX Audit Complete"
print_info "Total Checks: $TOTAL_CHECKS"
print_success "Passed: $PASSED_CHECKS"
if [ $FAILED_CHECKS -gt 0 ]; then
    print_error "Failed: $FAILED_CHECKS"
fi
print_info "Score: ${SCORE}%"
print_info "Report saved to: $REPORT_FILE"

# Exit with error if critical checks failed
if [ $FAILED_CHECKS -gt 0 ]; then
    exit 1
fi