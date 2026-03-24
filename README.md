*[Читать на русском](README.ru.md)*

# COIL — Cognitive Orchestration Interface Language

A scripting language for cognitive orchestration in an agent OS where the LLM is the processor.

## Why

Every agent in an agent OS needs a behavioral script — not a prompt ("who you are"), but a protocol: what to do, when to wait, whom to ask, where to send. COIL describes such protocols. A human sees a clear script in their own language. An LLM sees an unambiguous structure it can execute, generate, and improve.

## Hello World

```coil
SEND
  TO #general
  <<
  Hello, world!
  >>
END

EXIT
```

One command, one channel, zero LLM. The agent sends a message and terminates.

With a cognitive step:

```coil
THINK greeting
  INPUT <<
  Come up with a short greeting message in the style of Hello, world!
  >>
  RESULT
  * text: TEXT
END

WAIT
  ON ?greeting
END

SEND
  TO #general
  <<
  $greeting.text
  >>
END

EXIT
```

## Status

Spec v0.2 — working draft. Split into two zones:

- **Stable** — decisions that are fixed in the current version.
- **Working hypothesis** — decisions that fit the architecture but whose syntax or precise semantics may still be refined.

## Spec

| File | Contents |
|---|---|
| [00-overview.md](spec/00-overview.md) | Philosophy, scope, what COIL is |
| [01-lexical.md](spec/01-lexical.md) | Lexical structure, blocks, identifiers, templates, comments |
| [02-core.md](spec/02-core.md) | Core operators and syntax |
| [03-extended.md](spec/03-extended.md) | Extended operators and working extensions |
| [04-execution-model.md](spec/04-execution-model.md) | Execution model, determinism, promises, step ordering |
| [05-structured-output.md](spec/05-structured-output.md) | RESULT microsyntax specification |
| [06-templates.md](spec/06-templates.md) | Templates and template logic boundaries |
| [07-streams.md](spec/07-streams.md) | Streams, events, and signals |
| [08-errors-budget.md](spec/08-errors-budget.md) | Errors, timeouts, budget exhaustion, cancellation |
| [09-os-integration.md](spec/09-os-integration.md) | Agent OS integration |
| [10-terminology.md](spec/10-terminology.md) | Terminology |
| [11-coil-h.md](spec/11-coil-h.md) | COIL-H: tabular projection specification |
| [DESIGN.md](DESIGN.md) | Decision log |

## Examples

| Example | What it shows |
|---|---|
| [research-agent.en.md](examples/research-agent.en.md) | Full research agent (COIL-H + COIL-C, English) |
| [research-agent.ru.md](examples/research-agent.ru.md) | Same agent (Russian) |
| [hello-world.md](examples/hello-world.md) | Minimal Hello World with COIL-H |

### Patterns (COIL-C)

| Pattern | What it shows |
|---|---|
| [routing.coil](examples/patterns/routing.coil) | Classification → role selection → response |
| [parallelization.coil](examples/patterns/parallelization.coil) | Parallel review by three experts, then aggregation |
| [evaluator-optimizer.coil](examples/patterns/evaluator-optimizer.coil) | Iterative evaluation and improvement loop |
| [prompt-chaining.coil](examples/patterns/prompt-chaining.coil) | Sequential prompts with quality check |
| [internal-delegation.coil](examples/patterns/internal-delegation.coil) | One LLM, different roles via AS — internal reasoning |
| [multi-agent-orchestration.coil](examples/patterns/multi-agent-orchestration.coil) | Real agents, communication via SEND + AWAIT |

### Anti-patterns

| Anti-pattern | What's wrong |
|---|---|
| [everything-in-one-think.coil](examples/anti-patterns/everything-in-one-think.coil) | Entire workflow crammed into a single THINK prompt |
| [think-for-deterministic-check.coil](examples/anti-patterns/think-for-deterministic-check.coil) | Using THINK for a condition IF can evaluate without LLM |
| [missing-wait.coil](examples/anti-patterns/missing-wait.coil) | Accessing $name without WAIT after launching THINK |
| [define-instead-of-set.coil](examples/anti-patterns/define-instead-of-set.coil) | DEFINE twice instead of DEFINE + SET |
| [send-when-think-needed.coil](examples/anti-patterns/send-when-think-needed.coil) | SEND AWAIT to another agent for work the current agent can do itself |

## Dialects

The runtime operates on the semantics of constructs, not their spelling. Keywords are written in the language the user thinks in. The same script in different languages is the same protocol:

```coil
ДУМАЙ анализ                          THINK analysis
  ЦЕЛЬ <<                               GOAL <<
  Классифицируй запрос.                 Classify the request.
  >>                                    >>
  РЕЗУЛЬТАТ                             RESULT
  * тип: ВЫБОР(баг, фича, вопрос)       * type: CHOICE(bug, feature, question)
КОНЕЦ                                 END
```

COIL has no default dialect. Dialects are keyword sets with identical semantics and execution model — a dialect is the skin, not the skeleton. The spec examples use Russian keywords, but no dialect is privileged in the implementation.

| Dialect | Directory | Status | Purpose |
|---|---|---|---|
| Standard English | [dialects/en-standard](dialects/en-standard/README.md) | Official | Primary entry point for English-speaking users |
| English profanity | [dialects/en-profanity](dialects/en-profanity/README.md) | Community | Proof of concept: semantic resonance via slang |
| Russian мат | [dialects/ru-mat](dialects/ru-mat/README.md) | Community | Proof of concept: Russian obscene dialect |
| Matrix | [dialects/ru-matrix](dialects/ru-matrix/README.md) | Community | Thematic dialect inspired by The Matrix |

Rules:

- One script — one dialect. Mixing keywords from different dialects in one file is invalid.
- Sigils (`$`, `?`, `@`, `!`, `#`, `~`) are universal and dialect-independent.
- Identifiers (variable, participant, tool names) are free-form and not constrained by dialect language.
- A spec-compliant COIL implementation must load dialects from external dialect tables; it is not required to bundle any specific dialect. Standard English and Russian are both part of the official distribution.

## PDF Documents

LaTeX sources in `tex/`, Markdown spec in `spec/`, compiled PDFs in `pdf/`.

| PDF | Source | Contents |
|---|---|---|
| `tutorial` | `tex/tutorial.tex` | Tutorial: getting started, three common scenarios, anti-patterns, typical mistakes, THINK vs. SEND with AWAIT |
| `lang-reference` | `spec/*.md` | Full language reference assembled from spec files (pandoc) |

### Prerequisites

LaTeX and pandoc are required to build PDFs.

On macOS:

```bash
brew install --cask mactex && brew install pandoc
```

### Build

```bash
make        # build all PDFs
make clean  # remove built files
```

## Test Suite

Conformance tests in `tests/` — `.coil` files (en-standard dialect) that define what a spec-compliant implementation must accept or reject. See [tests/README.md](tests/README.md).

| Directory | What it tests |
|---|---|
| `tests/valid/core/` | Each Core operator in isolation |
| `tests/valid/extended/` | Extended operators (IF, REPEAT, EACH, SIGNAL) |
| `tests/valid/result/` | RESULT microsyntax (TEXT, NUMBER, FLAG, CHOICE, LIST) |
| `tests/valid/patterns/` | Multi-operator integration scenarios |
| `tests/invalid/` | Preparation errors — must be rejected before execution |

---

Animata Systems, 2026
