---
title: "快速开始"
category: getting-started
order: 1
---

# 快速开始指南

本章节帮助你快速搭建 Learning Log 系统的开发环境并启动项目。

## 文档列表

| 文档 | 描述 | 状态 |
|------|------|------|
| [环境搭建](environment-setup.md) | 开发环境依赖安装、配置与验证 | Draft |
| [项目启动](project-startup.md) | 本地开发服务器启动、数据库初始化、首次运行验证 | Draft |
| [常见问题](troubleshooting.md) | 环境搭建与启动过程中的常见问题及解决方案 | Draft |

## 前置要求

- Node.js 18+
- Python 3.10+
- PostgreSQL 14+
- Docker & Docker Compose（可选，用于容器化部署）

## 快速验证

```bash
# 克隆项目
git clone <repository-url>
cd learning-log

# 安装依赖
npm install
pip install -r requirements.txt

# 启动开发服务器
npm run dev
```

## 相关链接

- [架构设计](../architecture/index.md) - 了解系统整体架构
- [API 参考](../reference/api-reference.md) - 接口文档