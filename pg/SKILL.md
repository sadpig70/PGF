---
name: pg
description: "PG (PPR/Gantree) — AI-native intent specification notation. Gantree for hierarchical structure decomposition, PPR for detailed logic with AI_ cognitive functions, → pipelines, and [parallel] blocks. This skill is the notation reference that enables AI to comprehend and execute PG-written documents. Auto-load when encountering Gantree trees, PPR def blocks, AI_ prefixed functions, → pipelines, or any skill/document written in PG notation."
user-invocable: false
disable-model-invocation: false
---

# PG — PPR/Gantree Notation v1.3

> **A DSL with AI as the runtime.**
> Deterministic logic is written in Python; AI cognitive operations are denoted with the `AI_` prefix.
> Together they form a single program — AI reads it and performs the entire task.

PG expresses all AI operations (judgment, reasoning, recognition, creation) at a programming level and makes them executable by the AI runtime. Gantree decomposes structure, and PPR specifies the semantics of each component. It is a communication language between humans and AI, and between AI and AI. A document written in PG is simultaneously a design specification, an execution intent, and a communication medium.

## Quick Start

1. Decompose the task hierarchically with **Gantree** (indentation = hierarchy)
2. Write detailed logic in **PPR `def`** blocks only for complex nodes
3. Use the **`AI_`** prefix where AI judgment is needed; use actual code for precise calculations
4. Embed completion conditions with **`acceptance_criteria`**
5. Execute → Verify → Rework if needed

```
MyTask // task description (in-progress)
    StepA // first step (done)
    StepB // second step (in-progress) @dep:StepA
        # input: data from StepA
        # process: AI_analyze(data) → result
        # criteria: accuracy >= 0.9
```

That is all of PG. Below are the detailed definitions.

---

## Core Properties

### Parser-Free Property

The most important architectural property of PG: **No parser, compiler, or runtime toolchain required.**

- PG documents are composed of notation that AI already understands (Python syntax, indentation hierarchy, function composition)
- AI does not parse PG documents — it **comprehends** them
- A single PG document simultaneously serves 5 roles: design specification, implementation intent, AI execution command, communication medium, organizational contract

### Co-evolutionary Property

A co-evolutionary property where advances in the AI runtime directly improve PG execution quality.

- PG documents produce better results **without modification** as AI models improve
- Conversely, refining PG specifications increases execution accuracy of the same AI
- PG can analyze, design, and verify itself (self-referentiality)

### DL/OCME Paradigm

PG is the first implementation of the DL/OCME (Define Language / Optimized Code for Machine Engineering) paradigm.

- Unlike the 70-year PL/SE paradigm (targeting deterministic machines), PG presupposes AI cognitive runtime as the execution target
- Non-deterministic output from `AI_` functions is not a bug but a **design asset**

### AI-to-AI Communication Layer

PG is designed as the **primary communication layer** for AI-to-AI communication.

- In AI-to-AI communication, natural language is **not** the core execution language
- Natural language is used only as supplementary metadata (`//` comments, `"""docstring"""`) when needed
- Intent, structure, procedure, state, and verification are **directly conveyed** by PG constructs (`AI_`, `→`, `@dep:`, `[parallel]`, `acceptance_criteria`)
- Cross-model compatible: any AI model can immediately understand PG (proven with Claude, Kimi, ChatGPT, Gemini, etc.)

### Limitations of Existing Notations and PG's Solutions

| Existing Limitation | PG's Solution |
|----------|----------|
| No way to express AI capabilities at programming level | **PPR** — specifies cognitive operations at function signature level with `AI_` functions |
| No notation for tracking progress state in trees | **Gantree status codes** — 6 stages: `(done)/(in-progress)/(designing)` etc. |
| Visualization collapses as trees grow | **`(decomposed)`** — max allowed depth 5 levels, separate at level 6 entry |
| Loss of connectivity between separated nodes | Connectivity preserved via **`@dep:`, `→`, decomposed tree references** |

---

## Gantree — Hierarchical Structure

Decompose the system using indentation-based trees.

### Node Syntax

```
NodeName // description (status) [@v:version] [@dep:dependency] [#tag]
```

- **NodeName**: CamelCase identifier
- **// description**: natural language description
- **(status)**: `done` | `in-progress` | `designing` | `blocked` | `decomposed` | `needs-verify`
- **@v:X.Y**: version (used on root nodes)
- **@dep:A,B**: execute after A, B are completed
- **#tag**: classification tag (optional, for search/filtering)
- **[parallel]...[/parallel]**: parallel execution block

### Status Code Execution Rules

| Status | AI Execution Rule |
|--------|-------------|
| `(done)` | Already completed — skip |
| `(in-progress)` | Execute PPR def block |
| `(designing)` | Stub/basic logic only |
| `(blocked)` | Skip |
| `(decomposed)` | Refer to separated tree |
| `(needs-verify)` | Execute then verify → `(done)` if passed, `(designing)` if rework needed, `(blocked)` if unrecoverable |

### Structural Rules

- 4 spaces = 1 level (tabs prohibited)
- Max allowed depth 5 levels; on level 6 entry → separate with `(decomposed)`
- 10+ children → branching required
- `[parallel]` block nesting prohibited (only flat parallelism allowed)
- `@dep:` between nodes inside `[parallel]` blocks prohibited (parallel = independent execution)

### `(decomposed)` Separation Example

When entering depth level 6, separate into a standalone tree and reference from the original:

```
OrderSystem // order system (in-progress)
    PaymentFlow // payment flow — see PaymentFlow tree (decomposed)
    ShippingFlow // shipping flow (designing)

PaymentFlow // separated payment detail tree (in-progress)
    ValidateCard // card validation (done)
    ChargeCard // card charging (in-progress) @dep:ValidateCard
    SendReceipt // receipt sending (designing) @dep:ChargeCard
```

When separating into files: mark `(decomposed)` in the original DESIGN, place the detailed tree in a separate section or separate `.md` file.

### Example

```
PaymentSystem // payment system (in-progress) @v:1.0
    UserDB // user DB connection (done)
    Auth // authentication (done) @dep:UserDB
    [parallel]
    ValidateCard // card validation (done)
    CheckBalance // balance check (done)
    [/parallel]
    ProcessPayment // payment processing (designing) @dep:ValidateCard,CheckBalance
```

### Atomic Node

Diagnostic heuristics (high likelihood of atomicity if 5 or more are satisfied):

1. **I/O clarity** — expressible as a function signature
2. **Single responsibility** — describable in one sentence without "AND"
3. **Implementation complexity** — completable as a single function (typically ≤50 lines)
4. **Time predictability** — AI can write complete code within 15 minutes
5. **Decomposition futility** — further decomposition would be excessive granularity
6. **Independent execution** — external dependencies ≤ 2
7. **Domain independence** — understandable with foundational knowledge only

> **Final decision rule (15-minute rule)**: The 7 heuristics above are diagnostic tools, and the **15-minute rule has final authority**. Even if 5 heuristics are satisfied, if it cannot be completed within 15 minutes → decompose further. Even if only 4 heuristics are satisfied, if it can be completed within 15 minutes → atomic node.

---

## PPR — Detailed Logic

Intent specification that AI understands. Cognitive operations are expressed using Python syntax.

### Data Type Notation

Based on Python type hint syntax, but **relaxed notation is allowed for intent communication**. The goal is not strict Python typing compatibility but for AI to understand I/O structure.

```python
text: str                                          # basic type
user: dict = {"name": str, "age": int}             # schema literal (non-standard Python, allowed in PG)
status: Literal["draft", "review", "published"]    # enumeration
nickname: Optional[str]                            # optional
Section = dict[str, str | list[str] | int]         # type alias
```

### Differences from Python (only 5)

| Notation | Meaning |
|------|------|
| `AI_` prefix | AI cognitive operation declaration |
| `→` | Data pipeline (left→right flow) |
| `[parallel]` | Parallel execution block |
| Relaxed types | For intent communication (strictness not required) |
| import omission | Infrastructure setup can be omitted |

### AI_ Functions

```python
def AI_[verb]_[target](params: Type) -> ReturnType:
    """intent description"""
```

4 cognitive categories:

```python
# Judgment
score: float = AI_assess_quality(text, domain)

# Reasoning
plan: list = AI_generate_plan(goal, constraints)

# Recognition
intent: str = AI_understand_intent(query)

# Creation
content: str = AI_generate_content(brief, style)
```

### AI_make_ Causative Pattern

The `AI_` prefix is an **intransitive** expression where AI directly performs cognition. However, when AI **causes** a change in a target, the `AI_make_` causative pattern is used.

`AI_make_` is **not** a separate 5th cognitive category — causative variants exist for each of the 4 categories (Judgment/Reasoning/Recognition/Creation).

```python
# AI_ — intransitive: AI performs directly
keywords = AI_extract(text)             # AI extracts
score = AI_assess(quality)              # AI assesses

# AI_make_ — causative: AI causes the target to undergo change
evolved = AI_make_evolve(system)        # causes the system to evolve
adapted = AI_make_adapt(behavior, ctx)  # causes the behavior to adapt
converged = AI_make_converge(opinions)  # causes the opinions to converge
differentiated = AI_make_differentiate(cell, env)  # causes the cell to differentiate
```

**Decision order** (when ambiguous):
1. Is the subject of the verb AI itself? → `AI_`
2. Does the object (target) change its own state? → `AI_make_`
3. Cannot determine → use `AI_` (conservative default)

```python
# AI analyzes (AI is the subject)
analysis = AI_analyze(data)

# AI causes the system to self-learn (the system is the agent of change)
learned_system = AI_make_learn(system, feedback)

# AI causes the agents to reach consensus (the agents are the agents of change)
consensus = AI_make_agree(agents, proposal)
```

**The `AI_` prefix system is not an absolute rule but an evolvable system.** As AI model cognitive capabilities expand, new prefix patterns may naturally emerge. This is PG's Co-evolutionary Property.

**Rule**: Use actual code for precise calculations; use `AI_` only where AI judgment is needed.

```python
# ❌ Using AI_ where precision is needed
result = AI_calculate(2 + 2)
formatted = AI_format_date("2024-01-01")

# ✅ Using actual code
result = 2 + 2

# ✅ Using AI_ where AI judgment is needed
analysis: dict = AI_analyze_trend(sales_data: list[float])
```

### → Pipeline

```python
# Basic: left output becomes right input
raw → AI_clean → AI_extract → AI_classify → result

# Branching
input → {
    "sentiment": AI_analyze_sentiment → score,
    "keywords": AI_extract_keywords → words,
}

# Merging: combine multiple results into one
[parallel]
tech = AI_analyze(data, lens="tech")
market = AI_analyze(data, lens="market")
[/parallel]
synthesis = AI_synthesize(tech, market) → result
```

**Error propagation rule**: When a pipeline stage fails (None/exception), the **entire pipeline halts** and returns the output of the last successful stage. To ignore the failed stage and continue, explicitly wrap it with Python `try/except`.

```python
# Default: pipeline halts on stage failure
raw → AI_clean → AI_extract → result
# AI_clean fails → pipeline halts, returns raw

# Explicit error tolerance: wrap with try/except
try:
    result = raw → AI_clean → AI_extract → AI_classify
except:
    result = AI_generate_fallback(raw)
```

### Convergence Loop — AI Self-Improvement Iteration

```python
draft = AI_generate(brief)
while True:
    eval = AI_evaluate(draft, criteria)
    if eval.score >= threshold:
        break
    draft = AI_revise(draft, eval.feedback)
```

Key point: AI evaluates its own output and iterates improvements if below threshold.

### Failure Strategy — Self-Correction on Failure

```python
for attempt in range(max_retry):
    result = AI_execute(task)
    if AI_verify(result, acceptance_criteria):
        return result  # success
    if attempt >= 1:
        task.ppr = AI_redesign(task, result.failure_reason,
                               constraint='preserve_public_interface')
task.status = "blocked"  # final failure
```

Key point: AI can redesign the internal implementation while preserving the public interface.

### acceptance_criteria — Embedded Verification Criteria

```python
def some_task(input: InputType) -> OutputType:
    """task description"""
    # acceptance_criteria:
    #   - all fields included
    #   - AI_assess_quality >= 0.85
    #   - response time < 5 seconds
```

3 types: **Functional** (output satisfaction) | **Qualitative** (AI judgment) | **Structural** (format compliance)

### Flow Control

Uses Python flow control syntax as-is.

```python
# Conditional branching
language = AI_detect_language(input_text)
if language == "ko":
    result = AI_process_korean(input_text)
else:
    result = AI_translate_to_korean(input_text)

# Exception handling
try:
    response = call_external_api(query)
except APIError as e:
    fallback = AI_generate_fallback_response(query, error=str(e))
```

---

## Gantree ↔ PPR Connection

| Node Type | PPR Connection Method | Suitable Scale |
|----------|-------------|----------|
| Simple atomic | Inline — directly write `AI_extract_keywords` | Single call |
| Brief PPR | 3-7 lines of logic as `#` comments under the node | Small-scale (has flow but no def needed) |
| Separate def block | Complete PPR function definition | Medium-scale and above (conditions/loops/types needed) |

**Recommended brief PPR keys** (optional — recommended style, not mandatory):

- `# input:` — input data/type
- `# process:` — processing logic
- `# output:` — output result
- `# criteria:` — completion conditions

```
# Gantree — 3-level representation
TopicAnalyzer // topic analysis (done)              ← separate PPR def (complex)
    AI_extract_keywords // keywords (done)           ← inline (simple)
    AI_classify_topic // classification (done)       ← inline (simple)

DataCleaner // data cleaning (done)                 ← brief PPR (medium)
    # input: raw_data: list[dict]
    # filtered = [d for d in raw_data if d["status"] != "deleted"]
    # cleaned = AI_normalize_fields(filtered)
    # return cleaned
```

```python
# PPR def block — for complex nodes
def topic_analyzer(text: str, domain: Optional[str] = None) -> dict:
    keywords = AI_extract_keywords(text)
    if domain:
        keywords = [k for k in keywords if is_in_domain(k, domain)]
    category = AI_classify_topic(text, hint_keywords=keywords)
    return {"keywords": keywords, "category": category}
```

---

## Progressive Formalization — 3-Level Gradual Formalization

PG **progressively formalizes** from natural language to complete formal specification. Users do not need to know PG syntax from the start.

| Level | Format | Suitable Tasks | PG File Generation |
|---|---|---|---|
| **Level 1** | Single line of natural language | Bug fixes, config changes (≤3 nodes) | None (inline execution) |
| **Level 2** | Gantree + `#` comments | Feature additions, refactoring (4~10 nodes) | Optional |
| **Level 3** | Gantree + PPR `def` + `acceptance_criteria` | System design, large-scale implementation (10+ nodes) | Required |

```python
# Level 1: Execute with natural language only — no PG syntax needed
"Fix clippy warnings in ocwr_daemon"

# Level 2: Gantree + inline comments — just structure
FixClippy // fix clippy warnings (in-progress)
    DaemonCrate // ocwr_daemon (designing)
        # cargo clippy → warning list → fix
    GatewayCrate // ocwr_gateway (designing)

# Level 3: Complete PG specification — large-scale tasks
def fix_clippy(workspace: Path) -> FixResult:
    """Remove all workspace clippy warnings"""
    # acceptance_criteria:
    #   - cargo clippy --workspace -- -D warnings → 0 warnings
```

### Auto-Promotion

When complexity increases during execution, AI automatically promotes to a higher level:
- During Level 1 execution, more than 3 subtasks discovered → promote to Level 2
- During Level 2 execution, verification criteria needed → promote to Level 3
- **Existing completed task states are preserved on promotion**

## 3-Phase Development Process

1. **Gantree Structure Design** — Top-Down BFS hierarchical decomposition → down to atomic nodes
2. **PPR Detailing and Execution** — describe each node with `def` blocks, execute/skip based on status
3. **Self Cross-Verification** — 3-perspective review: **Consistency** (no internal contradictions), **Completeness** (no omissions), **Accuracy** (specification matches execution)

---

## When Encountering a Document Written in PG

1. Gantree tree → identify hierarchy and execution order
2. `(status)` → determine execute/skip
3. `@dep:` → determine dependency order
4. `[parallel]` → parallel processing
5. If PPR `def` present → interpret and execute
6. If `#` brief PPR present → interpret inline comments and execute
7. If `AI_` inline → execute directly
8. If nothing → recurse into child nodes

---

## Checklist

### Gantree Design

- [ ] Are all nodes within 5 levels?
- [ ] Is each node's status clearly marked?
- [ ] Is decomposition sufficient down to atomic nodes?
- [ ] Are node names consistent in CamelCase?
- [ ] Are `@dep:` dependencies marked where needed?
- [ ] Are there no circular `@dep:` references? (Verify via topological sort: no cycles if all nodes can be sorted)
- [ ] Are `[parallel]` eligible regions identified?
- [ ] Is 4-space indentation used inside code blocks?

### PPR Detailing

- [ ] Are PPR `def` blocks written for complex nodes?
- [ ] Are I/O specified with Python type hints?
- [ ] Does flow control follow Python syntax?
- [ ] Are `AI_` functions in snake_case with return types specified?
- [ ] Is the `AI_make_` prefix used for causative meanings (causing a target to change)?
- [ ] Is deterministic logic written as actual code?

### Common Mistakes

| Mistake | Solution |
|------|--------|
| Writing Gantree only, omitting PPR | Complex nodes must have PPR `def` blocks |
| Trying to express all logic in the tree | Separate flow control/types into PPR |
| Exceeding max depth 5 levels (entering level 6) | Separate into standalone tree with `(decomposed)` |
| 10+ child nodes | Add intermediate group nodes |
| Using `AI_` where precision is needed | Use actual code for math/transformations |
| Undefined I/O types | Declare with Python type hints |
