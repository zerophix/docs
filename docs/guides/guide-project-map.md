# Project Map - Learning Repository Organization

> **Philosophy**: Keep everything in one place for cross-pollination of ideas.  
> **Strategy**: Flat structure + metadata tagging + semantic search.

**Last Updated**: 2026-04-06

---

## 📂 Directory Classification

### 🎓 Learning Resources（学习资料）

| Directory | Purpose | Status | Key Takeaways |
|-----------|---------|--------|---------------|
| `JavaGuide/` | Java 面试指南 | Reference | JVM, concurrency, Spring |
| `Learn-Algorithms/` | 算法学习 | Active | LeetCode patterns, interview prep |
| `Principles-of-Accounting-Review-Notes/` | 会计原理 | Archive | Domain knowledge for fintech |
| `interview/` | 面试题库 | Active | STAR-R stories, technical questions |
| `prompts/` | AI Prompts | Active | LLM interaction patterns |

### 🏗️ Reference Projects（参考项目）

| Directory | Tech Stack | What to Learn | Applied To |
|-----------|-----------|---------------|------------|
| `Lottery/` | Spring Boot, DDD | State machine, event-driven | s-pay-mall-lottery |
| `big-market/` | DDD, CQRS | Aggregate design, value objects | s-pay-mall-domain |
| `api-gateway/` | Gateway, filters | Responsibility chain, rate limiting | (future) |
| `JeecgBoot/` | Low-code platform | Code generation, admin UI | (inspiration) |
| `mall/` | E-commerce | Order flow, payment integration | s-pay-mall-app |
| `group-buy-market/` | Group buying | Concurrency control, inventory | s-pay-mall-app |
| `roncoo-pay/` | Payment system | Payment channels, reconciliation | s-pay-mall-app |
| `payment_system/` | Payment architecture | Transaction management | s-pay-mall-domain |

### 🔧 Your Projects（您的项目）

| Directory | Role | Current Focus | Next Steps |
|-----------|------|---------------|------------|
| `s-pay-mall-api/` | API layer | REST endpoints | Add GraphQL? |
| `s-pay-mall-app/` | Application layer | Use cases, orchestration | Refactor services |
| `s-pay-mall-domain/` | Domain layer | Aggregates, entities | Add more value objects |
| `s-pay-mall-infrastructure/` | Infrastructure | Repositories, external APIs | Add caching layer |
| `s-pay-mall-trigger/` | Trigger layer | Event listeners, schedulers | Add MQ consumers |
| `s-pay-mall-types/` | Shared types | DTOs, enums, constants | Extract common lib |
| `s-pay-mall-lottery/` | Lottery module | Probability algorithms | A/B testing framework |
| `s-pay-mall-ddd-market/` | Market module | Promotion engine | Rule engine integration |

### 🛠️ Tooling & Infrastructure（工具和基础设施）

| Directory | Purpose | Usage Frequency |
|-----------|---------|-----------------|
| `.lingma/` | AI assistant config, skills, automation | Daily |
| `scripts/` | Automation scripts (ADR gen, metrics) | Weekly |
| `data/` | Generated artifacts (dashboards, retrospectives) | Weekly |
| `dev-middleware/` | Custom Spring Boot starters | Occasional |
| `dev-tech/dev-ops/` | Docker, MinIO configs | Monthly |
| `xfg-dev/` | Experimental projects | Sporadic |

### 📚 Knowledge Bases（知识库）

| Directory | Content Type | Search Strategy |
|-----------|-------------|-----------------|
| `claude-code-analysis/` | Claude Code internals | Semantic search for patterns |
| `cc-haha/` | Personal notes, experiments | Tag-based retrieval |
| `codeguide/` | Coding standards | Reference during code review |
| `docs/` | Personal documentation | Obsidian graph view |

### 🧪 Experimental/Sandbox（实验区）

| Directory | Experiment | Status |
|-----------|-----------|--------|
| `ai-agent/` | AI agent frameworks | Exploring |
| `ai-mcp-gateway/` | Model Context Protocol | Learning |
| `ai-rag-knowledge/` | RAG implementation | POC phase |
| `drools/` | Rule engine exploration | On hold |
| `source-proj/` | Source code analysis | Archive |

---

## 🔍 Navigation Strategies

### Strategy 1: Semantic Search（语义搜索）

Instead of remembering directory names, use content search:

```bash
# Find all distributed lock implementations
grep -r "RedissonRedLock" */src --include="*.java" -l

# Find state machine examples
grep -r "StateContext\|StateMachine" */src --include="*.java" -l

# Find DDD aggregate examples
grep -r "AggregateRoot" */src --include="*.java" -l
```

### Strategy 2: Tag-Based Retrieval（标签检索）

Use Obsidian tags across all projects:

```markdown
# In any note or code comment:
#domain/order          # Links to order-related code across projects
#pattern/state-machine # Links to state machine implementations
#pitfall/concurrency   # Links to concurrency bug fixes
```

### Strategy 3: Cross-Project Comparison（跨项目对比）

```bash
# Compare how different projects handle the same problem

# Example: How do Lottery and big-market implement repositories?
diff -u \
  Lottery/lottery-infrastructure/src/main/java/.../OrderRepository.java \
  big-market/big-market-infrastructure/src/main/java/.../OrderRepository.java

# Example: Compare state machine implementations
ls */*domain*/src/**/*State*.java
```

### Strategy 4: Learning Pathways（学习路径）

Follow structured learning paths across directories:

**Path 1: Master DDD**
```
1. Read: big-market/docs/ddd-introduction.md
2. Study: big-market/big-market-domain/src/...
3. Compare: Lottery/lottery-domain/src/...
4. Apply: Refactor s-pay-mall-domain/
5. Document: Create ADR in .lingma/skills/
```

**Path 2: Concurrency Control**
```
1. Study: Learn-Algorithms/7 Search/concurrency.md
2. Analyze: group-buy-market/src/.../InventoryService.java
3. Review: s-pay-mall-app/src/.../OrderService.java
4. Implement: Add distributed locks
5. Test: Write concurrency tests
6. Document: Create pitfall card
```

---

## 📊 Project Health Metrics

### Active Projects（活跃项目）
- ✅ s-pay-mall-* (main focus)
- ✅ Learn-Algorithms (daily practice)
- ✅ .lingma/automation (weekly use)

### Reference Projects（参考项目 - 偶尔查阅）
- 📖 Lottery (for state machine patterns)
- 📖 big-market (for DDD patterns)
- 📖 api-gateway (for future features)

### Archive Projects（归档项目 - 很少访问）
- 📦 Principles-of-Accounting-Review-Notes
- 📦 source-proj
- 📦 drools (on hold)

---

## 🎯 Maintenance Rules

### Rule 1: No Deep Nesting
```
✅ Good: s-pay-mall-domain/src/main/java/...
❌ Bad: s-pay-mall-domain/src/main/java/com/spaymall/domain/order/entity/valueobject/...
```

### Rule 2: Clear Naming
```
✅ Good: big-market/, s-pay-mall-domain/
❌ Bad: proj1/, test2/, stuff/
```

### Rule 3: Regular Cleanup
```bash
# Monthly: Archive completed learning paths
# Quarterly: Remove unused dependencies
# Yearly: Reassess project relevance
```

### Rule 4: Documentation Over Structure
```
Instead of creating complex directory hierarchies,
use metadata (tags, comments, docs) to organize.

Example:
- Flat structure: 50 directories at root level
- Rich metadata: tags-taxonomy.md, project-map.md, skills/
```

---

## 💡 Why This Works for You

### Your Cognitive Style（基于您的认知特点）
- **Spatial-Tactile Thinker**: You need to see everything at once
- **Pattern Recognition**: Flat structure helps spot cross-project patterns
- **Iterative Learning**: Easy to jump between theory (JavaGuide) and practice (s-pay-mall)

### Benefits
1. **Serendipity**: Accidentally discover useful patterns while browsing
2. **Context Switching**: Minimal friction when switching topics
3. **Holistic View**: See the big picture of your learning journey
4. **Personalized**: Organized for YOUR brain, not conventional wisdom

---

## 🚀 Future Enhancements

### Idea 1: Unified Search Index
```bash
# Build a search index across all projects
python3 scripts/build-search-index.py

# Then search semantically:
python3 scripts/search.py "distributed lock implementation"
```

### Idea 2: Cross-Project Knowledge Graph
```
Use Obsidian to link concepts across projects:
- [[Lottery/State-Machine]] → applied in → [[s-pay-mall-lottery/OrderStatus]]
- [[big-market/Money-VO]] → inspired → [[s-pay-mall-domain/Money]]
```

### Idea 3: Automated Learning Recommendations
```python
# Based on recent activity, suggest next steps:
if studied("state-machine") and implemented("order-status"):
    recommend("big-market/event-sourcing")
```

---

**Remember**: Chaos is just unstructured complexity. With the right metadata and tools, 
your "messy" repository becomes a powerful personal knowledge engine! 🚀
