#!/bin/bash
# 检查 GitHub Pages 部署状态

REPO="zerophix/docs"
echo "🔍 检查 $REPO 部署状态..."
echo ""

# 1. 检查最近的工作流运行
echo "📋 最近的 Actions 运行:"
gh run list --repo $REPO --limit 5 2>/dev/null || echo "  (无法获取运行列表)"

echo ""
echo ""

# 2. 检查 Pages 配置
echo "🌐 Pages 状态:"
if gh api --method GET /repos/$REPO/pages 2>/dev/null | grep -q "url"; then
    URL=$(gh api --method GET /repos/$REPO/pages 2>/dev/null | grep -o '"url": "[^"]*"' | cut -d'"' -f4)
    echo "  ✅ 已启用: $URL"
else
    echo "  ❌ 未配置"
    echo ""
    echo "📝 请手动启用:"
    echo "  1. 打开: https://github.com/$REPO/settings/pages"
    echo "  2. 选择源:"
    echo "     - GitHub Actions (推荐)"
    echo "     - 或: Deploy from a branch → master → /site"
    echo "  3. 保存"
    echo ""
    echo "🎯 目标 URL: https://$REPO/wiki/$REPO.github.io/docs/"
fi

echo ""
echo "📦 仓库信息:"
gh repo view $REPO --json name,url,defaultBranchRef,homepage 2>/dev/null | jq -r '
  "  - 名称: \(.name)",
  "  - URL: \(.url)",
  "  - 默认分支: \(.defaultBranchRef.name)",
  "  - 站点: \(.homepage // "未设置")"
' || gh repo view $REPO
