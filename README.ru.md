*[Read in English](README.md)*

# COIL — Cognitive Orchestration Interface Language

Язык сценариев для когнитивной оркестрации в агентной ОС, где в роли процессора выступает LLM.

## Зачем

Каждому агенту в агентной ОС нужен сценарий поведения — не промпт («кто ты»), а протокол: что делать, когда ждать, кого спросить, куда написать. COIL описывает такие протоколы. Человек видит понятный сценарий на своём языке. LLM видит однозначную структуру, которую может исполнять, генерировать и улучшать.

## Hello World

```coil
НАПИШИ
  КУДА #general
  <<
  Hello, world!
  >>
КОНЕЦ

ВЫХОД
```

Одна команда, один канал, ноль LLM. Агент отправляет сообщение и завершается.

С когнитивным шагом:

```coil
ДУМАЙ приветствие
  ВХОД <<
  Придумай короткое приветственное сообщение в стиле Hello, world!
  >>
  РЕЗУЛЬТАТ
  * текст: ТЕКСТ
КОНЕЦ

ЖДИ
  НА ?приветствие
КОНЕЦ

НАПИШИ
  КУДА #general
  <<
  $приветствие.текст
  >>
КОНЕЦ

ВЫХОД
```

## Статус

Спецификация v0.2 — рабочая версия. Разделена на две зоны:

- **Зафиксировано** — решения, которые уже стабильны в текущей версии.
- **Рабочая гипотеза** — решения, которые уже вписаны в архитектуру, но их синтаксис или точная семантика ещё могут быть уточнены.

## Спецификация

| Файл | Содержимое |
|---|---|
| [00-overview.md](spec/00-overview.md) | Философия, scope, что такое COIL |
| [01-lexical.md](spec/01-lexical.md) | Лексика, блоки, идентификаторы, шаблоны, комментарии |
| [02-core.md](spec/02-core.md) | Core-операторы и их синтаксис |
| [03-extended.md](spec/03-extended.md) | Extended-операторы и рабочие расширения |
| [04-execution-model.md](spec/04-execution-model.md) | Модель исполнения, детерминизм, обещания и порядок шагов |
| [05-structured-output.md](spec/05-structured-output.md) | Спецификация результата мышления |
| [06-templates.md](spec/06-templates.md) | Шаблоны и границы шаблонной логики |
| [07-streams.md](spec/07-streams.md) | Потоки, события и сигналы |
| [08-errors-budget.md](spec/08-errors-budget.md) | Ошибки, таймауты, budget exhaustion, cancellation |
| [09-os-integration.md](spec/09-os-integration.md) | Интеграция с агентной ОС |
| [10-terminology.md](spec/10-terminology.md) | Терминология |
| [11-coil-h.md](spec/11-coil-h.md) | COIL-H: спецификация табличной проекции |
| [DESIGN.md](DESIGN.md) | Журнал принятых решений |

## Примеры

| Пример | Что показывает |
|---|---|
| [research-agent.en.md](examples/research-agent.en.md) | Полный агент-исследователь (COIL-H + COIL-C, English) |
| [research-agent.ru.md](examples/research-agent.ru.md) | Тот же агент (русский) |
| [hello-world.md](examples/hello-world.md) | Минимальный Hello World с COIL-H |

### Паттерны (COIL-C)

| Паттерн | Что показывает |
|---|---|
| [routing.coil](examples/patterns/routing.coil) | Классификация → выбор роли → ответ |
| [parallelization.coil](examples/patterns/parallelization.coil) | Параллельное ревью тремя экспертами, агрегация |
| [evaluator-optimizer.coil](examples/patterns/evaluator-optimizer.coil) | Итеративная оценка и улучшение |
| [prompt-chaining.coil](examples/patterns/prompt-chaining.coil) | Последовательные промпты с проверкой качества |
| [internal-delegation.coil](examples/patterns/internal-delegation.coil) | Один LLM, разные роли через КАК — внутренний reasoning |
| [multi-agent-orchestration.coil](examples/patterns/multi-agent-orchestration.coil) | Реальные агенты, коммуникация через НАПИШИ + ЖДАТЬ |

### Антипаттерны

| Антипаттерн | В чём проблема |
|---|---|
| [everything-in-one-think.coil](examples/anti-patterns/everything-in-one-think.coil) | Весь рабочий процесс в одном THINK |
| [think-for-deterministic-check.coil](examples/anti-patterns/think-for-deterministic-check.coil) | THINK для проверки, которую IF вычислит без LLM |
| [missing-wait.coil](examples/anti-patterns/missing-wait.coil) | Обращение к $name без WAIT после запуска THINK |
| [define-instead-of-set.coil](examples/anti-patterns/define-instead-of-set.coil) | Повторный DEFINE вместо DEFINE + SET |
| [send-when-think-needed.coil](examples/anti-patterns/send-when-think-needed.coil) | SEND AWAIT другому агенту для работы, которую текущий агент может сделать сам |

## Диалекты

Среда исполнения оперирует семантикой конструкций, а не их написанием. Ключевые слова пишутся на том языке, на котором думает пользователь. Один и тот же сценарий на разных языках — один и тот же протокол:

```coil
ДУМАЙ анализ                          THINK analysis
  ЦЕЛЬ <<                               GOAL <<
  Классифицируй запрос.                 Classify the request.
  >>                                    >>
  РЕЗУЛЬТАТ                             RESULT
  * тип: ВЫБОР(баг, фича, вопрос)       * type: CHOICE(bug, feature, question)
КОНЕЦ                                 END
```

Канонический COIL использует русские ключевые слова. Диалекты — это альтернативные наборы ключевых слов с идентичной семантикой и моделью исполнения — диалект это скин, а не скелет.

| Диалект | Директория | Статус | Назначение |
|---|---|---|---|
| Стандартный английский | [dialects/en-standard](dialects/en-standard/README.md) | Официальный | Основная точка входа для англоязычных пользователей |
| English profanity | [dialects/en-profanity](dialects/en-profanity/README.md) | Коммьюнити | Proof of concept: семантический резонанс через сленг |
| Русский мат | [dialects/ru-mat](dialects/ru-mat/README.md) | Коммьюнити | Proof of concept: русский обсценный диалект |
| Matrix | [dialects/ru-matrix](dialects/ru-matrix/README.md) | Коммьюнити | Тематический диалект по мотивам «Матрицы» |

Правила:

- Один скрипт — один диалект. Смешение ключевых слов из разных диалектов в одном файле недопустимо.
- Сигилы (`$`, `?`, `@`, `!`, `#`, `~`) универсальны и не зависят от диалекта.
- Идентификаторы (имена переменных, участников, инструментов) — свободные и не ограничены языком диалекта.
- Реализация COIL, заявляющая соответствие спецификации, обязана поддерживать каноническую форму (русскую). Поддержка стандартного английского диалекта настоятельно рекомендуется.

## PDF-документы

LaTeX-исходники в `tex/`, Markdown-спецификация в `spec/`, собранные PDF в `pdf/`.

| PDF | Источник | Содержимое |
|---|---|---|
| `tutorial` | `tex/tutorial.tex` | Учебник: с чего начинать, три частых сценария, антипаттерны, типичные ошибки, ДУМАЙ vs. НАПИШИ с ЖДАТЬ |
| `lang-reference` | `spec/*.md` | Полный справочник языка, собранный из файлов спецификации (pandoc) |

### Требования

Для сборки PDF необходимы LaTeX и pandoc.

На macOS:

```bash
brew install --cask mactex && brew install pandoc
```

### Сборка

```bash
make        # собрать все PDF
make clean  # очистить собранные файлы
```

## Test Suite

Тесты соответствия в `tests/` — `.coil`-файлы на en-standard диалекте, определяющие, что конформная реализация обязана принять или отвергнуть. См. [tests/README.md](tests/README.md).

| Директория | Что тестирует |
|---|---|
| `tests/valid/core/` | Каждый Core-оператор изолированно |
| `tests/valid/extended/` | Extended-операторы (IF, REPEAT, EACH, SIGNAL) |
| `tests/valid/result/` | Микросинтаксис RESULT (TEXT, NUMBER, FLAG, CHOICE, LIST) |
| `tests/valid/patterns/` | Интеграционные сценарии из нескольких операторов |
| `tests/invalid/` | Ошибки подготовки — должны быть отвергнуты до исполнения |

---

Animata Systems, March 2026
