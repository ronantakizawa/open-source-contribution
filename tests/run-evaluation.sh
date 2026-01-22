#!/bin/bash

# Open Source Contribution Skill - A/B Test Runner
# This script runs evaluation prompts with and without the skill loaded

set -e

SKILL_NAME="open-source-contribution"
SKILL_SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DEST="$HOME/.claude/skills/$SKILL_NAME"
OUTPUT_DIR="$(dirname "$0")/output"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Test prompts
PROMPTS=(
    "Write a commit message for this change: I added a new endpoint that lets users export their data as CSV. The endpoint is /api/export and accepts a format query parameter."
    "I'm a Python developer and want to start contributing to open source. How do I find a good project?"
    "A reviewer left this comment on my PR: \"This implementation is inefficient. Consider using a hash map instead of nested loops.\" How should I respond?"
    "I want to contribute to a large project (50k+ lines) but I'm overwhelmed. How do I understand the codebase enough to make a contribution?"
    "I found a SQL injection vulnerability in a popular open source library. What should I do?"
    "I'm about to open a PR that fixes a bug where user sessions weren't being invalidated on password change. Write a PR description for me."
    "What's the difference between feat!, BREAKING CHANGE footer, and when should I use each?"
    "I want to submit a patch to the Linux kernel. What's different about their contribution process?"
    "I found a bug in a library where dates are displayed incorrectly in certain timezones. Help me write a bug report."
    "I'm new to open source. What are the biggest mistakes I should avoid when making my first contribution?"
)

PROMPT_NAMES=(
    "01-commit-message"
    "02-finding-project"
    "03-code-review-response"
    "04-understanding-codebase"
    "05-security-vulnerability"
    "06-pr-description"
    "07-conventional-commits"
    "08-linux-kernel"
    "09-bug-report"
    "10-common-mistakes"
)

echo "========================================"
echo "Open Source Contribution Skill Evaluator"
echo "========================================"
echo ""
echo "Output directory: $OUTPUT_DIR"
echo "Timestamp: $TIMESTAMP"
echo ""

# Function to run a single prompt
run_prompt() {
    local prompt="$1"
    local output_file="$2"

    # Run claude with the prompt, non-interactive mode
    echo "$prompt" | claude --print 2>/dev/null > "$output_file" || {
        echo "Error running prompt. Make sure 'claude' CLI is installed and configured."
        return 1
    }
}

# Check if skill is currently installed
skill_was_installed=false
if [ -d "$SKILL_DEST" ]; then
    skill_was_installed=true
fi

# ============================================
# PHASE 1: Test WITHOUT skill
# ============================================
echo "PHASE 1: Testing WITHOUT skill"
echo "------------------------------"

# Remove skill if installed
if [ -d "$SKILL_DEST" ]; then
    echo "Temporarily removing skill from $SKILL_DEST"
    mv "$SKILL_DEST" "$SKILL_DEST.backup"
fi

WITHOUT_DIR="$OUTPUT_DIR/$TIMESTAMP-without-skill"
mkdir -p "$WITHOUT_DIR"

for i in "${!PROMPTS[@]}"; do
    name="${PROMPT_NAMES[$i]}"
    prompt="${PROMPTS[$i]}"
    output_file="$WITHOUT_DIR/$name.md"

    echo "  Running test $((i+1))/10: $name"

    # Add header to output file
    {
        echo "# Test: $name"
        echo ""
        echo "**Prompt:**"
        echo "\`\`\`"
        echo "$prompt"
        echo "\`\`\`"
        echo ""
        echo "**Response (WITHOUT skill):**"
        echo ""
    } > "$output_file"

    # Run the prompt and append response
    echo "$prompt" | claude --print 2>/dev/null >> "$output_file" || {
        echo "    [ERROR] Failed to run prompt"
        echo "[ERROR] Failed to get response" >> "$output_file"
    }

    echo "    Saved to: $output_file"
done

echo ""
echo "Phase 1 complete. Results in: $WITHOUT_DIR"
echo ""

# ============================================
# PHASE 2: Test WITH skill
# ============================================
echo "PHASE 2: Testing WITH skill"
echo "----------------------------"

# Install skill
echo "Installing skill to $SKILL_DEST"
mkdir -p "$(dirname "$SKILL_DEST")"
cp -r "$SKILL_SOURCE" "$SKILL_DEST"

WITH_DIR="$OUTPUT_DIR/$TIMESTAMP-with-skill"
mkdir -p "$WITH_DIR"

for i in "${!PROMPTS[@]}"; do
    name="${PROMPT_NAMES[$i]}"
    prompt="${PROMPTS[$i]}"
    output_file="$WITH_DIR/$name.md"

    echo "  Running test $((i+1))/10: $name"

    # Add header to output file
    {
        echo "# Test: $name"
        echo ""
        echo "**Prompt:**"
        echo "\`\`\`"
        echo "$prompt"
        echo "\`\`\`"
        echo ""
        echo "**Response (WITH skill):**"
        echo ""
    } > "$output_file"

    # Run the prompt and append response
    echo "$prompt" | claude --print 2>/dev/null >> "$output_file" || {
        echo "    [ERROR] Failed to run prompt"
        echo "[ERROR] Failed to get response" >> "$output_file"
    }

    echo "    Saved to: $output_file"
done

echo ""
echo "Phase 2 complete. Results in: $WITH_DIR"
echo ""

# ============================================
# PHASE 3: Generate comparison file
# ============================================
echo "PHASE 3: Generating comparison file"
echo "------------------------------------"

COMPARISON_FILE="$OUTPUT_DIR/$TIMESTAMP-comparison.md"

{
    echo "# Skill Evaluation Comparison"
    echo ""
    echo "**Date:** $(date)"
    echo "**Skill:** $SKILL_NAME"
    echo ""
    echo "## Scoring Guide"
    echo ""
    echo "| Score | Meaning |"
    echo "|-------|---------|"
    echo "| 0 | Completely missed the point |"
    echo "| 1 | Partially correct but missing key elements |"
    echo "| 2 | Good response but missing some skill-specific content |"
    echo "| 3 | Excellent, includes skill-specific guidance |"
    echo ""
    echo "## Results Summary"
    echo ""
    echo "| Test | Without Skill (0-3) | With Skill (0-3) | Improvement |"
    echo "|------|---------------------|------------------|-------------|"
    echo "| 1. Commit Message | | | |"
    echo "| 2. Finding First Project | | | |"
    echo "| 3. Code Review Response | | | |"
    echo "| 4. Understanding Codebase | | | |"
    echo "| 5. Security Vulnerability | | | |"
    echo "| 6. PR Description | | | |"
    echo "| 7. Conventional Commits | | | |"
    echo "| 8. Linux Kernel | | | |"
    echo "| 9. Bug Report | | | |"
    echo "| 10. Common Mistakes | | | |"
    echo "| **Average** | | | |"
    echo ""
    echo "---"
    echo ""
} > "$COMPARISON_FILE"

# Add side-by-side comparisons
for i in "${!PROMPT_NAMES[@]}"; do
    name="${PROMPT_NAMES[$i]}"

    {
        echo "## Test $((i+1)): ${name//-/ }"
        echo ""
        echo "**Your Score:** Without [ ] With [ ] Improvement [ ]"
        echo ""
        echo "### Without Skill"
        echo ""
        cat "$WITHOUT_DIR/$name.md" 2>/dev/null | tail -n +10 || echo "[No response]"
        echo ""
        echo "### With Skill"
        echo ""
        cat "$WITH_DIR/$name.md" 2>/dev/null | tail -n +10 || echo "[No response]"
        echo ""
        echo "### Notes"
        echo ""
        echo "_Write your observations here_"
        echo ""
        echo "---"
        echo ""
    } >> "$COMPARISON_FILE"
done

echo "Comparison file: $COMPARISON_FILE"
echo ""

# ============================================
# Cleanup
# ============================================
echo "CLEANUP"
echo "-------"

# Restore original state
if [ "$skill_was_installed" = true ]; then
    echo "Skill was already installed, leaving it in place"
    rm -rf "$SKILL_DEST.backup" 2>/dev/null || true
else
    echo "Removing skill (wasn't installed before test)"
    rm -rf "$SKILL_DEST"
    # Restore backup if exists
    if [ -d "$SKILL_DEST.backup" ]; then
        mv "$SKILL_DEST.backup" "$SKILL_DEST"
    fi
fi

echo ""
echo "========================================"
echo "EVALUATION COMPLETE"
echo "========================================"
echo ""
echo "Output files:"
echo "  Without skill: $WITHOUT_DIR/"
echo "  With skill:    $WITH_DIR/"
echo "  Comparison:    $COMPARISON_FILE"
echo ""
echo "Next steps:"
echo "  1. Open $COMPARISON_FILE"
echo "  2. Review each response pair"
echo "  3. Score using the rubric (0-3)"
echo "  4. Fill in the Results Summary table"
echo ""
