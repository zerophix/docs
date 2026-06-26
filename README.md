<div align="center">

# 🐬 海豚思维笔记

**量化知识库 · 中文百科 · 技术文档**

<a href="https://mingxilv.github.io/dolphinmind/">
  <img src="https://img.shields.io/badge/🌐-在线访问-3f51b5?style=for-the-badge" alt="Online">
</a>
<img src="https://img.shields.io/badge/MkDocs-Material-3f51b5?style=for-the-badge&logo=materialdesign&logoColor=white" alt="MkDocs">
<img src="https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python">

</div>

---

## 📖 项目简介

一个结构化个人量化知识库，基于 **MkDocs** + **Material Theme** 构建，自动部署到 **GitHub Pages**。

### 内容分类

| 分类 | 说明 |
|------|------|
| 📖 基本概念 | 金融工具、市场微观结构、交易机制 |
| 🚀 入门教程 | 量化环境搭建、策略编写 |
| 🔬 量化前沿 | 机器学习、高频交易、另类数据 |
| 🤖 AI + 量化 | LLM、Agent 系统在量化中的应用 |
| 🔧 MCP 工作流 | Model Context Protocol 配置与集成 |

## 🚀 本地开发

```bash
# 1. 克隆仓库
git clone https://github.com/mingxilv/dolphinmind.git
cd dolphinmind

# 2. 安装依赖
pip install -r requirements.txt

# 3. 本地预览
mkdocs serve

# 4. 构建静态文件
mkdocs build
```

## 📝 编写文档

所有文档位于 `docs/` 目录，使用 Markdown 语法编写：

```markdown
# 标题

## 二级标题

- 列表项
- **加粗**、*斜体*

> 引用

`代码块`

!!! note "警告框"
    这是 MkDocs Material 的 admonition 语法。
```

### 文件结构

```
docs/
├── index.md              # 首页
├── concepts/             # 基本概念
│   ├── index.md
│   ├── financial-instruments.md
│   └── market-microstructure.md
├── tutorials/            # 入门教程
│   ├── index.md
│   ├── setup.md
│   └── first-strategy.md
├── frontier/             # 量化前沿
│   └── index.md
├── ai/                   # AI + 量化
│   └── index.md
└── mcp-workflow.md       # MCP 工作流
```

## 🔄 CI/CD

每次推送到 `main` 分支，GitHub Actions 自动：

1. 安装 Python 和 MkDocs 依赖
2. 构建静态网站
3. 部署到 GitHub Pages

## 📄 许可

本项目内容采用 [CC BY-NC 4.0](LICENSE) 许可协议。

---

<div align="center">
  <sub>Built with ❤️ using MkDocs Material</sub>
</div>