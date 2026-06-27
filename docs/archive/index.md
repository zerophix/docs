---
title: "归档"
category: archive
order: 8
---

# 归档

本章节归档已废弃、已完成或历史版本的文档，供参考使用。

## 文档列表

| 分类 | 文档 | 状态 | 归档时间 |
|------|------|------|----------|
| 旧版架构 | [v1 后端设计](v1-backend-design.md) | Archived | 2026-01-10 |
| 旧版架构 | [v1 前端设计](v1-frontend-design.md) | Archived | 2026-01-10 |
| 旧版协作 | [v1 AI 协作机制](v1-ai-collaboration.md) | Archived | 2026-01-10 |
| 废弃方案 | [GraphQL API 方案](deprecated-graphql.md) | Archived | 2026-01-12 |
| 废弃方案 | [微服务拆分方案](deprecated-microservices.md) | Archived | 2026-01-12 |

## 归档规范

1. **归档而非删除**：保留历史文档以便回溯决策背景
2. **明确标记**：文件名以 `v{版本}-` 或 `deprecated-` 前缀开头
3. **Frontmatter 标记**：`status: archived` 且包含 `archived_date`
4. **交叉引用**：在现行文档中链接归档版本说明废弃原因

## 版本历史

| 版本 | 日期 | 主要变更 | 迁移指南 |
|------|------|----------|----------|
| v2.0 | 2026-01-15 | 重构为分层架构，引入 MCP 协议 | [迁移指南](../guides/migration-v2.md) |
| v1.0 | 2025-12-01 | 初始版本，单体应用 | - |

## 相关链接

- [架构设计](../architecture/index.md) - 当前架构文档
- [开发指南](../guides/index.md) - 当前开发规范
- [ADR 记录](../notes/index.md#架构决策) - 架构决策历史