---
title: "项目实战"
category: projects
order: 5
---

# 项目实战

本章节记录 Learning Log 系统的实际项目案例、实现细节和经验总结。

## 文档列表

| 文档 | 描述 | 状态 |
|------|------|------|
| <!-- 按需添加项目文档 --> | | |

## Learning Log 系统概览

Learning Log 是一个面向开发者的个人知识管理与 AI 协作平台，核心功能包括：

- **智能笔记**：Markdown 编辑、双向链接、全文搜索
- **项目追踪**：任务管理、进度可视化、里程碑
- **AI 协作**：代码生成、文档生成、架构评审
- **知识图谱**：实体提取、关系推理、可视化探索

## 技术亮点

| 特性 | 实现方案 |
|------|----------|
| AI 协作架构 | MCP (Model Context Protocol) + Claude Code |
| 实时同步 | WebSocket + Operational Transform |
| 全文搜索 | PostgreSQL 全文搜索 + 向量检索 |
| 部署方案 | Docker Compose + GitHub Actions CI/CD |

## 相关链接

- [架构设计](../architecture/index.md) - 系统架构详解
- [后端开发指南](../guides/backend.md) - 后端实现规范
- [前端设计系统](../architecture/frontend-design.md) - 前端实现规范
- [API 参考](../reference/api.md) - 接口文档