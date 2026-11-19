# List available recipes
[private]
default:
    @just --list
# Check dependencies for known vulnerabilities (pip-audit)
audit:
    uv run pip-audit --skip-editable
# Scan staged changes for secrets
betterleaks:
    betterleaks git --pre-commit --staged --redact
# Type check, lint, format check, and lint workflows, YAML, and JSON without changing files
ci-lint:
    uv run ty check
    uv run ruff check .
    uv run ruff format --check .
    actionlint .github/workflows/*.yml
    yamllint --strict .
    just json-lint
# Validate JSON files (devcontainer.json is skipped because it allows comments)
json-lint:
    find . -name '*.json' -not -path './.venv/*' -not -name devcontainer.json -exec jq empty {} +
# Type check, lint, format, spell check, and lint workflows, YAML, and JSON, applying fixes
lint:
    uv run ty check
    uv run ruff check . --fix
    uv run ruff format .
    typos --write-changes
    actionlint .github/workflows/*.yml
    yamllint --strict .
    just json-lint
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
# Check spelling
spellcheck:
    typos
# Install all dependency groups into .venv
sync:
    uv sync --all-groups
# Run unit tests
test:
    uv run pytest
# Pull in the latest changes from the Copier template
update-template:
    copier update --trust
# Audit GitHub Actions workflows for security issues
zizmor:
    zizmor . --collect all
