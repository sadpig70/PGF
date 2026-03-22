# Gantree Design Notation Reference — PGF Extensions

> **Core Gantree syntax** is defined in the **PG skill**:
> Node syntax (`NodeName // desc (status) [@dep:]`), 6 basic status codes,
> indentation rules (4 spaces), `[parallel]`, `@dep:`, atomic node decision (15-minute rule).
>
> This document describes only the **design extension rules** that PGF adds on top of PG.

---

## 1. PGF Additional Status Codes (v2.2)

PGF adds 3 status codes to PG's 6 basic statuses (`done`, `in-progress`, `designing`, `blocked`, `decomposed`, `needs-verify`):

| Status | Meaning | AI Execution Rule |
|---|---|---|
| `(delegated)` | Handoff to another agent completed | Skip (running on remote agent) |
| `(awaiting-return)` | Delegation sent, awaiting result | Poll or wait for notification |
| `(returned)` | Result received, awaiting integration | Verify result + perform integration |

### Delegation State Transitions

```
(designing) → (delegated) → (awaiting-return) → (returned) → (done)
                                                    ↘ (blocked) if validation fails
```

---

## 2. 5-Level Decomposition Rule

When tree depth reaches 5+ levels, split into a separate tree. Mark with `(decomposed)` status.

```
# Before
Root // (in-progress)                          # Level 0
    A // (in-progress)                         # Level 1
        B // (in-progress)                     # Level 2
            C // (in-progress)                 # Level 3
                D // (in-progress)             # Level 4
                    E // (in-progress)         # Level 5 → split

# After
Root → ... → D → E // (decomposed) → see separate tree

E // module E details (in-progress)
    F // sub-module 1 (designing)
    G // sub-module 2 (designing)
```

| Condition | Decision |
|---|---|
| Depth 6+ | Strongly recommended to split |
| Children 10+ | Add intermediate group nodes |
| Independently executable | Split into separate module |

---

## 3. Dependencies and Data Flow

```
PaymentProcessor // (in-progress) @dep:UserAuth,Database
    ValidateCard // (done) @dep:CardAPI
    ProcessTransaction // (designing) @dep:BankGateway

DataPipeline // (in-progress)
    Ingestion // (done) → Transformation
    Transformation // (done) → Validation
    Validation // (in-progress) → Storage
    Storage // (designing)
```

---

## 4. Parallel Execution Notation

```
ImageProcessor // (in-progress)
    [parallel]
    ResizeImage // (done)
    CompressImage // (done)
    WatermarkImage // (done)
    [/parallel]
    SaveImage // (in-progress) @dep:ResizeImage,CompressImage,WatermarkImage
```

---

## 5. Connecting Gantree Nodes to PPR

| Node Type | PPR Connection Method | Suitable Scale |
|---|---|---|
| Simple atomic | Inline — write `AI_extract_keywords` directly | Single call |
| Brief PPR | 3-7 lines of `#` comments under node | Small scale |
| Separate def block | Complete PPR function definition | Medium scale and above |

```
ContentGenSystem // (in-progress)
    TopicAnalyzer // (done)              ← separate PPR def
        AI_extract_keywords // (done)    ← inline
        AI_classify_topic // (done)      ← inline

DataCleaner // (done)                    ← brief PPR
    # input: raw_data: list[dict]
    # cleaned = AI_normalize_fields(filtered)
    # return cleaned
```
