#!/usr/bin/env bash
set -euo pipefail

# Content & Copy Quality Checker
# Validates microcopy, error messages, and content standards

source "$(dirname "$0")/common.sh"

FEATURE_NAME="${1:-}"
REPORT_FILE="content-quality-report.md"

print_header "📝 Content Quality Check"

# Initialize report
cat > "$REPORT_FILE" << EOF
# Content Quality Report
**Date**: $(date '+%Y-%m-%d %H:%M:%S')
**Feature**: ${FEATURE_NAME:-All Features}

## Summary
EOF

TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
HARDCODED_STRINGS=()

# Function to check for content patterns
check_content_pattern() {
    local pattern="$1"
    local description="$2"
    local inverse="${3:-false}"
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    local found=$(find . -name "*.{js,jsx,ts,tsx}" -type f 2>/dev/null | xargs grep -l "$pattern" 2>/dev/null | wc -l)
    
    if [ "$inverse" = "true" ]; then
        # We want this pattern NOT to be found
        if [ "$found" -eq 0 ]; then
            print_success "$description"
            echo "✅ $description" >> "$REPORT_FILE"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            return 0
        else
            print_error "$description - Found $found instances"
            echo "❌ $description - Found $found instances" >> "$REPORT_FILE"
            FAILED_CHECKS=$((FAILED_CHECKS + 1))
            return 1
        fi
    else
        # We want this pattern to be found
        if [ "$found" -gt 0 ]; then
            print_success "$description"
            echo "✅ $description" >> "$REPORT_FILE"
            PASSED_CHECKS=$((PASSED_CHECKS + 1))
            return 0
        else
            print_warning "$description - Not found"
            echo "⚠️ $description - Not found" >> "$REPORT_FILE"
            return 0
        fi
    fi
}

# Function to find hardcoded strings
find_hardcoded_strings() {
    print_info "Scanning for hardcoded strings..."
    
    # Find strings that look like user-facing messages
    local patterns=(
        "Error:"
        "Success:"
        "Warning:"
        "Please "
        "You must"
        "You need"
        "Invalid "
        "Failed to"
        "Unable to"
        "Successfully"
        "Click here"
        "Submit"
        "Cancel"
        "Save"
        "Delete"
        "Confirm"
    )
    
    for pattern in "${patterns[@]}"; do
        local files=$(find . -name "*.{js,jsx,ts,tsx}" -type f 2>/dev/null | xargs grep -l "['\"]\([^'\"]*${pattern}[^'\"]*\)['\"]" 2>/dev/null || true)
        if [ -n "$files" ]; then
            HARDCODED_STRINGS+=("$pattern")
        fi
    done
}

echo "" >> "$REPORT_FILE"
echo "## Error Messages" >> "$REPORT_FILE"

print_info "Checking error message quality..."
check_content_pattern "catch.*error" "Error handling exists"
check_content_pattern "error.*message\|errorMessage" "Custom error messages"
check_content_pattern "console\.error\|console\.log" "No console.log in production" true
check_content_pattern "Error:.*[0-9]\|error.*code" "No error codes shown to users" true
check_content_pattern "try again\|Try again" "Actionable error recovery"

echo "" >> "$REPORT_FILE"
echo "## User-Facing Copy" >> "$REPORT_FILE"

print_info "Checking microcopy quality..."
check_content_pattern "placeholder=\|placeholder:" "Placeholder text for inputs"
check_content_pattern "title=\|tooltip\|Tooltip" "Helpful tooltips"
check_content_pattern "help.*text\|helperText" "Helper text for complex inputs"
check_content_pattern "description\|Description" "Feature descriptions"

echo "" >> "$REPORT_FILE"
echo "## Empty States" >> "$REPORT_FILE"

print_info "Checking empty state handling..."
check_content_pattern "no.*data\|No.*found\|empty\|Empty" "Empty state messages"
check_content_pattern "get.*started\|create.*first\|add.*first" "Empty state CTAs"

echo "" >> "$REPORT_FILE"
echo "## Internationalization" >> "$REPORT_FILE"

print_info "Checking i18n readiness..."
check_content_pattern "i18n\|t(\|translate\|intl\|localize" "i18n library usage"
check_content_pattern "formatMessage\|FormattedMessage" "Formatted messages"

# Find hardcoded strings
find_hardcoded_strings

if [ ${#HARDCODED_STRINGS[@]} -gt 0 ]; then
    echo "" >> "$REPORT_FILE"
    echo "### ⚠️ Hardcoded Strings Found" >> "$REPORT_FILE"
    echo "The following patterns were found hardcoded in the codebase:" >> "$REPORT_FILE"
    for str in "${HARDCODED_STRINGS[@]}"; do
        echo "- \"$str\"" >> "$REPORT_FILE"
    done
    FAILED_CHECKS=$((FAILED_CHECKS + ${#HARDCODED_STRINGS[@]}))
    TOTAL_CHECKS=$((TOTAL_CHECKS + ${#HARDCODED_STRINGS[@]}))
fi

echo "" >> "$REPORT_FILE"
echo "## Content Consistency" >> "$REPORT_FILE"

print_info "Checking content consistency..."
check_content_pattern "Loading\.\.\.\|loading\.\.\." "Consistent loading text"
check_content_pattern "Saving\.\.\.\|saving\.\.\." "Consistent saving text"
check_content_pattern "Please wait\|please wait" "Consistent wait messages"

echo "" >> "$REPORT_FILE"
echo "## Professional Language" >> "$REPORT_FILE"

print_info "Checking for unprofessional language..."
check_content_pattern "oops\|Oops\|whoops\|uh-oh" "No casual error language" true
check_content_pattern "damn\|shit\|hell\|crap" "No inappropriate language" true
check_content_pattern "FIXME\|TODO\|HACK\|XXX" "No development comments" true
check_content_pattern "test\|Test\|debug\|Debug" "No test/debug text" true

# Calculate score
SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo "" >> "$REPORT_FILE"
echo "## Content Guidelines Checklist" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "### Manual Review Required:" >> "$REPORT_FILE"
echo "- [ ] Error messages are helpful and actionable" >> "$REPORT_FILE"
echo "- [ ] Empty states provide clear next steps" >> "$REPORT_FILE"
echo "- [ ] Microcopy matches brand voice" >> "$REPORT_FILE"
echo "- [ ] All text is at 8th grade reading level" >> "$REPORT_FILE"
echo "- [ ] CTAs use action-oriented verbs" >> "$REPORT_FILE"
echo "- [ ] No jargon or technical terms in UI" >> "$REPORT_FILE"
echo "- [ ] Consistent terminology throughout" >> "$REPORT_FILE"
echo "- [ ] Proper capitalization and punctuation" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "## Results" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "- **Total Checks**: $TOTAL_CHECKS" >> "$REPORT_FILE"
echo "- **Passed**: $PASSED_CHECKS" >> "$REPORT_FILE"
echo "- **Failed**: $FAILED_CHECKS" >> "$REPORT_FILE"
echo "- **Score**: ${SCORE}%" >> "$REPORT_FILE"

if [ ${#HARDCODED_STRINGS[@]} -gt 0 ]; then
    echo "- **Hardcoded Strings**: ${#HARDCODED_STRINGS[@]} patterns found" >> "$REPORT_FILE"
fi

if [ $FAILED_CHECKS -eq 0 ]; then
    echo "- **Status**: ✅ Passed automated checks" >> "$REPORT_FILE"
else
    echo "- **Status**: ❌ Needs improvement" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "## Recommendations" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

if [ ${#HARDCODED_STRINGS[@]} -gt 0 ]; then
    echo "### Priority 1: Extract Hardcoded Strings" >> "$REPORT_FILE"
    echo "Move all user-facing strings to i18n files for consistency and localization." >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

if [ $FAILED_CHECKS -gt 0 ]; then
    echo "### Priority 2: Content Improvements" >> "$REPORT_FILE"
    echo "1. Review and improve error messages to be more helpful" >> "$REPORT_FILE"
    echo "2. Add empty states where missing" >> "$REPORT_FILE"
    echo "3. Ensure all copy follows brand guidelines" >> "$REPORT_FILE"
fi

print_header "📊 Content Quality Audit Complete"
print_info "Total Checks: $TOTAL_CHECKS"
print_success "Passed: $PASSED_CHECKS"
if [ $FAILED_CHECKS -gt 0 ]; then
    print_error "Failed: $FAILED_CHECKS"
fi
if [ ${#HARDCODED_STRINGS[@]} -gt 0 ]; then
    print_warning "Hardcoded strings: ${#HARDCODED_STRINGS[@]} patterns"
fi
print_info "Score: ${SCORE}%"
print_info "Report saved to: $REPORT_FILE"

# Exit with error if critical issues found
if [ $FAILED_CHECKS -gt 5 ]; then
    print_error "Content quality needs significant improvement"
    exit 1
fi