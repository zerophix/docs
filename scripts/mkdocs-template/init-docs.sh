#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MkDocs 项目文档骨架初始化脚本
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 用法：
#   ./init-docs.sh <目标项目路径> [--site-name "项目名"] [--author "作者"]
#
# 示例：
#   ./init-docs.sh /path/to/my-project --site-name "My API" --author "zerophix"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# 默认值
TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR=""
SITE_NAME=""
AUTHOR="zerophix"

# 解析参数
while [[ $# -gt 0 ]]; do
  case $1 in
    --site-name) SITE_NAME="$2"; shift 2 ;;
    --author) AUTHOR="$2"; shift 2 ;;
    -*) echo "未知选项: $1"; exit 1 ;;
    *) TARGET_DIR="$1"; shift ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  echo "用法: $0 <目标项目路径> [--site-name \"项目名\"] [--author \"作者\"]"
  exit 1
fi

# 如果没指定项目名，用目录名
if [[ -z "$SITE_NAME" ]]; then
  SITE_NAME="$(basename "$TARGET_DIR")"
fi

echo "━━━ MkDocs 文档骨架初始化 ━━━"
echo "目标项目: $TARGET_DIR"
echo "站点名称: $SITE_NAME"
echo "作者:     $AUTHOR"
echo ""

# 检查目标目录
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "目标目录不存在，创建中..."
  mkdir -p "$TARGET_DIR"
fi

# 复制模板
echo "[1/4] 复制文档目录结构..."
mkdir -p "$TARGET_DIR/docs"/{architecture,guides,reference,changelog,notes}
cp -r "$TEMPLATE_DIR/docs/" "$TARGET_DIR/docs/"

echo "[2/4] 生成 mkdocs.yml..."
cp "$TEMPLATE_DIR/mkdocs.yml" "$TARGET_DIR/mkdocs.yml"

echo "[3/4] 替换模板变量..."
# macOS sed 兼容写法
if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/mkdocs.yml"
  sed -i '' "s/{PROJECT_DESC}/项目文档站/g" "$TARGET_DIR/mkdocs.yml"
  sed -i '' "s/{AUTHOR}/$AUTHOR/g" "$TARGET_DIR/mkdocs.yml"
  sed -i '' "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/docs/index.md"
  sed -i '' "s/{PROJECT_DESC}/项目文档站/g" "$TARGET_DIR/docs/index.md"
else
  sed -i "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/mkdocs.yml"
  sed -i "s/{PROJECT_DESC}/项目文档站/g" "$TARGET_DIR/mkdocs.yml"
  sed -i "s/{AUTHOR}/$AUTHOR/g" "$TARGET_DIR/mkdocs.yml"
  sed -i "s/{PROJECT_NAME}/$SITE_NAME/g" "$TARGET_DIR/docs/index.md"
  sed -i "s/{PROJECT_DESC}/项目文档站/g" "$TARGET_DIR/docs/index.md"
fi

echo "[4/4] 生成 requirements.txt（如不存在）..."
if [[ ! -f "$TARGET_DIR/requirements.txt" ]]; then
  cat > "$TARGET_DIR/requirements.txt" << 'EOF'
mkdocs>=1.6
mkdocs-material>=9.7
mkdocs-git-revision-date-localized-plugin
mkdocs-minify-plugin
EOF
  echo "  已创建 requirements.txt"
else
  echo "  requirements.txt 已存在，跳过"
fi

echo ""
echo "━━━ 完成 ━━━"
echo ""
echo "后续步骤："
echo "  cd $TARGET_DIR"
echo "  pip install -r requirements.txt"
echo "  mkdocs serve"
echo ""
echo "提示：将 docs/DOC-GUIDE.md 加入你的 AI 规则文件（.cursorrules / CLAUDE.md）中，"
echo "      AI 就会遵循文档规范来操作。"
