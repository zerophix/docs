<div align="center">

# 🧠 思维笔记

<sub>个人知识沉淀 · AI 协作开发笔记</sub>

<a href="https://zerophix.github.io/docs/">
  <img src="https://img.shields.io/badge/🌐-在线访问-3f51b5?style=for-the-badge" alt="Online">
</a>

</div>

---

## 使用方式

把 `.md` 文件放到 `docs/` 目录，推送到 `master` 分支即可自动发布。

```bash
# 本地预览
mkdocs serve

# 构建
mkdocs build
```

## 项目结构

```
docs/
├── index.md           # 首页
├── map/               # 知识地图 (MOC)
├── domain/            # 领域知识
│   ├── ai/
│   ├── engineering/
│   └── quant/
├── chrono/            # 时间线
├── peek/              # L1 灵感碎片
├── log/               # L2 学习日志
├── deep/              # L3 深度沉淀
├── meta/              # 模板与指南
├── guide/             # 贡献指南
├── skills/            # 技能库索引
└── assets/            # 样式、脚本
```

## 部署

推送 `master` 分支 → GitHub Actions 自动构建并部署到 GitHub Pages。

访问: https://zerophix.github.io/docs/

---

<div align="center">
  <sub>Built with MkDocs Material</sub>
</div>
