#!/bin/bash
# 最终设置脚本 - 检查并指导启用 GitHub Pages

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║               📦 MkDocs 文档站 - 最终设置                      ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# 1. 本地构建检查
echo "🔨 步骤 1: 本地构建检查"
if command -v mkdocs &>/dev/null; then
    echo "   mkdocs build..."
    mkdocs build --quiet && echo "   ✅ 构建成功" || echo "   ❌ 构建失败"
else
    echo "   ⚠️  mkdocs 未安装，运行: pip install -r requirements.txt"
fi
echo ""

# 2. Git 状态
echo "📦 步骤 2: Git 状态"
git branch --show-current
git remote get-url origin
echo ""

# 3. GitHub Pages 设置（关键步骤）
echo "🌐 步骤 3: 启用 GitHub Pages (必须手动完成)"
echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  请在浏览器中打开以下链接：                                  │"
echo "│  https://github.com/zerophix/docs/settings/pages           │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
echo "然后按图示配置："
echo ""
echo "  选项 A (推荐 - GitHub Actions):"
echo "    ▢ Source: GitHub Actions"
echo ""
echo "  选项 B (传统 - 直接部署):"
echo "    ▢ Source: Deploy from a branch"
echo "    ▢ Branch: master"
echo "    ▢ Folder: /site"
echo ""
echo "  点击 'Save' 按钮"
echo ""

# 4. 验证
echo "✅ 步骤 4: 验证部署"
echo "  等待 1-2 分钟后，访问："
echo "  🔗 https://zerophix.github.io/docs/"
echo ""
echo "  查看 Actions 状态："
echo "  🔗 https://github.com/zerophix/docs/actions"
echo ""

# 5. 自动化使用
echo "🤖 步骤 5: 使用 OpenCode 自动化"
echo "  在 OpenCode 中输入："
echo "    /validate   # 验证文档"
echo "    /deploy     # 部署文档"
echo "    /create-doc L2 \"主题\"  # 创建文档"
echo ""

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  🎉 完成！请按步骤 3 手动启用 GitHub Pages                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
