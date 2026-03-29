# COIL:es-standard — Dialecto español estándar

> «Escribe guiones en el idioma en el que piensas.»

**Estado:** dialecto oficial, incluido en la distribución estándar.

Este dialecto ofrece un mapeo idiomático en español de todas las construcciones de COIL. Cada palabra clave está elegida para ser comprensible de inmediato por un hispanohablante — sin conocimientos de programación, sin pasar por el inglés. El español utilizado es neutro e internacional, sin regionalismos.

---

## Principios de diseño

1. **Imperativo (tuteo).** Los operadores son verbos en imperativo informal: DEFINE, RECIBE, PIENSA. El protocolo se dirige al entorno de ejecución como a un ejecutor: «haz esto.»

2. **Español natural.** Las palabras clave usan español cotidiano, no jerga técnica. `ESCRIBE` en lugar de `ENVÍA` — porque decimos «escríbeme» en los mensajeros, no «envíame un mensaje». `MÁXIMO` en lugar de `TIMEOUT` — porque «máximo 10 minutos» es español natural.

3. **Una palabra si es posible.** Se prefieren las formas de una sola palabra. Las formas compuestas solo donde una sola palabra sería ambigua: `RESPUESTA A`.

4. **Indicadores de categoría.** La connotación de la palabra indica la categoría del operador: bloqueante (`RECIBE`, `ESPERA`), lanzador (`PIENSA`, `EJECUTA`, `ESCRIBE`), instantáneo (`DEFINE`, `MODIFICA`).

---

## Operadores Core

| ID | ES | Semántica |
|---|---|---|
| `Op.Actors` | `PARTICIPANTES` | Declarar los participantes del protocolo. Quiénes actúan en el escenario. |
| `Op.Tools` | `HERRAMIENTAS` | Declarar las herramientas disponibles. Con qué trabajan los agentes. |
| `Op.Define` | `DEFINE` | Crear un nuevo valor con nombre. Como en matemáticas: definir un término. Coincide con el inglés por raíz latina compartida. |
| `Op.Set` | `MODIFICA` | Modificar un valor existente. No `DEFINE` — el valor ya existe. |
| `Op.Receive` | `RECIBE` | Enlace bloqueante desde el entorno. El protocolo espera a que el entorno proporcione un valor. |
| `Op.Think` | `PIENSA` | Lanzar un paso cognitivo LLM. El modelo recibe un problema y reflexiona sobre él. |
| `Op.Execute` | `EJECUTA` | Invocar una herramienta. Cubre tanto llamadas puntuales como sesiones interactivas. |
| `Op.Send` | `ESCRIBE` | Escribir un mensaje en un canal. No `ENVÍA` — en español decimos «escríbeme», no «envíame». El lenguaje de los mensajeros. |
| `Op.Wait` | `ESPERA` | Punto de sincronización. Bloquear hasta que las promesas se resuelvan. |
| `Op.Exit` | `TERMINA` | Finalizar el protocolo. Una línea, sin argumentos. |
| `Kw.End` | `FIN` | Cerrar un bloque. Cada operador de bloque se cierra con `FIN`. |

---

## Modificadores

### Configuración del modelo (PIENSA)

| ID | ES | Semántica |
|---|---|---|
| `Mod.Via` | `VÍA` | Qué modelo LLM usar. `VÍA $modelo_rápido` — encaminar la tarea por este modelo. |
| `Mod.As` | `COMO` | Definición de rol (habilidades). `COMO $analista` — piensa como este experto. Solo referencias. |
| `Mod.Using` | `CON` | Herramientas disponibles para el LLM. `CON !búsqueda, !cálculo` — el modelo puede invocar estas. |

### Enunciado de la tarea (PIENSA)

| ID | ES | Semántica |
|---|---|---|
| `Mod.Goal` | `OBJETIVO` | Propósito del paso cognitivo. Qué queremos lograr. |
| `Mod.Input` | `ENTRADA` | Enunciado del problema. Los datos con los que trabajar. |
| `Mod.Context` | `CONTEXTO` | Datos adicionales, trasfondo, restricciones. |
| `Mod.Result` | `RESULTADO` | Especificación de salida estructurada. Qué debe determinar el LLM. |

### Direccionamiento (ESCRIBE)

| ID | ES | Semántica |
|---|---|---|
| `Mod.To` | `HACIA` | Dirección del canal. `HACIA #soporte` — entregar a este canal. Preposición direccional, no locativa. |
| `Mod.For` | `PARA` | Destinatario. `PARA @experto` — este mensaje es para este participante. |
| `Mod.ReplyTo` | `RESPUESTA A` | Referencia de respuesta. A qué mensaje se responde. |
| `Mod.Await` | `AGUARDA` | Política de espera de respuesta. `AGUARDA CUALQUIERA` — esperar al menos una respuesta. Distinto de `ESPERA` (operador) — ver Notas. |
| `Mod.Timeout` | `MÁXIMO` | Plazo máximo. `MÁXIMO 10m` — abandonar después de 10 minutos. |

### Sincronización (ESPERA)

| ID | ES | Semántica |
|---|---|---|
| `Mod.On` | `POR` | Promesas esperadas. `POR ?plan, ?datos` — por qué promesas esperamos. |
| `Mod.Mode` | `MODO` | Modo de espera. Cuántas promesas deben resolverse. |
| `Pol.All` | `TODOS` | Esperar todas las promesas listadas. |
| `Pol.Any` | `CUALQUIERA` | Esperar cualquiera de las promesas listadas. |
| `Pol.None` | `NINGUNO` | No esperar respuesta. Enviar y olvidar. |
| `Mod.Timeout` | `MÁXIMO` | Plazo máximo. Misma palabra clave que en ESCRIBE — coherente. |

### Invocación de herramienta (EJECUTA)

| ID | ES | Semántica |
|---|---|---|
| `Mod.Using` | `CON` | Qué herramienta invocar. `CON !búsqueda` — obligatorio, exactamente una. |

---

## Operadores Extended

| ID | ES | Semántica |
|---|---|---|
| `Op.If` | `SI` | Bifurcación condicional. Determinista, sin LLM. |
| `Op.Repeat` | `REPITE` | Bucle con límite obligatorio. `REPITE 5` o `REPITE HASTA $listo MÁXIMO 5`. |
| `Op.Each` | `CADA` | Iterar sobre los elementos de una lista. `CADA $tarea DE $plan.archivos`. Invariable — sin concordancia de género con el identificador. |
| `Op.Gather` | `REÚNE` | Agregar resultados en un solo valor. |
| `Op.Signal` | `SEÑAL` | Enviar datos a un flujo existente. Palabra española nativa, no préstamo del inglés. |

### Modificadores de iteración

| ID | ES | Semántica |
|---|---|---|
| `Mod.Until` | `HASTA` | Condición de salida del bucle. `REPITE HASTA $listo MÁXIMO 5`. |
| `Mod.Limit` | `MÁXIMO` | Tope de iteraciones (en REPITE). Obligatorio — los bucles sin límite son inválidos. |
| `Mod.From` | `DE` | Fuente de la lista para iteración. `CADA $elemento DE $lista`. |

---

## Tipos de RESULTADO

| ID | ES | Semántica |
|---|---|---|
| `Typ.Text` | `TEXTO` | Valor de cadena de caracteres. |
| `Typ.Number` | `NÚMERO` | Valor numérico. |
| `Typ.Flag` | `MARCADOR` | Valor booleano. Marcado o no — como una casilla de verificación. |
| `Typ.Choice` | `OPCIÓN(...)` | Enum — uno de los valores listados. |
| `Typ.List` | `LISTA` | Arreglo de elementos estructurados. |

---

## Sufijos de duración

| ID | ES | Semántica |
|---|---|---|
| `Dur.Seconds` | `s` | Segundos. |
| `Dur.Minutes` | `m` | Minutos. |
| `Dur.Hours` | `h` | Horas. |

---

## Resolución contextual

`MÁXIMO` se mapea a dos identificadores abstractos. El contexto del operador determina sin ambigüedad cuál se aplica:

| Frase | Contexto | ID abstracto |
|---|---|---|
| `MÁXIMO` | Dentro de `ESCRIBE` o `ESPERA` | `Mod.Timeout` |
| `MÁXIMO` | Dentro de `REPITE` | `Mod.Limit` |

«Máximo 10 minutos» (plazo) y «máximo 5 veces» (límite de iteraciones) — una sola palabra natural cubre ambos casos.

---

## Ejemplo: agente de investigación

```coil
' ═══════════════════════════════════════
' Entorno
' ═══════════════════════════════════════
PARTICIPANTES experto, autor
HERRAMIENTAS búsqueda

' ═══════════════════════════════════════
' Roles — perfiles de experiencia para el LLM.
' Qué conocimientos y enfoque debe adoptar
' el LLM para la tarea.
' ═══════════════════════════════════════
DEFINE competencia_investigación
<<
Eres un analista investigador.
Trabajas con consultas no estructuradas.
Siempre buscas fuentes primarias e indicas
tu grado de confianza en las conclusiones.
Evitas las especulaciones.
Si los datos son insuficientes — lo dices directamente.
>>
FIN

DEFINE experiencia_dominio
<<
Dominas el análisis de producto.
Conoces las métricas de retención, activación y abandono.
Sabes leer embudos e informes de cohorte.
Al analizar, siempre distingues entre
correlación y causalidad.
>>
FIN

' ═══════════════════════════════════════
' Datos de entrada — el entorno debe proporcionar
' estos valores antes de que el protocolo continúe.
' ═══════════════════════════════════════
RECIBE consulta
<<
Consulta del usuario para la investigación.
>>
FIN

RECIBE historial
<<
Historial de consultas anteriores sobre este tema.
>>
FIN

RECIBE caso_id
<<
Identificador del caso actual.
>>
FIN

' ═══════════════════════════════════════
' 1. Enunciado de la tarea — estructurado como
'    un problema matemático:
'    COMO      — rol / perfil de experto
'    OBJETIVO  — qué queremos lograr
'    ENTRADA   — datos del problema
'    CONTEXTO  — información de fondo
'    RESULTADO — qué hay que determinar
'
' PIENSA se ejecuta en segundo plano. Crea una
' promesa de resultado ?análisis y un flujo
' en vivo ~análisis. Las entradas pueden
' complementarse durante la reflexión vía SEÑAL.
' ═══════════════════════════════════════
PIENSA análisis
  COMO $competencia_investigación, $experiencia_dominio
  OBJETIVO <<
  Preparar una respuesta fundamentada con fuentes.
  >>
  ENTRADA <<
  Investiga la consulta del usuario. Incorpora
  todos los datos que lleguen por el flujo
  durante el análisis.
  >>
  CONTEXTO <<
  Consulta: $consulta
  Historial: $historial
  >>
  RESULTADO
  * respuesta: TEXTO - respuesta final
  * fuentes: LISTA - referencias citadas
    * ref: TEXTO - enlace de la fuente
    * porqué: TEXTO - por qué es relevante
  * confianza: OPCIÓN(alta, media, baja)
FIN

' ═══════════════════════════════════════
' 2. Recopilación de datos — en paralelo con
'    la reflexión. La búsqueda y la consulta
'    al experto no se bloquean mutuamente
'    ni bloquean PIENSA.
' ═══════════════════════════════════════
EJECUTA encontrado
  CON !búsqueda
  - query: $consulta
  - limit: 10
FIN

ESCRIBE opinión
  HACIA #consultas
  PARA @experto
  AGUARDA CUALQUIERA
  MÁXIMO 10m
  <<
  Necesito opinión experta sobre la consulta: $consulta
  >>
FIN

' ═══════════════════════════════════════
' 3. Complementar entradas durante la reflexión.
'    Los datos llegan en orden arbitrario —
'    cada resultado se inyecta en ~análisis
'    de inmediato. El LLM lo incorpora
'    sin reiniciarse.
' ═══════════════════════════════════════
REPITE 2
  ESPERA datos
    POR ?encontrado, ?opinión
    MODO CUALQUIERA
  FIN

  SEÑAL ~análisis
    <<
    $datos
    >>
  FIN
FIN

' ═══════════════════════════════════════
' 4. El análisis está completo.
'    El resultado incorpora los datos iniciales,
'    los resultados de búsqueda y la opinión
'    del experto.
' ═══════════════════════════════════════
ESPERA
  POR ?análisis
FIN

' ═══════════════════════════════════════
' 5. Entregar la respuesta.
' ═══════════════════════════════════════
ESCRIBE
  HACIA #resultados/$caso_id
  PARA @autor
  <<
  $análisis.respuesta
  >>
FIN

TERMINA
```

---

## Notas

**¿Por qué ESPERA (operador) y AGUARDA (modificador)?**
Ambas palabras significan «esperar», pero tienen matices distintos. `ESPERA` es el imperativo directo: «¡espera!» — el protocolo se detiene. `AGUARDA` tiene un matiz de expectativa: «aguarda respuesta» — se declara una política de espera. En español, «aguardar» es ligeramente más formal y evoca paciencia, mientras que «esperar» es la acción inmediata. Esta distinción evita la colisión entre el operador y el modificador.

**¿Por qué DEFINE coincide con el inglés?**
`DEFINE` es el imperativo de «definir» en español — una palabra española de raíz latina. La coincidencia con el inglés es accidental y ocurre en ambas lenguas porque comparten la misma raíz. No es un préstamo ni una calca.
