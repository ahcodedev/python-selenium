# List available recipes
[private]
default:
    @just --list
# Check dependencies for known vulnerabilities (pip-audit)
audit:
    uv run pip-audit --skip-editable
# Type check, lint, format check, spell check, and lint workflows without changing files
ci-lint:
    uv run ty check
    uv run ruff check .
    uv run ruff format --check .
    uv run codespell
    uv run actionlint .github/workflows/*.yml
# Scan staged changes for secrets
git-leaks:
    gitleaks git --pre-commit --staged --redact
# Type check, lint, format, spell check, and lint workflows, applying fixes
lint:
    uv run ty check
    uv run ruff check . --fix
    uv run ruff format .
    uv run codespell
    uv run actionlint .github/workflows/*.yml
# Lint Markdown files
markdownlint:
    markdownlint-cli2 "**/*.md"
# Run the git hooks on staged files
prek:
    uv run prek
# Install Homebrew tools and sync the project
setup:
    brew bundle install
    just sync
# Install all dependency groups into .venv
sync:
    uv sync --all-groups
# Run unit tests with coverage
test:
    uv run pytest
# Audit GitHub Actions workflows for security issues
zizmor:
    zizmor . --collect all
