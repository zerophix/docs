---
title: "错误代码"
category: reference
order: 3
parent: reference/index.md
---

# 错误代码参考

Learning Log 系统标准化错误代码定义与处理指南。

## 错误响应格式

所有 API 错误响应遵循统一格式：

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "请求参数验证失败",
    "details": [
      {
        "field": "email",
        "message": "邮箱格式不正确",
        "code": "INVALID_FORMAT"
      }
    ]
  },
  "meta": {
    "timestamp": "2026-01-15T10:30:00Z",
    "request_id": "uuid-v4"
  }
}
```

## HTTP 状态码映射

| HTTP 状态码 | 错误代码 | 说明 |
|-------------|----------|------|
| 400 | `VALIDATION_ERROR` | 请求参数验证失败 |
| 400 | `BAD_REQUEST` | 请求格式错误 |
| 401 | `UNAUTHORIZED` | 未认证或 Token 无效/过期 |
| 401 | `TOKEN_EXPIRED` | Access Token 过期 |
| 401 | `INVALID_TOKEN` | Token 签名无效 |
| 403 | `FORBIDDEN` | 权限不足 |
| 403 | `RESOURCE_FORBIDDEN` | 资源访问被拒绝 |
| 404 | `NOT_FOUND` | 资源不存在 |
| 404 | `ROUTE_NOT_FOUND` | 路由不存在 |
| 409 | `CONFLICT` | 资源冲突 (如邮箱已注册) |
| 409 | `DUPLICATE_RESOURCE` | 重复资源 |
| 422 | `UNPROCESSABLE_ENTITY` | 语义错误，参数格式正确但业务逻辑不通过 |
| 429 | `RATE_LIMITED` | 请求频率超限 |
| 500 | `INTERNAL_ERROR` | 服务器内部错误 |
| 500 | `DATABASE_ERROR` | 数据库操作失败 |
| 503 | `SERVICE_UNAVAILABLE` | 服务暂不可用 |
| 503 | `DEPENDENCY_UNAVAILABLE` | 依赖服务不可用 (Redis, AI 等) |

## 业务错误代码

### 认证模块 (`AUTH_`)

| 代码 | HTTP | 消息 | 说明 |
|------|------|------|------|
| `AUTH_INVALID_CREDENTIALS` | 401 | 邮箱或密码错误 | 登录失败 |
| `AUTH_ACCOUNT_LOCKED` | 403 | 账户已锁定 | 多次失败锁定 |
| `AUTH_ACCOUNT_DISABLED` | 403 | 账户已禁用 | 管理员禁用 |
| `AUTH_EMAIL_NOT_VERIFIED` | 403 | 邮箱未验证 | 需要验证邮箱 |
| `AUTH_PASSWORD_TOO_WEAK` | 422 | 密码强度不足 | 不满足策略要求 |
| `AUTH_TOKEN_REFRESH_FAILED` | 401 | Token 刷新失败 | Refresh Token 无效/过期 |
| `AUTH_MFA_REQUIRED` | 401 | 需要双因子认证 | MFA 强制开启 |

### 用户模块 (`USER_`)

| 代码 | HTTP | 消息 | 说明 |
|------|------|------|------|
| `USER_NOT_FOUND` | 404 | 用户不存在 | |
| `USER_EMAIL_EXISTS` | 409 | 邮箱已被注册 | |
| `USER_USERNAME_EXISTS` | 409 | 用户名已被占用 | |
| `USER_PROFILE_INCOMPLETE` | 422 | 资料不完整 | 必填字段缺失 |

### 笔记模块 (`NOTE_`)

| 代码 | HTTP | 消息 | 说明 |
|------|------|------|------|
| `NOTE_NOT_FOUND` | 404 | 笔记不存在 | |
| `NOTE_ACCESS_DENIED` | 403 | 无权访问该笔记 | 私有笔记 |
| `NOTE_TITLE_REQUIRED` | 422 | 笔记标题不能为空 | |
| `NOTE_CONTENT_TOO_LARGE` | 422 | 笔记内容过大 | 超过限制 |
| `NOTE_TAG_LIMIT_EXCEEDED` | 422 | 标签数量超限 | 最多 20 个 |

### 项目模块 (`PROJECT_`)

| 代码 | HTTP | 消息 | 说明 |
|------|------|------|------|
| `PROJECT_NOT_FOUND` | 404 | 项目不存在 | |
| `PROJECT_ACCESS_DENIED` | 403 | 无权访问该项目 | |
| `PROJECT_NAME_REQUIRED` | 422 | 项目名称不能为空 | |
| `PROJECT_MEMBER_LIMIT` | 422 | 成员数量超限 | |

### AI 协作模块 (`AI_`)

| 代码 | HTTP | 消息 | 说明 |
|------|------|------|------|
| `AI_SERVICE_UNAVAILABLE` | 503 | AI 服务暂不可用 | 依赖服务故障 |
| `AI_RATE_LIMITED` | 429 | AI 请求频率超限 | 配额用尽 |
| `AI_TOKEN_LIMIT_EXCEEDED` | 422 | 输入 Token 超限 | 上下文过长 |
| `AI_CONTENT_FILTERED` | 400 | 内容被安全策略拦截 | 敏感内容 |
| `AI_MODEL_ERROR` | 500 | 模型推理错误 | 上游模型异常 |

### 文件存储 (`STORAGE_`)

| 代码 | HTTP | 消息 | 说明 |
|------|------|------|------|
| `STORAGE_FILE_TOO_LARGE` | 422 | 文件大小超限 | 超过配置限制 |
| `STORAGE_INVALID_TYPE` | 422 | 不支持的文件类型 | MIME 类型不在白名单 |
| `STORAGE_UPLOAD_FAILED` | 500 | 文件上传失败 | 存储后端错误 |
| `STORAGE_QUOTA_EXCEEDED` | 422 | 存储配额已满 | 用户配额用尽 |

## 客户端处理建议

### 可重试错误 (指数退避)

- `RATE_LIMITED` (429) - 等待 `Retry-After` 头指示时间
- `SERVICE_UNAVAILABLE` (503) - 重试 3 次，间隔 1s, 2s, 4s
- `DEPENDENCY_UNAVAILABLE` (503) - 同 503
- `AI_SERVICE_UNAVAILABLE` (503) - 同 503
- `AI_RATE_LIMITED` (429) - 等待更长时间 (60s+)

### 需用户干预

- `UNAUTHORIZED` / `TOKEN_EXPIRED` - 重定向登录页
- `FORBIDDEN` / `RESOURCE_FORBIDDEN` - 提示权限不足
- `VALIDATION_ERROR` / `UNPROCESSABLE_ENTITY` - 显示字段级错误
- `CONFLICT` / `DUPLICATE_RESOURCE` - 提示冲突详情

### 记录上报

所有 5xx 错误自动上报 Sentry，包含：
- `request_id`
- 用户 ID (如已认证)
- 完整堆栈跟踪
- 请求参数 (脱敏后)

## 相关链接

- [API 参考](api.md) - 接口定义
- [配置参考](configuration.md) - 限流、错误处理配置