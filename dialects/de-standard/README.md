# COIL:de-standard — Standarddeutscher Dialekt

> „Schreib Szenarien in der Sprache, in der du denkst."

**Status:** offizieller Dialekt, Teil der Standarddistribution.

Dieser Dialekt bildet alle COIL-Konstrukte auf idiomatisches Deutsch ab. Jedes Schlüsselwort ist so gewählt, dass es für deutschsprachige Nutzer sofort verständlich ist — ohne Programmierkenntnisse, ohne Umweg über Englisch.

---

## Designprinzipien

1. **Befehlsform.** Operatoren sind Verben im Imperativ: DEFINIERE, EMPFANGE, DENKE. Das Protokoll spricht die Laufzeitumgebung als Ausführenden an: „Tu das."

2. **Alltagssprache.** Schlüsselwörter verwenden natürliches Deutsch, keinen Fachjargon. `SCHREIBE` statt `SENDE` — weil man im Deutschen „schreib mir" sagt, nicht „sende mir". `HÖCHSTENS` statt `TIMEOUT` — weil „höchstens 10 Minuten" natürliches Deutsch ist.

3. **Ein Wort, wo möglich.** Einwortformen haben Vorrang. Mehrwortformen nur dort, wo ein einzelnes Wort mehrdeutig wäre: `FÜHRE AUS`, `ANTWORT AUF`.

4. **Kategoriale Hinweise.** Die Konnotation des Wortes deutet auf die Kategorie des Operators hin: blockierend (`EMPFANGE`, `WARTE`), startend (`DENKE`, `FÜHRE AUS`, `SCHREIBE`), sofort (`DEFINIERE`, `SETZE`).

---

## Core-Operatoren

| ID | DE | Semantik |
|---|---|---|
| `Op.Actors` | `TEILNEHMER` | Teilnehmer des Protokolls deklarieren. Wer im Szenario handelt. |
| `Op.Tools` | `WERKZEUGE` | Verfügbare Werkzeuge deklarieren. Womit Agenten arbeiten. |
| `Op.Define` | `DEFINIERE` | Einen neuen benannten Wert erstellen. Wie in der Mathematik: einen Begriff definieren. |
| `Op.Set` | `SETZE` | Einen bestehenden Wert ändern. Das Standardverb für Zuweisung. |
| `Op.Receive` | `EMPFANGE` | Blockierende Bindung aus der Umgebung. Das Protokoll wartet, bis die Umgebung einen Wert liefert. |
| `Op.Think` | `DENKE` | Einen kognitiven LLM-Schritt starten. Das Modell erhält eine Aufgabe und denkt darüber nach. |
| `Op.Execute` | `FÜHRE AUS` | Ein Werkzeug aufrufen. Trennbares Verb — die natürliche deutsche Form für „ausführen". |
| `Op.Send` | `SCHREIBE` | Eine Nachricht in einen Kanal schreiben. Nicht `SENDE` — „schreib mir" ist die natürliche Messengersprache. |
| `Op.Wait` | `WARTE` | Synchronisationspunkt. Blockieren, bis Versprechen eingelöst werden. |
| `Op.Exit` | `SCHLUSS` | Das Protokoll beenden. Eine Zeile, keine Argumente. „Schluss" — wie „das war's". |
| `Kw.End` | `ENDE` | Einen Block schließen. Jeder Blockoperator wird mit `ENDE` geschlossen. |

---

## Modifikatoren

### Modellkonfiguration (DENKE)

| ID | DE | Semantik |
|---|---|---|
| `Mod.Via` | `ÜBER` | Welches LLM-Modell verwenden. `ÜBER $schnelles_modell` — die Aufgabe über dieses Modell leiten. |
| `Mod.As` | `ALS` | Rollendefinition (Skills). `ALS $analyst` — denke als dieser Experte. Nur Referenzen. |
| `Mod.Using` | `MIT` | Verfügbare Werkzeuge für das LLM. `MIT !suche, !rechner` — das Modell darf diese aufrufen. |

### Aufgabenstellung (DENKE)

| ID | DE | Semantik |
|---|---|---|
| `Mod.Goal` | `ZIEL` | Zweck des kognitiven Schritts. Was wir erreichen wollen. |
| `Mod.Input` | `EINGABE` | Aufgabenstellung. Die Daten, mit denen gearbeitet wird. |
| `Mod.Context` | `KONTEXT` | Zusätzliche Daten, Hintergrund, Einschränkungen. |
| `Mod.Result` | `ERGEBNIS` | Strukturierte Ausgabespezifikation. Was das LLM bestimmen soll. |

### Adressierung (SCHREIBE)

| ID | DE | Semantik |
|---|---|---|
| `Mod.To` | `AN` | Kanaladresse. `AN #support` — an diesen Kanal liefern. Wie im E-Mail-Feld „An:". |
| `Mod.For` | `FÜR` | Empfänger. `FÜR @experte` — diese Nachricht ist für diesen Teilnehmer. |
| `Mod.ReplyTo` | `ANTWORT AUF` | Antwortreferenz. Auf welche Nachricht geantwortet wird. |
| `Mod.Await` | `ERWARTE` | Antwort-Wartepolitik. `ERWARTE BELIEBIG` — auf mindestens eine Antwort warten. |
| `Mod.Timeout` | `HÖCHSTENS` | Zeitlimit. `HÖCHSTENS 10m` — nach 10 Minuten aufgeben. |

### Synchronisation (WARTE)

| ID | DE | Semantik |
|---|---|---|
| `Mod.On` | `AUF` | Erwartete Versprechen. `AUF ?plan, ?daten` — auf diese Versprechen warten. |
| `Mod.Mode` | `MODUS` | Wartemodus. Wie viele Versprechen eingelöst werden müssen. |
| `Pol.All` | `ALLE` | Auf alle genannten Versprechen warten. |
| `Pol.Any` | `BELIEBIG` | Auf ein beliebiges der genannten Versprechen warten. |
| `Pol.None` | `KEINE` | Nicht auf Antwort warten. Abschicken und vergessen. |
| `Mod.Timeout` | `HÖCHSTENS` | Zeitlimit. Dasselbe Schlüsselwort wie bei SCHREIBE — einheitlich. |

### Werkzeugaufruf (FÜHRE AUS)

| ID | DE | Semantik |
|---|---|---|
| `Mod.Using` | `MIT` | Welches Werkzeug aufrufen. `MIT !suche` — pflichtgemäß, genau eines. |

---

## Extended-Operatoren

| ID | DE | Semantik |
|---|---|---|
| `Op.If` | `WENN` | Bedingte Verzweigung. Deterministisch, ohne LLM. |
| `Op.Repeat` | `WIEDERHOLE` | Schleife mit Pflichtobergrenze. `WIEDERHOLE 5` oder `WIEDERHOLE BIS $fertig HÖCHSTENS 5`. |
| `Op.Each` | `JEDES` | Über Listenelemente iterieren. `JEDES $aufgabe VON $plan.dateien`. Feste Form — kein Genus-Agreement mit dem Bezeichner. |
| `Op.Gather` | `SAMMLE` | Ergebnisse zu einem einzelnen Wert aggregieren. |
| `Op.Signal` | `SIGNAL` | Daten in einen bestehenden Strom einspeisen. |

### Modifikatoren der Iteration

| ID | DE | Semantik |
|---|---|---|
| `Mod.Until` | `BIS` | Schleifenabbruchbedingung. `WIEDERHOLE BIS $bereit HÖCHSTENS 5`. |
| `Mod.Limit` | `HÖCHSTENS` | Iterationslimit (in WIEDERHOLE). Pflicht — Schleifen ohne Limit sind ungültig. |
| `Mod.From` | `VON` | Listenquelle für Iteration. `JEDES $element VON $liste`. |

---

## ERGEBNIS-Typen

| ID | DE | Semantik |
|---|---|---|
| `Typ.Text` | `TEXT` | Zeichenkette. |
| `Typ.Number` | `ZAHL` | Numerischer Wert. |
| `Typ.Flag` | `FLAGGE` | Boolescher Wert. |
| `Typ.Choice` | `AUSWAHL(...)` | Enum — einer der aufgelisteten Werte. |
| `Typ.List` | `LISTE` | Array strukturierter Elemente. |

---

## Dauer-Suffixe

| ID | DE | Semantik |
|---|---|---|
| `Dur.Seconds` | `s` | Sekunden. |
| `Dur.Minutes` | `m` | Minuten. |
| `Dur.Hours` | `h` | Stunden. |

---

## Kontextabhängige Auflösung

`HÖCHSTENS` wird auf zwei abstrakte Bezeichner abgebildet. Der Operatorkontext bestimmt eindeutig, welcher gemeint ist:

| Phrase | Kontext | Abstrakter ID |
|---|---|---|
| `HÖCHSTENS` | Innerhalb von `SCHREIBE` oder `WARTE` | `Mod.Timeout` |
| `HÖCHSTENS` | Innerhalb von `WIEDERHOLE` | `Mod.Limit` |

„Höchstens 10 Minuten" (Zeitlimit) und „höchstens 5 Mal" (Iterationslimit) — ein Wort deckt beides natürlich ab.

---

## Beispiel: Recherche-Agent

```coil
' ──────────────────────────────────────────────
' Umgebung
' ──────────────────────────────────────────────
TEILNEHMER experte, autor
WERKZEUGE suche

' ──────────────────────────────────────────────
' Rollen — Expertenprofile für das LLM.
' Welches Wissen und welchen Ansatz
' das LLM bei der Aufgabe einsetzen soll.
' ──────────────────────────────────────────────
DEFINIERE recherche_skill
<<
Du bist ein Research-Analyst.
Du arbeitest mit unstrukturierten Anfragen.
Du suchst immer nach Primärquellen und gibst
den Grad deiner Sicherheit bei Schlussfolgerungen an.
Du vermeidest Spekulationen.
Wenn die Datenlage unzureichend ist — sagst du das direkt.
>>
ENDE

DEFINIERE fachkompetenz
<<
Du kennst dich mit Produktanalyse aus.
Du verstehst Retention, Activation und Churn.
Du kannst Funnels und Kohortenberichte lesen.
Bei der Analyse unterscheidest du immer zwischen
Korrelation und Kausalität.
>>
ENDE

' ──────────────────────────────────────────────
' Eingabedaten — die Umgebung muss diese Werte
' liefern, bevor das Protokoll fortfährt.
' ──────────────────────────────────────────────
EMPFANGE anfrage
<<
Nutzeranfrage zur Recherche.
>>
ENDE

EMPFANGE anfragenverlauf
<<
Verlauf früherer Anfragen zu diesem Thema.
>>
ENDE

EMPFANGE fall_id
<<
Kennung des aktuellen Falls.
>>
ENDE

' ──────────────────────────────────────────────
' 1. Aufgabenstellung — wie ein mathematisches
'    Problem strukturiert:
'    ALS      — Rolle / Expertenprofil
'    ZIEL     — was erreicht werden soll
'    EINGABE  — Aufgabendaten
'    KONTEXT  — Hintergrundinformationen
'    ERGEBNIS — was bestimmt werden soll
'
' DENKE läuft im Hintergrund. Erzeugt ein
' Ergebnisversprechen ?analyse und einen
' Live-Strom ~analyse. Eingaben können
' während des Denkens über SIGNAL ergänzt werden.
' ──────────────────────────────────────────────
DENKE analyse
  ALS $recherche_skill, $fachkompetenz
  ZIEL <<
  Eine fundierte Antwort mit Quellen vorbereiten.
  >>
  EINGABE <<
  Recherchiere die Nutzeranfrage. Berücksichtige
  alle Daten, die während der Analyse über den
  Strom eintreffen.
  >>
  KONTEXT <<
  Anfrage: $anfrage
  Anfragenverlauf: $anfragenverlauf
  >>
  ERGEBNIS
  * antwort: TEXT - endgültige Antwort
  * quellen: LISTE - herangezogene Referenzen
    * ref: TEXT - Quellenlink
    * warum: TEXT - warum relevant
  * sicherheit: AUSWAHL(hoch, mittel, niedrig)
ENDE

' ──────────────────────────────────────────────
' 2. Datenerhebung — parallel zum Denkprozess.
'    Suche und Expertenanfrage blockieren
'    weder einander noch DENKE.
' ──────────────────────────────────────────────
FÜHRE AUS gefunden
  MIT !suche
  - query: $anfrage
  - limit: 10
ENDE

SCHREIBE meinung
  AN #beratung
  FÜR @experte
  ERWARTE BELIEBIG
  HÖCHSTENS 10m
  <<
  Brauche Expertenmeinung zur Anfrage: $anfrage
  >>
ENDE

' ──────────────────────────────────────────────
' 3. Eingaben während des Denkens ergänzen.
'    Daten treffen in beliebiger Reihenfolge ein —
'    jedes Ergebnis fließt sofort in ~analyse ein.
'    Das LLM berücksichtigt es ohne Neustart.
' ──────────────────────────────────────────────
WIEDERHOLE 2
  WARTE daten
    AUF ?gefunden, ?meinung
    MODUS BELIEBIG
  ENDE

  SIGNAL ~analyse
    <<
    $daten
    >>
  ENDE
ENDE

' ──────────────────────────────────────────────
' 4. Die Analyse ist abgeschlossen.
'    Das Ergebnis berücksichtigt Ausgangsdaten,
'    Suchergebnisse und Expertenfeedback.
' ──────────────────────────────────────────────
WARTE
  AUF ?analyse
ENDE

' ──────────────────────────────────────────────
' 5. Antwort übermitteln.
' ──────────────────────────────────────────────
SCHREIBE
  AN #ergebnisse/$fall_id
  FÜR @autor
  <<
  $analyse.antwort
  >>
ENDE

SCHLUSS
```
