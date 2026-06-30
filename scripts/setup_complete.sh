#!/bin/bash
# 完成设置 - 一键检查和引导

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║       MkDocs 文档站点 - 部署完成总结                         ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# 检查 Git 状态
echo "📦 Git 状态:"
git branch -v | head -1
echo "  Remote: $(git remote get-url origin)"
echo ""

# 检查本地构建
echo "🔨 本地构建测试:"
if [ -d "site" ] && [ "$(ls -A site 2>/dev/null)" ]; then
    echo "  ✅ 构建产物存在 (site/)"
    echo "  📄 首页: site/index.html"
else
    echo "  ⚠️  未检测到构建产物，运行: mkdocs build"
fi
echo ""

# 检查工作流
echo "🤖 GitHub Actions 工作流:"
if [ -f ".github/workflows/deploy.yml" ]; then
    echo "  ✅ 工作流文件存在"
    echo "  📋 监听分支: master"
    echo "  🔄 触发事件: push"
else
    echo "  ❌ 工作流文件缺失"
fi
echo ""

# 检查 Pages 状态
echo "🌐 GitHub Pages 状态:"
PAGES_STATUS=$(gh api --method GET /repos/zerophix/docs/pages 2>/dev/null 2>&1 || echo "not_found")
if echo "$PAGES_STATUS" | grep -q "url"; then
    URL=$(echo "$PAGES_STATUS" | grep -o '"url": "[^"]*"' | head -1 | cut -d'"' -f4)
    echo "  ✅ 已启用"
    echo "  🔗 站点: $URL"
else
    echo "  ❌ 未配置"
    echo ""
    echo "⚠️  需要手动启用 GitHub Pages:"
    echo ""
    echo "1. 打开浏览器访问:"
    echo "   https://github.com/zerophix/docs/settings/pages"
    echo ""
    echo "2. 在 'Source' 部分选择:"
    echo "   □ GitHub Actions (推荐)"
    echo "   或"
    echo "   □ Deploy from a branch"
    echo "      Branch: master"
    echo "      Folder: /site"
    echo ""
    echo "3. 点击 'Save' 按钮"
    echo ""
    echo "📖 详细说明见: docs/guide/deployment.md"
fi
echo ""

# 最终提示
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  ✅ 代码已推送到 GitHub                                      ║"
echo "║  📝 文档结构已重构完成                                      ║"
echo "║  🔧 下一步: 手动启用 GitHub Pages                          ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "💡 快速命令:"
echo "   mkdocs serve              # 本地预览"
echo "   gh run list --repo zerophix/docs  # 查看构建状态"
echo "   gh browse --repo zerophix/docs    # 打开仓库"
echo ""
