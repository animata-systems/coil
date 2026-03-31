*[Read in English](README.md)*

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/animata-systems/coil)

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

## Статус

Спецификация v0.4 — рабочая версия с явной статусной маркировкой. Каждая область языка имеет один из трёх нормативных статусов:

- **Stable** — часть текущей нормы. Документация и примеры могут этому учить. Downstream-работы вправе на это опираться.
- **Experimental** — идея принята, но синтаксис или семантика ещё подвижны. Присутствие в реализации само по себе не делает конструкцию нормой.
- **Deferred** — область признана важной, но сознательно не нормализуется в текущем цикле. Упоминается только как future work.

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

## Примеры и тесты

Все примеры используют диалект ru-standard. Тестовый корпус использует en-standard — см. [tests/README.md](tests/README.md).

| Пример | Что показывает |
|---|---|
| [research-agent.md](examples/research-agent.md) | Полный агент-исследователь (COIL-H + COIL-C) |
| [hello-world.coil](examples/hello-world.coil) | Минимальный Hello World |

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
| [everything-in-one-think.coil](examples/anti-patterns/everything-in-one-think.coil) | Весь рабочий процесс в одном ДУМАЙ |
| [think-for-deterministic-check.coil](examples/anti-patterns/think-for-deterministic-check.coil) | ДУМАЙ для проверки, которую ЕСЛИ вычислит без LLM |
| [missing-wait.coil](examples/anti-patterns/missing-wait.coil) | Обращение к $имя без ЖДИ после запуска ДУМАЙ |
| [define-instead-of-set.coil](examples/anti-patterns/define-instead-of-set.coil) | Повторный ОПРЕДЕЛИ вместо ОПРЕДЕЛИ + УСТАНОВИ |
| [send-when-think-needed.coil](examples/anti-patterns/send-when-think-needed.coil) | НАПИШИ ЖДАТЬ другому агенту для работы, которую текущий агент может сделать сам |

### Структура файлов

| Расположение | Что содержит | Нормативный вес |
|---|---|---|
| `tests/` | Тесты соответствия | Нормативный — определяет, что совместимый парсер обязан принимать или отвергать |
| `examples/**/*.coil` | Исполняемые примеры | Документация, проверяемая машиной — иллюстрируют паттерны, но не устанавливают новых норм |
| `examples/**/*.md` | Нарративные примеры | Иллюстративные — COIL-H не фиксирует mapping-норму; блоки COIL-C проверяются парсером, но служат педагогической цели |

Исполняемые примеры не заменяют тесты соответствия. Если паттерн должен быть spec-invalid, нужен выделенный тест в `invalid/`; наличия в `anti-patterns/` недостаточно.

### Метаданные .coil файлов

Каждый `.coil` файл начинается с заголовка метаданных в комментариях:

```coil
' @test valid
' @role pattern
' @status stable
' @dialect ru-standard
' @covers Op.Think, Op.If, Op.Send
' @description Маршрутизация по классификации
```

| Поле | Обязательность | Значения | Описание |
|---|---|---|---|
| `@test` | да | `valid`, `invalid` | Ожидаемый результат парсера |
| `@role` | да | `test`, `pattern`, `demo`, `anti-pattern` | Что содержит файл |
| `@status` | да | `stable`, `mixed` | Нормативный статус |
| `@dialect` | да | код диалекта | Диалект файла |
| `@error` | только invalid | `parse`, `validate` | Фаза ошибки: парсер/лексер бросает или валидатор ловит |
| `@covers` | да | абстрактные ID через запятую | Задействованные конструкции (реестр: [dialects/README.md](dialects/README.md) § 4) |
| `@description` | да | свободный текст | Однострочное описание |

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

В COIL нет диалекта по умолчанию. Диалекты — это наборы ключевых фраз с идентичной семантикой и моделью исполнения — диалект это скин, а не скелет. Примеры в спецификации используют русские ключевые слова, но ни один диалект не привилегирован в реализации.

| Диалект | Код | Директория |
|---|---|---|
| Стандартный русский | `ru-standard` | [dialects/ru-standard](dialects/ru-standard/README.md) |
| Standard English | `en-standard` | [dialects/en-standard](dialects/en-standard/README.md) |
| Español estándar | `es-standard` | [dialects/es-standard](dialects/es-standard/README.md) |
| 简体中文 | `zh-standard` | [dialects/zh-standard](dialects/zh-standard/README.md) |
| 日本語 | `ja-standard` | [dialects/ja-standard](dialects/ja-standard/README.md) |
| Français standard | `fr-standard` | [dialects/fr-standard](dialects/fr-standard/README.md) |
| Português brasileiro | `pt-br-standard` | [dialects/pt-br-standard](dialects/pt-br-standard/README.md) |
| Standarddeutsch | `de-standard` | [dialects/de-standard](dialects/de-standard/README.md) |

Спецификация диалектной таблицы: [dialects/README.md](dialects/README.md).

Правила:

- Один скрипт — один диалект. Смешение ключевых слов из разных диалектов в одном файле недопустимо.
- Сигилы (`$`, `?`, `@`, `!`, `#`, `~`) универсальны и не зависят от диалекта.
- Идентификаторы (имена переменных, участников, инструментов) — свободные и не ограничены языком диалекта.
- Реализация COIL, заявляющая соответствие спецификации, обязана загружать диалекты из внешних диалектных таблиц; обязательная поставка конкретного диалекта не требуется.

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

Animata Systems, 2026
