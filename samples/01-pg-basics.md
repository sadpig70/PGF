# Sample 1: PG Basics — Your First Gantree + PPR

## What is PG?

**PG (PPR/Gantree)** is a structured notation for AI to think, plan, and communicate — a native language for AI cognition. It is **not code that runs on a machine**. Instead, AI reads PG documents and directly comprehends and executes the intent.

- **PG** = the language (platform-agnostic, works with any AI)
- **PGF** = a framework built on PG (implemented as a Claude Code skill)

**Why does this matter?** When you tell AI "build me a blog post generator," it produces something — but you can't track progress, verify quality at each step, or pinpoint where things went wrong. PG gives you structured control over AI's workflow while letting AI handle the details.

### Parser-Free: No Framework Required

Unlike LangChain or CrewAI where Python code orchestrates AI calls, PG documents need no parser, compiler, or runtime. AI reads the document and understands it — just like reading a blueprint.

```
# Traditional agent framework (Python code drives AI)
agent = Agent(tools=[search_tool, write_tool])
chain = search_tool | extract_tool | write_tool
result = chain.invoke({"topic": "AI in healthcare"})

# PG approach (AI reads intent directly)
AI_search_topic(topic) → AI_extract_key_points(results) → AI_write_draft(outline)
```

The same PG document produces **better results as AI models improve** — no code changes needed. This is the Co-evolutionary property.

---

## What You'll Learn
- How to decompose a task with **Gantree** (indentation = hierarchy)
- How to write detailed logic with **PPR** (`def` blocks — intent specs, not executable Python)
- The difference between `AI_` operations (AI judgment) and deterministic code (exact logic)

---

## Scenario: Build a Blog Post Generator

### Step 1: Gantree — Decompose the Task

```
BlogPostGenerator // Generate a blog post from a topic (designing)

    ResearchPhase // Gather information (designing)
        AI_search_topic // Search for relevant information (designing)
        AI_extract_key_points // Extract key points from search results (designing)

    WritingPhase // Write the blog post (designing) @dep:ResearchPhase
        AI_generate_outline // Create post structure (designing)
        AI_write_draft // Write first draft (designing)

    ReviewPhase // Review and polish (designing) @dep:WritingPhase
        AI_evaluate_quality // Score the draft (designing)
        AI_revise_draft // Improve based on feedback (designing)
```

**Reading this Gantree:**
- Each line is a **node** (a unit of work)
- Indentation shows **parent-child** relationships
- `//` comments describe what each node does
- `(designing)` is the **status** — this task hasn't started yet
- `@dep:ResearchPhase` means "wait until ResearchPhase is done"

### Status Codes

Every node has a status that tracks its lifecycle:

| Status | Meaning |
|--------|---------|
| `(designing)` | Not started — still being designed |
| `(in-progress)` | Currently being executed |
| `(done)` | Successfully completed |
| `(blocked)` | Cannot proceed — waiting on external dependency |
| `(failed)` | Execution attempted but failed |
| `(skipped)` | Intentionally bypassed |

### Step 2: PPR — Define the Logic

For complex nodes, write a `def` block to specify **how** to execute.

> **Important:** PPR uses Python syntax for readability, but it is **not executable code**. It is an intent specification that AI reads and interprets. Think of it as a blueprint, not a program.

```python
def research_phase(topic: str) -> dict:
    """Gather information about the topic"""

    # AI cognitive operation — AI decides what to search and how
    raw_results = AI_search_topic(topic, max_sources=5)

    # AI cognitive operation — AI judges which points matter
    key_points = AI_extract_key_points(
        results=raw_results,
        criteria="relevance to topic and reader value"
    )

    return {"topic": topic, "key_points": key_points, "sources": raw_results}
```

```python
def review_phase(draft: str) -> str:
    """
    Review and polish until quality threshold met.

    acceptance_criteria:
        score >= 0.85
    """

    while True:
        evaluation = AI_evaluate_quality(draft)  # -> {"score": float, "feedback": str}

        if evaluation["score"] >= 0.85:
            break

        draft = AI_revise_draft(draft, evaluation["feedback"])

    return draft
```

**Reading this PPR:**

| Element | Meaning | Example |
|---------|---------|---------|
| `AI_` prefix | AI makes a judgment call (non-deterministic) | `AI_evaluate_quality(draft)` |
| No prefix | Deterministic logic (exact, repeatable) | `len(results)`, `sorted(...)` |
| `acceptance_criteria` | Completion condition — how we know it's done | `score >= 0.85` |
| `while True` + threshold | **Convergence Loop** — iterate until quality met | Keep revising until score passes |

> **On Convergence Loops:** Won't this loop forever? In PGF, POLICY settings like `max_verify_cycles` cap iterations. See [Sample 2](02-pgf-workflow.md) for details.

### Step 3: Watch It Execute

Once the AI agent reads this PG document, execution proceeds automatically:

```
1. BlogPostGenerator (designing → in-progress)

2. ResearchPhase (designing → in-progress)
   AI_search_topic("AI in healthcare") → 5 articles found
   AI_extract_key_points(articles) → 8 key points extracted
   ResearchPhase → done ✓

3. WritingPhase (designing → in-progress)     ← @dep:ResearchPhase done, unlocked
   AI_generate_outline(key_points) → 4-section outline
   AI_write_draft(outline) → 800-word draft
   WritingPhase → done ✓

4. ReviewPhase (designing → in-progress)      ← @dep:WritingPhase done, unlocked
   AI_evaluate_quality(draft) → score: 0.72   ← below 0.85, revise
   AI_revise_draft(draft, "needs stronger intro")
   AI_evaluate_quality(revised) → score: 0.88 ✓  ← passes threshold
   ReviewPhase → done ✓

5. BlogPostGenerator → done ✓                 ← all children done
```

> No framework executed this. No Python runtime parsed the PPR. The AI read the Gantree structure, understood the dependencies, followed the PPR logic, and made judgment calls at every `AI_` step.

---

## Key Takeaways

| Concept | What It Does | Example |
|---------|-------------|---------|
| **Gantree** | Breaks work into a tree | `WritingPhase // ... (designing)` |
| **Status codes** | Tracks progress | `(designing)` → `(in-progress)` → `(done)` |
| **`@dep:`** | Sets execution order | `@dep:ResearchPhase` |
| **PPR `def`** | Specifies detailed logic (intent, not code) | `def review_phase(draft) -> str:` |
| **`AI_` prefix** | Marks AI judgment calls | `AI_evaluate_quality(draft)` |
| **No prefix** | Deterministic, exact operations | `sorted(results, key=...)` |
| **Convergence Loop** | Iterates until quality met | `while True: ... if score >= 0.85: break` |
| **`acceptance_criteria`** | Defines "done" condition | `score >= 0.85` |

---

## Try It Yourself

Replace the blog post scenario with your own task:
1. List the major phases as top-level Gantree nodes
2. Break each phase into specific steps
3. Add `@dep:` where order matters
4. Write `def` blocks only for the complex steps — remember, these are intent specs, not code
5. Mark everything `(designing)` and let the AI agent execute

**Next:** [Sample 2 — PGF Workflow](02-pgf-workflow.md) shows how PGF automates the full design → plan → execute → verify cycle.
