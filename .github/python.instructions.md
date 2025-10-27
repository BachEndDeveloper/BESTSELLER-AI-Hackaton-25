---
applyTo: "/**/*.py"
---

# Python Development Standards

## Quick Reference (Copilot reads this first)

- Python: 3.12+ | Style: Black + Ruff + mypy
- Priority: correctness > security > readability > tests > performance
- No naive datetimes, no print() in libs, use pathlib, type everything
- Tests: pytest with parametrize; hermetic, deterministic
- Deps: stdlib first; justify all external packages

## Code Generation DefaultsGreat question! Your instructions file is already quite comprehensive. Here are my optimization suggestions for making it work better with GitHub Copilot

## Key Optimizations

### 1. **Reorganize for Copilot's Context Window**

Move the most actionable content to the top. Copilot works best when critical patterns appear early:

````markdown name=.github/copilot-instructions.md
# GitHub Copilot – Python Instructions

## Quick Reference (Copilot Priority Patterns)
- Python ≥3.12, PEP 8, Black formatter, Ruff linter, mypy/pyright strict
- Type hints: `list[int]`, `dict[str, Any]`, `int | None` (modern syntax)
- Use `dataclasses`, `pathlib.Path`, `logging.getLogger(__name__)`
- Aware datetimes only (UTC + `zoneinfo`)
- Tests: pytest with parametrize; deterministic, no network
- No `print()` in libraries, no secrets in code, no mutable defaults

## Code Generation Defaults
When writing Python code, always:
1. Add explicit type hints to all functions
2. Use context managers for resources (`with` statements)
3. Include docstrings (Google or NumPy style, 1-liner min)
4. Prefer stdlib over dependencies
5. Return early, fail fast with specific exceptions
6. Generate corresponding pytest tests

### Example Function Template
```python
from pathlib import Path
import logging

logger = logging.getLogger(__name__)

def process_data(
    input_path: Path,
    *,
    encoding: str = "utf-8",
    strict: bool = True
) -> dict[str, Any]:
    """Process data from file and return structured results.
    
    Args:
        input_path: Path to input file
        encoding: Text encoding to use
        strict: Whether to fail on validation errors
        
    Returns:
        Processed data dictionary
        
    Raises:
        FileNotFoundError: If input_path doesn't exist
        ValueError: If data validation fails in strict mode
    """
    if not input_path.exists():
        raise FileNotFoundError(f"Input not found: {input_path}")
    
    # Implementation here
    logger.info("Processed %s", input_path)
    return {}
```

## Testing Pattern
```python
import pytest

@pytest.mark.parametrize("input_val,expected", [
    ("normal", "result"),
    ("edge_case", "special"),
])
def test_process_data_parametrized(input_val: str, expected: str) -> None:
    """Test process_data with various inputs."""
    result = process_data(input_val)
    assert result == expected

def test_process_data_raises_on_invalid() -> None:
    """Test that invalid input raises ValueError."""
    with pytest.raises(ValueError, match="validation"):
        process_data("invalid")
```

## Project Structure (inferred defaults)
```
repo/
├── pyproject.toml          # PEP 621 metadata
├── src/
│   └── package_name/       # Importable code here
├── tests/                  # Mirror src/ structure
└── .github/
    └── copilot-instructions.md
```

## Priorities (in order)
1. **Correctness** – Type-safe, handles edge cases
2. **Security** – No secrets, validate input, sanitize output
3. **Readability** – Clear names, small functions, documented
4. **Testability** – Pure functions, dependency injection
5. **Performance** – Only optimize with evidence

## Common Patterns

### Data Models
```python
from dataclasses import dataclass
from typing import Protocol

@dataclass(frozen=True, slots=True)  # 3.10+
class User:
    """Immutable user model."""
    id: int
    name: str
    email: str | None = None

class Storage(Protocol):
    """Pluggable storage interface."""
    def save(self, key: str, value: bytes) -> None: ...
    def load(self, key: str) -> bytes: ...
```

### Async Patterns
```python
import asyncio
from collections.abc import AsyncIterator

async def fetch_items() -> AsyncIterator[Item]:
    """Async generator for streaming results."""
    async with httpx.AsyncClient() as client:
        for page in range(10):
            resp = await client.get(f"/items?page={page}")
            resp.raise_for_status()
            for item in resp.json()["items"]:
                yield Item(**item)
```

### Error Handling
```python
class ValidationError(ValueError):
    """Domain-specific validation error."""
    pass

def validate_input(data: dict[str, Any]) -> None:
    """Validate input schema."""
    try:
        # validation logic
        if "required_field" not in data:
            raise KeyError("required_field")
    except KeyError as err:
        raise ValidationError(
            f"Missing required field: {err}"
        ) from err
```

## What NOT to Generate
- ❌ Mutable default arguments: `def func(items=[])`
- ❌ Bare `except:` clauses
- ❌ `print()` in library code
- ❌ Naive datetimes: `datetime.now()`
- ❌ String path concatenation: `path + "/" + file`
- ❌ Wildcard imports: `from module import *`
- ❌ Global state or module-level I/O
- ❌ Hardcoded secrets or credentials

## Security Checklist
- [ ] No secrets in code (use env vars: `os.getenv("API_KEY")`)
- [ ] Validate all external input (files, APIs, user data)
- [ ] Use parameterized queries (never string concat for SQL)
- [ ] Sanitize outputs (`html.escape`, `shlex.quote`)
- [ ] Log without PII

## Dependency Guidelines
**Default: Use stdlib.** If proposing a dependency, include:
- **Why**: What problem does it solve that stdlib can't?
- **Risk**: Maintenance status, last release, known CVEs
- **Alternative**: How to implement without it (if < 50 LOC)

Example justification:
```python
# ✅ Justified
import httpx  # Async HTTP/2 support, better than stdlib urllib

# ❌ Not justified (use stdlib)
import requests  # Use urllib3 or httpx instead
```

## When to Ask for Clarification
If generating code and any of these are unclear, ask first:
- Input/output formats and constraints
- Error handling expectations (fail fast vs. graceful degradation)
- Performance requirements (can it be O(n²)?)
- Backward compatibility needs
- Whether to mock external services in tests

## Copilot Chat Prompts (User Quick Reference)
```
/doc Add docstrings to all functions in this file
/tests Generate pytest tests for [function/class]
/fix Apply Black formatting and fix Ruff violations
```

**Inline generation:**
- Comment: `# Function to validate email format with regex`  
  → Copilot generates typed, tested implementation
- Comment: `# TODO: Add logging for failed validations`  
  → Copilot adds structured logging

## Definition of Done
Before accepting generated code, verify:
- [x] Type hints on all public functions
- [x] Docstrings on public APIs
- [x] Tests cover happy + edge + error paths
- [x] No linter/type-checker errors
- [x] No secrets or hardcoded config
- [x] Logging instead of print statements
- [x] Resources use context managers
