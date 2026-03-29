# COIL:pt-br-standard — Dialeto padrão do português brasileiro

> «Escreva roteiros na língua em que você pensa.»

**Status:** dialeto oficial, incluído na distribuição padrão.

Este dialeto oferece um mapeamento idiomático em português brasileiro de todas as construções COIL. Cada palavra-chave foi escolhida para ser imediatamente compreensível por um falante brasileiro — sem conhecimento de programação, sem passar pelo inglês. O registro é o do português brasileiro contemporâneo, direto e sem formalismo excessivo.

---

## Princípios de design

1. **Imperativo (você).** Os operadores são verbos no imperativo da forma «você»: DEFINA, RECEBA, PENSE. O protocolo se dirige ao ambiente de execução como a alguém que vai fazer a tarefa: «faça isso.»

2. **Português do dia a dia.** As palavras-chave usam português cotidiano, não jargão técnico. `ESCREVA` em vez de `ENVIE` — porque dizemos «me escreve no WhatsApp», não «me envie uma mensagem». `MÁXIMO` em vez de `TIMEOUT` — porque «máximo 10 minutos» é português natural.

3. **Uma palavra quando possível.** Formas de uma única palavra são preferidas. Formas compostas só onde uma palavra seria ambígua: `RESPOSTA A`.

4. **Dicas de categoria.** A conotação da palavra indica a categoria do operador: bloqueante (`RECEBA`, `ESPERE`), lançador (`PENSE`, `EXECUTE`, `ESCREVA`), instantâneo (`DEFINA`, `ALTERE`).

---

## Operadores Core

| ID | PT-BR | Semântica |
|---|---|---|
| `Op.Actors` | `PARTICIPANTES` | Declarar os participantes do protocolo. Quem age no cenário. |
| `Op.Tools` | `FERRAMENTAS` | Declarar as ferramentas disponíveis. Com o que os agentes vão trabalhar. |
| `Op.Define` | `DEFINA` | Criar um novo valor nomeado. Como na matemática: definir um termo. |
| `Op.Set` | `ALTERE` | Alterar um valor existente. Não `DEFINA` — o valor já existe. |
| `Op.Receive` | `RECEBA` | Vinculação bloqueante do ambiente. O protocolo espera até que o ambiente forneça um valor. |
| `Op.Think` | `PENSE` | Lançar uma etapa cognitiva LLM. O modelo recebe um problema e reflete sobre ele. |
| `Op.Execute` | `EXECUTE` | Invocar uma ferramenta. Cobre tanto chamadas pontuais quanto sessões interativas. Coincide com o inglês por raiz latina compartilhada. |
| `Op.Send` | `ESCREVA` | Escrever uma mensagem em um canal. Não `ENVIE` — no Brasil dizemos «me escreve», não «me envie». A língua dos mensageiros. |
| `Op.Wait` | `ESPERE` | Ponto de sincronização. Bloquear até que as promessas sejam resolvidas. |
| `Op.Exit` | `ENCERRE` | Encerrar o protocolo. Uma linha, sem argumentos. «Encerre» — como «é isso, acabou». |
| `Kw.End` | `FIM` | Fechar um bloco. Todo operador de bloco se fecha com `FIM`. |

---

## Modificadores

### Configuração do modelo (PENSE)

| ID | PT-BR | Semântica |
|---|---|---|
| `Mod.Via` | `VIA` | Qual modelo LLM usar. `VIA $modelo_rápido` — encaminhar a tarefa por esse modelo. |
| `Mod.As` | `COMO` | Definição de papel (habilidades). `COMO $analista` — pense como esse especialista. Apenas referências. |
| `Mod.Using` | `COM` | Ferramentas disponíveis para o LLM. `COM !busca, !cálculo` — o modelo pode invocar essas. |

### Enunciado da tarefa (PENSE)

| ID | PT-BR | Semântica |
|---|---|---|
| `Mod.Goal` | `OBJETIVO` | Propósito da etapa cognitiva. O que queremos alcançar. |
| `Mod.Input` | `ENTRADA` | Enunciado do problema. Os dados com os quais trabalhar. |
| `Mod.Context` | `CONTEXTO` | Dados adicionais, contexto, restrições. |
| `Mod.Result` | `RESULTADO` | Especificação de saída estruturada. O que o LLM deve determinar. |

### Endereçamento (ESCREVA)

| ID | PT-BR | Semântica |
|---|---|---|
| `Mod.To` | `NO` | Endereço do canal. `NO #suporte` — escrever no canal. Locativo, como se usa no Brasil: «escreve no grupo». |
| `Mod.For` | `PARA` | Destinatário. `PARA @especialista` — essa mensagem é para esse participante. |
| `Mod.ReplyTo` | `RESPOSTA A` | Referência de resposta. A qual mensagem se responde. |
| `Mod.Await` | `AGUARDE` | Política de espera de resposta. `AGUARDE QUALQUER` — esperar ao menos uma resposta. Distinto de `ESPERE` (operador) — ver Notas. |
| `Mod.Timeout` | `MÁXIMO` | Prazo máximo. `MÁXIMO 10m` — desistir após 10 minutos. |

### Sincronização (ESPERE)

| ID | PT-BR | Semântica |
|---|---|---|
| `Mod.On` | `POR` | Promessas esperadas. `POR ?plano, ?dados` — por quais promessas esperamos. |
| `Mod.Mode` | `MODO` | Modo de espera. Quantas promessas precisam ser resolvidas. |
| `Pol.All` | `TODOS` | Esperar todas as promessas listadas. |
| `Pol.Any` | `QUALQUER` | Esperar qualquer uma das promessas listadas. |
| `Pol.None` | `NENHUM` | Não esperar resposta. Mandar e esquecer. |
| `Mod.Timeout` | `MÁXIMO` | Prazo máximo. Mesma palavra-chave que em ESCREVA — coerente. |

### Invocação de ferramenta (EXECUTE)

| ID | PT-BR | Semântica |
|---|---|---|
| `Mod.Using` | `COM` | Qual ferramenta invocar. `COM !busca` — obrigatório, exatamente uma. |

---

## Operadores Extended

| ID | PT-BR | Semântica |
|---|---|---|
| `Op.If` | `SE` | Ramificação condicional. Determinística, sem LLM. |
| `Op.Repeat` | `REPITA` | Laço com limite obrigatório. `REPITA 5` ou `REPITA ATÉ $pronto MÁXIMO 5`. |
| `Op.Each` | `CADA` | Iterar sobre os elementos de uma lista. `CADA $tarefa DE $plano.arquivos`. Invariável — sem concordância de gênero com o identificador. |
| `Op.Gather` | `REÚNA` | Agregar resultados em um único valor. |
| `Op.Signal` | `SINAL` | Enviar dados para um fluxo existente. Palavra portuguesa nativa. |

### Modificadores de iteração

| ID | PT-BR | Semântica |
|---|---|---|
| `Mod.Until` | `ATÉ` | Condição de saída do laço. `REPITA ATÉ $pronto MÁXIMO 5`. |
| `Mod.Limit` | `MÁXIMO` | Teto de iterações (em REPITA). Obrigatório — laços sem limite são inválidos. |
| `Mod.From` | `DE` | Fonte da lista para iteração. `CADA $elemento DE $lista`. |

---

## Tipos de RESULTADO

| ID | PT-BR | Semântica |
|---|---|---|
| `Typ.Text` | `TEXTO` | Valor de string. |
| `Typ.Number` | `NÚMERO` | Valor numérico. |
| `Typ.Flag` | `MARCADOR` | Valor booleano. Marcado ou não — como uma caixa de seleção. |
| `Typ.Choice` | `OPÇÃO(...)` | Enum — um dos valores listados. |
| `Typ.List` | `LISTA` | Array de elementos estruturados. |

---

## Sufixos de duração

| ID | PT-BR | Semântica |
|---|---|---|
| `Dur.Seconds` | `s` | Segundos. |
| `Dur.Minutes` | `m` | Minutos. |
| `Dur.Hours` | `h` | Horas. |

---

## Resolução contextual

`MÁXIMO` é mapeado para dois identificadores abstratos. O contexto do operador determina sem ambiguidade qual se aplica:

| Frase | Contexto | ID abstrato |
|---|---|---|
| `MÁXIMO` | Dentro de `ESCREVA` ou `ESPERE` | `Mod.Timeout` |
| `MÁXIMO` | Dentro de `REPITA` | `Mod.Limit` |

«Máximo 10 minutos» (prazo) e «máximo 5 vezes» (limite de iterações) — uma única palavra natural cobre os dois casos.

---

## Exemplo: agente de pesquisa

```coil
' ═══════════════════════════════════════
' Ambiente
' ═══════════════════════════════════════
PARTICIPANTES especialista, autor
FERRAMENTAS busca

' ═══════════════════════════════════════
' Papéis — perfis de expertise para o LLM.
' Que conhecimentos e abordagem o LLM
' deve adotar para a tarefa.
' ═══════════════════════════════════════
DEFINA competência_pesquisa
<<
Você é um analista pesquisador.
Trabalha com consultas não estruturadas.
Sempre busca fontes primárias e indica
o grau de confiança nas conclusões.
Evita especulações.
Se os dados são insuficientes — diz isso diretamente.
>>
FIM

DEFINA expertise_domínio
<<
Você domina análise de produto.
Conhece métricas de retenção, ativação e churn.
Sabe ler funis e relatórios de coorte.
Na análise, sempre distingue entre
correlação e causalidade.
>>
FIM

' ═══════════════════════════════════════
' Dados de entrada — o ambiente deve fornecer
' esses valores antes que o protocolo continue.
' ═══════════════════════════════════════
RECEBA consulta
<<
Consulta do usuário para pesquisa.
>>
FIM

RECEBA histórico
<<
Histórico de consultas anteriores sobre o tema.
>>
FIM

RECEBA caso_id
<<
Identificador do caso atual.
>>
FIM

' ═══════════════════════════════════════
' 1. Enunciado da tarefa — estruturado como
'    um problema de matemática:
'    COMO      — papel / perfil de especialista
'    OBJETIVO  — o que queremos alcançar
'    ENTRADA   — dados do problema
'    CONTEXTO  — informações de fundo
'    RESULTADO — o que precisa ser determinado
'
' PENSE roda em segundo plano. Cria uma
' promessa de resultado ?análise e um fluxo
' ao vivo ~análise. As entradas podem ser
' complementadas durante a reflexão via SINAL.
' ═══════════════════════════════════════
PENSE análise
  COMO $competência_pesquisa, $expertise_domínio
  OBJETIVO <<
  Preparar uma resposta fundamentada com fontes.
  >>
  ENTRADA <<
  Pesquise a consulta do usuário. Incorpore
  todos os dados que chegarem pelo fluxo
  durante a análise.
  >>
  CONTEXTO <<
  Consulta: $consulta
  Histórico: $histórico
  >>
  RESULTADO
  * resposta: TEXTO - resposta final
  * fontes: LISTA - referências citadas
    * ref: TEXTO - link da fonte
    * porquê: TEXTO - por que é relevante
  * confiança: OPÇÃO(alta, média, baixa)
FIM

' ═══════════════════════════════════════
' 2. Coleta de dados — em paralelo com
'    a reflexão. A busca e o pedido ao
'    especialista não bloqueiam um ao outro
'    nem bloqueiam PENSE.
' ═══════════════════════════════════════
EXECUTE encontrado
  COM !busca
  - query: $consulta
  - limit: 10
FIM

ESCREVA opinião
  NO #consultas
  PARA @especialista
  AGUARDE QUALQUER
  MÁXIMO 10m
  <<
  Preciso de opinião especializada sobre a consulta: $consulta
  >>
FIM

' ═══════════════════════════════════════
' 3. Complementar entradas durante a reflexão.
'    Os dados chegam em ordem arbitrária —
'    cada resultado é injetado em ~análise
'    imediatamente. O LLM incorpora sem
'    reiniciar.
' ═══════════════════════════════════════
REPITA 2
  ESPERE dados
    POR ?encontrado, ?opinião
    MODO QUALQUER
  FIM

  SINAL ~análise
    <<
    $dados
    >>
  FIM
FIM

' ═══════════════════════════════════════
' 4. A análise está completa.
'    O resultado incorpora os dados iniciais,
'    os resultados da busca e a opinião
'    do especialista.
' ═══════════════════════════════════════
ESPERE
  POR ?análise
FIM

' ═══════════════════════════════════════
' 5. Entregar a resposta.
' ═══════════════════════════════════════
ESCREVA
  NO #resultados/$caso_id
  PARA @autor
  <<
  $análise.resposta
  >>
FIM

ENCERRE
```

---

## Notas

**Por que NO para o canal e não PARA?**
No Brasil, dizemos «escreve no grupo», «manda no chat» — usamos a forma locativa «no» (em + o), não a direcional «para». O canal é o lugar onde se escreve, não a direção para onde se envia. `PARA` fica reservado para o destinatário: «para @especialista». Essa divisão — `NO` (onde) e `PARA` (para quem) — reflete os dois níveis de endereçamento de forma natural para um brasileiro.

**Por que ESPERE (operador) e AGUARDE (modificador)?**
Ambas as palavras significam «esperar», mas com nuances diferentes. `ESPERE` é o imperativo direto: «espere!» — o protocolo para. `AGUARDE` carrega um matiz de expectativa paciente: «aguarde resposta» — declara-se uma política de espera. No dia a dia brasileiro, «aguarde» é o que você ouve na fila do banco ou na linha telefônica — uma espera com propósito. Essa distinção evita a colisão entre o operador e o modificador.
