---
title: "架构设计"
category: architecture
order: 1
---

# 架构设计文档

本目录包含 Learning Log 系统的核心架构设计文档，涵盖 AI 协作机制、后端设计、前端设计系统和 MCP 工作流。

## 文档列表

| 文档 | 描述 | 状态 |
|------|------|------|
| [AI 协作机制完整参考](ai-collaboration.md) | Learning Log 系统与 AI（Claude Code）的协作架构、触发机制、数据流和协议设计 | Stable |
| [后端设计系统完整参考](backend-design.md) | 后端技术架构、数据库设计、API 规范、MCP 服务和脚本工具生态 | Stable |
| [前端设计系统完整参考](frontend-design.md) | 前端设计语言、组件体系、样式规范和技术栈 | Stable |
| [MCP Filesystem 配置流程](mcp-workflow.md) | Model Context Protocol 文件系统服务器的配置与工作流程 | Stable |

## 适用场景

- **新成员上手**：快速理解系统整体架构
- **AI 协作开发**：AI 可据此 1:1 复现完整系统
- **架构评审**：作为技术决策的参考基准
- **二次开发扩展**：新增功能时的设计约束参考

## 相关链接

- [快速开始指南](../getting-started/index.md) - 环境搭建与启动
- [后端 API 参考](../reference/api-reference.md) - 完整 API 接口文档
- [前端组件库](../reference/component-reference.md) - 组件使用规范