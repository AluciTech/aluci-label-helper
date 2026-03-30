# Aluci Label Reviewer

[![GitHub License](https://img.shields.io/github/license/AluciTech/aluci-label-reviewer)](LICENSE)

> [!WARNING]
> This project is in early development and is not yet ready for production use.

## Overview

An AI-markdown-powered pre-review assistant for the [Aluci labeling](https://github.com/AluciTech/aluci-label) committee. It explores a repository, gathers evidence against the [Aluci label criteria](https://github.com/AluciTech/aluci-label/blob/main/CRITERIA.md), and produces structured notes so human reviewers can work better and focus on judgment calls.

This is **not** an automated reviewer, it surfaces facts and flags concerns. The final verdict is always made by humans.

## Setup

### Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI or [OpenCode](https://opencode.ai/)

### Installation

From the root of the repository you want to review, run the install script with your tool of choice:

**For Claude Code**:

```bash
curl -fsSL https://raw.githubusercontent.com/AluciTech/aluci-label-reviewer/refs/heads/main/install.sh | bash -s -- claude
```

**For OpenCode**:

```bash
curl -fsSL https://raw.githubusercontent.com/AluciTech/aluci-label-reviewer/refs/heads/main/install.sh | bash -s -- opencode
```

**For both**:

```bash
curl -fsSL https://raw.githubusercontent.com/AluciTech/aluci-label-reviewer/refs/heads/main/install.sh | bash -s -- all
```

This downloads the `/pre-review` command into the current directory. No other dependencies are required.

## Usage

From the target repository, run:

```bash
/pre-review
```

The assistant will:

1. Map the repository structure
2. Read key files (LICENSE, README, AI_USAGE.md, dependency manifests, etc.)
3. Inspect setup automation, CI/CD, and test infrastructure
4. Scan source files for code quality, telemetry, and resource efficiency signals
5. Write a `pre-review-notes.md` file with findings organized by Aluci criteria (C1-C5)

The generated notes are structured to align with the committee's final report template, so reviewers can lift findings directly.

## License

This project is licensed under the Apache License (Version 2.0).

See the [LICENSE](LICENSE) file for details.

## AI Usage Transparency

This project uses AI tools to assist with development.
For more details, see the [AI Usage Disclosure](AI_USAGE.md) file.
