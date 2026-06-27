---
title: "配置参考"
category: reference
order: 2
parent: reference/index.md
---

# 配置参考

完整的环境变量、配置文件和 MCP 服务器配置参考。

## 环境变量完整列表

### 应用核心

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `APP_ENV` | enum | `development` | 否 | `development` \| `staging` \| `production` |
| `APP_HOST` | string | `0.0.0.0` | 否 | 绑定地址 |
| `APP_PORT` | int | `8000` | 否 | 监听端口 |
| `DEBUG` | bool | `true` | 否 | 调试模式 |
| `SECRET_KEY` | string | - | 是 | 应用密钥，用于会话加密等 |

### 数据库

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `DATABASE_URL` | string | - | 是 | PostgreSQL DSN |
| `DATABASE_POOL_SIZE` | int | `10` | 否 | 连接池核心大小 |
| `DATABASE_MAX_OVERFLOW` | int | `20` | 否 | 连接池最大溢出 |
| `DATABASE_POOL_TIMEOUT` | int | `30` | 否 | 获取连接超时(秒) |
| `DATABASE_POOL_RECYCLE` | int | `3600` | 否 | 连接回收间隔(秒) |
| `DATABASE_ECHO` | bool | `false` | 否 | 打印 SQL 语句 |

### Redis

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `REDIS_URL` | string | `redis://localhost:6379/0` | 否 | Redis DSN |
| `REDIS_MAX_CONNECTIONS` | int | `50` | 否 | 连接池上限 |
| `REDIS_SOCKET_TIMEOUT` | int | `5` | 否 | Socket 超时(秒) |
| `REDIS_SOCKET_CONNECT_TIMEOUT` | int | `5` | 否 | 连接超时(秒) |

### 认证与安全

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `JWT_SECRET` | string | - | 是 | JWT 签名密钥 (>=32 字符) |
| `JWT_ALGORITHM` | string | `HS256` | 否 | 签名算法 |
| `JWT_EXPIRE_MINUTES` | int | `30` | 否 | Access Token TTL |
| `REFRESH_TOKEN_EXPIRE_DAYS` | int | `7` | 否 | Refresh Token TTL |
| `BCRYPT_ROUNDS` | int | `12` | 否 | 密码哈希成本 |
| `PASSWORD_MIN_LENGTH` | int | `8` | 否 | 密码最小长度 |
| `RATE_LIMIT_REQUESTS` | int | `100` | 否 | 每分钟请求限制 |
| `RATE_LIMIT_WINDOW` | int | `60` | 否 | 限流窗口(秒) |

### CORS

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `CORS_ORIGINS` | string | `*` | 否 | 允许的源，逗号分隔 |
| `CORS_ALLOW_CREDENTIALS` | bool | `true` | 否 | 允许携带凭证 |
| `CORS_ALLOW_METHODS` | string | `*` | 否 | 允许的方法 |
| `CORS_ALLOW_HEADERS` | string | `*` | 否 | 允许的头部 |
| `CORS_EXPOSE_HEADERS` | string | - | 否 | 暴露的头部 |
| `CORS_MAX_AGE` | int | `600` | 否 | 预检缓存(秒) |

### 文件存储

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `STORAGE_BACKEND` | enum | `local` | 否 | `local` \| `s3` \| `minio` |
| `STORAGE_LOCAL_PATH` | string | `./data/uploads` | 否 | 本地存储根目录 |
| `STORAGE_MAX_FILE_SIZE` | int | `10485760` | 否 | 最大文件大小(字节，默认 10MB) |
| `STORAGE_ALLOWED_TYPES` | string | `image/*,application/pdf,text/*` | 否 | 允许的 MIME 类型 |

#### S3/MinIO 配置 (STORAGE_BACKEND=s3|minio 时生效)

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `STORAGE_S3_ENDPOINT` | string | - | 是 | S3/MinIO Endpoint |
| `STORAGE_S3_BUCKET` | string | - | 是 | 存储桶名称 |
| `STORAGE_S3_REGION` | string | `us-east-1` | 否 | 区域 |
| `STORAGE_S3_ACCESS_KEY` | string | - | 是 | Access Key |
| `STORAGE_S3_SECRET_KEY` | string | - | 是 | Secret Key |
| `STORAGE_S3_USE_SSL` | bool | `true` | 否 | 使用 HTTPS |

### 邮件服务

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `SMTP_HOST` | string | - | 否 | SMTP 服务器 |
| `SMTP_PORT` | int | `587` | 否 | SMTP 端口 |
| `SMTP_USER` | string | - | 否 | 用户名 |
| `SMTP_PASSWORD` | string | - | 否 | 密码 |
| `SMTP_USE_TLS` | bool | `true` | 否 | 使用 TLS |
| `EMAIL_FROM` | string | `noreply@example.com` | 否 | 发件人地址 |
| `EMAIL_FROM_NAME` | string | `Learning Log` | 否 | 发件人名称 |

### 监控与日志

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `LOG_LEVEL` | enum | `INFO` | 否 | `DEBUG`\|`INFO`\|`WARNING`\|`ERROR` |
| `LOG_FORMAT` | enum | `json` | 否 | `json`\|`text` |
| `LOG_FILE` | string | - | 否 | 日志文件路径 |
| `SENTRY_DSN` | string | - | 否 | Sentry DSN |
| `SENTRY_TRACES_SAMPLE_RATE` | float | `0.1` | 否 | 追踪采样率 |
| `PROMETHEUS_ENABLED` | bool | `false` | 否 | 启用 Prometheus 指标 |
| `PROMETHEUS_PORT` | int | `9090` | 否 | 指标端口 |

### AI 服务

| 变量 | 类型 | 默认值 | 必填 | 描述 |
|------|------|--------|------|------|
| `AI_PROVIDER` | enum | `anthropic` | 否 | `anthropic` \| `openai` |
| `AI_API_KEY` | string | - | 是 | API 密钥 |
| `AI_DEFAULT_MODEL` | string | `claude-3-5-sonnet-20241022` | 否 | 默认模型 |
| `AI_MAX_TOKENS` | int | `4096` | 否 | 最大 Token 数 |
| `AI_TEMPERATURE` | float | `0.7` | 否 | 采样温度 |

## 配置文件

### .env 示例

```bash
# 应用
APP_ENV=development
APP_HOST=0.0.0.0
APP_PORT=8000
DEBUG=true
SECRET_KEY=your-secret-key-min-32-chars

# 数据库
DATABASE_URL=postgresql://user:pass@localhost:5432/learning_log_dev
DATABASE_POOL_SIZE=10
DATABASE_ECHO=true

# Redis
REDIS_URL=redis://localhost:6379/0

# 认证
JWT_SECRET=your-jwt-secret-min-32-chars
JWT_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS
CORS_ORIGINS=http://localhost:5173,http://localhost:3000

# 存储
STORAGE_BACKEND=local
STORAGE_LOCAL_PATH=./data/uploads

# 邮件 (可选)
# SMTP_HOST=smtp.example.com
# SMTP_PORT=587
# SMTP_USER=user@example.com
# SMTP_PASSWORD=password
# EMAIL_FROM=noreply@example.com

# 监控 (可选)
LOG_LEVEL=DEBUG
LOG_FORMAT=text
# SENTRY_DSN=https://xxx@sentry.io/xxx

# AI (可选)
# AI_PROVIDER=anthropic
# AI_API_KEY=sk-xxx
```

### cline_mcp_settings.json 示例

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/mingxilv/dolphinmind"
      ],
      "disabled": false,
      "autoApprove": []
    },
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_TOKEN": "ghp_xxx"
      },
      "disabled": false
    },
    "sqlite": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sqlite",
        "./data/learning_log.db"
      ],
      "disabled": false
    }
  }
}
```

## 配置验证脚本

```python
# app/config.py
from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional
import json

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore"
    )
    
    # 必填字段会在实例化时自动验证
    APP_ENV: str = "development"
    DATABASE_URL: str
    JWT_SECRET: str
    SECRET_KEY: str
    
    # 可选字段带默认值
    APP_HOST: str = "0.0.0.0"
    APP_PORT: int = 8000
    DEBUG: bool = True
    
    # 复杂类型
    CORS_ORIGINS: str = "*"
    MCP_SERVERS: str = "{}"
    
    @property
    def cors_origins_list(self) -> list[str]:
        return [o.strip() for o in self.CORS_ORIGINS.split(",")]
    
    @property
    def mcp_servers_dict(self) -> dict:
        return json.loads(self.MCP_SERVERS)

settings = Settings()

# 使用
# from app.config import settings
# settings.DATABASE_URL
```

## 相关链接

- [快速开始 - 配置说明](../getting-started/configuration.md) - 环境差异配置表
- [API 参考](api.md) - 接口文档