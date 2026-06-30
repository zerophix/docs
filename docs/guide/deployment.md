# GitHub Pages 部署指南

## 📋 前置条件

- ✅ 仓库已推送代码到 `master` 分支
- ✅ `.github/workflows/deploy.yml` 已配置
- ✅ 需要仓库管理员权限

## 🚀 启用步骤

### 方法一：GitHub Actions (推荐)

1. 访问 https://github.com/zerophix/docs/settings/pages
2. 在 **Build and deployment** 部分：
   - **Source**: 选择 `GitHub Actions`
3. 系统会自动检测 `deploy.yml` 工作流
4. 无需额外配置，保存即可

### 方法二：直接部署分支

1. 访问 https://github.com/zerophix/docs/settings/pages
2. 在 **Source** 部分：
   - 选择 `Deploy from a branch`
   - Branch: `master`
   - Folder: `/site`
3. 点击 **Save**

## 📊 验证部署

### 查看构建状态

```bash
# 查看最近的 Actions 运行
gh run list --repo zerophix/docs

# 查看特定运行详情
gh run view <run-id> --repo zerophix/docs --log
```

### 访问站点

启用后，站点将在以下 URL 可用：

```
https://zerophix.github.io/docs/
```

**注意**：首次部署可能需要 1-2 分钟。

## 🔄 自动部署流程

一旦启用，每次推送到 `master` 分支将自动触发：

1. GitHub Actions 检出代码
2. 安装依赖 (`pip install -r requirements.txt`)
3. 运行 `mkdocs build`
4. 构建产物 (`site/`) 自动部署到 Pages

## 🐛 故障排除

### 构建失败

查看 Actions 日志排查问题：
- 确保 `requirements.txt` 存在且正确
- 确保 `mkdocs.yml` 语法正确
- 检查是否有相对路径问题

### 页面 404

- 确认 Pages 源设置正确
- 确认工作流已成功完成
- 尝试重新保存 Pages 设置

### 自定义域名

在 Pages 设置中添加 `CNAME` 文件到 `docs/` 或站点根目录。

---

**创建时间**: 2026-07-01  
**状态**: Stable
