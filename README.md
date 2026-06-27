<div align="center">

# 🐬 思维笔记

<sub>个人学习笔记 · 基于 MkDocs Material</sub>

<a href="https://mingxilv.github.io/dolphinmind/">
  <img src="https://img.shields.io/badge/🌐-在线访问-3f51b5?style=for-the-badge" alt="Online">
</a>

</div>

---

## 使用方式

把 `.md` 文件放到 `docs/` 目录，推送即可自动发布。

```bash
# 本地预览
mkdocs serve

# 构建
mkdocs build
```

## 项目结构

```
docs/
├── index.md    # 首页
├── *.md        # 笔记直接放这里，自动发现
└── assets/     # 样式、脚本（无需关注）
```

## 部署

推送 `master` 分支 → GitHub Actions 自动构建并部署到 GitHub Pages。

---

<div align="center">
  <sub>Built with MkDocs Material</sub>
</div>
