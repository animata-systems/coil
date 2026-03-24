# COIL Test Suite

Conformance test cases for the COIL language specification. Each `.coil` file is a self-contained scenario that defines what a spec-compliant implementation must accept or reject.

All tests use the [en-standard](../dialects/en-standard/README.md) dialect.

## Structure

```
tests/
├── valid/              # must pass preparation and be executable
│   ├── core/           # one test per Core operator feature
│   ├── extended/       # Extended operators (IF, REPEAT, EACH, SIGNAL)
│   ├── result/         # RESULT microsyntax (TEXT, NUMBER, FLAG, CHOICE, LIST)
│   └── patterns/       # multi-operator integration scenarios
└── invalid/            # must be rejected at preparation time
```

## File format

Each file starts with metadata in comments:

```coil
' @test valid
' @covers THINK, RESULT, WAIT
' @description Minimal THINK with a single RESULT field
```

Fields:

| Field | Required | Values |
|---|---|---|
| `@test` | yes | `valid` or `invalid` |
| `@error` | invalid only | `preparation` or `execution` (error class per spec/08) |
| `@covers` | yes | constructs exercised by the test |
| `@description` | yes | one-line summary of what is being tested |

## Adding tests

1. Choose `valid/` or `invalid/` based on expected outcome.
2. Pick the appropriate subdirectory (or `invalid/` flat).
3. Name the file after the feature it tests: `think-minimal.coil`, `undeclared-actor.coil`.
4. Add the metadata header.
5. Write the smallest scenario that exercises the feature.
6. For `invalid/` tests — include exactly one error per file.

## Spec references

- [02-core.md](../spec/02-core.md) — Core operators
- [03-extended.md](../spec/03-extended.md) — Extended operators
- [05-structured-output.md](../spec/05-structured-output.md) — RESULT microsyntax
- [08-errors-budget.md](../spec/08-errors-budget.md) — Error classification
- [en-standard dialect](../dialects/en-standard/README.md) — English keyword mapping
