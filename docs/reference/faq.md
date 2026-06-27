---
title: "常见问题"
category: reference
order: 4
parent: reference/index.md
---

# 常见问题 (FAQ)

Learning Log 系统开发、部署、运维常见问题解答。

## 环境搭建

### Q: PostgreSQL 连接失败 "connection refused"

**A:** 检查以下几点：
1. PostgreSQL 服务是否运行：`brew services list` / `systemctl status postgresql`
2. 端口是否正确：默认 5432，检查 `postgresql.conf` 中的 `port` 设置
3. 认证方式：`pg_hba.conf` 是否允许密码认证 (`md5` 或 `scram-sha-256`)
4. 防火墙：云服务器需开放安全组 5432 端口

### Q: Redis 连接超时

**A:** 
1. 确认 Redis 服务运行：`redis-cli ping`
2. 检查 `REDIS_URL` 格式：`redis://[:password@]host:port/db`
3. 云 Redis 需配置白名单/安全组
4. 连接池配置过大可能耗尽连接，调整 `REDIS_MAX_CONNECTIONS`

### Q: Python 依赖安装失败 (特别是 `psycopg2`, `lxml` 等)

**A:**
```bash
# macOS
brew install postgresql libpq
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
pip install psycopg2-binary

# Ubuntu
sudo apt install libpq-dev python3-dev build-essential
pip install psycopg2-binary
```

### Q: Node.js 依赖安装慢 / 失败

**A:**
```bash
# 使用国内镜像
npm config set registry https://registry.npmmirror.com
# 或
pnpm config set registry https://registry.npmmirror.com

# 清理缓存重试
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

## 开发调试

### Q: 后端热重载不生效

**A:** 
1. 确保使用 `uvicorn app.main:app --reload`
2. 检查文件监听限制：`echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p`
3. Docker 环境需挂载源码卷且开启 `--reload`

### Q: 前端修改不生效 / 白屏

**A:**
1. 清理 Vite 缓存：`rm -rf node_modules/.vite && npm run dev`
2. 检查浏览器控制台错误 (F12)
3. 确认 `import` 路径大小写正确 (Linux 区分大小写)
4. 环境变量需以 `VITE_` 前缀：`VITE_API_URL`

### Q: 数据库迁移失败

**A:**
```bash
# 查看当前版本
alembic current

# 查看历史
alembic history

# 回滚一步
alembic downgrade -1

# 重新生成迁移 (谨慎)
alembic revision --autogenerate -m "description"
alembic upgrade head
```

### Q: TypeScript 类型报错但运行正常

**A:**
1. 重启 TS Server：VS Code `Cmd+Shift+P` → `TypeScript: Restart TS Server`
2. 检查 `tsconfig.json` 的 `baseUrl` 和 `paths` 配置
3. 确保 `@types/*` 包版本匹配
4. 运行 `npm run typecheck` 查看完整错误

## 部署运维

### Q: Docker 构建失败 "no space left on device"

**A:**
```bash
# 清理 Docker 资源
docker system prune -a --volumes

# 或增加 Docker Desktop 磁盘配额 (macOS/Windows)
```

### Q: 生产环境 CORS 报错

**A:**
1. 确保 `CORS_ORIGINS` 包含生产域名 (不含末尾斜杠)
2. `CORS_ALLOW_CREDENTIALS=true` 时 `CORS_ORIGINS` 不能为 `*`
3. 检查 Nginx/反向代理是否转发 `Origin` 头

### Q: JWT Token 频繁过期 / 刷新失败

**A:**
1. 检查服务器时间同步 (NTP)
2. `JWT_EXPIRE_MINUTES` 设置是否过短 (建议 30-15-60 分钟)
3. `REFRESH_TOKEN_EXPIRE_DAYS` 确保足够长 (7-30 天)
4. 客户端需在 Access Token 过期前主动刷新 (如提前 5 分钟)

### Q: 文件上传失败 "413 Payload Too Large"

**A:**
```nginx
# Nginx 配置
client_max_body_size 50M;

# 或应用层配置
# STORAGE_MAX_FILE_SIZE=52428800  # 50MB
```

### Q: 生产环境数据库连接池耗尽

**A:**
1. 增加 `DATABASE_POOL_SIZE` 和 `DATABASE_MAX_OVERFLOW`
2. 检查是否有长事务/未关闭连接
3. 启用 `DATABASE_POOL_RECYCLE` 定期回收
4. 监控连接数：`SELECT count(*) FROM pg_stat_activity;`

### Q: WebSocket 连接频繁断开

**A:**
1. Nginx 需配置 WebSocket 代理：
```nginx
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
proxy_read_timeout 86400;
```
2. 负载均衡需开启 Sticky Session
3. 检查客户端重连逻辑 (指数退避)

## AI 协作

### Q: MCP 服务器启动失败

**A:**
1. 检查 Node.js 版本 (需 18+)
2. 确认 `npx` 可用
3. 查看具体 MCP Server 日志
4. 权限问题：文件系统 Server 需读取目录权限

### Q: AI 请求超时

**A:**
1. 增加代理/网关超时时间 (建议 120s+)
2. 检查 `AI_MAX_TOKENS` 设置
3. 复杂任务拆分为多轮对话
4. 启用流式响应减少感知延迟

### Q: AI 返回内容被截断

**A:**
1. 增加 `AI_MAX_TOKENS` (默认 4096，最大视模型而定)
2. 调整 `AI_TEMPERATURE` 降低随机性
3. 使用 `system prompt` 限制输出长度

## 性能优化

### Q: API 响应慢

**A:**
1. 开启 `DATABASE_ECHO=false` 生产环境
2. 添加数据库索引 (查看 `EXPLAIN ANALYZE`)
3. 启用 Redis 缓存热点数据
4. 使用连接池、异步 IO
5. 启用 `PROMETHEUS_ENABLED` 监控指标

### Q: 前端首屏加载慢

**A:**
1. 代码分割：`import('./HeavyComponent')` 懒加载
2. 启用 gzip/brotli 压缩 (Nginx/Vite)
3. 使用 CDN 加速静态资源
4. 预加载关键资源 `<link rel="preload">`

## 其他

### Q: 如何重置开发环境数据库？

**A:**
```bash
# 删除并重建
dropdb learning_log_dev
createdb -O learning_log learning_log_dev
alembic upgrade head
```

### Q: 如何贡献代码？

**A:**
1. Fork 仓库
2. 创建特性分支：`git checkout -b feat/xxx`
3. 提交遵循 Conventional Commits
4. 确保测试通过：`pytest` / `npm run test`
5. 发起 PR

### Q: 如何更新依赖？

**A:**
```bash
# Python
pip list --outdated
pip install -U package_name
pip freeze > requirements.txt

# Node.js
npm outdated
npm update
# 或
pnpm up -L
```

## 相关链接

- [安装指南](../guides/installation.md) - 环境搭建详细步骤
- [配置参考](configuration.md) - 完整配置选项
- [错误代码](error-codes.md) - 错误代码对照
- [GitHub Issues](https://github.com/mingxilv/dolphinmind/issues) - 提交 Bug/Feature Request