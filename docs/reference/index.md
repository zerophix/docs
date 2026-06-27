---
title: "参考文档"
category: reference
order: 4
---

# 参考文档

本章节提供 Learning Log 系统的完整技术参考，包括 API 接口、配置选项、错误代码和常见问题。

## 文档列表

| 文档 | 描述 | 状态 |
|------|------|------|
| [API 参考](api.md) | 完整的 RESTful API 接口文档 | Draft |
| [配置参考](configuration.md) | 环境变量、配置文件、MCP 服务器配置 | Draft |
| [错误代码](error-codes.md) | 标准化错误代码定义与处理指南 | Draft |
| [常见问题](faq.md) | 开发、部署、运维常见问题解答 | Draft |

## API 快速导航

### 核心模块

| 模块 | 基础路径 | 描述 |
|------|----------|------|
| 认证 | `/api/v1/auth` | 登录、注册、Token 刷新 |
| 用户 | `/api/v1/users` | 用户档案、偏好设置 |
| 笔记 | `/api/v1/notes` | 笔记 CRUD、搜索、标签 |
| 项目 | `/api/v1/projects` | 项目管理、进度追踪 |
| AI 协作 | `/api/v1/ai` | AI 对话、代码生成、文档生成 |

### 公共响应格式

```json
{
  "success": true,
  "data": {},
  "meta": {
    "timestamp": "2026-01-15T10:30:00Z",
    "request_id": "uuid"
  }
}
```

## 配置快速导航

| 配置项 | 环境变量 | 默认值 | 必填 |
|--------|----------|--------|------|
| 数据库 URL | `DATABASE_URL` | - | 是 |
| JWT 密钥 | `JWT_SECRET` | - | 是 |
| CORS 域名 | `CORS_ORIGINS` | `*` | 否 |
| MCP 服务器 | `MCP_SERVERS` | `{}` | 否 |

## 相关链接

- [开发指南](../guides/index.md) - 开发规范与最佳实践
- [架构设计](../architecture/index.md) - 系统整体架构
- [快速开始](../getting-started/index.md) - 环境搭建与启动