*[Читать на русском](README.ru.md)*

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/animata-systems/coil)

# COIL — Cognitive Orchestration Interface Language
> Spec v0.4 · Preview

A protocol language for how agents interact — with each other and with humans.

## Why

An agent needs more than a "who you are" instruction — it needs a protocol: when to think, whom to ask, where to write. In COIL, humans read a clear script in their own language, the runtime sees an unambiguous structure, and the LLM steps in where reasoning is needed. Moreover, one protocol can generate and refine another — the language is self-describing.

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

---

## Syntax Reference

### Typed References

Every entity in COIL is addressed via a prefix. Bare names (without prefix) are only allowed in operator signatures (binding position).

| Prefix | Entity | Example | Description |
|---|---|---|---|
| `$` | Value | `$request`, `$plan.summary` | Named datum. Field access via dot |
| `?` | Promise | `?plan`, `?answer` | Future of a launching operator's result |
| `@` | Actor | `@tech_analyst` | Person or agent — no distinction |
| `!` | Tool | `!search` | MCP server function |
| `#` | Address | `#channel`, `#channel/1234` | Location in the message space |
| `~` | Stream | `~decision` | Live bidirectional session |

#### Dynamic References

After a prefix, `$`-substitution is allowed. Three levels of dynamism:

| Level | Example | Result |
|---|---|---|
| Static | `#quick_questions` | `#quick_questions` |
| Partial | `#requests/$case` | `#requests/1234` |
| Full | `#$route.channel` | `#tech_support` |

Without `$` everything is literal: `#route.channel` → literal address `#route.channel`.

Nested substitutions (`#$${name}`) are forbidden — exactly one level of indirection.

### Comments

Start with `'` and continue to end of line:

```coil
' This is a comment
```

### Operator Forms

**Block** — operator with modifiers or body:

```coil
OPERATOR [signature]
  [modifiers]
  [anonymous body]
END
```

`END` closes the **operator**, not a modifier.

**Inline** — for declarations with a simple list:

```coil
ACTORS tech_analyst, client_a
TOOLS search, database
```

**Without END** — only `EXIT`:

```coil
EXIT
```

### Modifiers

Three kinds:

| Kind | Syntax | Examples |
|---|---|---|
| Referential/modal | `KEYWORD value` (single line) | `FOR @analyst`, `AWAIT ALL`, `TIMEOUT 5m` |
| Template | `KEYWORD << ... >>` | `GOAL << ... >>`, `INPUT << ... >>` |
| Structural | Own micro-syntax | `RESULT` |

Template opens with `<<` on the same line as the modifier and closes with `>>` on a separate line. Indentation inside is part of the content.

### Duration Literals

| Suffix | Unit | Example |
|---|---|---|
| `s` | Seconds | `30s` |
| `m` | Minutes | `5m` |
| `h` | Hours | `2h` |

---

## Operators

### Operator Categories

| Behavior | Operators | Meaning |
|---|---|---|
| Instant | `ACTORS`, `TOOLS`, `DEFINE`, `SET` | No waiting, no external calls |
| Blocking | `RECEIVE`, `WAIT` | Suspend protocol until data arrives |
| Launching | `THINK`, `EXECUTE`, `SEND` | Initiate async work, create `?name` |
| Terminating | `EXIT` | End protocol |

---

### ACTORS

Declares protocol participants. After declaration, addressed as `@name`.

```coil
ACTORS tech_analyst, client_a
```

```coil
ACTORS
  tech_analyst
  client_a
  financial_analyst
END
```

Using `@name` without declaration is an error.

### TOOLS

Declares tools. After declaration, addressed as `!name`.

```coil
TOOLS search, database
```

Using `!name` without declaration is an error.

### DEFINE

Creates a new named value `$name`. Duplicate `DEFINE` with the same name is an error (use `SET`).

Literal:
```coil
DEFINE retries
3
END
```

Template:
```coil
DEFINE analyst_role
<<
You are an analyst who identifies artifacts requiring changes.
>>
END
```

Alias (value copy):
```coil
DEFINE current_role
$general_role
END
```

Boolean:
```coil
DEFINE done
FALSE
END
```

### SET

Modifies an already existing value. Signature uses `$name` (with prefix).

```coil
SET $retries
4
END
```

```coil
SET $current_translation
$improved_translation.text
END
```

`SET` for a non-existent name is an error.

### RECEIVE

Blocking step — binds a value from the host environment. Creates `$name`.

```coil
RECEIVE contract_id
<<
Please provide the contract number.
>>
END
```

Without body:
```coil
RECEIVE config_value
END
```

With timeout:
```coil
RECEIVE user_input
TIMEOUT 5m
<<
Please specify preferred response format.
>>
END
```

Modifiers: `TIMEOUT` (optional).

### THINK

LLM cognitive step. The main COIL operator. Creates promise `?name` and after waiting — value `$name`.

#### Full Form

```coil
THINK plan
  VIA $fast_model
  AS $analyst_role, $troubleshooting
  USING !search, !calculate
  GOAL <<
  Determine which artifacts require changes.
  >>
  INPUT <<
  User request:
  $request
  >>
  CONTEXT <<
  History:
  $history
  >>
  RESULT
  * summary: TEXT - brief overall conclusion
  * artifacts: LIST - artifacts requiring changes
    * path: TEXT - artifact path
    * action: CHOICE(create, modify, delete) - change type
    * reason: TEXT - why the change is needed
END
```

#### Modifiers

Split into two groups. **Equipment comes first**, then **task statement**.

**Equipment** (how and with what to execute):

| Modifier | Accepts | Required |
|---|---|---|
| `VIA` | Exactly one `$name` reference (LLM model) | No |
| `AS` | List of `$name` via `,` (skills/roles) | No |
| `USING` | List of `!name` via `,` (tools) | No |

**Task statement** (what to solve):

| Modifier | Form | Required |
|---|---|---|
| `GOAL` | Template `<< >>` | No |
| `INPUT` | Template `<< >>` | No |
| `CONTEXT` | Template `<< >>` | No |
| `RESULT` | Structural (see below) | No |

**Order rules**: equipment → task statement. `GOAL` before `AS` is an error.

**Minimal THINK** — at least one task statement modifier or anonymous body:

```coil
THINK decision
  GOAL <<
  Classify the customer request.
  >>
  RESULT
  * category: CHOICE(bug, feature, question) - request type
END
```

**VIA** accepts only `$name` (not a literal). The model must be defined via `DEFINE` or `RECEIVE`.

**AS** accepts only `$name`. Template `<< >>` is forbidden.

**USING** — all tools must be declared via `TOOLS`.

**RESULT** must be the last modifier. Not closed by its own `END`.

**RESULT and anonymous body** are compatible. Order: `RESULT` → body → `END`.

### EXECUTE

Tool invocation. Creates `?name` and potentially `~name`.

```coil
EXECUTE article
  USING !load_article
  - url: $url
  - format: "markdown"
END
```

| Modifier | Accepts | Required |
|---|---|---|
| `USING` | Exactly one `!name` reference | **Yes** |

Arguments — list of `- key: value` after `USING`. Values are literals or `$name`.

Template body `<< >>` in `EXECUTE` is forbidden.

### SEND

Sends a message. Covers both regular messages and information requests.

```coil
SEND answer
  TO #quick_questions
  FOR @tech_analyst
  AWAIT ANY
  TIMEOUT 10m
  <<
  Check the possible cause of failure and a safe workaround.
  >>
END
```

#### Modifiers

| Modifier | Accepts | Required |
|---|---|---|
| `TO` | Reference `#name` | No |
| `FOR` | List of `@name` via `,` | No |
| `REPLY TO` | Reference `#name` (message path) | No |
| `AWAIT` | `NONE`, `ANY`, `ALL` | No (default `NONE`) |
| `TIMEOUT` | Duration literal | No |

Anonymous body — the message text. Must come last.

#### Await Policies

| Policy | Completion condition | Shape of `$name` |
|---|---|---|
| `AWAIT NONE` | Message sent | Name is **not created** |
| `AWAIT ANY` | At least one reply received | Single reply |
| `AWAIT ALL` | Replies from all recipients received | Collection of replies |

**Name + AWAIT NONE** = error. Fire-and-forget does not produce a value.

**SEND without a name** — allowed; no promise is created.

#### Addressing

`TO #channel` — message in a channel.
`TO #channel/post_id` — comment on a post.
`REPLY TO #channel/post_id` — link to another message (not location, but reference).

The two dimensions are orthogonal: `TO` defines *location*, `REPLY TO` defines *relation*. Both can be used simultaneously:

```coil
SEND
  TO #channel/post_id_B
  REPLY TO #channel/post_id_A
  FOR @client_a
  <<
  $answer
  >>
END
```

### WAIT

Synchronization point. Blocks the protocol until results arrive.

```coil
WAIT
  ON ?plan, ?answer
  MODE ALL
  TIMEOUT 10m
END
```

| Modifier | Accepts | Required |
|---|---|---|
| `ON` | List of `?name` via `,` | Yes |
| `MODE` | `ALL` or `ANY` | No (default `ALL`) |
| `TIMEOUT` | Duration literal | No |

**Bound form** — binds the first completed result to a name:

```coil
WAIT data
  ON ?found, ?opinion
  MODE ANY
END
```

After `WAIT`, promise values become available as `$name`.

### EXIT

Terminates the protocol. Single line, no arguments, no `END`.

```coil
EXIT
```

---

### IF (Extended)

Conditional branching. Evaluated deterministically, without LLM.

```coil
IF $score > 80
  ...
END
```

```coil
IF NOT ($verdict.type = "technical")
  ...
END
```

Condition syntax — expression grammar (see below).

### REPEAT (Extended)

Loop with a mandatory upper bound.

Count-only:
```coil
REPEAT 5
  ...
END
```

Conditional form:
```coil
REPEAT UNTIL $score >= 8 NO MORE THAN 5
  ...
END
```

`REPEAT` without a limit is invalid.

### EACH (Extended)

Iterates over list elements. Sequential, not parallel.

```coil
EACH $task FROM $plan.files
  ...
END
```

| Modifier | Accepts | Required |
|---|---|---|
| `FROM` | Reference `$name` (LIST type) | **Yes** |

Each iteration creates a **nested scope**. Variables inside are invisible outside and don't leak between iterations.

### SIGNAL (Extended)

Sends data to an existing stream. Does not create a new stream.

```coil
SIGNAL ~decision
<<
Client reported new contract number: $contract_id
>>
END
```

`SIGNAL` after stream closure is an error.

---

## Expression Grammar

Used in `IF` and `REPEAT UNTIL`. Evaluated deterministically.

### Operands

| Kind | Example |
|---|---|
| Value reference | `$name` |
| Field access | `$name.a.b.c` |
| String literal | `"technical"` |
| Numeric literal | `42`, `3.14` |
| Boolean literal | `TRUE`, `FALSE` |

### Comparison Operators

| Operator | Description | Types |
|---|---|---|
| `=` | Equality (structural) | Any |
| `<` | Less than | Numbers |
| `>` | Greater than | Numbers |
| `<=` | Less than or equal | Numbers |
| `>=` | Greater than or equal | Numbers |

`==` and `!=` **do not exist** in COIL. Inequality: `NOT ($x = value)`.

Chained comparisons (`1 < $x < 10`) are forbidden.

### Logical Connectives

| Connective | Description |
|---|---|
| `AND` | Logical and |
| `OR` | Logical or |
| `NOT` | Negation |

**Precedence** (highest to lowest): `NOT` → comparisons → `AND`, `OR` (same level).

**Mixing `AND` and `OR` without parentheses is an error.** Grouping is mandatory:

```coil
' Error:
IF $a > 1 AND $b > 1 OR $override = TRUE

' Correct:
IF ($a > 1 AND $b > 1) OR $override = TRUE
```

---

## Structured Output

`RESULT` is a declaration of what the LLM must **determine**, not an output format.

### Micro-syntax

```
* field_name: TYPE - description (semantic hint to LLM)
```

The description after `-` is not a comment — it is part of the task for the model.

### Types

| Type | Purpose | Example |
|---|---|---|
| `TEXT` | String | `* summary: TEXT - brief conclusion` |
| `NUMBER` | Number | `* score: NUMBER - rating from 1 to 10` |
| `FLAG` | Boolean | `* approved: FLAG - whether approved` |
| `CHOICE(...)` | One of listed | `* type: CHOICE(bug, feature, question) - type` |
| `LIST` | Array with child structure | `* items: LIST - elements` |
| `OBJECT` | Record with fields | `* metadata: OBJECT - information` |

Synonyms (`STRING`, `BOOL`, `ENUM`, `ARRAY`) are forbidden.

### Nesting

`LIST` and `OBJECT` have child structure via indentation:

```coil
RESULT
* metadata: OBJECT - document information
  * author: TEXT - author
  * stats: OBJECT - statistics
    * word_count: NUMBER - word count
    * language: TEXT - document language
* artifacts: LIST - artifacts
  * path: TEXT - artifact path
  * details: OBJECT - change details
    * action: CHOICE(create, modify, delete) - type
    * reason: TEXT - reason
```

---

## Execution Model

### Order

Steps execute sequentially. Launching operators (`THINK`, `EXECUTE`, `SEND`) initiate async work and **the protocol continues** without waiting for completion. For synchronization — `WAIT`.

### Promises and Values

A launching operator creates `?name`. After `WAIT ON ?name` the value is available as `$name`:

```coil
THINK plan
  ...
END
' Here ?plan exists, $plan does not yet

WAIT
  ON ?plan
END
' Now $plan is available, including $plan.summary
```

### Templates

A template is text with substitutions, not a second programming language.

```coil
GOAL <<
Determine which artifacts require changes.
>>
```

Inside templates:
- substitutions `$request`, `$artifact.path`
- arbitrary text, markdown, XML-like markup

Templates are used in: `GOAL`, `INPUT`, `CONTEXT` (modifiers of `THINK`), anonymous body of `SEND`, `DEFINE`, `SIGNAL`.

Referential modifiers are NOT templates. `FOR << tech_analyst >>` is invalid.

### Streams

Launching operators (`THINK`, `EXECUTE`, `SEND`) can create stream `~name` in addition to promise `?name`.

- Stream — a live bidirectional session
- `SIGNAL ~name` — send data into the stream
- Stream closes when `?name` resolves
- Ordering — FIFO in each direction
- `SIGNAL` after stream closure is an error

Experimental form `WAIT ... FROM ~name` for waiting on stream events exists but is **not stabilized** — do not use in production scripts.

Typical scenario:
```coil
THINK decision
  ...
END

SEND tech
  FOR @tech_dept
  AWAIT ANY
  <<
  Need the cause of the failure.
  >>
END

WAIT
  ON ?tech
END

' Inject data into the still-running reasoning
SIGNAL ~decision
<<
Data from tech department: $tech
>>
END

WAIT
  ON ?decision
END
```

### Errors

| Class | When | Examples |
|---|---|---|
| Preparation | Before launch | Undeclared actor/tool, duplicate `DEFINE`, `==` instead of `=` |
| Execution | During run | Timeout, tool failure, invalid result after repair |
| Environment | External | Budget exhaustion, cancellation |

---

## Patterns

Core COIL compositional techniques. Full code examples are in [examples/](examples/).

### 1. Parallel Processing

Multiple `THINK` statements launch in sequence, then `WAIT` awaits all:

```coil
THINK security_review
  ...
END

THINK performance_review
  ...
END

WAIT
  ON ?security_review, ?performance_review
  MODE ALL
END

' Aggregation
THINK summary
  CONTEXT <<
  Security: $security_review
  Performance: $performance_review
  >>
  ...
END
```

### 2. Routing

Classify → branch → handle:

```coil
THINK classification
  RESULT
  * type: CHOICE(general, refund, technical) - request type
END

WAIT
  ON ?classification
END

IF $classification.type = "refund"
  DEFINE current_role
  $refund_role
  END
END

IF $classification.type = "technical"
  DEFINE current_role
  $technical_role
  END
END
```

### 3. Evaluator-Optimizer (Iterative Improvement)

```coil
DEFINE done
FALSE
END

REPEAT UNTIL $done = TRUE NO MORE THAN 3

  THINK evaluation
    ...
    RESULT
    * quality_score: NUMBER - rating from 1 to 10
  END

  WAIT
    ON ?evaluation
  END

  IF $evaluation.quality_score >= 8
    SET $done
    TRUE
    END
  END

  IF $done = FALSE
    THINK improved
      CONTEXT <<
      Feedback: $evaluation
      >>
      ...
    END

    WAIT
      ON ?improved
    END

    SET $current
    $improved.text
    END
  END

END
```

### 4. Stream Feedback

Launch THINK → gather data in parallel → inject via SIGNAL:

```coil
THINK analysis
  ...
END

EXECUTE refs
  USING !search
  - query: $topic
END

WAIT
  ON ?refs
END

SIGNAL ~analysis
<<
Additional data: $refs
>>
END

WAIT
  ON ?analysis
END
```

### 5. Internal Delegation

One LLM, different roles via `AS`:

```coil
THINK plan
  AS $architect_role
  ...
END

WAIT
  ON ?plan
END

EACH $task FROM $plan.files
  IF $task.change_type = "create"
    DEFINE current_role
    $worker_create_role
    END
  END

  THINK implementation
    AS $current_role
    ...
  END

  WAIT
    ON ?implementation
  END
END
```

### 6. Multi-Agent Orchestration

Communication between agents via `SEND`:

```coil
ACTORS researcher, writer

SEND research_results
  FOR @researcher
  AWAIT ANY
  <<
  Find key facts on the topic: $topic
  >>
END

WAIT
  ON ?research_results
END

SEND draft
  FOR @writer
  AWAIT ANY
  <<
  Write an article based on: $research_results
  >>
END
```

---

# Repository contents

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

### Dialect Tables

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

## Tests

Conformance tests in `tests/` — `.coil` files (en-standard dialect) that define what a spec-compliant implementation must accept or reject. Test structure, standard weight, and rules for adding — see [tests/README.md](tests/README.md).

## Status

Spec v0.4 — working draft with explicit status markers. Each area of the language has one of three normative statuses:

- **Stable** — part of the current norm. Docs and examples can teach this. Downstream work can rely on it.
- **Experimental** — the idea is accepted, but syntax or semantics may still change. Parser presence alone does not make it normative.
- **Deferred** — recognized as important, but consciously not normalized in this cycle. Mentioned only as future work.

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

---

Animata Systems, 2026
