#!/bin/bash
# GitHub Pages 自动启用脚本
# 注意事项：需要有仓库管理员权限和正确的 token 权限

echo "🔧 正在启用 GitHub Pages..."

# 1. 检查登录状态
if ! gh auth status &>/dev/null; then
    echo "❌ 请先登录 GitHub: gh auth login"
    exit 1
fi

# 2. 获取仓库信息
REPO="zerophix/docs"
echo "📍 仓库: $REPO"

# 3. 尝试通过 API 启用 Pages
echo "📤 尝试配置 GitHub Pages..."

# 方法1: 使用 GitHub Actions 作为源（推荐）
gh api --method POST \
    -H "Accept: application/vnd.github+json" \
    "/repos/$REPO/pages" \
    -f source='{"branch":"master","path":"/site"}' 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ GitHub Pages 已启用！"
    echo "🌐 站点 URL: https://zerophix.github.io/docs/"
    exit 0
fi

# 4. 如果失败，提供手动步骤
echo "⚠️  API 配置失败，请手动启用："
echo ""
echo "步骤:"
echo "1. 访问: https://github.com/zerophix/docs/settings/pages"
echo "2. 在 'Source' 部分选择:"
echo "   - 选项 A: GitHub Actions (推荐)"
echo "   - 选项 B: Deploy from a branch"
echo "      Branch: master"
echo "      Folder: /site"
echo "3. 点击 Save"
echo ""
echo "启用后，你的站点将在几分钟内生效："
echo "🔗 https://zerophix.github.io/docs/"
echo ""
