---
title: "安装指南"
category: getting-started
order: 2
parent: getting-started/index.md
---

# 安装指南

本文档详细说明 Learning Log 系统的开发环境依赖安装与配置。

## 系统要求

| 组件 | 版本要求 | 说明 |
|------|----------|------|
| Node.js | 18.0+ | 前端构建、开发服务器 |
| Python | 3.10+ | 后端 API 服务 |
| PostgreSQL | 14+ | 主数据库 |
| Redis | 7.0+ | 缓存、会话存储 |
| Docker | 24.0+ | 容器化部署（可选） |
| Docker Compose | 2.20+ | 多容器编排（可选） |

## 核心依赖安装

### macOS (Homebrew)

```bash
# 安装核心工具
brew install node@18 python@3.10 postgresql@14 redis

# 启动服务
brew services start postgresql@14
brew services start redis

# 验证安装
node --version   # v18.x.x
python3 --version # 3.10.x
psql --version   # 14.x
redis-cli --version # 7.x
```

### Ubuntu/Debian

```bash
# 更新包索引
sudo apt update

# 安装 Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 安装 Python 3.10
sudo apt install -y python3.10 python3.10-venv python3.10-dev

# 安装 PostgreSQL 14
sudo apt install -y postgresql-14 postgresql-client-14

# 安装 Redis
sudo apt install -y redis-server

# 启动服务
sudo systemctl start postgresql
sudo systemctl start redis
sudo systemctl enable postgresql
sudo systemctl enable redis
```

### Windows (WSL2 推荐)

```powershell
# 安装 WSL2 并使用 Ubuntu 发行版
wsl --install -d Ubuntu

# 在 WSL 中按 Ubuntu 步骤操作
```

## Python 虚拟环境

```bash
# 创建虚拟环境
python3.10 -m venv venv

# 激活虚拟环境
# Linux/macOS:
source venv/bin/activate
# Windows (PowerShell):
venv\Scripts\Activate.ps1

# 升级 pip
pip install --upgrade pip

# 安装后端依赖
pip install -r requirements.txt
```

## Node.js 依赖

```bash
# 安装前端依赖
npm install

# 或使用 pnpm (推荐)
pnpm install
```

## 数据库初始化

```bash
# 创建数据库用户
sudo -u postgres createuser --interactive learning_log

# 创建数据库
sudo -u postgres createdb -O learning_log learning_log_dev

# 运行迁移 (项目代码就绪后)
# alembic upgrade head
```

## 环境变量配置

```bash
# 复制示例配置
cp .env.example .env

# 编辑配置
# DATABASE_URL=postgresql://user:pass@localhost:5432/learning_log_dev
# JWT_SECRET=your-secret-key
# REDIS_URL=redis://localhost:6379/0
```

## 验证安装

```bash
# 检查所有服务状态
# PostgreSQL
psql -U learning_log -d learning_log_dev -c "SELECT version();"

# Redis
redis-cli ping  # 应返回 PONG

# Python 环境
python -c "import fastapi; print(fastapi.__version__)"

# Node 环境
npm list --depth=0
```

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 端口冲突 (5432/6379) | 修改对应服务配置文件端口，或停止占用进程 |
| 权限不足 | 确保当前用户在 postgres 组中，或使用 sudo |
| Python 版本不对 | 使用 `python3.10` 显式指定版本，或配置别名 |
| npm 安装慢 | 使用国内镜像：`npm config set registry https://registry.npmmirror.com` |

## 下一步

- [快速上手](quickstart.md) - 启动开发服务器
- [配置说明](configuration.md) - 详细配置选项