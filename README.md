# Open Source Contribution Skill

A Claude Code skill that guides developers through open source contributions.

## What It Does

- **Finding Projects**: Resources and labels for finding beginner-friendly issues
- **Understanding Codebases**: Step-by-step approach to navigating large projects
- **Writing PRs**: Forking workflow, branch strategy, conventional commits, PR descriptions
- **Code Review**: How to respond to feedback professionally
- **Communicating with Maintainers**: Bug reports, feature requests, best practices
- **Enterprise Standards**: Linux Kernel patch format, Apache contributor ladder
- **Security Disclosure**: Coordinated vulnerability reporting

## Installation

### Using npx add-skill
```bash
npx add-skill ronantakizawa/skill-open-source-contribution
```

### Using npx skills
```bash
npx skills add ronantakizawa/skill-open-source-contribution
```

### Manual Installation
```bash
# Clone to your skills directory
git clone https://github.com/ronantakizawa/skill-open-source-contribution ~/.claude/skills/open-source-contribution
```

## Usage

Once installed, the skill activates when you ask Claude Code about:
- Contributing to GitHub/GitLab projects
- Writing commit messages
- Responding to code review
- Reporting vulnerabilities
- Finding open source projects to contribute to

### Example Prompts

```
Write a commit message for this change: I added user authentication

How do I find a good first open source project to contribute to?

A reviewer said my code is inefficient. How should I respond?

I found a security vulnerability in a library. What should I do?
```

## Structure

```
open-source-contribution/
├── SKILL.md                 # Main skill file
├── marketplace.json         # Marketplace metadata
├── reference/
│   ├── conventional-commits.md
│   ├── enterprise-practices.md
│   └── security-disclosure.md
├── templates/
│   ├── pull-request.md
│   ├── bug-report.md
│   ├── feature-request.md
│   └── commit-messages.md
└── tests/
    ├── evaluation-prompts.md
    └── run-evaluation.sh
```

## License

MIT
