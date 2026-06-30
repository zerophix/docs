#!/bin/bash
# GitHub Pages 部署修复脚本

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         GitHub Pages 部署状态检查与修复                         ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# 1. 检查仓库
REPO="zerophix/docs"
echo "📍 仓库: $REPO"
echo ""

# 2. 检查最近构建
echo "🔨 最近的 Actions 运行:"
gh run list --repo $REPO --limit 3 --json conclusion,displayTitle,status --jq '.[] | "  \(.status) \(.conclusion) \(.displayTitle)"' 2>/dev/null
echo ""

# 3. 检查 Pages 状态
echo "🌐 GitHub Pages 状态:"
if gh api --method GET /repos/$REPO/pages 2>/dev/null | grep -q '"url"'; then
    URL=$(gh api --method GET /repos/$REPO/pages 2>/dev/null | grep -o '"url": "[^"]*"' | head -1 | cut -d'"' -f4)
    echo "  ✅ 已启用"
    echo "  🔗 站点: $URL"
else
    echo "  ❌ 未配置"
fi
echo ""

# 4. 提供修复步骤
echo "📝 修复步骤："
echo ""
echo "1. 打开设置页面："
echo "   https://github.com/$REPO/settings/pages"
echo ""
echo "2. 在 'Build and deployment' 部分："
echo "   ✅ 选项 A: 选择 'GitHub Actions'（推荐）"
echo "      - 系统会自动检测 deploy.yml"
echo "      - 无需额外配置"
echo ""
echo "   ✅ 选项 B: 选择 'Deploy from a branch'"
echo "      - Branch: master"
echo "      - Folder: /site"
echo ""
echo "3. 点击 'Save' 按钮"
echo ""
echo "4. 等待 1-2 分钟，访问："
echo "   https://zerophix.github.io/docs/"
echo ""
echo "5. 如果仍有问题，强制刷新（Cmd+Shift+R）"
echo ""

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  完成！如有问题请查看 Actions 日志：                          ║"
echo "║  https://github.com/$REPO/actions                            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
