> **Type**: illustrative narrative example · COIL-C parser-checked
> **Status**: mixed — contains experimental syntax (SIGNAL, stream references `~name`)
> **COIL-H**: illustrative — does not establish mapping norm

# Research Agent

## COIL-H

<table>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      Environment<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>1</td>
    <td><b><code>ACTORS</code></b></td>
    <td><code>expert</code>, <code>author</code></td>
    <td></td>
  </tr>
  <tr>
    <td>2</td>
    <td><b><code>TOOLS</code></b></td>
    <td><code>search</code></td>
    <td></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      Skills — solver qualifications<br>
      Define the knowledge and approach the LLM must possess when solving a task.<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>3</td>
    <td><b><code>DEFINE</code></b></td>
    <td>
      <em>You are a research analyst.
      You work with unstructured queries.
      You always look for primary sources and indicate
      your confidence level in conclusions. You avoid speculation.
      If the data is insufficient — you say so directly.</em>
    </td>
    <td><code>research_skill</code></td>
  </tr>
  <tr>
    <td>4</td>
    <td><b><code>DEFINE</code></b></td>
    <td>
      <em>You are well-versed in product analytics.
      You know retention, activation, and churn metrics.
      You can read funnels and cohort reports.
      When analyzing, you always distinguish between
      correlation and causation.</em>
    </td>
    <td><code>domain_expertise</code></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      Input data<br>
      The environment must provide values before the protocol continues.<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>5</td>
    <td><b><code>RECEIVE</code></b></td>
    <td><em>User query for research.</em></td>
    <td><code>query</code></td>
  </tr>
  <tr>
    <td>6</td>
    <td><b><code>RECEIVE</code></b></td>
    <td><em>History of previous requests on this topic.</em></td>
    <td><code>request_history</code></td>
  </tr>
  <tr>
    <td>7</td>
    <td><b><code>RECEIVE</code></b></td>
    <td><em>Current case identifier.</em></td>
    <td><code>case</code></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      1. Problem statement<br>
      THINK runs in the background. Creates a result promise ?analysis and a live stream ~analysis. Problem conditions can be augmented during solving via SIGNAL.<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>8</td>
    <td><b><code>THINK</code></b></td>
    <td>
      <b><code>AS</code></b> <code>$research_skill</code>, <code>$domain_expertise</code>
      <br>
      <b><code>GOAL</code></b>
      <pre>Prepare a well-grounded answer with sources.</pre>
      <b><code>INPUT</code></b>
      <pre>Research the user's query. Account for all data
that arrives during the process via stream.</pre>
      <b><code>CONTEXT</code></b>
      <pre>Query: $query
Request history: $request_history</pre>
      <b><code>RESULT</code></b>
<pre>* answer: TEXT - final answer
* sources: LIST - materials used
  * ref: TEXT - reference
  * why: TEXT - why it is relevant
* confidence: CHOICE(high, medium, low)</pre>
    </td>
    <td><code>analysis</code></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      2. Data collection<br>
      Parallel to reasoning. Search and expert request block neither each other nor THINK.<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>9</td>
    <td><b><code>EXECUTE</code></b></td>
    <td>
      <b><code>USING</code></b> <code>!search</code>
<pre>- query: $query
- limit: 10</pre>
    </td>
    <td><code>found</code></td>
  </tr>
  <tr>
    <td>10</td>
    <td><b><code>SEND</code></b></td>
    <td>
      <b><code>TO</code></b> <code>#consultations</code>
      <br>
      <b><code>FOR</code></b> <code>@expert</code>
      <br>
      <b><code>AWAIT</code></b> ANY
      <br>
      <b><code>TIMEOUT</code></b> 10m
      <pre>Need expertise on query: $query</pre>
    </td>
    <td><code>opinion</code></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      3. Augmenting conditions during solving<br>
      Data arrives in arbitrary order — each result immediately goes to ~analysis. The LLM accounts for them without restarting.<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>11</td>
    <td><b><code>REPEAT</code></b></td>
    <td>2</td>
    <td></td>
  </tr>
  <tr>
    <td>11.1</td>
    <td><b><code>WAIT</code></b></td>
    <td>
      <b><code>ON</code></b> <code>?found</code>, <code>?opinion</code>
      <br>
      <b><code>MODE</code></b> ANY
    </td>
    <td><code>data</code></td>
  </tr>
  <tr>
    <td>11.2</td>
    <td><b><code>SIGNAL</code></b></td>
    <td>
      <code>~analysis</code>
      <pre>$data</pre>
    </td>
    <td></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      4. Solution is ready<br>
      Analysis accounted for the initial data, search results, and expert opinion.<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>12</td>
    <td><b><code>WAIT</code></b></td>
    <td>
      <b><code>ON</code></b> <code>?analysis</code>
    </td>
    <td></td>
  </tr>

  <tr>
    <td colspan="4">
  ────────────────────────────────────────────── <br>
      5. Reply to the request author<br>
  ──────────────────────────────────────────────
    </td>
  </tr>

  <tr>
    <td>13</td>
    <td><b><code>SEND</code></b></td>
    <td>
      <b><code>TO</code></b> <code>#results/$case</code>
      <br>
      <b><code>FOR</code></b> <code>@author</code>
      <pre>$analysis.answer</pre>
    </td>
    <td></td>
  </tr>

</table>

## COIL-C

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

RECEIVE case
<<
Current case identifier.
>>
END

' ──────────────────────────────────────────────
' 1. Problem statement.
'    THINK runs in the background. Creates a result
'    promise ?analysis and a live stream ~analysis.
'    Problem conditions can be augmented during
'    solving via SIGNAL.
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
    * ref: TEXT - reference
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
  TO #results/$case
  FOR @author
  <<
  $analysis.answer
  >>
END

EXIT
```
