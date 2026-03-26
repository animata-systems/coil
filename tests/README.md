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

## Scope and normative weight

The conformance corpus establishes a **parser/preparation-level contract**. It verifies that a spec-compliant implementation correctly accepts valid surface syntax and rejects invalid constructs at preparation time.

The corpus does **not** constitute a full runtime specification. In particular, the following areas remain experimental and are not covered by conformance tests:

- stream semantics and event-based WAIT (`ЖДИ ... ИЗ ~...`);
- full expression grammar (operator precedence, logical connectives);
- reply-result shape and aggregation semantics for WAIT ALL.

### Artifact hierarchy

| Layer | Location | Normative weight |
|---|---|---|
| Conformance tests | `coil/tests/` | Normative — defines what a compliant parser must accept or reject |
| Executable examples | `coil/examples/**/*.coil` | Documentation-first, machine-checkable — illustrate patterns but do not establish new norms |
| Narrative examples | `coil/examples/**/*.md` | Illustrative — COIL-H does not fix mapping norm; COIL-C blocks are parser-checked but serve pedagogical purpose |

Executable examples are not a substitute for conformance tests. If a pattern must be spec-invalid, a dedicated `invalid/` test is required; presence in `anti-patterns/` alone is not sufficient.

## Spec references

- [02-core.md](../spec/02-core.md) — Core operators
- [03-extended.md](../spec/03-extended.md) — Extended operators
- [05-structured-output.md](../spec/05-structured-output.md) — RESULT microsyntax
- [08-errors-budget.md](../spec/08-errors-budget.md) — Error classification
- [en-standard dialect](../dialects/en-standard/README.md) — English keyword mapping
