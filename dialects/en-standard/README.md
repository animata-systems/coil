# COIL:en-standard — Standard English Dialect

> "Write scripts in the language you think in."

**Status:** official dialect, part of the standard distribution.

This dialect provides a direct, idiomatic English mapping for all COIL constructs. Each keyword is chosen for clarity and semantic precision: it should mean exactly what the operator does, with no ambiguity for a native English speaker.

The standard English dialect is the primary entry point for non-Russian-speaking users. It prioritizes readability and discoverability over brevity.

---

## Design Principles

1. **Semantic fidelity.** The English keyword must reflect the operator's actual behavior, not its Russian etymology. `НАПИШИ` literally means "write," but the operator sends a message — so the English keyword is `SEND`, not `WRITE`.

2. **One word where possible.** Modifiers and operators use single uppercase words when a single word is unambiguous. Multi-word forms are allowed only where a single word would be misleading (`REPLY TO`, `NO MORE THAN`).

3. **No synonyms.** Each concept has exactly one keyword. `RECEIVE` is the only way to express `ПОЛУЧИ`; `GET`, `FETCH`, `OBTAIN` are not accepted.

4. **Consistency with the execution model.** The keyword's connotation should hint at the operator's category: blocking (`RECEIVE`, `WAIT`), launching (`THINK`, `EXECUTE`, `SEND`), instant (`DEFINE`, `SET`).

---

## Core Operators

| ID | EN | Semantics |
|---|---|---|
| `Op.Actors` | `ACTORS` | Declare participants by name. "Actors" — the cast of the protocol. |
| `Op.Tools` | `TOOLS` | Declare available tools. Direct and unambiguous. |
| `Op.Define` | `DEFINE` | Create a new named value. Mirrors the mathematical sense: define a term. |
| `Op.Set` | `SET` | Modify an existing value. The standard verb for assignment in every language. |
| `Op.Receive` | `RECEIVE` | Blocking bind from environment. Not `GET` — the protocol *waits* to receive, it doesn't actively fetch. |
| `Op.Think` | `THINK` | Launch an LLM cognitive step. The model is given a problem and thinks through it. |
| `Op.Execute` | `EXECUTE` | Run a tool. Covers both one-shot calls and interactive sessions. |
| `Op.Send` | `SEND` | Send a message to a channel. Not `WRITE` — the operator delivers a message, not produces text. |
| `Op.Wait` | `WAIT` | Synchronization point. Block until promises resolve. |
| `Op.Exit` | `EXIT` | Terminate the protocol. One line, no arguments. |
| `Kw.End` | `END` | Close a block. Every block operator opens with a keyword and closes with `END`. |

---

## Modifiers

### Rigging (THINK)

| ID | EN | Semantics |
|---|---|---|
| `Mod.Via` | `VIA` | Which LLM model to use. `VIA $fast_model` — route the task via this model. |
| `Mod.As` | `AS` | Solver qualification (skills). `AS $analyst` — think as this expert. References only. |
| `Mod.Using` | `USING` | Available tools for LLM. `USING !search, !calc` — the model may call these. |

### Formulation (THINK)

| ID | EN | Semantics |
|---|---|---|
| `Mod.Goal` | `GOAL` | Purpose of the cognitive task. What we want to achieve. |
| `Mod.Input` | `INPUT` | Problem statement. The conditions of the task. |
| `Mod.Context` | `CONTEXT` | Additional data, background, constraints. |
| `Mod.Result` | `RESULT` | Structured output specification. What the LLM must determine. |

### Addressing (SEND)

| ID | EN | Semantics |
|---|---|---|
| `Mod.To` | `TO` | Channel address. `TO #support` — deliver to this channel. |
| `Mod.For` | `FOR` | Recipient. `FOR @expert` — this message is for this participant. |
| `Mod.ReplyTo` | `REPLY TO` | Reply reference. Which message this responds to. |
| `Mod.Await` | `AWAIT` | Reply wait policy. `AWAIT ANY` — wait for at least one reply. |
| `Mod.Timeout` | `TIMEOUT` | Timeout. `TIMEOUT 10m` — give up after 10 minutes. |

### Synchronization (WAIT)

| ID | EN | Semantics |
|---|---|---|
| `Mod.On` | `ON` | Awaited promises. `ON ?plan, ?data` — these are the promises we wait for. |
| `Mod.Mode` | `MODE` | Wait mode. How many promises must resolve. |
| `Pol.All` | `ALL` | Wait for all listed promises. |
| `Pol.Any` | `ANY` | Wait for any one of the listed promises. |
| `Pol.None` | `NONE` | Do not wait for a reply. Fire and forget. |
| `Mod.Timeout` | `TIMEOUT` | Timeout. Same keyword as in SEND — consistent. |

### Tool call (EXECUTE)

| ID | EN | Semantics |
|---|---|---|
| `Mod.Using` | `USING` | Which tool to invoke. `USING !search` — mandatory, exactly one. |

---

## Extended Operators

| ID | EN | Semantics |
|---|---|---|
| `Op.If` | `IF` | Conditional branching. Deterministic, no LLM involved. |
| `Op.Repeat` | `REPEAT` | Loop with mandatory upper bound. `REPEAT 5` or `REPEAT UNTIL $done NO MORE THAN 5`. |
| `Op.Each` | `EACH` | Iterate over list elements. `EACH $task FROM $plan.files`. Deterministic iteration — no LLM for control flow. |
| `Op.Gather` | `GATHER` | Aggregate results into a single value. |
| `Op.Signal` | `SIGNAL` | Send data into an existing stream. |

### Extended Modifiers

| ID | EN | Semantics |
|---|---|---|
| `Mod.Until` | `UNTIL` | Loop exit condition. `REPEAT UNTIL $ready NO MORE THAN 5`. |
| `Mod.Limit` | `NO MORE THAN` | Iteration cap (in REPEAT). Required — loops without a cap are invalid. |
| `Mod.From` | `FROM` | List source for iteration. `EACH $item FROM $list`. |

---

## RESULT Types

| ID | EN | Semantics |
|---|---|---|
| `Typ.Text` | `TEXT` | String value. |
| `Typ.Number` | `NUMBER` | Numeric value. |
| `Typ.Flag` | `FLAG` | Boolean value. |
| `Typ.Choice` | `CHOICE(...)` | Enum — one of the listed values. |
| `Typ.List` | `LIST` | Array of structured items. |

---

## Reference Sigils

Sigils are part of the lexical core and do not change across dialects.

| Sigil | Meaning |
|---|---|
| `$` | Value |
| `?` | Promise |
| `@` | Participant |
| `!` | Tool |
| `#` | Channel |
| `~` | Stream |

---

## Example: Research Agent

```coil
' ──────────────────────────────────────────────
' Environment
' ──────────────────────────────────────────────
ACTORS expert, author
TOOLS search

' ──────────────────────────────────────────────
' Skills — solver qualifications.
' Define the knowledge and approach
' the LLM must possess when solving a task.
' ──────────────────────────────────────────────
DEFINE research_skill
<<
You are a research analyst.
You work with unstructured queries.
You always look for primary sources and indicate
your confidence level in conclusions. You avoid speculation.
If the data is insufficient — you say so directly.
>>
END

DEFINE domain_expertise
<<
You are well-versed in product analytics.
You know retention, activation, and churn metrics.
You can read funnels and cohort reports.
When analyzing, you always distinguish between
correlation and causation.
>>
END

' ──────────────────────────────────────────────
' Input data — the environment must provide
' values before the protocol continues.
' ──────────────────────────────────────────────
RECEIVE query
<<
User query for research.
>>
END

RECEIVE request_history
<<
History of previous requests on this topic.
>>
END

RECEIVE case_id
<<
Current case identifier.
>>
END

' ──────────────────────────────────────────────
' 1. Problem statement — like in mathematics:
'    AS      — solver qualification
'    GOAL    — objective
'    INPUT   — problem conditions
'    CONTEXT — given data
'    RESULT  — what to find
'
' THINK runs in the background. Creates a result
' promise ?analysis and a live stream ~analysis.
' Conditions can be augmented during solving
' via SIGNAL.
' ──────────────────────────────────────────────
THINK analysis
  AS $research_skill, $domain_expertise
  GOAL <<
  Prepare a well-grounded answer with sources.
  >>
  INPUT <<
  Research the user's query. Account for all data
  that arrives during the process via stream.
  >>
  CONTEXT <<
  Query: $query
  Request history: $request_history
  >>
  RESULT
  * answer: TEXT - final answer
  * sources: LIST - materials used
    * ref: TEXT - reference link
    * why: TEXT - why it is relevant
  * confidence: CHOICE(high, medium, low)
END

' ──────────────────────────────────────────────
' 2. Data collection — parallel to reasoning.
'    Search and expert request block
'    neither each other nor THINK.
' ──────────────────────────────────────────────
EXECUTE found
  USING !search
  - query: $query
  - limit: 10
END

SEND opinion
  TO #consultations
  FOR @expert
  AWAIT ANY
  TIMEOUT 10m
  <<
  Need expertise on query: $query
  >>
END

' ──────────────────────────────────────────────
' 3. Augmenting conditions during solving.
'    Data arrives in arbitrary order —
'    each result immediately goes to ~analysis.
'    The LLM accounts for them without restarting.
' ──────────────────────────────────────────────
REPEAT 2
  WAIT data
    ON ?found, ?opinion
    MODE ANY
  END

  SIGNAL ~analysis
    <<
    $data
    >>
  END
END

' ──────────────────────────────────────────────
' 4. Solution is ready.
'    Analysis accounted for the initial data,
'    search results, and expert opinion.
' ──────────────────────────────────────────────
WAIT
  ON ?analysis
END

' ──────────────────────────────────────────────
' 5. Reply to the request author.
' ──────────────────────────────────────────────
SEND
  TO #results/$case_id
  FOR @author
  <<
  $analysis.answer
  >>
END

EXIT
```

---

## Minimal Example

```coil
' Classify a customer request.

RECEIVE query
<<
Customer request text.
>>
END

THINK verdict
  GOAL <<
  Classify the customer request.
  >>
  RESULT
  * category: CHOICE(bug, feature, question) - request type
END

WAIT
  ON ?verdict
END

SEND
  TO #support
  <<
  Category: $verdict.category
  >>
END

EXIT
```

---

## Notes

**Why SEND and not WRITE?**
`НАПИШИ` literally means "write" in Russian, but the operator's semantics is message delivery, not text production. `SEND` describes the observable behavior: a message is sent to a channel, optionally with a wait policy. This is a case where semantic fidelity to the operator's behavior takes precedence over literal translation.

**Why RECEIVE and not GET?**
`ПОЛУЧИ` is a blocking bind: the protocol pauses until the environment provides a value. `RECEIVE` carries the right connotation — you are waiting to receive something, not actively going out to get it. `GET` implies agency that the protocol does not have at this step.

**Why FOR and not TO for recipient?**
The channel address already uses `TO`. Using `TO` for both channel and recipient would create ambiguity. `FOR @expert` reads naturally: "this message is for the expert." The distinction between `TO` (destination) and `FOR` (recipient) mirrors the difference between `КУДА` (where) and `КОМУ` (to whom) in the Russian dialect.

**Why TIMEOUT and not NO MORE THAN?**
In the `SEND` and `WAIT` context, `TIMEOUT 10m` is idiomatic and immediately clear. `NO MORE THAN` is reserved for the `REPEAT` operator where it sets an iteration cap — a different semantic domain.

---

## FAQ

**Q: Is this the "real" COIL?**
A: COIL has no default dialect. Every dialect — Russian, English, or community-created — maps keyword phrases to the same abstract operators and produces identical runtime behavior. A COIL implementation that claims spec compliance must load dialects from external dialect tables; it is not required to bundle any specific dialect. Standard English and Russian are both part of the official distribution.

**Q: Can I mix languages in one script?**
A: No. A script is written in exactly one dialect. Sigils (`$`, `?`, `@`, `!`, `#`, `~`) are universal, but keywords must be consistent within a single file.

**Q: What about identifiers — must they be in English too?**
A: Identifiers (variable names, participant names, tool names) are free-form. You can write `DEFINE моя_переменная` in the English dialect. The dialect governs keywords, not identifiers.

**Q: Other dialects?**
A: COIL supports community dialects for any language or theme. See also: [English profanity dialect](../en-profanity/README.md), [Russian мат-dialect](../ru-mat/README.md), [Matrix theme dialect](../ru-matrix/README.md).
