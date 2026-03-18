*[Читать на русском](README.ru.md)*

# COIL — Cognitive Orchestration Interface Language

**A scripting language for cognitive orchestration.**

## Why

A next-generation operating system is being developed where an LLM serves as the processor. Every agent in such an OS needs a behavioral script — not a prompt ("who you are"), but a protocol: what to do, when to wait, whom to ask, where to send.

COIL is a language for describing such protocols. It is read and written by both humans and LLMs simultaneously. A human sees a clear script in their own language. An LLM sees an unambiguous structure it can execute, generate, and improve.

## Manifesto

1. **COIL puts the user at the center.** The language must remain readable and accessible to non-programmers. Keywords are written in the user's natural language.

2. **COIL orchestrates, it does not program.** The language describes workflows, not general-purpose computational algorithms.

3. **COIL makes logic explicit.** Branching, waiting, addressing, invocations, and termination must be visible in the script text.

4. **COIL separates the hard and the soft.** The control scaffold executes deterministically. The LLM is invoked only where cognitive work is truly needed.

5. **COIL is born for an agent OS.** It speaks in terms of participants, channels, messages, tools, streams, and events.

## Hello World

The minimal script — send a message to a channel:

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

## Two representations of one language

COIL scripts are written by both humans and LLMs. They have different needs. Instead of a compromise, the language offers two projections with unified semantics:

**COIL-C** *(canonical)* — the textual machine form. Verbose, explicit, unambiguous. Optimized for LLM generation and machine parsing.

**COIL-H** *(human)* — a tabular projection resembling a numbered specification. Optimized for reading and editing by a human in COIL IDE.

COIL-H translates to COIL-C without loss of meaning. Semantics live in COIL-C.

The same Hello World — now with a cognitive step:

**COIL-C:**

```coil
' ═══════════════════════════════════════
' LLM composes a greeting, result — promise ?greeting
' ═══════════════════════════════════════
THINK greeting
  INPUT <<
  Come up with a short greeting message in the style of Hello, world!
  >>
  RESULT
  * text: TEXT
END

' ═══════════════════════════════════════
' Wait for the LLM to finish thinking
' ═══════════════════════════════════════
WAIT
  ON ?greeting
END

' ═══════════════════════════════════════
' Send the result to the channel
' ═══════════════════════════════════════
SEND
  TO #general
  <<
  $greeting.text
  >>
END

EXIT
```

**COIL-H:**

<table>
  <tr>
    <td colspan="4">
      ═══════════════════════════════════════<br>
      LLM composes a greeting, result — promise ?greeting<br>
      ═══════════════════════════════════════
    </td>
  </tr>
  <tr>
    <td>1</td>
    <td><b><code>THINK</code></b></td>
    <td>
      <b><code>INPUT</code></b>
      <pre>Come up with a short greeting message
in the style of Hello, world!</pre>
      <b><code>RESULT</code></b>
      <pre>* text: TEXT</pre>
    </td>
    <td><code>greeting</code></td>
  </tr>
  <tr>
    <td colspan="4">
      ═══════════════════════════════════════<br>
      Wait for the LLM to finish thinking<br>
      ═══════════════════════════════════════
    </td>
  </tr>
  <tr>
    <td>2</td>
    <td><b><code>WAIT</code></b></td>
    <td>
      <b><code>ON</code></b> <code>?greeting</code>
    </td>
    <td></td>
  </tr>
  <tr>
    <td colspan="4">
      ═══════════════════════════════════════<br>
      Send the result to the channel<br>
      ═══════════════════════════════════════
    </td>
  </tr>
  <tr>
    <td>3</td>
    <td><b><code>SEND</code></b></td>
    <td>
      <b><code>TO</code></b> <code>#general</code>
      <pre>$greeting.text</pre>
    </td>
    <td></td>
  </tr>
</table>

One script, two representations, one semantics.

## Multilingualism

The runtime operates on the semantics of constructs, not their spelling. Keywords are written in the language the operator thinks in. There should be no translation between thought and script text.

The same script in different languages is the same protocol:

```coil
ДУМАЙ анализ                          THINK analysis
  ЦЕЛЬ <<                               GOAL <<
  Классифицируй запрос.                 Classify the request.
  >>                                    >>
  РЕЗУЛЬТАТ                             RESULT
  * тип: ВЫБОР(баг, фича, вопрос)       * type: CHOICE(bug, feature, question)
КОНЕЦ                                 END
```

COIL IDE translates everything automatically — operators, modifiers, template content, comments.

## Examples

### Research agent

A full script: parallel search, expert query, enriching the task input mid-reasoning.

| Format | File |
|---|---|
| COIL-H + COIL-C (English) | [research-agent-coil.md](research-agent-coil.md) |
| COIL-H + COIL-C (Русский) | [research-agent-coil-ru.md](research-agent-coil-ru.md) |

## Key ideas

**Hard and soft.** The control scaffold (step ordering, waiting, addressing, timeouts) executes deterministically, without the LLM. Template content `<< >>` is passed to the LLM or participant as-is. The two modes do not mix.

**Typed references.** Six prefixes — six entity types. Each symbol unambiguously tells you what you are dealing with:

| Prefix | What it is               | Example |
|---|--------------------------|---|
| `$` | Value                    | `$request`, `$plan.output` |
| `?` | Promise of a result      | `?analysis` |
| `@` | Participant              | `@expert` |
| `!` | Tool                     | `!search` |
| `#` | Address (channel, message) | `#results/$case` |
| `~` | Bidirectional stream     | `~analysis` |

**Structured task for LLM.** The `THINK` operator is structured like a math problem: AS (solver qualification), GOAL (why), INPUT (conditions), CONTEXT (given), RESULT (find). The LLM acts as the solver.

**Promises and streams.** Launching operators (`THINK`, `EXECUTE`, `SEND`) create a result promise `?name` and a bidirectional stream `~name`. The script continues executing without waiting for a response. Waiting is explicit, via the `WAIT` operator.

---

Animata Systems, March 2026
