# Skill Evaluation Prompts

Run each prompt **twice**: once without the skill loaded, once with it. Compare outputs.

---

## Test 1: Commit Message Writing

**Prompt:**
```
Write a commit message for this change: I added a new endpoint that lets users export their data as CSV. The endpoint is /api/export and accepts a format query parameter.
```

**Expected with skill:**
- Uses conventional commit format (`feat(api): ...`)
- Imperative mood ("add" not "added")
- Subject under 50 characters
- Body explains what and why

**Section tested:** Writing PRs → Commit Messages

---

## Test 2: Finding First Project

**Prompt:**
```
I'm a Python developer and want to start contributing to open source. How do I find a good project?
```

**Expected with skill:**
- Mentions specific resources (Good First Issue, Up For Grabs, etc.)
- Mentions labels to search for (`good first issue`, `help wanted`)
- Includes project evaluation criteria (license, activity, responsiveness)

**Section tested:** Finding Projects

---

## Test 3: Code Review Response

**Prompt:**
```
A reviewer left this comment on my PR: "This implementation is inefficient. Consider using a hash map instead of nested loops."

How should I respond?
```

**Expected with skill:**
- Professional, collaborative tone
- Acknowledges the feedback
- Either agrees to change or explains reasoning
- Doesn't argue or get defensive

**Section tested:** Responding to Code Review

---

## Test 4: Understanding Large Codebase

**Prompt:**
```
I want to contribute to a large project (50k+ lines) but I'm overwhelmed. How do I understand the codebase enough to make a contribution?
```

**Expected with skill:**
- Step-by-step approach (docs first, build locally, explore strategically)
- Mentions reading tests to understand behavior
- Suggests focusing on target area, not understanding everything
- Mentions using git history as documentation

**Section tested:** Understanding Large Codebases

---

## Test 5: Security Vulnerability

**Prompt:**
```
I found a SQL injection vulnerability in a popular open source library. What should I do?
```

**Expected with skill:**
- Emphasizes NOT opening a public issue
- Mentions looking for SECURITY.md
- Describes coordinated disclosure process
- Mentions 90-day timeline expectation

**Section tested:** Reference → Security Disclosure

---

## Test 6: PR Description

**Prompt:**
```
I'm about to open a PR that fixes a bug where user sessions weren't being invalidated on password change. Write a PR description for me.
```

**Expected with skill:**
- Follows template structure (Summary, Changes, Related Issues, Testing)
- Clear and concise
- Includes testing checklist

**Section tested:** Writing PRs → PR Description Template

---

## Test 7: Conventional Commits Deep Dive

**Prompt:**
```
What's the difference between feat!, BREAKING CHANGE footer, and when should I use each?
```

**Expected with skill:**
- Explains both notations correctly
- Notes they can be combined
- Mentions MAJOR version bump implication
- Provides examples

**Section tested:** Reference → Conventional Commits (should load reference file)

---

## Test 8: Linux Kernel Contribution

**Prompt:**
```
I want to submit a patch to the Linux kernel. What's different about their contribution process?
```

**Expected with skill:**
- Mentions Signed-off-by requirement
- Mentions email-based workflow (git send-email)
- Mentions checkpatch.pl
- Mentions finding maintainers with get_maintainer.pl

**Section tested:** Reference → Enterprise Practices (should load reference file)

---

## Test 9: Bug Report Writing

**Prompt:**
```
I found a bug in a library where dates are displayed incorrectly in certain timezones. Help me write a bug report.
```

**Expected with skill:**
- Follows bug report template structure
- Includes steps to reproduce
- Includes expected vs actual behavior
- Includes environment details

**Section tested:** Communicating with Maintainers → Bug Report Template

---

## Test 10: Avoiding Common Mistakes

**Prompt:**
```
I'm new to open source. What are the biggest mistakes I should avoid when making my first contribution?
```

**Expected with skill:**
- Mentions reading CONTRIBUTING.md first
- Mentions not working on already-assigned issues
- Mentions using feature branches (not main)
- Mentions keeping PRs small
- Mentions responding to feedback promptly

**Section tested:** Common Mistakes to Avoid

---

## Scoring Guide

For each test, rate 0-3:

| Score | Meaning |
|-------|---------|
| 0 | Completely missed the point |
| 1 | Partially correct but missing key elements |
| 2 | Good response but missing some skill-specific content |
| 3 | Excellent, includes skill-specific guidance |

**Target:** With skill loaded, all tests should score 2-3.
