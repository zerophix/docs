#!/bin/bash
# 迁移脚本：将旧 docs/notes/skills 目录结构迁移到新的 domain/ 结构

set -e

cd "$(dirname "$0")/.."

# 1. 复制通用技能到 domain/engineering/
echo "📦 复制通用技能到 domain/engineering/..."
cp -r docs/notes/skills/*.md docs/domain/engineering/ 2>/dev/null || true

# 2. 创建余下的目录型技能（如果它们在 git 历史中）
echo "📦 恢复目录型技能..."
git checkout 96fd942 -- docs/notes/skills/ 2>/dev/null || true

# 3. 移动到对应领域
echo "📦 迁移技能目录..."
# AI 领域技能
if [ -d "docs/notes/skills/ai-decision-framework" ]; then
    mv docs/notes/skills/ai-decision-framework docs/domain/ai/
fi
if [ -d "docs/notes/skills/ai-workflow-orchestrator" ]; then
    mv docs/notes/skills/ai-workflow-orchestrator docs/domain/ai/
fi
if [ -d "docs/notes/skills/harness-testing-engineering" ]; then
    mv docs/notes/skills/harness-testing-engineering docs/domain/ai/
fi
if [ -d "docs/notes/skills/knowledge" ]; then
    mv docs/notes/skills/knowledge docs/domain/ai/
fi
if [ -d "docs/notes/skills/wq-api-client-guide" ]; then
    mv docs/notes/skills/wq-api-client-guide docs/domain/ai/
fi
if [ -d "docs/notes/skills/wq-fields" ]; then
    mv docs/notes/skills/wq-fields docs/domain/ai/
fi
if [ -d "docs/notes/skills/wq-operator-algebra" ]; then
    mv docs/notes/skills/wq-operator-algebra docs/domain/ai/
fi
if [ -d "docs/notes/skills/interview-coach" ]; then
    mv docs/notes/skills/interview-coach docs/domain/ai/
fi
if [ -d "docs/notes/skills/auto-documentation-policy" ]; then
    mv docs/notes/skills/auto-documentation-policy docs/domain/ai/
fi

# 工程领域技能
if [ -d "docs/notes/skills/ddd-architecture-validator" ]; then
    mv docs/notes/skills/ddd-architecture-validator docs/domain/engineering/
fi
if [ -d "docs/notes/skills/dependency-management" ]; then
    mv docs/notes/skills/dependency-management docs/domain/engineering/
fi
if [ -d "docs/notes/skills/git" ]; then
    mv docs/notes/skills/git docs/domain/engineering/
fi
if [ -d "docs/notes/skills/harness-engineering-thinking" ]; then
    mv docs/notes/skills/harness-engineering-thinking docs/domain/engineering/
fi
if [ -d "docs/notes/skills/project-file-creation-policy" ]; then
    mv docs/notes/skills/project-file-creation-policy docs/domain/engineering/
fi
if [ -d "docs/notes/skills/project-file-organization" ]; then
    mv docs/notes/skills/project-file-organization docs/domain/engineering/
fi
if [ -d "docs/notes/skills/project-health-scanner" ]; then
    mv docs/notes/skills/project-health-scanner docs/domain/engineering/
fi
if [ -d "docs/notes/skills/secure-credentials" ]; then
    mv docs/notes/skills/secure-credentials docs/domain/engineering/
fi
if [ -d "docs/notes/skills/test-driven-development" ]; then
    mv docs/notes/skills/test-driven-development docs/domain/engineering/
fi
if [ -d "docs/notes/skills/alpha-knowledge-db-schema" ]; then
    mv docs/notes/skills/alpha-knowledge-db-schema docs/domain/engineering/
fi
if [ -d "docs/notes/skills/code-size-constraint" ]; then
    mv docs/notes/skills/code-size-constraint docs/domain/engineering/
fi
if [ -d "docs/notes/skills/db-schema-sync" ]; then
    mv docs/notes/skills/db-schema-sync docs/domain/engineering/
fi

# 量化领域技能
if [ -d "docs/notes/skills/alpha-factor-classification" ]; then
    mv docs/notes/skills/alpha-factor-classification docs/domain/quant/
fi
if [ -d "docs/notes/skills/quant-alpha-strategy-engineering" ]; then
    mv docs/notes/skills/quant-alpha-strategy-engineering docs/domain/quant/
fi
if [ -d "docs/notes/skills/quant-field-classification-protocol" ]; then
    mv docs/notes/skills/quant-field-classification-protocol docs/domain/quant/
fi

# 4. 清理
echo "🧹 清理临时文件..."
rm -rf docs/notes/skills/

echo "✅ 迁移完成！"
