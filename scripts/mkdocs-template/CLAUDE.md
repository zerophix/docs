# 项目文档规范

本项目使用 MkDocs 管理文档。任何文档操作前，先读取 `docs/DOC-GUIDE.md`。

## 核心规则

### 目录结构
```
docs/
├── index.md              # 项目仪表盘
├── DOC-GUIDE.md         # 完整文档规范（必读）
├── architecture/         # 架构设计（系统是什么样的）
├── guides/               # 开发指南（怎么开发）
├── reference/            # 参考文档（接口/配置细节）
├── changelog/            # 变更日志（发生了什么变化）
└── notes/                # 笔记（思考、决策记录）
```

### 强制规则
1. **先读后写**：修改文档前先读 `docs/DOC-GUIDE.md` 和 `docs/index.md`
2. **目录归属**：新文档必须放入上述五个目录之一，禁止在 `docs/` 根目录随意创建文件
3. **nav 同步**：新增/删除 `.md` 文件后，必须同步更新 `mkdocs.yml` 的 `nav` 节
4. **index 更新**：新增文档后更新所在目录的 `index.md`
5. **更新优先**：已有相关文档时，优先更新而非新建
6. **单次限量**：一次最多新建 3 个文档文件
7. **文件命名**：`kebab-case`，禁止中文文件名
8. **Front Matter**：每个文档开头包含 `title`，可选 `status`（draft/review/stable/archive）
9. **不编造**：不确定的内容标注 `<!-- TODO: 待确认 -->`

### 目录职责一句话
- `architecture/` → "系统长什么样"
- `guides/` → "怎么用它/怎么开发"
- `reference/` → "具体参数/接口是什么"
- `changelog/` → "发生了什么变化"
- `notes/` → "为什么这么决定"

### 文档模板
```markdown
---
title: "文档标题"
status: draft
---

# 文档标题

> 一句话描述本文档的目的。

---

## 正文
```

### 变更日志
在 `changelog/index.md` 按时间倒序记录，遵循 Keep a Changelog 格式。
