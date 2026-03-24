# COIL:en-profanity — the unofficial English dialect

> "If you can write scripts in the language you think in — well, some of us think like this."

**Status:** community dialect, not part of the official distribution.

This dialect follows the principle of semantic resonance: each keyword isn't just a random swear word, it's chosen so its colloquial meaning reflects the operator's actual purpose.

---

## Core Operators

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `ACTORS` | `FUCKERS` | Declaring participants = introducing the team. "Here are our fuckers." Every PM's inner monologue at standup. |
| `TOOLS` | `SHIT` | Declaring tools = listing the shit we work with. The universal word for any set of gadgets. |
| `DEFINE` | `BULLSHIT` | Create a new value = bullshit it into existence. You're literally fabricating a persona from thin air. An act of pure invention. |
| `SET` | `UNFUCK` | Modify an existing value = unfuck it. Was wrong, now right. The most precise verb in the English language for corrective action. |
| `GET` | `SNATCH` | Obtain a value from the environment = snatch it. The data won't come willingly. You have to grab it. |
| `THINK` | `BRAINFUCK` | LLM cognitive work = brainfucking the problem. The model is literally wrestling with a task, burning tokens, struggling toward an answer. |
| `EXECUTE` | `SMASH` | Run a tool = smash that button. Don't think. Just do. |
| `WRITE` | `DUMP` | Send a message = dump it into the channel. Like taking a dump — you produce output and move on. |
| `WAIT` | `EDGE` | Synchronization point = edging. You're right there at the brink of resolution, holding back, waiting for promises to finish. Technically precise. |
| `EXIT` | `GTFO` | Terminate protocol = get the fuck out. Job's done. Leave. |
| `END` | `STFU` | Close a block. The block is done talking. Shut the fuck up. |

---

## Modifiers

### Rigging (BRAINFUCK)

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `VIA` | `RIDING` | Which LLM model to use. "RIDING $gpt4" — riding the model. You're mounting it and going for a ride. |
| `AS` | `LARPING` | Solver qualification = LARPing as analyst. The LLM is literally pretending to be an expert. The most honest description of prompt engineering. |
| `USING` | `PACKING` | Available tools = packing heat. "PACKING !search" — armed and ready. |

### Task formulation (BRAINFUCK)

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `GOAL` | `WTF` | Purpose of the task. "WTF: prepare a sourced report." The eternal first question of any project, finally asked directly. |
| `INPUT` | `THE DEAL` | Input data = here's the deal. "THE DEAL: research the user query." Cuts right to it. |
| `CONTEXT` | `OH AND` | Additional context = "oh and also consider this." How every stakeholder adds scope mid-sentence. |
| `RESULT` | `COUGH UP` | Structured output = what the LLM must cough up. Not optional. The model owes you this. |

### Addressing (DUMP)

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `WHERE` | `WHERE TF` | Channel address. "WHERE TF #support" — where the fuck does this go. |
| `TO` | `HEY DIPSHIT` | Recipient. "HEY DIPSHIT @expert" — directed delivery with attitude. |
| `REPLY TO` | `RE THAT CRAP` | Reply reference. Which crap are we responding to. |
| `WAIT FOR` | `LOITER` | Reply wait policy. You dumped your message, now you loiter around like a creep waiting for a response. |
| `NO MORE THAN` | `OR BUST` | Timeout. "10min OR BUST" — either it happens or everything falls apart. The honest version of SLA. |

### Synchronization (EDGE)

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `ON` | `BLUE BALLS` | Awaited promises = blue balls. You're edging, waiting for promises to resolve, and these are the blue balls you're nursing. Physiologically consistent. |
| `MODE` | `HOW BAD` | Wait mode = how badly do you need all of them. |
| `ALL` | `EVERY LAST ONE` | Wait for all promises. No one gets out of this. |
| `ANY` | `WHATEVER` | Wait for any promise. First one to finish wins. We don't care which. |

---

## Extended Operators

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `IF` | `SHIT WHAT IF` | Conditional branching. "SHIT WHAT IF $score > 80" — the moment of sudden realization. |
| `REPEAT` | `GRIND` | Loop = grind through iterations. "GRIND 5" — like grinding XP. The universal gamer metaphor for repetitive work that you must survive. |
| `EACH` | `NAIL` | Iterate over a list = nail each one. Go through every item and hit it. "NAIL $task OUTTA $list" — process each fucker in the list. |
| `GATHER` | `SCRAPE` | Aggregate results = scrape together whatever you've got. |
| `SIGNAL` | `SHOVE` | Send data to stream = shove data in. The signal enters the stream cooperatively, but firmly. |

---

## COUGH UP types

| COIL | PROFANITY | Why it works |
|------|-----------|--------------|
| `TEXT` | `BLAH` | String value. Any text is just blah. |
| `NUMBER` | `DIGITS` | Numeric value. Give me the digits. |
| `FLAG` | `BALLS` | Boolean. Got balls or not. True/false. Binary courage. |
| `CHOICE(...)` | `PICK YOUR POISON(...)` | Enum. "PICK YOUR POISON(bug, feature, question)" — limited options, all bad. |
| `LIST` | `SHITLOAD` | Array. A shitload of items. |

---

## Reference sigils

Sigils don't change — they're part of the lexical core, not the dialect. But how you read them out loud:

| Sigil | Meaning | Pronounced in dialect |
|-------|---------|---------------------|
| `$` | Value | "the goods" |
| `?` | Promise | "blue balls" |
| `@` | Participant | "that fucker" |
| `!` | Tool | "that piece of shit" |
| `#` | Channel | "the hole" |
| `~` | Stream | "the drip" |

---

## Example: research agent

```coil
' ──────────────────────────────────────────────
' Meet the fuckers. Here's our shit.
' ──────────────────────────────────────────────
FUCKERS expert, author
SHIT search

' ──────────────────────────────────────────────
' Skills — bullshit personas into existence
' ──────────────────────────────────────────────
BULLSHIT research_skill
<<
You are a research analyst.
You work with unstructured queries.
Always look for primary sources and state
your confidence level. Avoid speculation.
If data is insufficient — say so directly.
>>
STFU

BULLSHIT domain_expertise
<<
You understand product analytics.
You know retention, activation, churn.
You can read funnels and cohort reports.
Always separate correlation from causation.
>>
STFU

' ──────────────────────────────────────────────
' Input data — snatch from the environment
' ──────────────────────────────────────────────
SNATCH query
<<
User query for research.
>>
STFU

SNATCH case_history
<<
Previous interaction history on this topic.
>>
STFU

SNATCH case_id
<<
Current case identifier.
>>
STFU

' ──────────────────────────────────────────────
' 1. Brainfuck the analysis
' ──────────────────────────────────────────────
BRAINFUCK analysis
  LARPING $research_skill, $domain_expertise
  WTF <<
  Prepare a well-sourced, substantiated answer.
  >>
  THE DEAL <<
  Research the user query. Incorporate any data
  that arrives via the stream during processing.
  >>
  OH AND <<
  Query: $query
  Case history: $case_history
  >>
  COUGH UP
  * answer: BLAH - final answer
  * sources: SHITLOAD - materials used
    * ref: BLAH - reference link
    * why: BLAH - why it's relevant
  * confidence: PICK YOUR POISON(high, medium, low)
STFU

' ──────────────────────────────────────────────
' 2. Smash search, dump to the expert — in parallel
' ──────────────────────────────────────────────
SMASH found
  PACKING !search
  - query: $query
  - limit: 10
STFU

DUMP opinion
  WHERE TF #consultations
  HEY DIPSHIT @expert
  LOITER WHATEVER
  OR BUST 10min
  <<
  Need your take on this: $query
  >>
STFU

' ──────────────────────────────────────────────
' 3. Shove data into the drip as it arrives
' ──────────────────────────────────────────────
GRIND 2
  EDGE data
    BLUE BALLS ?found, ?opinion
    HOW BAD WHATEVER
  STFU

  SHOVE ~analysis
    <<
    $data
    >>
  STFU
STFU

' ──────────────────────────────────────────────
' 4. Edge on the final result
' ──────────────────────────────────────────────
EDGE
  BLUE BALLS ?analysis
STFU

' ──────────────────────────────────────────────
' 5. Dump the answer to the author
' ──────────────────────────────────────────────
DUMP
  WHERE TF #results/$case_id
  HEY DIPSHIT @author
  <<
  $analysis.answer
  >>
STFU

GTFO
```

---

## Minimal example

```coil
' Classify a request. Keep it simple.

SNATCH query
<<
Customer request.
>>
STFU

BRAINFUCK verdict
  WTF <<
  Classify the customer request.
  >>
  COUGH UP
  * category: PICK YOUR POISON(bug, feature, question) - request type
STFU

EDGE
  BLUE BALLS ?verdict
STFU

DUMP
  WHERE TF #support
  <<
  Category: $verdict.category
  >>
STFU

GTFO
```

---

## FAQ

**Q: Is this a joke?**
A: No. It's a proof of concept for COIL's dialect system. The fact that this script is fully valid and perfectly readable proves that keywords are the skin, not the skeleton of the language.

**Q: Can I use this in production?**
A: Technically — yes. The runtime operates on construct semantics, not spelling. Morally — your call, your HR department.

**Q: Why does this work?**
A: COIL was designed so you can write scripts in the language you think in. Some people think in Korean, some in German. And some people, when a deploy breaks at 3 AM on a Saturday, think in a very specific English dialect. This is that dialect.

**Q: Other dialects?**
A: The same principle works for any language. There's also a [Russian мат-dialect](../ru-mat/README.md) that proves the concept just as effectively.
