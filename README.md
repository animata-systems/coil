*[Читать на русском](README.ru.md)*

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/animata-systems/coil)

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

## Status

Spec v0.3 — working draft with explicit status markers. Each area of the language has one of three normative statuses:

- **Stable** — part of the current norm. Docs and examples can teach this. Downstream work can rely on it.
- **Experimental** — the idea is accepted, but syntax or semantics may still change. Parser presence alone does not make it normative.
- **Deferred** — recognized as important, but consciously not normalized in this cycle. Mentioned only as future work.

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

All examples use the ru-standard dialect. Conformance tests use en-standard — see [tests/README.md](tests/README.md).

| Example | What it shows |
|---|---|
| [research-agent.md](examples/research-agent.md) | Full research agent (COIL-H + COIL-C) |
| [hello-world.coil](examples/hello-world.coil) | Minimal Hello World |

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

### Artifact hierarchy

| Layer | Location | Normative weight |
|---|---|---|
| Conformance tests | `tests/` | Normative — defines what a compliant parser must accept or reject |
| Executable examples | `examples/**/*.coil` | Documentation-first, machine-checkable — illustrate patterns but do not establish new norms |
| Narrative examples | `examples/**/*.md` | Illustrative — COIL-H does not fix mapping norm; COIL-C blocks are parser-checked but serve pedagogical purpose |

Executable examples are not a substitute for conformance tests. If a pattern must be spec-invalid, a dedicated `invalid/` test is required; presence in `anti-patterns/` alone is not sufficient.

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

| Dialect | Code | Directory |
|---|---|---|
| Standard Russian | `ru-standard` | [dialects/ru-standard](dialects/ru-standard/README.md) |
| Standard English | `en-standard` | [dialects/en-standard](dialects/en-standard/README.md) |
| Español estándar | `es-standard` | [dialects/es-standard](dialects/es-standard/README.md) |
| 简体中文 | `zh-standard` | [dialects/zh-standard](dialects/zh-standard/README.md) |
| 日本語 | `ja-standard` | [dialects/ja-standard](dialects/ja-standard/README.md) |
| Français standard | `fr-standard` | [dialects/fr-standard](dialects/fr-standard/README.md) |
| Português brasileiro | `pt-br-standard` | [dialects/pt-br-standard](dialects/pt-br-standard/README.md) |
| Standarddeutsch | `de-standard` | [dialects/de-standard](dialects/de-standard/README.md) |

Dialect table specification: [dialects/README.md](dialects/README.md).

Rules:

- One script — one dialect. Mixing keywords from different dialects in one file is invalid.
- Sigils (`$`, `?`, `@`, `!`, `#`, `~`) are universal and dialect-independent.
- Identifiers (variable, participant, tool names) are free-form and not constrained by dialect language.
- A spec-compliant COIL implementation must load dialects from external dialect tables; it is not required to bundle any specific dialect.

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
