---
title: "API 参考"
category: reference
order: 1
parent: reference/index.md
---

# API 参考

Learning Log 系统 RESTful API 完整接口文档。

## 基础信息

| 项目 | 值 |
|------|-----|
| Base URL | `http://localhost:8000/api/v1` |
| 协议 | HTTP/1.1, HTTPS |
| 格式 | JSON |
| 认证 | Bearer Token (JWT) |

## 通用响应格式

### 成功响应

```json
{
  "success": true,
  "data": {},
  "meta": {
    "timestamp": "2026-01-15T10:30:00Z",
    "request_id": "uuid-v4"
  }
}
```

### 错误响应

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "人类可读的错误描述",
    "details": {}
  },
  "meta": {
    "timestamp": "2026-01-15T10:30:00Z",
    "request_id": "uuid-v4"
  }
}
```

## 认证接口

### 用户注册

```
POST /auth/register
```

**请求体**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "username": "username"
}
```

**响应** (201)
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "username": "username",
      "created_at": "2026-01-15T10:30:00Z"
    },
    "access_token": "jwt-token",
    "refresh_token": "refresh-token"
  }
}
```

### 用户登录

```
POST /auth/login
```

**请求体**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**响应** (200)
```json
{
  "success": true,
  "data": {
    "user": { "id": "uuid", "email": "user@example.com", "username": "username" },
    "access_token": "jwt-token",
    "refresh_token": "refresh-token"
  }
}
```

### 刷新 Token

```
POST /auth/refresh
```

**请求头**
```
Authorization: Bearer <refresh_token>
```

### 用户登出

```
POST /auth/logout
```

**请求头**
```
Authorization: Bearer <access_token>
```

## 用户接口

### 获取当前用户信息

```
GET /users/me
```

**请求头**
```
Authorization: Bearer <access_token>
```

### 更新用户档案

```
PATCH /users/me
```

**请求体**
```json
{
  "username": "newname",
  "avatar_url": "https://example.com/avatar.png",
  "preferences": {
    "theme": "dark",
    "language": "zh-CN"
  }
}
```

## 笔记接口

### 创建笔记

```
POST /notes
```

**请求体**
```json
{
  "title": "笔记标题",
  "content": "# Markdown 内容",
  "tags": ["tag1", "tag2"],
  "project_id": "uuid"
}
```

### 获取笔记列表

```
GET /notes
```

**查询参数**
| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| page | int | 1 | 页码 |
| page_size | int | 20 | 每页数量 |
| tag | string | - | 标签筛选 |
| project_id | uuid | - | 项目筛选 |
| search | string | - | 全文搜索 |

### 获取单篇笔记

```
GET /notes/{note_id}
```

### 更新笔记

```
PATCH /notes/{note_id}
```

### 删除笔记

```
DELETE /notes/{note_id}
```

## 项目接口

### 创建项目

```
POST /projects
```

### 获取项目列表

```
GET /projects
```

### 获取项目详情

```
GET /projects/{project_id}
```

### 更新项目

```
PATCH /projects/{project_id}
```

### 删除项目

```
DELETE /projects/{project_id}
```

## AI 协作接口

### 发起 AI 对话

```
POST /ai/chat
```

**请求体**
```json
{
  "messages": [
    {"role": "user", "content": "帮我写一个 FastAPI 路由"}
  ],
  "model": "claude-3-5-sonnet",
  "tools": ["filesystem", "github"],
  "context": {
    "project_id": "uuid",
    "note_ids": ["uuid"]
  }
}
```

### 生成代码

```
POST /ai/generate/code
```

### 生成文档

```
POST /ai/generate/doc
```

## WebSocket 接口

### 实时协作

```
WS /ws/collaborate/{note_id}
```

**认证**：连接时携带 `?token=<access_token>`

**消息格式**
```json
{
  "type": "operation",
  "payload": {
    "operation": "insert",
    "position": 10,
    "text": "新内容"
  }
}
```

## 错误代码

| HTTP 状态码 | 错误代码 | 说明 |
|-------------|----------|------|
| 400 | VALIDATION_ERROR | 请求参数验证失败 |
| 401 | UNAUTHORIZED | 未认证或 Token 过期 |
| 403 | FORBIDDEN | 权限不足 |
| 404 | NOT_FOUND | 资源不存在 |
| 409 | CONFLICT | 资源冲突 (如邮箱已注册) |
| 422 | UNPROCESSABLE_ENTITY | 语义错误 |
| 429 | RATE_LIMITED | 请求频率限制 |
| 500 | INTERNAL_ERROR | 服务器内部错误 |
| 503 | SERVICE_UNAVAILABLE | 服务暂不可用 |

## 版本控制

- 当前版本：v1
- 版本路径：`/api/v1/`
- 弃用策略：提前 3 个月通知，保留旧版本并行运行

## 相关链接

- [Swagger UI](http://localhost:8000/docs) - 交互式 API 文档
- [ReDoc](http://localhost:8000/redoc) - 替代文档视图
- [配置参考](../configuration.md) - 环境变量配置