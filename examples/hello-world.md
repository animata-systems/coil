> **Type**: illustrative narrative example · COIL-C parser-checked
> **Status**: stable

# COIL-H: Hello World

## COIL-C

```coil
THINK greeting
  INPUT <<
  Come up with a short welcome message.
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

## COIL-H

<table>
  <tr>
    <td>1</td>
    <td><b><code>THINK</code></b></td>
    <td>
      <b><code>INPUT</code></b>
      <pre>Come up with a short welcome message.</pre>
      <b><code>RESULT</code></b>
      <pre>* text: TEXT</pre>
    </td>
    <td><code>greeting</code></td>
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
    <td>3</td>
    <td><b><code>SEND</code></b></td>
    <td>
      <b><code>TO</code></b> <code>#general</code>
      <pre>$greeting.text</pre>
    </td>
    <td></td>
  </tr>
</table>
