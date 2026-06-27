---
title: "快速上手"
category: getting-started
order: 3
parent: getting-started/index.md
---

# 快速上手

本文档指导你在完成环境安装后，快速启动 Learning Log 系统并验证运行。

## 启动开发服务器

### 后端 API 服务

```bash
# 激活虚拟环境
source venv/bin/activate

# 启动后端 (默认端口 8000)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# 验证
curl http://localhost:8000/health  # {"status": "ok"}
```

### 前端开发服务器

```bash
# 新终端窗口
npm run dev
# 或
pnpm dev

# 默认启动在 http://localhost:5173
# Vite 会自动打开浏览器
```

### 使用 Docker Compose (一键启动)

```bash
# 构建并启动所有服务
docker-compose up -d --build

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

## 验证运行

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端 | http://localhost:5173 | React + Vite 开发服务器 |
| 后端 API | http://localhost:8000 | FastAPI 服务 |
| API 文档 | http://localhost:8000/docs | Swagger UI |
| ReDoc | http://localhost:8000/redoc | ReDoc 文档 |

## 首次运行检查清单

- [ ] 后端健康检查返回 `{"status": "ok"}`
- [ ] 前端页面正常加载，无控制台报错
- [ ] API 文档可访问
- [ ] 数据库连接正常 (检查后端日志)
- [ ] Redis 连接正常 (检查后端日志)

## 常用开发命令

```bash
# 后端
uvicorn app.main:app --reload        # 热重载启动
pytest                               # 运行测试
alembic revision --autogenerate -m "msg"  # 生成迁移
alembic upgrade head                 # 应用迁移

# 前端
npm run dev                          # 开发服务器
npm run build                        # 生产构建
npm run preview                      # 预览构建产物
npm run lint                         # 代码检查
npm run typecheck                    # 类型检查

# 数据库
psql -U learning_log -d learning_log_dev  # 连接数据库
```

## 下一步

- [配置说明](configuration.md) - 详细环境变量与配置选项
- [架构设计](../architecture/index.md) - 了解系统整体架构
- [开发指南](../guides/index.md) - 开发规范与最佳实践