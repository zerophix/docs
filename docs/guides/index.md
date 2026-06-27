---
title: "开发指南"
category: guides
order: 3
---

# 开发指南

本章节包含 Learning Log 系统的开发规范、最佳实践和技术指南。

## 文档列表

| 文档 | 描述 | 状态 |
|------|------|------|
| [后端开发指南](backend.md) | 后端开发规范、数据库设计、API 实现模式 | Draft |
| [前端开发指南](frontend.md) | 前端组件开发、状态管理、样式规范 | Draft |
| [API 设计指南](api-design.md) | RESTful API 设计原则、版本控制、错误处理 | Draft |
| [测试策略](testing.md) | 单元测试、集成测试、E2E 测试策略与工具 | Draft |

## 核心原则

- **类型安全**：TypeScript 严格模式 + Python 类型提示
- **测试驱动**：核心逻辑必须有单元测试覆盖
- **文档优先**：新增 API 先写文档再写代码
- **约定优于配置**：遵循项目既定的代码风格与目录结构

## 技术栈概览

| 层级 | 技术栈 |
|------|--------|
| 后端 | FastAPI + SQLAlchemy + PostgreSQL |
| 前端 | React 18 + TypeScript + Vite + Tailwind CSS |
| AI 协作 | Claude Code + MCP (Model Context Protocol) |
| 部署 | Docker + Docker Compose |

## 相关链接

- [架构设计](../architecture/index.md) - 系统整体架构
- [API 参考](../reference/api.md) - 接口规范
- [配置参考](../reference/configuration.md) - 环境变量与配置