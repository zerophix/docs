---
title: "配置说明"
category: getting-started
order: 4
parent: getting-started/index.md
---

# 配置说明

本文档详细说明 Learning Log 系统的所有配置选项、环境变量和配置文件。

## 环境变量

### 核心配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `APP_ENV` | string | `development` | 否 | 运行环境: development/staging/production |
| `APP_HOST` | string | `0.0.0.0` | 否 | 服务监听地址 |
| `APP_PORT` | int | `8000` | 否 | 服务监听端口 |
| `DEBUG` | bool | `true` | 否 | 调试模式开关 |

### 数据库配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `DATABASE_URL` | string | - | 是 | PostgreSQL 连接字符串 |
| `DATABASE_POOL_SIZE` | int | `10` | 否 | 连接池大小 |
| `DATABASE_MAX_OVERFLOW` | int | `20` | 否 | 连接池溢出数 |
| `DATABASE_ECHO` | bool | `false` | 否 | SQL 日志开关 |

示例：
```bash
DATABASE_URL=postgresql://user:password@localhost:5432/learning_log_dev
```

### Redis 配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `REDIS_URL` | string | `redis://localhost:6379/0` | 否 | Redis 连接字符串 |
| `REDIS_MAX_CONNECTIONS` | int | `50` | 否 | 最大连接数 |

### 认证配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `JWT_SECRET` | string | - | 是 | JWT 签名密钥 (生产环境必须修改) |
| `JWT_ALGORITHM` | string | `HS256` | 否 | JWT 签名算法 |
| `JWT_EXPIRE_MINUTES` | int | `30` | 否 | Access Token 过期时间(分钟) |
| `REFRESH_TOKEN_EXPIRE_DAYS` | int | `7` | 否 | Refresh Token 过期时间(天) |
| `BCRYPT_ROUNDS` | int | `12` | 否 | 密码哈希轮数 |

### CORS 配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `CORS_ORIGINS` | string | `*` | 否 | 允许的源，逗号分隔 |
| `CORS_ALLOW_CREDENTIALS` | bool | `true` | 否 | 允许凭证 |
| `CORS_ALLOW_METHODS` | string | `*` | 否 | 允许的 HTTP 方法 |
| `CORS_ALLOW_HEADERS` | string | `*` | 否 | 允许的请求头 |

示例：
```bash
CORS_ORIGINS=http://localhost:5173,https://app.example.com
```

### MCP 服务器配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `MCP_SERVERS` | JSON | `{}` | 否 | MCP 服务器配置对象 |

示例 (`cline_mcp_settings.json`)：
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/workspace"],
      "disabled": false
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your-token"
      }
    }
  }
}
```

### 文件存储配置

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `STORAGE_BACKEND` | string | `local` | 否 | 存储后端: local/s3/minio |
| `STORAGE_LOCAL_PATH` | string | `./data/uploads` | 否 | 本地存储路径 |
| `STORAGE_S3_BUCKET` | string | - | 否 | S3 存储桶 |
| `STORAGE_S3_REGION` | string | `us-east-1` | 否 | S3 区域 |

### 监控与日志

| 变量名 | 类型 | 默认值 | 必填 | 说明 |
|--------|------|--------|------|------|
| `LOG_LEVEL` | string | `INFO` | 否 | 日志级别: DEBUG/INFO/WARNING/ERROR |
| `LOG_FORMAT` | string | `json` | 否 | 日志格式: json/text |
| `SENTRY_DSN` | string | - | 否 | Sentry DSN (生产环境) |
| `PROMETHEUS_ENABLED` | bool | `false` | 否 | Prometheus 指标开关 |

## 配置文件优先级

1. **环境变量** (最高优先级)
2. **`.env.local`** - 本地开发覆盖
3. **`.env`** - 项目默认配置
4. **代码默认值** (最低优先级)

## 配置验证

启动时会自动验证必填配置，缺失时抛出错误：

```bash
# 验证配置
python -m app.config validate
```

## 环境差异配置

| 配置项 | Development | Staging | Production |
|--------|-------------|---------|------------|
| `DEBUG` | `true` | `false` | `false` |
| `LOG_LEVEL` | `DEBUG` | `INFO` | `WARNING` |
| `CORS_ORIGINS` | `*` | 具体域名 | 具体域名 |
| `JWT_SECRET` | 固定值 | 密钥管理 | 密钥管理 |
| `DATABASE_ECHO` | `true` | `false` | `false` |

## 下一步

- [快速上手](quickstart.md) - 启动开发服务器
- [参考文档](../reference/configuration.md) - 完整配置参考