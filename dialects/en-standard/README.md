<!-- @test valid -->
<!-- @role demo -->
<!-- @status mixed -->
<!-- @dialect en-standard -->
<!-- @covers Op.Think, Op.Execute, Op.Send, Op.Wait, Op.Signal, Op.Receive, Mod.Timeout, Op.Each, Mod.From, Op.If, Op.Define, Op.Set -->
<!-- @description Research agent — full dialect showcase -->

# COIL:en-standard — Standard English Dialect

> "Write scripts in the language you think in."

**Status:** official dialect, part of the standard distribution.

This dialect provides a direct, idiomatic English mapping for all COIL constructs. Each keyword is chosen for clarity and semantic precision: it should mean exactly what the operator does, with no ambiguity for a native English speaker.

The standard English dialect prioritizes readability and discoverability over brevity.

---

## Design Principles

1. **Semantic fidelity.** Each keyword reflects the operator's actual behavior. The operator that delivers a message to a channel is `SEND`, not `WRITE` — because writing implies text production, while the operator's job is message delivery.

2. **One word where possible.** Modifiers and operators use single uppercase words when a single word is unambiguous. Multi-word forms are allowed only where a single word would be misleading (`REPLY TO`, `NO MORE THAN`).

3. **No synonyms.** Each concept has exactly one keyword. `RECEIVE` is the only way to express a blocking bind; `GET`, `FETCH`, `OBTAIN` are not accepted.

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

### Model Setup (THINK)

| ID | EN | Semantics |
|---|---|---|
| `Mod.Via` | `VIA` | Which LLM model to use. `VIA $fast_model` — route the task via this model. |
| `Mod.As` | `AS` | Role definition (skills). `AS $analyst` — think as this expert. References only. |
| `Mod.Using` | `USING` | Available tools for LLM. `USING !search, !calc` — the model may call these. |

### Task Definition (THINK)

| ID | EN | Semantics |
|---|---|---|
| `Mod.Goal` | `GOAL` | Purpose of the cognitive task. What we want to achieve. |
| `Mod.Input` | `INPUT` | Problem statement. The data to work with. |
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
| `Typ.Object` | `OBJECT` | Record with named fields. |

---

## Example: Research Agent

```coil
' ═══════════════════════════════════════
' Environment
' ═══════════════════════════════════════
ACTORS expert, author
TOOLS search

' ═══════════════════════════════════════
' Roles — expert profiles for LLM.
' Define the knowledge and approach
' the LLM should adopt for a task.
' ═══════════════════════════════════════
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

' ═══════════════════════════════════════
' Input data — the environment must provide
' values before the protocol continues.
' ═══════════════════════════════════════
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

' ═══════════════════════════════════════
' 1. Task definition — structured like a math problem:
'    AS      — role / expert profile
'    GOAL    — objective
'    INPUT   — problem data
'    CONTEXT — background info
'    RESULT  — what to determine
'
' THINK runs in the background. Creates a result
' promise ?analysis and a live stream ~analysis.
' Input can be supplemented while thinking
' is in progress via SIGNAL.
' ═══════════════════════════════════════
THINK analysis
  AS $research_skill, $domain_expertise
  GOAL <<
  Prepare a well-grounded answer with sources.
  >>
  INPUT <<
  Research the user's query. Incorporate any data
  that arrives via the stream during analysis.
  >>
  CONTEXT <<
  Query: $query
  Request history: $request_history
  >>
  RESULT
  * answer: TEXT - final answer
  * sources: LIST - references cited
    * ref: TEXT - reference link
    * why: TEXT - why it is relevant
  * confidence: CHOICE(high, medium, low)
END

' ═══════════════════════════════════════
' 2. Data collection — parallel to reasoning.
'    Search and expert request block
'    neither each other nor THINK.
' ═══════════════════════════════════════
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

' ═══════════════════════════════════════
' 3. Supplementing input while thinking.
'    Data arrives in arbitrary order —
'    each result is fed into ~analysis immediately.
'    The LLM incorporates it without restarting.
' ═══════════════════════════════════════
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

' ═══════════════════════════════════════
' 4. Analysis is complete.
'    The result incorporates initial data,
'    search results, and expert feedback.
' ═══════════════════════════════════════
WAIT
  ON ?analysis
END

' ═══════════════════════════════════════
' 5. Deliver the answer.
' ═══════════════════════════════════════
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

## Example 2: Document Review

Demonstrates all stable v0.4 constructs: expression grammar (`IF` with `AND`, `OR`, `NOT`, `TRUE`, `FALSE`), `RECEIVE` with `TIMEOUT`, stream MVP (`SIGNAL`), `EACH` with nested scope.

```coil
' ═══════════════════════════════════════
' Showcase: document review
' Demonstrates expression grammar,
' stream MVP (SIGNAL), RECEIVE with timeout,
' EACH with nested scope.
' ═══════════════════════════════════════

ACTORS author

TOOLS search

' --- RECEIVE with TIMEOUT ---

RECEIVE document
TIMEOUT 3m
<<
Paste the document text for review.
>>
END

' --- THINK creates stream ~review ---

THINK review
  GOAL <<
  Review the document.
  >>
  INPUT <<
  $document
  >>
  RESULT
  * issues: LIST - issues found
    * title: TEXT - description
    * severity: NUMBER - severity from 1 to 10
    * fixable: FLAG - can be auto-fixed
  * score: NUMBER - overall score from 1 to 10
END

' --- EXECUTE + SIGNAL into active stream ---

EXECUTE refs
  USING !search
  - query: $document
END

WAIT
  ON ?refs
END

SIGNAL ~review
  <<
  Additional sources: $refs
  >>
END

WAIT
  ON ?review
END

' --- Expression grammar: comparisons, AND, NOT ---

DEFINE needs_attention
FALSE
END

IF $review.score < 5 AND NOT ($review.score = 1)
  SET $needs_attention
  TRUE
  END
END

' --- EACH with nested scope ---
' $issue, ?fix, $fix — invisible outside the loop

EACH $issue FROM $review.issues

  IF ($issue.severity >= 7 AND $issue.fixable = TRUE) OR $issue.severity >= 9
    THINK fix
      GOAL <<
      Suggest a fix.
      >>
      INPUT <<
      Issue: $issue.title
      >>
      RESULT
      * suggestion: TEXT - suggestion
    END

    WAIT
      ON ?fix
    END

    SEND
      FOR @author
      <<
      Issue: $issue.title
      Fix: $fix.suggestion
      >>
    END
  END

END

' --- Summary ---

IF $needs_attention = TRUE
  SEND
    FOR @author
    <<
    Document needs attention. Score: $review.score
    >>
  END
END

EXIT
```
